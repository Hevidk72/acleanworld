import 'package:flutter/material.dart';
import './widgets/Drawer.dart';
import 'RecordMap.dart';
import 'Globals.dart' as globals;

class SignInPage extends StatefulWidget {
  static const String route = "/SignInPage";
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  void initState() {
    _getAuth();
    super.initState();
  }

  Future<void> _getAuth() async 
  {
    globals.gUser = globals.dataBase.auth.currentUser;
    globals.dataBase.auth.onAuthStateChange.listen((data) 
    {
       globals.gUser = data.session?.user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log ind'),        
      ),
      drawer: buildDrawer(context, SignInPage.route),
      body: const _LoginForm(),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  bool _loading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : WillPopScope(
            onWillPop: () async {
              return globals.onWillPop(context);
            },
            child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    prefixIconColor: Colors.blue,
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
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
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.security),
                    prefixIconColor: Colors.blue,
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
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
                  setState(() {
                    _loading = true;
                  });
                  try {
                    final email = _emailController.text;
                    final password = _passwordController.text;
                    await globals.dataBase.auth.signInWithPassword(email: email,password: password,);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Log ind er godkendt!"),
                      backgroundColor: Colors.green,
                    ));
                    // Save Verified credentials
                    globals.SPHelper.sp.save("useremail", email);
                    globals.SPHelper.sp.save("userpassword", password);
                    Navigator.popAndPushNamed(context, RecordMap.route);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Log ind fej! : $e"),
                      backgroundColor: Colors.red,
                    ));
                    setState(() {
                      _loading = false;
                    });
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
                child: const Text('Log ind',style: TextStyle(fontSize: 30)),
              ),           
            ],
          ));
  }
}

