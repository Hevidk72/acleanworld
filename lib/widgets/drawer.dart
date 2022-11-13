import 'package:flutter/material.dart';

import 'package:acleanworld/HomePage.dart';
import 'package:acleanworld/bouncing_button.dart';

Widget _buildMenuItem(
    BuildContext context, Widget title, String routeName, String currentRoute) {
  final isSelected = routeName == currentRoute;

  return ListTile(
    title: title,
    selected: isSelected,
    onTap: () {
      if (isSelected) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacementNamed(context, routeName);
      }
    },
  );
}

Drawer buildDrawer(BuildContext context, String currentRoute) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        const DrawerHeader(
          child: Center(
            child: Text('Menu'),
          ),
        ),
        _buildMenuItem(
          context,
          const Text('Main Page'),
          HomePage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Bouncing Button'),
          BouncingButton.route,
          currentRoute,
        ),
        /*_buildMenuItem(
          context,
          const Text('WMS Layer'),
          WMSLayerPage.route,
          currentRoute,
        )*/
      ],
    ),
  );
}
