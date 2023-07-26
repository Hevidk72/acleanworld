import 'package:acleanworld/HistoryMap.dart';
import 'package:flutter/material.dart';
import 'Splash.dart';
import 'RecordMap.dart';
import 'Settings.dart';
import 'SignInPage.dart';
import 'SignUpPage.dart';
import 'SignInOrSignUp.dart';
import 'Globals.dart' as globals;


bool debug = globals.bDebug;

main() 
{
  runApp(const MyApp());   
}
/*
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();  // make sure plugins are initialized properly
  globals.checkVersion(context).whenComplete(() 
    {
      if (debug) print("(Main.dart) checking for current store version=${globals.version}");     
    });
}
*/

class MyApp extends StatefulWidget 
{
  const MyApp({Key? key}) : super(key: key);
  
@override
  State<StatefulWidget> createState() => _stateMyApp();
 }

class _stateMyApp extends State<MyApp> {

 @override
  void didChangeDependencies() 
  {
    super.didChangeDependencies();
    WidgetsFlutterBinding.ensureInitialized();  // make sure plugins are initialized properly
    globals.checkVersion(context).whenComplete(() 
    {
      if (debug) print("(Main.dart) checking for current store version=${globals.version}");     
    });
  }

 @override
  initState() 
  {
    super.initState();     
    print("main.dart (initstate) Called in main.dart");   
    //globals.checkVersion(context);
    globals.checkVersion(context).whenComplete(() 
    {
      if (debug) print("(main.dart) checkVersion version: ${globals.version} store URL: ${globals.storeUrl}"); 
    });
 
    globals.initSPHelper();
    globals.initSPHelper().whenComplete(() 
    {
      globals.gsUserName = globals.SPHelper.sp.get("useremail")!;
      globals.gsPassword = globals.SPHelper.sp.get("userpassword")!;
      if (debug) print("globals.gsUserName=${globals.gsUserName}");
      if (debug) print("globals.gsPassword=${globals.gsPassword}");
    }); 
    // Check for updated version
    
      
            
    if (debug) print("(Main.dart) globals.version=${globals.version}");
  }
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
   return MaterialApp(
        // in the below line, we are specifying title of our app.
        title: 'A Cleaner World',
        // in the below line, we are hiding our debug banner.
        debugShowCheckedModeBanner: false,
        // in the below line, we are specifying theme.
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // First Screen of our App
        home: const Splash(),
        routes: <String, WidgetBuilder>{
          SignInPage.route: (context) => const SignInPage(),
          SignUpPage.route: (context) => const SignUpPage(),
          RecordMap.route: (context) => const RecordMap(),
          HistoryMap.route: (context) => const HistoryMap(),
          Settings.route: (context) => const Settings(),
          SignInOrSignUp.route: (context) => const SignInOrSignUp()
        });
  }
}