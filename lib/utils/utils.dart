import 'package:flutter/material.dart';

  Future showAlert(BuildContext context, String messageText, int delayed) async {
    await Future.delayed(Duration(seconds: delayed));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          
          title: new Text(messageText),
          actions: <Widget>[
            OutlinedButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
