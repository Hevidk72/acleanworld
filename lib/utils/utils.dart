import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

// Get Shared Preferences
late final SharedPreferences prefs;
appSetting aps = appSetting(userEmail: "", password: "", defaultZoom: 18.49);

class trip {
  double lat;
  double long;
  trip({required this.lat, required this.long});
  late DateTime startTime;
  late DateTime stopTime;
}

class appSetting {
  String userEmail = "";
  String password = "";
  double defaultZoom;

  appSetting(
      {required this.userEmail,
      required this.password,
      required this.defaultZoom});
}

Future<appSetting> getSettings() async {
  final prefs = await SharedPreferences.getInstance();

  aps.defaultZoom = prefs.getDouble("defaultzoom") ?? 18.49;
  aps.userEmail = prefs.getString("useremail") ?? "";
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
