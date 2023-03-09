import 'package:acleanworld/SignInOrSignUp.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'RecordMap.dart';
import 'SignInPage.dart';
import 'Globals.dart' as globals;

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool userDataExists = false;

  @override
  void initState() {
    super.initState();
    if (mounted) {      
      _navigatetohome();
    }
  }
  
  _navigatetohome() async {
    globals.checkVersion(context);
    await Future.delayed(
      const Duration(milliseconds: 4000),
    );

  // check saves login
  if (globals.gsUserName.isNotEmpty) 
  {
    try 
    {
      globals.dataBase.auth.signInWithPassword(email: globals.gsUserName,password: globals.gsPassword,);
      globals.gbisLoggedIn = true;
      globals.dataBase.auth.onAuthStateChange.listen((data) {
      globals.gUser = data.session?.user;
      if (globals.bDebug) {
        print("gUser.email=${globals.gUser?.email}");
      }   
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Automatisk login med gemte data!"),
                      backgroundColor: Colors.green,
                    ));  
    });    
    }
    catch (e) 
    {
      globals.gbisLoggedIn = false;
    }    
    if (globals.bDebug) 
    {
      print("Setting global gbisLoggedIn=${globals.gbisLoggedIn}");
    }
  } 
    
  if (globals.gbisLoggedIn) 
  {
    Navigator.pushNamed(context, RecordMap.route);
  } 
  else 
  {
    Navigator.pushNamed(context, SignInOrSignUp.route);
  }   
  }

  @override
  Widget build(BuildContext context) {
    //globals.checkVersion(context);
    if (debug) print("(Splash.dart) store:${globals.storeVersion ?? "Not Available!"}");
    if (debug) print("Version:${globals.version}");
  
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(color: Colors.blue),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[ Text(
                      "A Cleaner World",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 100.0,
                      child: Icon(LineAwesomeIcons.globe,
                          color: Colors.greenAccent, size: 148.0),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const CircularProgressIndicator(color: Colors.white), 
                    const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    const Text(
                      "Lets make it a cleaner earth",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white),
                    ),
                    Text("Version:${globals.version}",
                      softWrap: true,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Colors.white70),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
