##  Google Maps Flutter Notes
```
	.\gradlew signingReport
```
sha1 each project have same sha because the make debug when you upload to google store the sha change so should change for google map


---


## 🔍 Zoom Levels in Google Maps

| Zoom Level Range | View Type       | Description                                     |
|------------------|------------------|-------------------------------------------------|
| 1 → 3 🌍         | World View       | See entire continents or the globe              |
| 4 → 6 🌐         | Country View     | Countries or large regions                      |
| 10 → 12 🏙️       | City View        | Detailed view of individual cities              |
| 13 → 17 🛣️       | Street View      | Roads, neighborhoods, and finer city details    |
| 18 → 20 🏢       | Building View    | Buildings, individual houses, and storefronts   |

> ⚠️ **Note:** These zoom values are approximate and can vary depending on device and map resolution.



```dart
```dart
GoogleMap(
      initialCameraPosition: CameraPosition(
        zoom: 8,
        target: LatLng(
          13.046279282623589,
          77.59288321390162,
        ),
      ),
    )

```

---

## controller in map

can not initial googleMapController director 
so :

```dart
```dart
late GoogleMapController googleMapController;
```dart
GoogleMap(
          onMapCreated: (controller) {
            googleMapController = controller;
          },

```
 
```dart
googleMapController.animateCamera(CameraUpdate.newLatLng(
                  LatLng(12.317784225421597, 76.654293337011)));
            },

```
## dispose
  @override
  ```dart
```dart
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

```

---

## mapType

```dart
mapType: MapType.terrain : just the mount is 3D
	 MapType.satellite : 3D map without name and detail
	 MapType.hybrid : 3D map with detail
	 MapType.normal : normal map <default>

```

## style for map

1) https://mapstyle.withgoogle.com/
2) https://snazzymaps.com/  <<more detail + confirmed>>
3) https://stylist.atlist.com/ <<little detail + fast>>

##  apply
1)
var darkMap = await DefaultAssetBundle.of(context).loadString("assets/map_style/dark_map.json");
    googleMapController.setMapStyle(darkMap); // 'setMapStyle' is deprecated and shouldn't be used
2)
style = await rootBundle.loadString('assets/map_style/dark_map.json'); + setState(() {});
```dart
```dart
GoogleMap(
          style: style,...

```

---


## marker

marker : select special location 


// moedel
```dart
```dart
class MarkerModel {
  final String id;
  final String name;
  final LatLng latLng;
  
```
  static List<MarkerModel> marker = const [
    MarkerModel(
      id: "1",
      name: "King",
```dart
      latLng: LatLng(
        13.022343863196378,
        77.63909922043815,
      ),
    ),
    MarkerModel(
      id: "1",
      name: "Some Thing",
      latLng: LatLng(
        13.010048923522781,
        77.55100088504592,
      ),
    ),
  ];
}

```
//main
```dart
```dart
late Set<Marker> markers;

```
 ```dart
```dart
 GoogleMap(
        markers: markers,...

```

```dart
```dart
void initMarkerMap() {
    markers = MarkerModel.marker
        .map(
          (element) => Marker(
            markerId: MarkerId(element.id),
            position: element.latLng,
            infoWindow: InfoWindow(title: element.name),
          ),
        )
        .toSet();
  }

```
## change markers icon
1)
// { give me all markers have same id and different position }
    markers.addAll(MarkerModel.marker
        .map(
```dart
          (element) => element.id == "1"? Marker(
            icon: AssetMapBitmap(
              //you’re passing a new object each time
              "assets/images/dragon-removebg-preview.png",
              width: 40,
              height: 40,
            ),
            markerId: MarkerId(element.id),
            position: element.latLng,
            infoWindow: InfoWindow(title: element.name),
          ):null,
        ).whereType<Marker>()//delete null value . just take type have marker DataType
        .toSet());

```
2)
//{ give just the last markers when markers have same id if want all appear make unique id }
    Uint8List icon =
        await resetIcon("assets/images/dragon-removebg-preview.png", 40, 40);
// log ("icon : $icon");
    Set<Marker> data = MarkerModel.marker.asMap().entries.map(
      (element) {
         final clonedIcon = Uint8List.fromList(icon);
```dart
        return element.value.id == "1"//{just catecory have id = "1"}?Marker(
          icon: BytesMapBitmap(clonedIcon), // causing deduplication
          markerId: MarkerId(element.value.id + element.key.toString()),//display all markers have same id
          position: element.value.latLng,
          infoWindow: InfoWindow(title: element.value.name),
        ):null;
      },
    ).whereType<Marker>().toSet();
    log("data : ${data.length}");
    markers.addAll(data);
    setState(() {
      log("length : ${markers.length}");
    });

