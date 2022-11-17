import 'package:acleanworld/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:acleanworld/Auth.dart';

class Splash extends StatefulWidget 
{
const Splash({ Key? key }) : super(key: key);
@override 
_SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash>
{
@override
void initState()
{
  super.initState();
  _navigatetohome();
}

_navigatetohome() async 
{
  await Future.delayed(const Duration(milliseconds: 3000),);
  Navigator.pushNamed(context,Auth.route);
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
                        child: Icon(
                          Icons.keyboard,
                          color: Colors.greenAccent,
                          size: 75.0,
                        ),
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
                    CircularProgressIndicator(color: Colors.white ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text("Lets make it a cleaner earth",
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