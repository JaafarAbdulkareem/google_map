import 'package:flutter/material.dart';
import 'package:google_map/section8/utils/location_service_8.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Section8 extends StatefulWidget {
  const Section8({super.key});

  @override
  State<Section8> createState() => _Section8State();
}

class _Section8State extends State<Section8> {
  late CameraPosition initialCameraPosition;
  late GoogleMapController googleMapController;
  late LocationService8 locationService8;
  @override
  void initState() {
    initialCameraPosition = const CameraPosition(target: LatLng(0, 0));
    locationService8 = LocationService8();
    updateLocation();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (controller) {
        googleMapController = controller;
      },
      initialCameraPosition: initialCameraPosition,);
  }
  
  void updateLocation() async {
    var currentLocation = await locationService8.getCurrentLocation();
  }
}