import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_map/section8/models/autocomplet_model/autocomplet_model.dart';
import 'package:google_map/section8/utils/my_service.dart';
import 'package:google_map/section8/widget/custom_text_field.dart';
import 'package:google_map/section8/widget/list_autocomplete.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class Section8 extends StatefulWidget {
  const Section8({super.key});

  @override
  State<Section8> createState() => _Section8State();
}

class _Section8State extends State<Section8> {
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  late CameraPosition initialCameraPosition;
  late GoogleMapController googleMapController;
  late TextEditingController textEditingController;
  late MyService myService;
  List<AutocompleteModel> autocompleteData = [];
  late Uuid uuid;
  Timer? time;

  @override
  void initState() {
    uuid = const Uuid();
    initialCameraPosition =
        const CameraPosition(target: LatLng(0, 0), zoom: 14);
    textEditingController = TextEditingController();
    textEditingController.addListener(searchAutocomplete);
    myService = MyService();
    super.initState();
  }

  @override
  dispose() {
    textEditingController.dispose();
    googleMapController.dispose();
    time?.cancel();
    super.dispose();
  }

  void searchAutocomplete() {
    if (time?.isActive ?? false) {
      time!.cancel();
    }
    time = Timer(const Duration(milliseconds: 500), () async {
      await myService.autocompleteListen(
        textEditingController: textEditingController,
        autocompleteData: autocompleteData,
      );
      setState(() {});
    });
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
              onMapCreated: (controller) async {
                googleMapController = controller;
                await myService.updateLocation(
                    googleMapController: googleMapController,
                    markers: markers,
                    refresh: () {
                      setState(() {});
                    });
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
                    myService: myService,
                    data: autocompleteData,
                    onTap: (detailData) async {
                      autocompleteData.clear();
                      textEditingController.clear();

                      await myService.fetchRoute(
                        detailData: detailData,
                        polylines: polylines,
                        markers: markers,
                        googleMapController: googleMapController,
                      );
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,

              child: ElevatedButton(
                onPressed: () async{
                  await myService.selectDirection(googleMapController: googleMapController);
                },
                child: const Text("Directions"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
