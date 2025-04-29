import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_map/section8/models/autocomplet_model/autocomplet_model.dart';
import 'package:google_map/section8/models/body_route_model/body_route_model.dart';
import 'package:google_map/section8/models/place_detail_model/place_detail_model.dart';
import 'package:google_map/section8/models/route_model/route_model.dart';
import 'package:google_map/section8/utils/location_service_8.dart';
import 'package:google_map/section8/utils/places_api_service.dart';
import 'package:google_map/section8/utils/route_api_service.dart';
import 'package:google_map/section8/widget/custom_text_field.dart';
import 'package:google_map/section8/widget/list_autocomplete.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

class Section8 extends StatefulWidget {
  const Section8({super.key});

  @override
  State<Section8> createState() => _Section8State();
}

class _Section8State extends State<Section8> {
  Set<Marker> markers = {};
  late CameraPosition initialCameraPosition;
  late GoogleMapController googleMapController;
  late TextEditingController textEditingController;
  late LocationService8 locationService8;
  late PlacesApiService placesApiService;
  late RouteApiService routeApiService;
  List<AutocompleteModel> autocompleteData = [];
  late Uuid uuid;
  String? sessionToken;
  late LocationData currentLocation;
  late PolylinePoints polylinePoints;
  Set<Polyline> polylines = {};

  @override
  void initState() {
    uuid = const Uuid();
    initialCameraPosition = const CameraPosition(target: LatLng(0, 0));
    textEditingController = TextEditingController();
    textEditingController.addListener(searchAutocomplete);
    locationService8 = LocationService8();
    placesApiService = PlacesApiService();
    routeApiService = RouteApiService();
    polylinePoints = PolylinePoints();

    super.initState();
  }

  void searchAutocomplete() async {
    sessionToken ??= uuid.v4();
    if (textEditingController.text.isEmpty) {
      autocompleteData.clear();
      textEditingController.clear();
      setState(() {});
    } else {
      try {
        autocompleteData.clear();
        List<AutocompleteModel> places =
            await placesApiService.getAutocompleteApi(
          input: textEditingController.text,
          sessiontoken: sessionToken!,
        );
        autocompleteData.addAll(places);
        setState(() {});
      } on AutocompleteException catch (_) {
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    googleMapController.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              markers: markers,
              polylines: polylines,
              onMapCreated: (controller) {
                googleMapController = controller;
                updateLocation();
              },
              initialCameraPosition: initialCameraPosition,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  CustomTextField(
                    textEditingController: textEditingController,
                  ),
                  ListAutocomplete(
                    data: autocompleteData,
                    onTap: (detailData) {
                      autocompleteData.clear();
                      textEditingController.clear();
                      sessionToken = null;
                      fetchRoute(detailData);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateLocation() async {
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
      setState(() {
        log("setState : $latLng");
      });
    } on LocationServiceException catch (_) {
    } on LocationPermissionException catch (_) {
    } catch (_) {}
  }

  void fetchRoute(PlaceDetailModel detailData) async {
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
    log("route : ${routeData.polyline}");

    displayRoute(routeData.polyline.encodedPolyline);
  }

  void displayRoute(String encodedPolyline) {
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
    polylines.add(polyline);
    setState(() {
      
    });
  }
}
