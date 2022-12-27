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
  
  @override
  void initState() 
  {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    //WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  void dispose() 
  {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Indstillinger "),
      ),
      drawer: buildDrawer(context, Settings.route),
      body: Center(
        child: Form(
          key: _formKey,
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value);

                  if (!emailValid) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (debug) print(_emailController.text);
                    if (debug) print(_passwordController.text);   
                    globals.SPHelper.sp.save("useremail",_emailController.text);    
                    globals.SPHelper.sp.save("userpassword",_passwordController.text);    
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
