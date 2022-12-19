import 'package:flutter/material.dart';
import 'Splash.dart';
import 'homePage.dart';
import 'settings.dart';
import 'signInPage.dart';
import 'globals.dart' as globals;

main() {
  runApp(const MyApp());
// Setting Globals
  globals.initSPHelper();
  globals.initSPHelper().whenComplete(() {
  globals.gsUserName = globals.SPHelper.sp.get("useremail")!;
  globals.gsPassword = globals.SPHelper.sp.get("userpassword")!;
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
          signInPage.route: (context) => const signInPage(),
          homePage.route: (context) => const homePage(),
          settings.route: (context) => const settings()
        });
  }
}
