import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Location
  late Location location = Location();
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  bool _serviceEnabled = false;
  double curLati = 55.6577728;
  double curLong = 9.399007;
  final mapController = MapController();

  bool bDebugMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // in the below line, we are specifying our app bar.
      appBar: AppBar(
        // setting background color for app bar
        backgroundColor: Colors.blueAccent,
        // setting title for app bar.
        title: const Text("A Cleaner World"),
        centerTitle: true,
        leading: const Icon(Icons.menu),
      ),
      body: Container(
          // in the below line, creating google maps.
          child: FlutterMap(
              mapController: mapController,
              options: MapOptions(center: LatLng(curLati, curLong), zoom: 17.0),
              layers: [
            TileLayerOptions(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
            MarkerLayerOptions(markers: [
              Marker(
                  width: 30.0,
                  height: 30.0,
                  point: LatLng(curLati, curLong),
                  builder: (ctx) => Container(
                          child: Container(
                        child: Icon(
                          Icons.location_on,
                          color: Colors.blueAccent,
                          size: 40,
                        ),
                      )))
            ])
          ])),
    );
  }

  void initLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();

      if (!_serviceEnabled) {
        print("_locationData.latitude=" +
            _locationData.latitude.toString() +
            " _locationData.longitude=" +
            _locationData.longitude.toString());
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print("_locationData.latitude=" +
            _locationData.latitude.toString() +
            " _locationData.longitude=" +
            _locationData.longitude.toString());
        return;
      }
    }
    _locationData = await location.getLocation();
    curLati = _locationData.latitude!;
    curLong = _locationData.longitude!;

    print("_locationData.latitude=" +
        _locationData.latitude.toString() +
        " _locationData.longitude=" +
        _locationData.longitude.toString());
  }

  @override
  void initState() {
    super.initState();
   
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use `MapController` as needed
      initLocation();
      mapController.move(LatLng(curLati,curLong), 17.0);
    });
    // after map move 
    print("_locationData.latitude=" +
        _locationData.latitude.toString() +
        " _locationData.longitude=" +
        _locationData.longitude.toString());
    showAlert(context);
    
  }

  Future showAlert(BuildContext context) async {
    await Future.delayed(Duration(seconds: 6));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Welcome To Our App :) Latitude=" +
              curLati.toString() +
              " Longitude=" +
              curLong.toString()),
          actions: <Widget>[
            OutlinedButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
