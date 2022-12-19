import 'package:flutter/material.dart';
import '../homePage.dart';
import '../settings.dart';
import '../signInPage.dart';

Widget _buildMenuItem(
    BuildContext context, String title, String subtitle, String routeName, String currentRoute, IconData icon) {
  final isSelected = routeName == currentRoute;

  return ListTile(
    title: Text(title,style: const TextStyle(fontSize: 18.0)),
    subtitle: Text(subtitle),
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
        _buildMenuItem(context,'Kort', 'Ny tur', homePage.route, currentRoute, Icons.map),
        _buildMenuItem(context,'Kort', 'Historik', homePage.route, currentRoute, Icons.map_outlined),
        _buildMenuItem(context,'Indstillinger', '', settings.route, currentRoute, Icons.settings),        
        _buildMenuItem(context,'Log ud', '',signInPage.route, currentRoute, Icons.login),
      ],
    ),  
  );
}
