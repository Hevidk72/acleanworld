import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool bDebug = true;
bool gbisLoggedIn = false;
String gsUserName = "";
String gsPassword = "";
double MaxZoom = 18.49;

// Database init
const supabaseUrl = 'https://zbqoritnaqhkridbyaxc.supabase.co';
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpicW9yaXRuYXFoa3JpZGJ5YXhjIiwicm9sZSI6ImFub24iLCJpYXQiOjE2Njg2MzI0NDEsImV4cCI6MTk4NDIwODQ0MX0.NO3SvLCPEmXMFIVFiHBYV9ZLp0o2IFgndMzpkwQG_F0';
final dataBase = SupabaseClient(supabaseUrl, supabaseKey);
User? gUser;

//Shared Preferences

Future<void> initSPHelper() async {
  await SPHelper.sp.initSharedPreferences();
  //await Future.delayed(const Duration(milliseconds: 3000));
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

// Handle Back nutton
Future<bool> onWillPop(context) async {
  return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Er du sikker ?"),
          content: const Text("Vil du afslutte denne App?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Nej'),
            ),
            TextButton(
              onPressed: () {
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                } else if (Platform.isIOS) {
                  exit(0);
                }
                // SystemNavigator.pop();
              },
              child: const Text('Ja'),
            ),
          ],
        ),
      )) ??
      false;
}

Color getColorValue(int value_) {
  return Color.fromRGBO(getRed(value_), getGreen(value_), 0, 200);
}

int getRed(i) {
  var percent = i / 100;
  return clip(percent * 200 * 2);
}

int getGreen(i) {
  var percent = i / 100;
  return clip((200 - (percent * 200)) * 2);
}

int clip(num) {
  if (num > 200) {
    return num;
  } else {
    return num;
  }
}
