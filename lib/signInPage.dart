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

  Future<void> _getAuth() async {
    setState(() {
      globals.gUser = globals.dataBase.auth.currentUser;
    });
    globals.dataBase.auth.onAuthStateChange.listen((data) {
      setState(() {
        globals.gUser = data.session?.user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log ind'),        
      ),
      drawer: buildDrawer(context, SignInPage.route),
      body: globals.gUser == null ? const _LoginForm() : const _ProfileForm(),
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
                    await globals.dataBase.auth.signInWithPassword(
                      email: email,
                      password: password,
                    );
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
                child: const Text('Log ind',style: TextStyle(fontSize: 30)),
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
                    await globals.dataBase.auth.signUp(
                      email: email,
                      password: password,
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Signup failed! : $e'),
                      backgroundColor: Colors.red,
                    ));
                    setState(() {
                      _loading = false;
                    });
                  }
                },
                child: const Text('Opret ny bruger',style: TextStyle(fontSize: 30)),
              ),
            ],
          ));
  }
}

class _ProfileForm extends StatefulWidget {
  const _ProfileForm({Key? key}) : super(key: key);

  @override
  State<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<_ProfileForm> {
  var _loading = true;
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();

  @override
  void initState() {
    _loadProfile();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final userId = globals.dataBase.auth.currentUser!.id;
      final data = (await globals.dataBase
          .from('profiles_tab')
          .select()
          .match({'id': userId}).maybeSingle()) as Map?;
      if (data != null) {
        setState(() {
          _usernameController.text = data['username'];
          _fullNameController.text = data['full_name'];
        });
      }
    } catch (e) {
      print("Fejl ved hentning af profil : $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Fejl ved hentning af profil : $e'),
        backgroundColor: Colors.red,
      ));
    }
    setState(() {
      _loading = false;
    });
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
                  controller: _usernameController,
                  decoration: InputDecoration(
                              label: const Text('Username'),
                              border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                       label: const Text('Fulde Navn'),
                     border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      )
                  ),
                
                const SizedBox(height: 16),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        setState(() {
                          _loading = true;
                        });
                        final userId = globals.dataBase.auth.currentUser!.id;
                        final username = _usernameController.text;
                        final fullName = _fullNameController.text;
                        await globals.dataBase.from('profiles_tab').upsert({
                          'id': userId,
                          'username': username,
                          'full_name': fullName,
                          'updated_at': DateTime.now().toIso8601String()
                        });
                        if (mounted) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Din profil er gemt'),
                            backgroundColor: Colors.green,
                          ));
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Fejl ved gem profil : $e'),
                          backgroundColor: Colors.red,
                        ));
                      }
                      setState(() {
                        _loading = false;
                      });
                    },
                    child: const Text('Gem',style: TextStyle(fontSize: 30))),
                const SizedBox(height: 16),
                TextButton(
                    onPressed: () => globals.dataBase.auth.signOut(),
                    child: const Text('Log Ud',style: TextStyle(fontSize: 30))),
              ],
            ));
  }
}
