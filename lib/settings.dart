import 'package:flutter/material.dart';
import 'package:acleanworld/widgets/drawer.dart';
import './utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(settings());
}

class settings extends StatefulWidget {
  static const String route = '/Settings';
  const settings({Key? key}) : super(key: key);

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    var a_ = getSharedString("useremail");
    var b_ = getSharedString("password");
    print("Emailuser: $a_");
    print("Password: $b_");
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Indstillinger ${getPrefString("usermail")}'),
      ),
      drawer: buildDrawer(context, settings.route),
      body: Center(
        child: Form(
          key: _formKey,
          child: Wrap(
            alignment: WrapAlignment.spaceAround,
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
                    print(_emailController.text);
                    print(_passwordController.text);
                    setPrefString("useremail", _emailController.text);
                    setPrefString("password", _passwordController.text);
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

  // Handle Shared Preferences
  Future<String> getPrefString(String str) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(str) ?? "";
  }

  Future<void> setPrefString(String str_, String value_) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(str_, value_);
  }

  Future<String?> getSharedString(String str_) async {
    return await getPrefString(str_);
  }
}
