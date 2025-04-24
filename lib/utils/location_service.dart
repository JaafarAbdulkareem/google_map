import 'package:location/location.dart';

class LocationService {
  Location location = Location();

  Future<bool> checkAndRequiredLocationService() async {
    bool isServiceEnable = await location.serviceEnabled();
    if (!isServiceEnable) {
      isServiceEnable = await location.requestService();
      if (!isServiceEnable) {
        return false;
      }
    }
    return true;
  }

  Future<bool> checkAndRequiredLocationPermission() async {
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.deniedForever) {
      return false;
    } else if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      return permissionStatus == PermissionStatus.granted;
    }
    return true;
  }

  void getRealTimeLocationData(void Function(LocationData)? onData) {
    location.changeSettings(
        // interval: 2000, // means 2 seconds
        // distanceFilter: 5 // 5 metter
        );
    location.onLocationChanged.listen(onData);
  }
}

// inquire about location service
// request permission
// get location
// display
