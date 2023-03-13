import 'dart:convert';
import 'dart:math' as math;
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

  List<Polyline> Polylines=[Polyline(isDotted: true, points: [LatLng(0,0)], strokeWidth: 0, color: Colors.green)];
  int trips_ = 0;
 
  @override
  initState() 
  {   
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
               /*
                if (debug) {
                  print(
                      " Time / Speed = ${_currentLocation!.time} / ${_currentLocation!.speed}");
                }
*/
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
  void getPolylines(List<Map<String, dynamic>> jsonArray) async 
  {
    int count = 1;          

    // Clear polylines if any exists
    if (jsonArray.isNotEmpty) Polylines.clear();
    
    Polyline polyLine = Polyline(isDotted: true, points: [LatLng(0,0)], strokeWidth: 0, color: Colors.green);
    
    // Loop over database records trips
    for (var element in jsonArray) 
    { 
      // Clear Polyline
      polyLine = Polyline(isDotted: true, points: [LatLng(0,0)], strokeWidth: 0, color: Colors.green);
      
      //print ("trip $count ${globals.getColorValue(count)}");      
      print (element['trip_data']);
          
      for (var word in jsonDecode(element["trip_data"])) 
      {  
        polyLine.points.add(LatLng(word['lat'], word['long']));                
      }
      
      // Adding Polyline to map        
      print ("Adding Polyline $count");
      Polylines.add(polyLine);
      //Polylines.add(polyLine);
      
      // increment trip counter
      count++;      
    }       
      trips_ = count-1;  
      print ("Polylines loop done !");     
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

    void _showAction(BuildContext context, int index) async {
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
              getPolylines(data);
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
          final data = await globals.dataBase                
                .from("user_get_trips")
                .select<List<Map<String, dynamic>>>("trip_age_days, trip_data")     
                .not('user_id','eq', userId)
                .order("trip_age_days", ascending: true);

            if (data.isNotEmpty) 
            {
              print(data);
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
          final data = await globals.dataBase                
                .from("user_get_trips")
                .select<List<Map<String, dynamic>>>("trip_age_days, trip_data")   
                .order("trip_age_days", ascending: true);
          if (data.isNotEmpty) 
          {
            print(data);                          
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
      /*
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
      */
    }

    return WillPopScope(
        onWillPop: () async {
          return globals.onWillPop(context);
        },
        child: Scaffold(
          appBar: AppBar(
              title: const Text('A Cleaner World (Historik)',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
              centerTitle: true,
          ),
          drawer: buildDrawer(context, HistoryMap.route),
          body: Padding(
            padding: const EdgeInsets.all(2),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 8),
                  child: _serviceError!.isEmpty
                      ? Text(
                          'pos: (${currentLatLng.latitude}, ${currentLatLng.longitude}) og Zoom=$_currentZoom')
                      //Text('This is a map that is showing (${currentLatLng.latitude}, ${currentLatLng.longitude}) and zoom=${_mapController.zoom}.')
                      : Text(
                          'Fejl ved at finde din lokation. Fejl Besked : $_serviceError'),
                ),
                Flexible(
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(maxZoom: globals.MaxZoom,
                                        center: LatLng(currentLatLng.latitude, currentLatLng.longitude),
                                        interactiveFlags: interActiveFlags,
                                        ),
                    children: 
                    [
                      TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                               ),
                      MarkerLayer(markers: markers),
                      PolylineLayer(polylines: Polylines),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: ExpandableFab(
            distance: 90.0,
            children: [
              ActionButton(
                onPressed: () => _showAction(context, 0),
                //onPressed: () {   },
                icon: Image.asset("assets/Mine.png"),
              ),
              ActionButton(
                onPressed: () => _showAction(context, 1),
                icon: Image.asset("assets/Andre.png"),
              ),
              ActionButton(
                onPressed: () => _showAction(context, 2),
                icon: Image.asset("assets/Alle.png"),
              ),
            ],
          ),
        ));
  }
}

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    super.key,
    this.initialOpen,
    required this.distance,
    required this.children,
  });

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: _toggle,
            child: const Icon(Icons.menu_sharp),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.secondary,
      elevation: 4.0,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: theme.colorScheme.onSecondary,
      ),
    );
  }
}
