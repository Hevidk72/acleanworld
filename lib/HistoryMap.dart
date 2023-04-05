import 'dart:convert';
import 'dart:math' as math;
import 'package:acleanworld/globals.dart';
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

class _HistoryMapState extends State<HistoryMap> 
{
  LocationData? _currentLocation;
  double _currentZoom = 0;
  late final MapController _mapController;
  bool _permission = false;
  String? _serviceError = '';
  int interActiveFlags = InteractiveFlag.all;
  final Location _locationService = Location();
  bool initialPosition = false;

  //Future <List<Polyline>> polylines = [Future<Polyline>>(isDotted: true, points: [LatLng(0,0)], strokeWidth: 4, color: Colors.green)];
  late Future<List<Polyline>> polylines;
    
  int trips_ = 0;
 
  @override
  initState() 
  {     
    polylines = getEmptyPolyLine();
    super.initState();    
    initLocationService();
    _mapController = MapController();
  }

  Future<List<Polyline>> getEmptyPolyLine() async {
    var polyLines =[Polyline(points: [LatLng(55.6577721, 9.3988780)],strokeWidth: 4, color: Colors.red, ),];  
    String userId = globals.dataBase.auth.currentUser!.id;     
    int count = 1;
    var polyLine = Polyline(isDotted: true, points: [LatLng(55.6577721,9.3988783)], strokeWidth: 0, color: Colors.green);
    polyLines.add(polyLine);
    /*
    try 
    {
    final List<Map<String, dynamic>> data = await globals.dataBase                
                .from("user_get_trips")
                .select<List<Map<String, dynamic>>>("trip_age_days, trip_data")                
                .match({'user_id::text': userId})
                .order("trip_age_days", ascending: true);       

      // Loop over database records trips
    for (var element in data) 
    { 
      double colorPercent = count/data.length.toInt() * 100;

      // Clear Polyline
      polyLine = Polyline(isDotted: true, points: [LatLng(0,0)], strokeWidth: 4, color: getColorPercent(colorPercent.toInt()));
      
      //print ("trip $count ${globals.getColorValue(count)}");      
      print (element['trip_data']);
          
      polyLine.points.clear();
      for (var word in jsonDecode(element["trip_data"])) 
      {  
        polyLine.points.add(LatLng(word['lat'], word['long']));                
      }
      
      // Adding Polyline to map        
      print ("Adding Polyline $count");
      
      //Add polyline
      polyLines.add(polyLine);

      // increment trip counter
      count++;      
    }       
      trips_ = count-1;                  
    }   
    catch (e) 
          {            
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Fejl ved hentning af profil : $e'),
              backgroundColor: Colors.red,
            ));
          }
          */          
  return Future.value(polyLines);
      //return polyLines;
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

  // Get Polylines with colours
  Future<List<Polyline>> getPolylines(List<Map<String, dynamic>> jsonArray) async 
  {
    int _count = 1;          
    final _polyLines = [Polyline(points:[LatLng(0,9)], strokeWidth: 4, color: Colors.amber)];
    Polyline _polyLine = Polyline(isDotted: true, points: [LatLng(0,0)], strokeWidth: 4, color: Colors.green);
    double _lat,_lng;
    double _tripLength;

    _polyLines.clear();
    // Loop over database records trips
    for (var element in jsonArray) 
    { 
      // Calculate color
      double colorPercent = _count/jsonArray.length.toInt() * 100;

      // define new empty Polyline
      _polyLine = Polyline(isDotted: true, points: [LatLng(0,0)], strokeWidth: 4, color: getColorPercent(colorPercent.toInt()));
      _polyLine.points.clear();
              
      print ("Adding Polyline ${element["trip_data"]}");
      for (var item in jsonDecode(element["trip_data"])) 
      {                
        _polyLine.points.add(LatLng(item['lat'], item['long']));        
        // Calculate length in KM
        //_lat = item['lat'];
        //_lng = item['long'];
      }

      // Adding Polyline to map        
      print ("Adding Polyline $_count");
       
      //Add polyline
      _polyLines.add(_polyLine);

      // increment trip counter
      _count++;      
    }       
      trips_ = _count-1;  
      /*
      if (trips_ == 0)
      {

      }
      */  
      return Future.value(_polyLines);
  }

  @override
  Widget build(BuildContext context) 
  {
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

    void showAction(BuildContext context, int index) async {
      final userId = globals.dataBase.auth.currentUser!.id;
      switch (index) {
        case 0:
        // Current user trips
          try 
          {            
            final List<Map<String, dynamic>> data = await globals.dataBase                
                .from("user_get_trips")
                .select<List<Map<String, dynamic>>>("trip_age_days, trip_data")                
                .match({'user_id': userId})
                .order("trip_age_days", ascending: true);               

            if (data.isNotEmpty) 
            {            
              polylines = getPolylines(data);
            }
            else
            {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ingen ture fundet!'), backgroundColor: Colors.red));
            }
           
          } 
          catch (e) 
          {            
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Fejl ved hentning af profil : $e'),
              backgroundColor: Colors.red,
            ));
          }          
          break;
        case 1:
        // Not Current user
        try { 
          final List<Map<String, dynamic>> data = await globals.dataBase                
                .from("user_get_trips")
                .select<List<Map<String, dynamic>>>("trip_age_days, trip_data")     
                .not('user_id','eq', userId)
                .order("trip_age_days", ascending: true);

            if (data.isNotEmpty) 
            {
              polylines = getPolylines(data);
            }
            else
            {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ingen ture fundet!'), backgroundColor: Colors.red));
            }
          } catch (e) {
            print("SQL Error : $e");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Fejl ved hentning af profil : $e'),
              backgroundColor: Colors.red,
            ));
          }          
          break;
        case 2:
         // All user trips
          try { 
          final List<Map<String, dynamic>> data = await globals.dataBase                
                .from("user_get_trips")
                .select<List<Map<String, dynamic>>>("trip_age_days, trip_data")   
                .order("trip_age_days", ascending: true);
          if (data.isNotEmpty) 
          {
             polylines = getPolylines(data);                       
          }
          else
          {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ingen ture fundet!'), backgroundColor: Colors.red));
          }
          } catch (e) {
            print("SQL Error : $e");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Fejl ved hentning af profil : $e'),
              backgroundColor: Colors.red,
            ));
          }          
          break;
        default:
          if (debug) print('Not implemented yet!');
      }
      
      showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Viser $trips_ ture"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('CLOSE'),
              ),
            ],
          );
        },
      );
      
    }

    return WillPopScope(
        onWillPop: () async {
          return globals.onWillPop(context);
        },
        child: Scaffold(
               appBar: AppBar(
               title: const Text('A Cleaner World (Historik)',
               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
               centerTitle: true),
          drawer: buildDrawer(context, HistoryMap.route),
          body: Padding(
                padding: const EdgeInsets.all(2),
                child: 
                FutureBuilder<List<Polyline>>
                (
                   future: polylines,
                   builder: (BuildContext context, AsyncSnapshot<List<Polyline>> snapshot) 
                   {
                             print('snapshot: ${snapshot.hasData}');
                             if (snapshot.hasData) 
                             {
                                return Column(
                                       children: [
                                       Padding(
                                        padding: const EdgeInsets.only(top: 0, bottom: 8),
                                        child: _serviceError!.isEmpty
                                        ? Text('pos: (${currentLatLng.latitude}, ${currentLatLng.longitude}) og Zoom=$_currentZoom')
                                        : Text('Fejl ved at finde din lokation. Fejl Besked : $_serviceError'),
                                        ),
                                      /*  DropdownButtonFormField(items: <String>['1','2','3','4'].toList(),
                                        onChanged: (value) {
                                          
                                        },),                */
                                      Flexible
                                      (                                        
                                        child: FlutterMap
                                        (
                                               mapController: _mapController,
                                               options: MapOptions
                                               (maxZoom: globals.MaxZoom,
                                                center: LatLng(currentLatLng.latitude, currentLatLng.longitude),
                                                interactiveFlags: interActiveFlags,      
                                                
                                               /* onTap: (tapPosition, point) 
                                                {
                                                  setState(() 
                                                  {
                                                    debugPrint('onTap');
                                                    polylines = getPolylines();
                                                  });
                                                }
                                                */
                                               ),
                                              children: 
                                              [
                                                TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'dev.fleaflet.flutter_map.example'),
                                                MarkerLayer(markers: markers),
                                                PolylineLayer(polylines: snapshot.data!, polylineCulling: true),
                                              ],    
                                        ),
                                      ),
                                ],
                                );
                                
                              }
                                                   
                  // Map data not ready
                 // return const Text(
                 // 'Getting map data...\n\nTap on map when complete to refresh map data.');
               return FlutterMap
                                        (
                                               mapController: _mapController,
                                               options: MapOptions
                                               (maxZoom: globals.MaxZoom,
                                                center: LatLng(currentLatLng.latitude, currentLatLng.longitude),
                                                interactiveFlags: interActiveFlags,                             
                                               /* onTap: (tapPosition, point) 
                                                {
                                                  setState(() 
                                                  {
                                                    debugPrint('onTap');
                                                    polylines = getPolylines();
                                                  });
                                                }
                                                */
                                               ),
                                              children: 
                                              [
                                                TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'dev.fleaflet.flutter_map.example'),
                                                MarkerLayer(markers: markers),
                                               // PolylineLayer(polylines: snapshot.data!, polylineCulling: true),
                                              ],    
                                        );
                 }
                )),
                floatingActionButton: ExpandableFab(
                  distance: 90.0,
                  children: 
                  [
                    ActionButton
                    (
                      icon: Image.asset("assets/Mine.png"),
                      onPressed: () => {setState(() 
                      {
                        showAction(context, 0);
                       _mapController.move(LatLng(currentLatLng.latitude, currentLatLng.longitude), globals.MaxZoom);
                      })},
                    ),                    
                    ActionButton
                    (
                      icon: Image.asset("assets/Andre.png"),
                      onPressed: () => {setState(() 
                      {
                        showAction(context, 1);
                        _mapController.move(LatLng(currentLatLng.latitude, currentLatLng.longitude), globals.MaxZoom);
                      })},
                    ),
                    ActionButton
                    (
                      icon: Image.asset("assets/Alle.png"),
                      onPressed: () => {setState(() 
                      {
                        showAction(context, 2);
                        _mapController.move(LatLng(currentLatLng.latitude, currentLatLng.longitude), globals.MaxZoom);
                      })},                
                    ),
            ],
          ),
        )
      );
  }   
  }




