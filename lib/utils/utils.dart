import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

// Get Shared Preferences
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
appSetting aps;

class trip {
  double lat;
  double long;
  trip({required this.lat, required this.long});
}

class appSetting {
  String userName = "";
  String password = "";
  double defaultZoom;

  appSetting(
      {required this.userName,
      required this.password,
      required this.defaultZoom});
}

Future<appSetting> getSettings() async {
  final SharedPreferences prefs = await _prefs;  
  aps.defaultZoom = prefs.getDouble("defaultzoom") ?? 18.49;
  aps.userName = prefs.getString("username") ?? "";
  aps.password = prefs.getString("password") ?? "";
  return aps;
}

void dumpEnvironment() {
  Map<String, String> envVars = Platform.environment;
  envVars.forEach((key, value) {
    debugPrint("key:$key value:$value");
  });
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

Future showNewTripDialog(
    BuildContext context, String messageText, int delayed) async {
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

Future showEndTripDialog(
    BuildContext context, String messageText, int delayed) async {
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