import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition initialCamerPosition;
  late GoogleMapController googleMapController;
  String? style;
  @override
  void initState() {
    initialCamerPosition = const CameraPosition(
      zoom: 12,
      target: LatLng(
        13.046279282623589,
        77.59288321390162,
      ),
    );
    initStyleMap();
    super.initState();
  }

  @override
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          style: style,
          zoomControlsEnabled: false,
          onMapCreated: (controller) {
            googleMapController = controller;
            // initStyleMap();
          },
          initialCameraPosition: initialCamerPosition,
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: ElevatedButton(
            onPressed: () {
              googleMapController.animateCamera(
                CameraUpdate.newLatLng(
                  const LatLng(
                    12.320505273066722,
                    76.62978062497629,
                  ),
                ),
              );
            },
            child: const Text("Mysuru"),
          ),
        )
      ],
    );
  }

  void initStyleMap() async {
    style = await rootBundle.loadString('assets/map_style/dark_map.json');
    setState(() {});
    // var darkMap = await DefaultAssetBundle.of(context).loadString("assets/map_style/dark_map.json");
    // googleMapController.setMapStyle(darkMap);
  }
}
