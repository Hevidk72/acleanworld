import 'package:flutter/material.dart';
import '../RecordMap.dart';
import '../HistoryMap.dart';
import '../Settings.dart';
import '../SignInOrSignUp.dart';

Widget _buildMenuItem(
    BuildContext context, String title, String subtitle, String routeName, String currentRoute, IconData icon) {
  final isSelected = routeName == currentRoute;

  return ListTile(
    title: Text(title,style: const TextStyle(fontSize: 18.0)),
    subtitle: Text(subtitle),
    leading: Icon(icon),
    selected: isSelected,
    selectedColor: Color.fromRGBO(55, 125, 125, 1.0),
    onTap: () {
      if (isSelected) 
      {
        Navigator.pop(context);
      } 
      else 
      {
        debugPrint('Drawer RouteName: "$routeName" Current Route: "$currentRoute"');
        if (routeName.contains("close"))
        {
          Navigator.pop(context);
        }
        else
        {
          Navigator.pushReplacementNamed(context, routeName);
        }
        
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
        height: 95,
        child: DrawerHeader
        (
          decoration: const BoxDecoration
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
          child: GestureDetector(
                 child: const Text( 'Menu', style:  TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white)),  
                 onTap: () { print(  "I was tapped!"); Navigator.pop(context);},
              ), 
          ),
        ),
        _buildMenuItem(context,'Kort', 'Ny tur', RecordMap.route, currentRoute, Icons.map),
        _buildMenuItem(context,'Kort', 'Historik', HistoryMap.route, currentRoute, Icons.map_outlined),
        _buildMenuItem(context,'Min Side', 'Indstillinger', Settings.route, currentRoute, Icons.settings),        
        _buildMenuItem(context,'Log ud', 'Skift bruger', SignInOrSignUp.route, currentRoute, Icons.login),
        _buildMenuItem(context,'Luk menuen', '', "close", currentRoute, Icons.close),
      ],
    ),  
  );
}
