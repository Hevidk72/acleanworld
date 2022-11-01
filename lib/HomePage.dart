import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
 }

class _HomePageState extends State<HomePage> {
   // Location
  late Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  bool bDebugMode = true;

// in the below line, we are initializing our controller for google maps.
  Completer<GoogleMapController> _controller = Completer();

// in the below line, we are specifying our camera position
  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(55.6577776, 9.3990118),
    zoom: 19,
  );
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // in the below line, we are specifying our app bar.
        appBar: AppBar(
          // setting background color for app bar
          backgroundColor: Color(0xFF0F9D58),
          // setting title for app bar.
          title: const Text("A Clean World"),
          centerTitle:true,
          leading: const Icon(Icons.keyboard_backspace,          
          ),
        ),
        
        body: Container(
          // in the below line, creating google maps.
          child: GoogleMap(
            // in the below line, setting camera position
            initialCameraPosition: _kGoogle, 
            // in the below line, specifying map type.
            mapType: MapType.hybrid,
            // in the below line, setting user location enabled.
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            // in the below line, setting compass enabled.
            compassEnabled: true,
            // in the below line, specifying controller on map complete.
            onMapCreated: (GoogleMapController controller) {      
               initLocation(controller);
              /*  
              _controller.complete(controller);              
              controller.moveCamera(CameraUpdate.newLatLng(
                  LatLng(_locationData.latitude!, _locationData.longitude!)));
              */
            },
          ),
        ));
  }
/*
  void initState() 
  {   
    super.initState();     
  }
  */
  void initLocation(GoogleMapController controller)
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
  
/*
  Future<LocationData> getCurrentLocation() 
  async {
   bool _serviceEnabled;
   LocationData curpos;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) 
    {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) 
      {
        //return null;
      }
    }
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) 
    {
      _permissionGranted = await _location.requestPermission();
    }
    // Get Current GPS position
    curpos = await _location.getLocation();

    if (bDebugMode) 
    {
      print("Lat="+curpos.latitude.toString()+" Lng="+curpos.longitude.toString());
    }
    
    return curpos;  
  }
  */


}
