import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_map/utils/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//section 7 :  Live Location Tracker

class Section7 extends StatefulWidget {
  const Section7({super.key});

  @override
  State<Section7> createState() => _Section7State();
}

class _Section7State extends State<Section7> {
  late CameraPosition initialCameraPosition;
  GoogleMapController? googleMapController;
  Set<Marker> markers = {};
  late bool firstCheck;
  @override
  void initState() {
    initLocationService();
    initialCameraPosition = initialCamera();
    firstCheck = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (controller) {
        googleMapController = controller;
      },
      markers: markers,
      initialCameraPosition: initialCameraPosition,
    );
  }

  void initLocationService() async {
    late LatLng latLng;
    LocationService locationService = LocationService();

    bool hasSerivce = await locationService.checkAndRequiredLocationService();
    if (hasSerivce) {
      bool hasPermission =
          await locationService.checkAndRequiredLocationPermission();
      if (hasPermission) {
        locationService.getRealTimeLocationData(
          (locationData) {
            latLng = LatLng(
              locationData.latitude!,
              locationData.longitude!,
            );
            if (firstCheck) {
              CameraPosition cameraPosition = CameraPosition(
                target: latLng,
                zoom: 14,
              );
              googleMapController?.animateCamera(
                CameraUpdate.newCameraPosition(cameraPosition),
              );
              firstCheck = false;
            } else {
              googleMapController?.animateCamera(
                CameraUpdate.newLatLng(latLng),
              );
              markers.add(
                Marker(markerId: const MarkerId("value"), position: latLng),
              );
              setState(() {});
            }
          },
        );
      }
    } else {
      log("else serivce");
    }
  }

  CameraPosition initialCamera() {
    return const CameraPosition(
      target: LatLng(
        0,
        0,
      ),
      // zoom: 14,
    );
  }
}
