import 'package:acleanworld/signInPage.dart';
import 'package:flutter/material.dart';
import './widgets/Drawer.dart';
import 'Globals.dart' as globals;

bool debug = globals.bDebug;

void main() async {
  runApp(const Settings());
}

class Settings extends StatefulWidget {
  static const String route = '/Settings';
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _userNameController;
  late final TextEditingController _fullNameController;

  @override
  void initState() 
  {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _userNameController = TextEditingController();
    _fullNameController = TextEditingController();
    _emailController.text = globals.gsUserName;
    _passwordController.text = globals.gsPassword;
    _userNameController.text = globals.gsUserNameAlias;
    _fullNameController.text = globals.gsFullName;
    if (debug) print("store:${globals.storeVersion ?? "Not Available!"}");
    if (debug) print("Version:${globals.version}");
    if (debug) print("PackageName:${globals.packageName}");

  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _userNameController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return globals.onWillPop(context);
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Min Side"),
            ),
            drawer: buildDrawer(context, Settings.route),
            body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                TextFormField(
                  readOnly: true,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      prefixIconColor: Colors.blue,
                      hintText: "Email",
                      hintStyle:
                          TextStyle(color: Colors.black.withOpacity(0.3)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      )
                      ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: true,
                  readOnly: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.security),
                      prefixIconColor: Colors.blue,
                      hintText: "Password",
                      hintStyle:
                          TextStyle(color: Colors.black.withOpacity(0.3)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      )),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.perm_device_information_sharp),
                      prefixIconColor: Colors.blue,
                      hintText: "Bruger Navn / Alias",
                      hintStyle:
                          TextStyle(color: Colors.black.withOpacity(0.3)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      )),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.perm_device_information_rounded),
                      prefixIconColor: Colors.blue,
                      hintText: "Fulde Navn",
                      hintStyle:
                          TextStyle(color: Colors.black.withOpacity(0.3)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      )),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                    onPressed: () async {
                    try {                      
                      await globals.dataBase.auth.signInWithPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Log ind er OK!"),
                        backgroundColor: Colors.green,
                      ));
                      // Save Verified credentials
                      globals.SPHelper.sp.save("useremail", _emailController.text);
                      globals.SPHelper.sp.save("userpassword", _passwordController.text);
                      // And update user profile values
                      // *todo*
                      
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Log ind fej! : $e"),
                        backgroundColor: Colors.red,
                      ));
                    }
                  },
                  style: ButtonStyle(padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
                          (Set<MaterialState> states) { return const EdgeInsets.all(20); },
                          ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                   RoundedRectangleBorder(                                  
                                   borderRadius: BorderRadius.circular(20),
                                   side: const BorderSide(color: Colors.blue),      
                                   )
                                   )
                                ),
                  child: const Text('Gem data',style: TextStyle(fontSize: 30)),                  
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: () async { showDeleteUserAlertDialog(context); },                              
                               style: ButtonStyle(padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
                                (Set<MaterialState> states) { return const EdgeInsets.all(20); },),
                                backgroundColor: MaterialStateProperty.all(Colors.red),
                               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                   RoundedRectangleBorder(                                  
                                   borderRadius: BorderRadius.circular(20),
                                   side: const BorderSide(color: Colors.black),      
                                   )
                                   )
                                ),                                
                               child: const Text('Slet bruger og data',style: TextStyle(fontSize: 30))),
                const SizedBox(height: 15),
                Text("Version: ${globals.version}",textAlign: TextAlign.center,)
              ],
            )));
  }
  
  showDeleteUserAlertDialog(BuildContext context) 
  {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: const Text("Fortryd"),
      onPressed:  () 
      {
        Navigator.of(context).pop(); // dismiss dialog       
      },
    );
    Widget continueButton = ElevatedButton(
      child: const Text("Jeg ønsker at slette min bruger"),
      onPressed:  () async
      {
        try {
              final userId = globals.dataBase.auth.currentUser!.id;
              globals.dataBase.auth.signOut();
              globals.SPHelper.sp.save("useremail", "");
              globals.SPHelper.sp.save("userpassword", "");
              globals.gsUserName = "";
              globals.gsPassword = "";                   
              await globals.dataBase.auth.admin.deleteUser(userId);              
              Navigator.popAndPushNamed(context, SignInPage.route);
           }
        catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Fejl ved sletning af bruger: $e"),
                      backgroundColor: Colors.red,
                    ));       
                    Navigator.popAndPushNamed(context, SignInPage.route);             
                  }
      }
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("!Advarsel!"),
      content: const Text("Er du sikker på at du vil slette brugeren og alt tilhørende data?"),
      actions: 
      [
        cancelButton,
        continueButton,
      ],
    );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) 
    {
      return alert;
    },
  );
  }
}