```


---


## polyline

 ```dart
```dart
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
        LatLng(...
	]

```

## polygon

 ```dart
```dart
 Polygon polygon =  Polygon(
      polygonId: PolygonId("1"),
      strokeWidth: 1,
      // fillColor: Colors.grey.withAlpha(120),
      fillColor: Colors.grey.withOpacity(0.3),
      strokeColor: Colors.grey,
      points: [
        LatLng(13.014332027132125, 77.5658971904098),
        LatLng(13.014776967628048, 77.58393569709125),
        LatLng(13.04310320071611, 77.59040520370696),
        LatLng(13.041916826676411, 77.5967224866376),
        LatLng(13.04087874472384, 77.62381830258106),
        LatLng(13.028347268983548, 77.63196226973263),
      ],
      holes: [[
         LatLng(13.050369484489758, 77.60528859717826),
        LatLng(13.031521055069245, 77.60133846249931),
        LatLng(13.031082048539954, 77.60322673769438),
        LatLng(13.03191825078206, 77.60421379063727),
        LatLng(13.032817165041957, 77.60339839907576),
      ]],
    );

```
## circle

 ```dart
```dart
 Circle circle = Circle(
      circleId: CircleId("1"),
      strokeWidth: 2,
      fillColor: Colors.yellow.withOpacity(0.3),
      strokeColor: Colors.red,
      center: LatLng(13.027177383649434, 77.61094094053026),
      radius:
          1000, //Radius of the circle in meters; must be positive. The default value is 0.
    );

```

---


## location package
```dart
```dart
class LocationService {
  Location location = Location();

```
  ```dart
```dart
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

```
  ```dart
```dart
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

```
  ```dart
```dart
  void getRealTimeLocationData(void Function(LocationData)? onData) {
    location.changeSettings(
      // interval: 2000, // means 2 seconds
      // distanceFilter: 5 // 5 metter
    );
    location.onLocationChanged.listen(onData);
  }
}

```
```dart
///void Function(LocationData)? onData

```
 (locationData) {
```dart
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
            // } else {
              googleMapController?.animateCamera(
                CameraUpdate.newLatLng(latLng),
              );
              markers.add(
                Marker(markerId: const MarkerId("value"), position: latLng),
              );
              setState(() {});
            }
          },
        
```




## Bounds

### minimum point for southwest
### maximu point for northeast

```dart
 Polyline displayRoute(String encodedPolyline) {
    List<PointLatLng> result = polylinePoints.decodePolyline(encodedPolyline);
    selectBoundlePolyline(result);
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
    return polyline;
    // setState(() {});
  }

  void selectBoundlePolyline(List<PointLatLng> points) {
    double southwestLatitude = points.first.latitude;
    double southwestLongitude = points.first.longitude;
    double northeastLatitude = points.first.latitude;
    double northeastLongitude = points.first.longitude;
    for (var element in points) {
      southwestLatitude = min(southwestLatitude, element.latitude);
      southwestLongitude = min(southwestLongitude, element.longitude);
      northeastLatitude = max(northeastLatitude, element.latitude);
      northeastLongitude = max(northeastLongitude, element.longitude);
    }
    bounds = LatLngBounds(
      /*minimum point*/
      southwest: LatLng(
        southwestLatitude,
        southwestLongitude,
      ),
      /*maximum point */
      northeast: LatLng(
        northeastLatitude,
        northeastLongitude,
      ),
    );
  }
```



---

## 📚 More Knowledge

- 🗺️ `GoogleMapController.animateCamera()` helps in dynamic camera movement.
- 📌 Use **custom markers** with assets or bytes for visual clarity.
- 🎨 Apply custom **map styles** from:
  - [Google Map Style Wizard](https://mapstyle.withgoogle.com/)
  - [Snazzy Maps](https://snazzymaps.com/) ✅
  - [Atlist Stylist](https://stylist.atlist.com/)
- 🚦 Polygons, Polylines, and Circles can be layered with zIndex.
- 🔐 Manage permissions using the `location` package:
  - Check service status
  - Request runtime permissions
  - Listen for real-time updates
- 💡 Use `setState(() {})` after location or marker updates for UI refresh.
- 🧹 Don’t forget to call `googleMapController.dispose()` in `dispose()` lifecycle!

✨ Mastering these makes your map features stand out beautifully in any Flutter app!
