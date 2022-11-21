import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:acleanworld/widgets/drawer.dart';
import 'package:acleanworld/utils/utils.dart';

Future<void> main() async {
    runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  static const String route = '/HomePage';
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LocationData? _currentLocation;
  double _currentZoom = 0;
  late final MapController _mapController;
  bool _liveUpdate = false;
  bool _permission = false;
  String? _serviceError = '';
  int interActiveFlags = InteractiveFlag.all;
  final Location _locationService = Location();
  bool debug = true;
  List<trip> currentTrip = [];
  
  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    initLocationService();
    
    if (debug) debugPrint("Supabase.initialize");
    Supabase.initialize(url: 'https://zbqoritnaqhkridbyaxc.supabase.co', anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpicW9yaXRuYXFoa3JpZGJ5YXhjIiwicm9sZSI6ImFub24iLCJpYXQiOjE2Njg2MzI0NDEsImV4cCI6MTk4NDIwODQ0MX0.NO3SvLCPEmXMFIVFiHBYV9ZLp0o2IFgndMzpkwQG_F0');
    final supabase = Supabase.instance.client;
        //showAlert(context, "Ready to Rock and Roll!", 0);
  }

   void initLocationService() async 
   {
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
                // If Live Update is enabled, move map center
                if (_liveUpdate) 
                {
                   //showAlert(context, "Ready to Rock and Roll! \n ${_currentLocation!.latitude!}", 0);
                   print("Logging position ");
                  _mapController.move(LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!), _mapController.zoom);
                  // Todo log trip data here:
                  currentTrip.add(trip(lat: _currentLocation!.latitude!, long: _currentLocation!.longitude!));
                }
              });
            }
          });
        }
      } 
      else 
      {
        serviceRequestResult = await _locationService.requestService();
        if (serviceRequestResult) 
        {
          initLocationService();
          return;
        }
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      if (e.code == 'PERMISSION_DENIED') 
      {
        _serviceError = e.message;
        showAlert(context, _serviceError!, 1);
      } 
      else if (e.code == 'SERVICE_STATUS_ERROR') 
      {
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
    if (_currentLocation != null) 
    {
      currentLatLng = LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
      _currentZoom = _mapController.zoom;
    } 
    else 
    {
      currentLatLng = LatLng(0, 0);
      _currentZoom = 17;
    }

    final markers = <Marker>
    [
      Marker
      (
        width: 80,
        height: 80,
        point: currentLatLng,
        builder: (ctx) => const Icon(Icons.my_location),
      ),
    ];

    return Scaffold(      
      appBar: AppBar
      (
        title: const Text('A Cleaner World')
      ),
      drawer: buildDrawer(context, HomePage.route),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: 
          [
            Padding
            (
              padding: const EdgeInsets.only(top: 0, bottom: 8),
              child: _serviceError!.isEmpty
                  ? Text('Din position: (${currentLatLng.latitude}, ${currentLatLng.longitude}) and Zoom=$_currentZoom' )//Text('This is a map that is showing (${currentLatLng.latitude}, ${currentLatLng.longitude}) and zoom=${_mapController.zoom}.')
                  : Text('Error occured while acquiring location. Error Message : $_serviceError'),
            ),
            Flexible
            (
              child: FlutterMap
              (
                mapController: _mapController,
                options: MapOptions
                (
                  maxZoom: 18.49,
                  center: LatLng(currentLatLng.latitude, currentLatLng.longitude),                  
                  interactiveFlags: interActiveFlags,
                ),
                children: 
                [
                  TileLayer
                  (
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  ),
                  MarkerLayer(markers: markers),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Builder(builder: (BuildContext context) {
        return FloatingActionButton(
          onPressed: () 
          {
            setState(() 
            {
              _liveUpdate = !_liveUpdate;
              if (_liveUpdate) 
              {
                if (debug)  debugPrint("Start Button pressed");
                _mapController.move(LatLng(currentLatLng.latitude, currentLatLng.longitude), 18.49);
                interActiveFlags = InteractiveFlag.rotate | InteractiveFlag.pinchZoom | InteractiveFlag.doubleTapZoom;
                // Todo call dialog box to start recording trip in to an array

                
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar( content: Text('I live update mode virker kun zoom og rotation.'),));
              } 
              else 
              {
                if (debug)  debugPrint("Stop Button pressed");
                _mapController.move(LatLng(currentLatLng.latitude, currentLatLng.longitude), 18.49);
                interActiveFlags = InteractiveFlag.all;
                // Todo call dialog box to stop recording current trip or cancel trip. Get notes and kg litter collected and update Database.
                if (debug)  
                {
                  for (var trip in currentTrip) 
                  {                    
                      debugPrint("lat is: ${trip.lat} and long is: ${trip.long}");                    
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
    );
  }
}
