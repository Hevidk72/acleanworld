import 'package:flutter/material.dart';
import 'package:acleanworld/HomePage.dart';
import 'package:acleanworld/bouncing_button.dart';

Widget _buildMenuItem(
    BuildContext context, Widget title, String routeName, String currentRoute, IconData icon) {
  final isSelected = routeName == currentRoute;

  return ListTile(
    title: title,
    leading: Icon(icon),
    selected: isSelected,
    onTap: () {
      if (isSelected) 
      {
        Navigator.pop(context);
      } 
      else 
      {
        Navigator.pushReplacementNamed(context, routeName);
      }
    },
  );
}

Drawer buildDrawer(BuildContext context, String currentRoute) 
{
  return Drawer
  (
    //width: MediaQuery.of(context).size.width * 0.75,
    elevation: 10,  
    
    child: ListView
    (
      padding: EdgeInsets.zero,
      children: <Widget>[
        SizedBox
        (
        height: 100,
        child: DrawerHeader
        (
          decoration: BoxDecoration
          (
            color: Colors.blue,            
            boxShadow: [
            BoxShadow(
              color: Color.fromARGB(128, 31, 26, 26),
              blurRadius: 12.0,
              offset: Offset(0.0, 5.0),
            ),
          ] 
          ),
          
          child: Center
          (            
            child: Text('Menu', style:  TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white)),
            heightFactor: 15,
          ),
        ),),
        _buildMenuItem(context,const Text('Main Page'), HomePage.route, currentRoute, Icons.home),
        _buildMenuItem(context,const Text('Settings'),BouncingButton.route, currentRoute, Icons.settings),
        /*_buildMenuItem(context,const Text('WMS Layer'),WMSLayerPage.route,currentRoute, )*/
      ],
    ),  
  );
}
