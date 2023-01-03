import 'package:acleanworld/HistoryMap.dart';
import 'package:flutter/material.dart';
import 'Splash.dart';
import 'RecordMap.dart';
import 'Settings.dart';
import 'SignInPage.dart';
import 'Globals.dart' as globals;

bool debug = globals.bDebug;

main() async {
  runApp(const MyApp());
// Setting Globals
  globals.initSPHelper();
  globals.initSPHelper().whenComplete(() {
  globals.gsUserName = globals.SPHelper.sp.get("useremail")!;
  globals.gsPassword = globals.SPHelper.sp.get("userpassword")!;
  if (debug) print("globals.gsUserName=${globals.gsUserName}");
  if (debug) print("globals.gsPassword=${globals.gsPassword}");
  });
  
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
          RecordMap.route: (context) => const RecordMap(),
          HistoryMap.route: (context) => const HistoryMap(),
          Settings.route: (context) => const Settings()
        });
  }
}
