import 'package:acleanworld/SignInPage.dart';
import 'package:flutter/material.dart';
import './widgets/Drawer.dart';
import 'Globals.dart' as globals;
import 'SignUpPage.dart';

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
      globals.dataBase.auth.signOut();
      globals.SPHelper.sp.save("useremail", "");
      globals.SPHelper.sp.save("userpassword", "");
      globals.gsUserName = "";
      globals.gsPassword = "";
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
                      Navigator.popAndPushNamed(context, SignInPage.route);
                      } 
                  catch (e) 
                  {
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
                    Navigator.popAndPushNamed(context, SignUpPage.route);                                      
                },
                child: const Text('Opret ny bruger',style: TextStyle(fontSize: 30)),
              ),] ),)
    );
  }
}