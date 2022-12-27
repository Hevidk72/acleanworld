import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
//Custom utils
import './widgets/drawer.dart';
import './utils/utils.dart';
import 'globals.dart' as globals;

bool debug = globals.bDebug;

Future<void> main() async {
  runApp(const RecordMap());
}

class RecordMap extends StatefulWidget {
  static const String route = "/RecordMap";
  const RecordMap({Key? key}) : super(key: key);

  @override
  _RecordMapState createState() => _RecordMapState();
}

class _RecordMapState extends State<RecordMap> {
  LocationData? _currentLocation;
  double _currentZoom = 0;
  late final MapController _mapController;
  bool _liveUpdate = false;
  bool _permission = false;
  String? _serviceError = '';
  int interActiveFlags = InteractiveFlag.all;
  final Location _locationService = Location();

  // Trip Variables
  List<trip> currentTrip = [];
  List<LatLng> currpoints = [];
  bool initialPosition = false;
  late DateTime startTime_;
  late DateTime stopTime_;
  String description_ = "A nice day to collect litter";
  late final TextEditingController _descriptionController = TextEditingController();
  late final TextEditingController _kgController = TextEditingController();

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

                // If Live Update / Recording trip is enabled, move map center
                if (_liveUpdate) {
                  if (debug) print("Logging position setting camera to current location");
                  _mapController.move(LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),_mapController.zoom);

                  // logging trip data here:
                  currentTrip.add(trip(lat: _currentLocation!.latitude!,long: _currentLocation!.longitude!));
                  currpoints.add(LatLng(_currentLocation!.latitude!,_currentLocation!.longitude!));
                }
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
      appBar: AppBar(title: const Text('A Cleaner World',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0)), 
                     centerTitle: true, 
                     actions: <Widget>[
                                        Text(globals.gUser?.email ?? "",
                                             style: const TextStyle(color: Colors.amber,
                                             fontSize: 12),
                                        ), 
                                      ]),  
      drawer: buildDrawer(context, RecordMap.route),
      body: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 8),
              child: _serviceError!.isEmpty
                  ? Text('Din position: (${currentLatLng.latitude}, ${currentLatLng.longitude}) og Zoom=$_currentZoom') 
                  //Text('This is a map that is showing (${currentLatLng.latitude}, ${currentLatLng.longitude}) and zoom=${_mapController.zoom}.')
                  : Text('Fejl ved at finde din lokation. Fejl Besked : $_serviceError'),
            ),
            Flexible(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  maxZoom: 18.49,
                  center: LatLng(currentLatLng.latitude, currentLatLng.longitude),
                  interactiveFlags: interActiveFlags,
                ),
                children: [
                  TileLayer( urlTemplate:'https://tile.openstreetmap.org/{z}/{x}/{y}.png',  userAgentPackageName: 'dev.fleaflet.flutter_map.example',),
                  MarkerLayer(markers: markers),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                          isDotted: true,
                          points: currpoints,
                          strokeWidth: 4,
                          color: Colors.green),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Builder(builder: (BuildContext context) {
        return FloatingActionButton(
          onPressed: () {
            setState(() {
              _liveUpdate = !_liveUpdate;
              if (_liveUpdate) 
              {
                if (debug) print("Start Button pressed");
                _mapController.move(LatLng(currentLatLng.latitude, currentLatLng.longitude), 18.49);
                interActiveFlags = InteractiveFlag.rotate | InteractiveFlag.pinchZoom | InteractiveFlag.doubleTapZoom;
                // Todo call dialog box to start recording trip in to an array
                //Clear trip and polyline
                currentTrip.clear();
                currpoints.clear();
                startTime_ = DateTime.now();   
                
                // Snackbar messsage
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Din tur registreres nu, og kun zoom og rotation virker nu.'),));
              } 
              else 
              {
                if (debug) print("Stop/resume Button pressed");
                _mapController.move(LatLng(currentLatLng.latitude, currentLatLng.longitude), 18.49);
                interActiveFlags = InteractiveFlag.all;
                // Todo call dialog box to stop recording current trip or cancel trip. Get notes and kg litter collected and update Database.
                

                // Dialog: Do you want to save this trip ?.
                // Ask for trip litter weight in kg approx.
                // Calculate trip length in meters
                if (debug) print("Before end Dialog");
                showEndTripDialog(context,"Afslut tur eller fortsæt ?",2);
                if (debug) print("After end Dialog");

                // Add trip to database and draw current trip on Polyline layer
                if (debug)
                {
                  for (var trip in currentTrip) 
                  {
                    print("lat is: ${trip.lat} and long is: ${trip.long}");
                    // currpoints.add(LatLng(trip.lat,trip.long));
                  }
                }                
                }
            });
          },
          child: _liveUpdate
              ? const Icon(Icons.stop_sharp)
              : const Icon(Icons.play_arrow),
        );
      }),
    )
   );
  }

  // End Trip
  showEndTripDialog(
    BuildContext context, String messageText, int delayed)  async {
    await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text(messageText,style: const TextStyle(color: Colors.black,fontSize: 18.0)),
        content: Column(mainAxisAlignment: MainAxisAlignment.center,mainAxisSize: MainAxisSize.min,children: 
        [
          TextFormField(autofocus: true,decoration: const InputDecoration(hintText: "Beskrivelse"),controller: _descriptionController,),
          TextFormField(decoration: const InputDecoration(hintText: "Antal kg samlet?"),controller: _kgController,)       
        ]
        ),
        actions: <Widget>
        [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: 
          [
            OutlinedButton(child: const Text("Afslut"), onPressed: () { endTrip(); Navigator.of(context).pop(); },),
            OutlinedButton(child: const Text("Fortsæt"), onPressed: ()  { _liveUpdate=true; Navigator.of(context).pop(); },),
          ], )
        ],
      );
    },
  );
}

  Future<void> endTrip()
  async {
    var currentTripsMap = currentTrip.map((e){return {"lat": e.lat, "long": e.long};}).toList();
    var jsonTrip = jsonEncode(currentTripsMap);
    if (debug) print(jsonTrip);
    // Add trip to cloud database:
    stopTime_ = DateTime.now();
    //var data = 
    await globals.dataBase.from('trips_tab').insert
    (
      {
      "user_id": globals.gUser?.id,
      "trip_data": jsonTrip,
      "litter_collected": _kgController.text,
      "description": _descriptionController.text,
      "start_date": startTime_.toIso8601String(),
      "stop_date": stopTime_.toIso8601String()
     }
    );    
    
    _liveUpdate = false;

  }
}