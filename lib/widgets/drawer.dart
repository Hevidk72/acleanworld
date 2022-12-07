import 'package:flutter/material.dart';
import '../homePage.dart';
import '../settings.dart';

Widget _buildMenuItem(
    BuildContext context, Widget title, String routeName, String currentRoute, IconData icon) {
  final isSelected = routeName == currentRoute;

  return ListTile(
    title: title,
    subtitle: const Text("Hello"),
    leading: Icon(icon),
    selected: isSelected,
    onTap: () {
      if (isSelected) 
      {
        Navigator.pop(context);
      } 
      else 
      {
        debugPrint('Drawer RouteName: "$routeName" Current Route: "$currentRoute"');
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
        const SizedBox
        (
        height: 95,
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
          child: Text('Menu', style:  TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white)),          
        ),),
        _buildMenuItem(context,const Text('Kort',style: TextStyle(fontSize: 18.0)), homePage.route, currentRoute, Icons.home),
        _buildMenuItem(context,const Text('Indstillinger',style: TextStyle(fontSize: 18.0)), settings.route, currentRoute, Icons.settings),        
      ],
    ),  
  );
}
