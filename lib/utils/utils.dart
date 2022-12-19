import 'package:flutter/material.dart';
import 'dart:io';


class trip {
  double lat;
  double long;
  trip({required this.lat, required this.long});
  late DateTime startTime;
  late DateTime stopTime;
  
}

void dumpEnvironment() {
  Map<String, String> envVars = Platform.environment;
  envVars.forEach((key, value) {
    debugPrint("key:$key value:$value");
  });
}

Future showAlert(BuildContext context, String messageText, int delayed) async 
{
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

