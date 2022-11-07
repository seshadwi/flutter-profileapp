import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:geocoder/geocoder.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late GoogleMapController mapController;

  static const double _defaultLat = -6.3439167;
  static const double _defaultLng = 106.8866944;

  // final LatLng _center = const LatLng(-6.3439167, 106.8866944);

  static const CameraPosition _defaultLocation =
      CameraPosition(target: LatLng(_defaultLat, _defaultLng), zoom: 15);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  MapType _currentMapType = MapType.normal;
  final Set<Marker> _markers = {};

  void _changeMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _addMarker() async {
    var addresses = await Geocoder.local
        .findAddressesFromCoordinates(Coordinates(_defaultLat, _defaultLng));
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('defaultLocation'),
          position: _defaultLocation.target,
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: "${addresses.first.featureName}",
            snippet: "${addresses.first.addressLine}",
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Maps App'),
        backgroundColor: Colors.green[700],
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: _defaultLocation,
            mapType: _currentMapType,
            markers: _markers,
            // CameraPosition(
            // target: _center,
            // zoom: 11.0,
            // ),
          ),
          Container(
            padding: EdgeInsets.only(top: 24, right: 12),
            alignment: Alignment.topRight,
            child: Column(
              children: <Widget>[
                FloatingActionButton(
                  onPressed: _changeMapType,
                  backgroundColor: Colors.green,
                  child: const Icon(
                    Icons.map,
                    size: 30,
                  ),
                ),
                SizedBox(height: 20),
                FloatingActionButton(
                  onPressed: _addMarker,
                  backgroundColor: Colors.deepPurpleAccent,
                  child: const Icon(
                    Icons.location_pin,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'src/locations.dart' as locations;

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final Map<String, Marker> _markers = {};
//   Future<void> _onMapCreated(GoogleMapController controller) async {
//     final googleOffices = await locations.getGoogleOffices();
//     setState(() {
//       _markers.clear();
//       for (final office in googleOffices.offices) {
//         final marker = Marker(
//           markerId: MarkerId(office.name),
//           position: LatLng(office.lat, office.lng),
//           infoWindow: InfoWindow(
//             title: office.name,
//             snippet: office.address,
//           ),
//         );
//         _markers[office.name] = marker;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Google Office Locations'),
//           backgroundColor: Colors.green[700],
//         ),
//         body: GoogleMap(
//           onMapCreated: _onMapCreated,
//           initialCameraPosition: const CameraPosition(
//             target: LatLng(0, 0),
//             zoom: 2,
//           ),
//           markers: _markers.values.toSet(),
//         ),
//       ),
//     );
//   }
// }
