import 'package:flutter/material.dart';
import './widgets/Drawer.dart';
import 'RecordMap.dart';
import 'Globals.dart' as globals;

class SignInOrSignUp extends StatefulWidget {
  static const String route = "/SignInOrSignUp";
  const SignInOrSignUp({Key? key}) : super(key: key);

  @override
  _SignInOrSignUpState createState() => _SignInOrSignUpState();
}

class _SignInOrSignUpState extends State<SignInOrSignUp> {
  @override
  void initState() 
  {
      super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return globals.onWillPop(context);
        },
        child: Scaffold(
      appBar: AppBar(
      title: const Text('Log ind eller opret bruger'),        
      ),
      drawer: buildDrawer(context, SignInOrSignUp.route),
      body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              ElevatedButton(
                onPressed: () async {                  
                  try {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Log ind er godkendt!"),
                      backgroundColor: Colors.green,
                    ));
                    
                    
                    Navigator.popAndPushNamed(context, RecordMap.route);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Log ind fej! : $e"),
                      backgroundColor: Colors.red,
                    ));                    
                  }
                },
                child: const Text('Log ind',style: TextStyle(fontSize: 30)),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Signup failed! : e'),
                      backgroundColor: Colors.red,
                    ));                    
                  
                },
                child: const Text('Opret ny bruger',style: TextStyle(fontSize: 30)),
              ),] ),)
    );
  }
}