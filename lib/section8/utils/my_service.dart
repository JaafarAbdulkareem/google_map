import 'dart:async';

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
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

class MyService {
  LocationService8 locationService8 = LocationService8();
  PlacesApiService placesApiService = PlacesApiService();
  RouteApiService routeApiService = RouteApiService();
  Uuid uuid = const Uuid();
  PolylinePoints polylinePoints = PolylinePoints();

  String? sessionToken;
  late LocationData currentLocation;
  Future<void> updateLocation({
    required GoogleMapController googleMapController,
    required Set<Marker> markers,
  }) async {
    try {
      currentLocation = await locationService8.getCurrentLocation();
      LatLng latLng =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: latLng,
            zoom: 15,
          ),
        ),
      );
      markers.add(
        Marker(markerId: const MarkerId("markerId"), position: latLng),
      );
    } on LocationServiceException catch (_) {
    } on LocationPermissionException catch (_) {
    } catch (_) {}
  }

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

  void fetchRoute({
    required PlaceDetailModel detailData,
    required Set<Polyline> polylines,
    required VoidCallback refresh,
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
    refresh();
  }

  Polyline displayRoute(String encodedPolyline) {
    List<PointLatLng> result = polylinePoints.decodePolyline(encodedPolyline);
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

  Future<PlaceDetailModel> getPlaceDetailApi({required String placeId}) async {
    return await PlacesApiService().getPlaceDetailApi(
      placeId: placeId,
    );
  }
}
