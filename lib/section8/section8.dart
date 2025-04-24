import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_map/section8/models/autocomplet/autocomplet_model.dart';
import 'package:google_map/section8/utils/location_service_8.dart';
import 'package:google_map/section8/utils/places_api_service.dart';
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
  List<AutocompleteModel> autocompleteData = [];
  late Uuid uuid;
  String? sessionToken;
  @override
  void initState() {
    uuid = const Uuid();
    initialCameraPosition = const CameraPosition(target: LatLng(0, 0));
    textEditingController = TextEditingController();
    textEditingController.addListener(searchAutocomplete);
    locationService8 = LocationService8();
    placesApiService = PlacesApiService();
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
        log(textEditingController.text);
        List<AutocompleteModel> places =
            await placesApiService.getAutocompleteApi(
          input: textEditingController.text,
           sessiontoken: sessionToken!,
        );
        autocompleteData.addAll(places);
        log("length: ${autocompleteData.length}");
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
      LocationData currentLocation =
          await locationService8.getCurrentLocation();
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
        Marker(markerId: MarkerId("markerId"), position: latLng),
      );
      setState(() {
        log("setState : $latLng");
      });
    } on LocationServiceException catch (_) {
    } on LocationPermissionException catch (_) {
    } catch (_) {}
  }
}
