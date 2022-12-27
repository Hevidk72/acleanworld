import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
//Custom utils
import './widgets/Drawer.dart';
import './utils/Utils.dart';
import 'Globals.dart' as globals;

bool debug = globals.bDebug;

Future<void> main() async {
  runApp(const HistoryMap());
}

class HistoryMap extends StatefulWidget {
  static const String route = "/HistoryMap";
  const HistoryMap({Key? key}) : super(key: key);

  @override
  _HistoryMapState createState() => _HistoryMapState();
}

class _HistoryMapState extends State<HistoryMap> {
  LocationData? _currentLocation;
  double _currentZoom = 0;
  late final MapController _mapController;
  bool _permission = false;
  String? _serviceError = '';
  int interActiveFlags = InteractiveFlag.all;
  final Location _locationService = Location();
  bool initialPosition = false;

  late Future<List<Polyline>> polylines;
  Future<List<Polyline>> getPolylines() async {
    final polyLines = [
      Polyline(
        points: [
          LatLng(50.5, -0.09),
          LatLng(51.3498, -6.2603),
          LatLng(53.8566, 2.3522),
        ],
        strokeWidth: 4,
        color: Color.fromARGB(255, 90, 243, 2),
      ),
    ];
    await Future<void>.delayed(const Duration(seconds: 3));
    return polyLines;
  }

  @override
  initState() {
    super.initState();
    _mapController = MapController();
    initLocationService();    
  }

  void initLocationService() async {
    await _locationService.changeSettings(accuracy: LocationAccuracy.high, interval: 1000);

    LocationData? location;
    bool serviceEnabled;
    bool serviceRequestResult;

    try {
      serviceEnabled = await _locationService.serviceEnabled();

      if (serviceEnabled) {
        final permission = await _locationService.requestPermission();
        _permission = permission == PermissionStatus.granted;

        if (_permission) {
          location = await _locationService.getLocation();
          _currentLocation = location;
          _locationService.onLocationChanged
              .listen((LocationData result) async {
            if (mounted) {
              setState(() {
                _currentLocation = result;
                if (debug) print(" Time / Speed = ${_currentLocation!.time} / ${_currentLocation!.speed}");

                // initial position
                if (!initialPosition) {
                  _mapController.move(
                      LatLng(_currentLocation!.latitude!,
                          _currentLocation!.longitude!),
                      globals.MaxZoom);
                }
                initialPosition = true;
              });
            }
          });
        }
      } else {
        serviceRequestResult = await _locationService.requestService();
        if (serviceRequestResult) {
          initLocationService();
          return;
        }
      }
    } on PlatformException catch (e) {
      if (debug) print(e.toString());
      if (e.code == 'PERMISSION_DENIED') {
        _serviceError = e.message;
        showAlert(context, _serviceError!, 1);
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        _serviceError = e.message;
        showAlert(context, _serviceError!, 1);
      }
      location = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    LatLng currentLatLng;
    // Until currentLocation is initially updated, Widget can locate to 0, 0
    // by default or store previous location value to show.
    if (_currentLocation != null) {
      currentLatLng =
          LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
      _currentZoom = _mapController.zoom;
    } else {
      currentLatLng = LatLng(0, 0);
      _currentZoom = 17;
    }

    final markers = <Marker>[
      Marker(
        width: 40,
        height: 40,
        point: currentLatLng,
        builder: (ctx) => const Icon(Icons.my_location),
      ),
    ];

   return WillPopScope(
        onWillPop: () async {
          return globals.onWillPop(context);
        },
        child: Scaffold(
      appBar: AppBar(title: const Text('A Cleaner World (Historik)',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)), 
                     centerTitle: true, 
                     actions: <Widget>[
                                        Text(globals.gUser?.email ?? "",
                                             style: const TextStyle(color: Colors.amber,
                                             fontSize: 12),
                                        ), 
                                      ]),  
      drawer: buildDrawer(context, HistoryMap.route),
      body: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 8),
              child: _serviceError!.isEmpty
                  ? Text('pos: (${currentLatLng.latitude}, ${currentLatLng.longitude}) og Zoom=$_currentZoom') 
                  //Text('This is a map that is showing (${currentLatLng.latitude}, ${currentLatLng.longitude}) and zoom=${_mapController.zoom}.')
                  : Text('Fejl ved at finde din lokation. Fejl Besked : $_serviceError'),
            ),
            Flexible(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  maxZoom: globals.MaxZoom,
                  center: LatLng(currentLatLng.latitude, currentLatLng.longitude),
                  interactiveFlags: interActiveFlags,
                ),
                children: [
                  TileLayer( urlTemplate:'https://tile.openstreetmap.org/{z}/{x}/{y}.png',  userAgentPackageName: 'dev.fleaflet.flutter_map.example',),
                  MarkerLayer(markers: markers),
                 // PolylineLayer(polylines: [ getPolylines() ]),
                ],
              ),
            ),
          ],
        ),
      ),
    )
   );
  }




}