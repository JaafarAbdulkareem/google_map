import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:google_maps_flutter/google_maps_flutter.dart';
class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition controllerInitialCamerPosition;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const GoogleMap(
        initialCameraPosition: CameraPosition(
        
            target: LatLng(13.046279282623589, 77.59288321390162)));
  }
}
