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
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
              title: const Text("Indstillinger"),
            ),
            drawer: buildDrawer(context, Settings.route),
            body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                TextFormField(
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
                ElevatedButton(
                    onPressed: () async {
                    try {
                      final email = _emailController.text;
                      final password = _passwordController.text;
                      await globals.dataBase.auth.signInWithPassword(
                        email: email,
                        password: password,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Log ind er OK!"),
                        backgroundColor: Colors.green,
                      ));
                      // Save Verified credentials
                      globals.SPHelper.sp.save("useremail", email);
                      globals.SPHelper.sp.save("userpassword", password);
                      //  Navigator.popAndPushNamed(context, RecordMap.route);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Log ind fej! : $e"),
                        backgroundColor: Colors.red,
                      ));
                    }
                  },
                  child: const Text('Gem data',style: TextStyle(fontSize: 30)),                  
                ),
              ],
            )));
  }
}
