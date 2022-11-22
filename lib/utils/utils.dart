import 'package:flutter/material.dart';

class trip
{
   double lat;
   double long;
   trip({required this.lat, required this.long});
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
