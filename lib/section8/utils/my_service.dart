import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_map/section8/models/autocomplet_model/autocomplet_model.dart';
import 'package:google_map/section8/models/body_route_model/body_route_model.dart';
import 'package:google_map/section8/models/place_detail_model/place_detail_model.dart';
import 'package:google_map/section8/models/route_model/route_model.dart';
import 'package:google_map/section8/utils/location_service_8.dart';
import 'package:google_map/section8/utils/places_api_service.dart';
import 'package:google_map/section8/utils/route_api_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class MyService {
  LocationService8 locationService8 = LocationService8();
  PlacesApiService placesApiService = PlacesApiService();
  RouteApiService routeApiService = RouteApiService();
  Uuid uuid = const Uuid();
  PolylinePoints polylinePoints = PolylinePoints();
  bool firstCheck = true;
  String? sessionToken;
  late LatLng currentLocation;

  LatLngBounds? bounds;

  Future<void> updateLocation({
    required GoogleMapController googleMapController,
    required Set<Marker> markers,
    required VoidCallback refresh,
  }) async {
    try {
      await locationService8.getRealTimeLocationData((locationData) async {
        currentLocation = LatLng(
          locationData.latitude!,
          locationData.longitude!,
        );

        // if (firstCheck) {
        //   CameraPosition cameraPosition = CameraPosition(
        //     target: currentLocation,
        //     zoom: 14,
        //   );
        //   googleMapController.animateCamera(
        //     CameraUpdate.newCameraPosition(cameraPosition),
        //   );
        //   firstCheck = false;
        // } else {

        googleMapController.animateCamera(
          CameraUpdate.newLatLng(currentLocation),
        );
        // if (bounds != null) {
        //   googleMapController.animateCamera(
        //     CameraUpdate.newLatLngBounds(bounds!, 16),
        //   );
        // } else {
        //   googleMapController.animateCamera(
        //     CameraUpdate.newLatLng(currentLocation),
        //   );
        // }
        markers.add(
          Marker(
            markerId: const MarkerId("value"),
            position: currentLocation,
          ),
        );
        // }
        refresh();
      });
    } on LocationServiceException catch (_) {
    } on LocationPermissionException catch (_) {
    } catch (_) {}
  }
  // Future<void> updateLocation({
  //   required GoogleMapController googleMapController,
  //   required Set<Marker> markers,
  // }) async {
  //   try {
  //     currentLocation = await locationService8.getCurrentLocation();
  //     LatLng latLng =
  //         LatLng(currentLocation.latitude!, currentLocation.longitude!);
  //     googleMapController.animateCamera(
  //       CameraUpdate.newCameraPosition(
  //         CameraPosition(
  //           target: latLng,
  //           zoom: 15,
  //         ),
  //       ),
  //     );
  //     markers.add(
  //       Marker(markerId: const MarkerId("markerId"), position: latLng),
  //     );
  //   } on LocationServiceException catch (_) {
  //   } on LocationPermissionException catch (_) {
  //   } catch (_) {}
  // }

  Future<void> autocompleteListen({
    required TextEditingController textEditingController,
    required List<AutocompleteModel> autocompleteData,
  }) async {
    sessionToken ??= uuid.v4();
    if (textEditingController.text.isEmpty) {
      autocompleteData.clear();
      textEditingController.clear();
    } else {
      try {
        autocompleteData.clear();
        List<AutocompleteModel> places =
            await placesApiService.getAutocompleteApi(
          input: textEditingController.text,
          sessiontoken: sessionToken!,
        );
        autocompleteData.addAll(places);
      } on AutocompleteException catch (_) {
      } catch (_) {}
    }
  }

  Future<void> fetchRoute({
    required PlaceDetailModel detailData,
    required Set<Polyline> polylines,
    required Set<Marker> markers,
    required GoogleMapController googleMapController,
    // required VoidCallback refresh,
  }) async {
    sessionToken = null;
    BodyRouteModel bodyRoute = BodyRouteModel.fromJson(
      {
        "origin": {
          "location": {
            "latLng": {
              "latitude": currentLocation.latitude,
              "longitude": currentLocation.longitude
            }
          }
        },
        "destination": {
          "location": {
            "latLng": {
              "latitude": detailData.geometry!.location!.lat,
              "longitude": detailData.geometry!.location!.lng
            }
          }
        },
        "travelMode": "DRIVE",
        "routingPreference": "TRAFFIC_AWARE",
        "computeAlternativeRoutes": false,
        "routeModifiers": {
          "avoidTolls": false,
          "avoidHighways": false,
          "avoidFerries": false
        },
        "languageCode": "en-US",
        "units": "IMPERIAL"
      },
    );
    RouteModel routeData =
        await routeApiService.getRouteApi(bodyRoute: bodyRoute);
    // log("route : ${routeData.polyline}");
    polylines.add(displayRoute(routeData.polyline.encodedPolyline));
    Marker begin = Marker(
      icon: AssetMapBitmap(
        "assets/images/dragon-removebg-preview.png",
        width: 40,
        height: 40,
      ),
      markerId: const MarkerId("begin"),
      position: LatLng(
        currentLocation.latitude,
        currentLocation.longitude,
      ),
      infoWindow: const InfoWindow(title: "begin"),
    );
    markers.add(begin);
    Marker end = Marker(
      icon: AssetMapBitmap(
        "assets/images/dragon-removebg-preview.png",
        width: 40,
        height: 40,
      ),
      markerId: const MarkerId("end"),
      position: LatLng(
        detailData.geometry!.location!.lat!,
        detailData.geometry!.location!.lng!,
      ),
      infoWindow: const InfoWindow(title: "end"),
    );
    markers.add(end);
    googleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(bounds!, 16));
    // refresh();
  }

  Polyline displayRoute(String encodedPolyline) {
    List<PointLatLng> result = polylinePoints.decodePolyline(encodedPolyline);
    selectBoundlePolyline(result);
    Polyline polyline = Polyline(
      width: 5,
      color: const Color(0xFF10293D),
      polylineId: const PolylineId("value"),
      points: result
          .map(
            (e) => LatLng(e.latitude, e.longitude),
          )
          .toList(),
    );
    return polyline;
    // setState(() {});
  }

  void selectBoundlePolyline(List<PointLatLng> points) {
    double southwestLatitude = points.first.latitude;
    double southwestLongitude = points.first.longitude;
    double northeastLatitude = points.first.latitude;
    double northeastLongitude = points.first.longitude;
    for (var element in points) {
      southwestLatitude = min(southwestLatitude, element.latitude);
      southwestLongitude = min(southwestLongitude, element.longitude);
      northeastLatitude = max(northeastLatitude, element.latitude);
      northeastLongitude = max(northeastLongitude, element.longitude);
    }
    bounds = LatLngBounds(
      /*minimum point*/
      southwest: LatLng(
        southwestLatitude,
        southwestLongitude,
      ),
      /*maximum point */
      northeast: LatLng(
        northeastLatitude,
        northeastLongitude,
      ),
    );
  }

  Future<PlaceDetailModel> getPlaceDetailApi({required String placeId}) async {
    return await PlacesApiService().getPlaceDetailApi(
      placeId: placeId,
    );
  }

  Future<void> selectDirection(
      {required GoogleMapController googleMapController}) async {
    await googleMapController.animateCamera(
      CameraUpdate.newLatLngZoom(currentLocation, 18),
    );
  }
}
