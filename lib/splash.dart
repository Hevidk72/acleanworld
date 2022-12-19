import 'package:acleanworld/homePage.dart';
import 'package:acleanworld/signInPage.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'globals.dart' as globals;

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
    await Future.delayed(
      const Duration(milliseconds: 2000),
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
      print("gUser.email=${globals.gUser?.email}");     
    });    
    }
    catch (e) 
    {
      globals.gbisLoggedIn = false;
    }    
    print("Setting global gbisLoggedIn=${globals.gbisLoggedIn}");
  } 
    
  if (globals.gbisLoggedIn) 
  {
    Navigator.pushNamed(context, homePage.route);
  } 
  else 
  {
    Navigator.pushNamed(context, signInPage.route);
  }   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.blue),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
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
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(color: Colors.white),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      "Lets make it a cleaner earth",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white),
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
