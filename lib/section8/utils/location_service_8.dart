import 'package:location/location.dart';

class LocationService8 {
  Location location = Location();

  Future<void> checkAndRequiredLocationService() async {
    bool isServiceEnable = await location.serviceEnabled();
    if (!isServiceEnable) {
      isServiceEnable = await location.requestService();
      if (!isServiceEnable) {
        throw LocationServiceException();
      }
    }
  }

  Future<void> checkAndRequiredLocationPermission() async {
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.deniedForever) {
      throw LocationPermissionException();
    } else if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        throw LocationPermissionException();
      }
    }
  }

  Future<void> getRealTimeLocationData(
      void Function(LocationData)? onData) async {
    await checkAndRequiredLocationService();
    await checkAndRequiredLocationPermission();
    location.changeSettings(
        interval: 5000, // 2000 means 2 seconds
        distanceFilter: 5 // 5 metter
        );
    location.onLocationChanged.listen(onData);
  }

  Future<LocationData> getCurrentLocation() async {
    await checkAndRequiredLocationService();
    await checkAndRequiredLocationPermission();
    return location.getLocation();
  }
}

class LocationServiceException implements Exception {}

class LocationPermissionException implements Exception {}
