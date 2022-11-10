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
          centerTitle:true,
          leading: const Icon(Icons.menu_book),
        ),
        
        body: Container(
          // in the below line, creating google maps.
          child: FlutterMap(
            options:
              MapOptions(center: LatLng(-12.069783, -77.034057), zoom: 13.0),
          layers: [
            TileLayerOptions(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),              
            MarkerLayerOptions(markers: [
              Marker(
                  width: 30.0,
                  height: 30.0,
                  point: LatLng(-12.069783, -77.034057),
                  builder: (ctx) => Container(
                          child: Container(
                        child: Icon(
                          Icons.location_on,
                          color: Colors.blueAccent,
                          size: 20,
                        ),
                      )))
            ])]
          )));
  }
  /*
  LatLng initLocation()
  async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) 
    {
      _serviceEnabled = await location.requestService();
      
      if (!_serviceEnabled) 
      {
        return;
      }      
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) 
    {
      _permissionGranted = await location.requestPermission();      
      if (_permissionGranted != PermissionStatus.granted) 
      {
        return;
      }      
    }
  _locationData = await location.getLocation();
  print("_locationData.latitude="+_locationData.latitude.toString()+" _locationData.longitude="+_locationData.longitude.toString());
  _controller.complete(controller);              
  controller.moveCamera(CameraUpdate.newLatLng(LatLng(_locationData.latitude!, _locationData.longitude!)));
  }
  */


}
