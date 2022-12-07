import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

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

//Shared Preferences

  Future<void> initSPHelper()  async 
  {
    await SPHelper.sp.initSharedPreferences();
    await Future.delayed(const Duration(milliseconds: 3000));
  }

class SPHelper {
  SPHelper._();
  static SPHelper sp = SPHelper._();
  SharedPreferences? prefs;

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> save(String name, String value) async {
    await prefs?.setString(name, value);
  }

  String? get(String key) {
    return prefs?.getString(key) ?? "";
  }

  Future<bool> delete(String key) async {
    return await prefs!.remove(key);
  }
}