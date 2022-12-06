import 'package:flutter/material.dart';
import 'Splash.dart';
import 'homePage.dart';
import 'settings.dart';

void main() 
{
  runApp(const MyApp());
}
  
class MyApp extends StatelessWidget 
{
  const MyApp({Key? key}) : super(key: key);
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)  
  { 
    return MaterialApp
    (
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
      routes: <String, WidgetBuilder>
      {
        homePage.route: (context) => const homePage(),
        settings.route: (context) => const settings()
      }
    );

    
  }
}