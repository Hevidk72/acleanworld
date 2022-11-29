import 'package:flutter/material.dart';
import 'dart:io';

class trip
{
   double lat;
   double long;
   trip({required this.lat, required this.long});
}

class appSetting
{
  String userName = "";
  String password = "";
  double defaultZoom; 

 appSetting({
             required this.userName,
             required this.password,
             required this.defaultZoom             
             });
}

appSetting getSettings()
{
  
}


void dumpEnvironment()
{
  Map<String, String> envVars = Platform.environment;
  envVars.forEach((key, value) { debugPrint("key:$key value:$value");});
}

  Future showAlert(BuildContext context, String messageText, int delayed) async {
    await Future.delayed(Duration(seconds: delayed));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(          
          title: Text(messageText),
          actions: <Widget>[
            OutlinedButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Future showNewTripDialog(BuildContext context, String messageText, int delayed) async {
    await Future.delayed(Duration(seconds: delayed));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(          
          title: Text(messageText),
          actions: <Widget>[
            OutlinedButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

Future showEndTripDialog(BuildContext context, String messageText, int delayed) async {
    await Future.delayed(Duration(seconds: delayed));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(          
          title: Text(messageText),
          actions: <Widget>[
            OutlinedButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
