import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map/model/marker_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition initialCamerPosition;
  late GoogleMapController googleMapController;
  String? style;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  Set<Polygon> polygon = {};
  @override
  void initState() {
    initialCamerPosition = const CameraPosition(
      // zoom: 12,
      target: LatLng(
        13.046279282623589,
        77.59288321390162,
      ),
    );
    // initStyleMap();
    initMarkerMap();
    initPolyline();
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
          // style: style,
          polylines: polylines,
          markers: markers,
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

  Future<Uint8List> resetIcon(String image, int width, int height) async {
    ByteData byteData = await DefaultAssetBundle.of(context).load(image);
    ui.Codec dataCodec = await ui.instantiateImageCodec(
      byteData.buffer.asUint8List(),
      targetWidth: width,
      targetHeight: height,
    );

    ui.FrameInfo imageFrameInfo = await dataCodec.getNextFrame();
    ByteData? imageByteData =
        await imageFrameInfo.image.toByteData(format: ui.ImageByteFormat.png);

    return imageByteData!.buffer.asUint8List();
  }

  void initMarkerMap() async {
    // { give me all markers have same id and different position }
    markers.addAll(MarkerModel.marker
        .map(
          (element) => element.id == "1"
              ? Marker(
                  icon: AssetMapBitmap(
                    //you’re passing a new object each time
                    "assets/images/dragon-removebg-preview.png",
                    width: 40,
                    height: 40,
                  ),
                  markerId: MarkerId(element.id),
                  position: element.latLng,
                  infoWindow: InfoWindow(title: element.name),
                )
              : null,
        )
        .whereType<
            Marker>() //delete null value . just take type have marker DataType
        .toSet());

// { give just the last markers when markers have same id if want all appear make unique id }
//     Uint8List icon =
//         await resetIcon("assets/images/dragon-removebg-preview.png", 40, 40);
// // log ("icon : $icon");
//     Set<Marker> data = MarkerModel.marker.asMap().entries.map(
//       (element) {
//          final clonedIcon = Uint8List.fromList(icon);
//         return element.value.id == "1"//{just catecory have id = "1"}?Marker(
//           icon: BytesMapBitmap(clonedIcon), // causing deduplication
//           markerId: MarkerId(element.value.id + element.key.toString()),//display all markers have same id
//           position: element.value.latLng,
//           infoWindow: InfoWindow(title: element.value.name),
//         ):null;
//       },
//     ).whereType<Marker>().toSet();
//     log("data : ${data.length}");
//     markers.addAll(data);
//     setState(() {
//       log("length : ${markers.length}");
//     });
  }

  void initPolyline() {
    Polyline polyline = const Polyline(
      polylineId: PolylineId("1"),
      zIndex:
          2, // z-index, so that lower values means drawn earlier, and thus appearing to be closer to the surface of the Earth.
      width: 2,
      color: Colors.red,
      geodesic:
          true, //polyline should be drawn as geodesics, as opposed to straight lines on the Mercator projection.
      // visible: false, //true : appear
      startCap: Cap.squareCap,
      endCap: Cap.roundCap,
      points: [
        LatLng(13.014332027132125, 77.5658971904098),
        LatLng(13.014776967628048, 77.58393569709125),
        LatLng(13.04310320071611, 77.59040520370696),
        LatLng(13.041916826676411, 77.5967224866376),
        LatLng(13.04087874472384, 77.62381830258106),
        LatLng(13.028347268983548, 77.63196226973263),
      ],
    );
    polylines.add(polyline);
    Polyline polyline2 = const Polyline(
      polylineId: PolylineId("1"),
      width: 2,
      color: Colors.green,
      // visible: false, //appear
      startCap: Cap.squareCap,
      endCap: Cap.roundCap,
      points: [
        LatLng(-80.19805071707997, 89.51698173417829),
        LatLng(13.041916826676411, 77.5967224866376),
        LatLng(84.36460795500405, 69.48883687225583),
      ],
    );
    polylines.add(polyline2);
  }
}
