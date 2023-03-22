import 'package:flutter/material.dart';
import './widgets/Drawer.dart';
import 'Globals.dart' as globals;
import 'RecordMap.dart';

bool debug = globals.bDebug;

class SignUpPage extends StatefulWidget {
  static const String route = "/SignUpPage";
  const SignUpPage({Key? key}) : super(key: key);
  
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  void initState() {
  super.initState();
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opret Bruger'),        
      ),
      drawer: buildDrawer(context, SignUpPage.route),
      body: const _ProfileForm(),
    );
  }
}
class _ProfileForm extends StatefulWidget {
  const _ProfileForm({Key? key}) : super(key: key);

  @override
  State<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<_ProfileForm> {
  
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordCheckController = TextEditingController();
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  
  @override
  void initState() {
    
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordCheckController.dispose();
    _usernameController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  bool _obscureText = true;
  // Toggles the password show status
   void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
            onWillPop: () async {
              return globals.onWillPop(context);
            },            
              child:  Form(key: _formKey,
              child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                // Email
                TextFormField(
                  validator: (value) 
                  {
                    if (value == null || value.isEmpty) {
                    return 'Dette felt kan ikke være blankt!';
                  }
                  return null;
                  },                  
                  controller: _emailController,
                  decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email,color: Colors.blue,size: 35),
                              label: const Text('Email'),
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
                
                // Password
                TextFormField(
                  validator: (value) 
                  {
                    if (value!.length < 6)
                    {
                     return "Password er for kort. Det skal mindst være 6 tegn."; 
                    }
                    
                    if (value.isEmpty) 
                    {
                    return 'Dette felt kan ikke være blankt!';
                    }                    
                    return null;
                  },
                  controller: _passwordController,                  
                  obscureText: _obscureText,
                  obscuringCharacter: "*",
                  decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock,color: Colors.blue,size: 35),
                              suffixIcon: GestureDetector(
                                    onTap: _toggle,
                                    child: Icon(_obscureText ? Icons.toggle_on : Icons.toggle_off,color: Colors.blue,size: 35)),
                              label: const Text('Password'),
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
                
                 // Password Check
                TextFormField(
                  validator: (value) 
                  {
                    if (value!.length < 6)
                    {
                     return "Password er for kort. Det skal mindst være 6 tegn."; 
                    }
                    
                    if (value.isEmpty) 
                    {
                    return 'Dette felt kan ikke være blankt!';
                    }                    
                    return null;
                  },
                  controller: _passwordCheckController,
                  obscureText: _obscureText,
                  obscuringCharacter: "*",
                  decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock,color: Colors.blue,size: 35),
                              suffixIcon: GestureDetector(
                                    onTap: _toggle,
                                    child: Icon(_obscureText ? Icons.toggle_on : Icons.toggle_off,color: Colors.blue,size: 35)),
                              label: const Text('Gentag Password'),
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

                 // Username        
                 TextFormField(                  
                  controller: _usernameController,
                  decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.account_box,color: Colors.blue,size: 35),
                              label: const Text('Brugernavn'),
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
                const SizedBox(height: 32),

                // Full Name
                TextFormField(                  
                  validator: (value) 
                  {
                    if (value == null || value.isEmpty) {
                    return 'Dette felt kan ikke være blankt!';
                  }
                  return null;
                  },
                  controller: _fullNameController,
                  decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.description,color: Colors.blue,size: 35),                        
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
                
               const SizedBox(height: 32),

               // Submit button
               ElevatedButton(      
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
                    onPressed: () async {                 
                    if (_formKey.currentState!.validate()) 
                    {
                      if (_passwordController.text == _passwordCheckController.text) 
                      {
                        final email    = _emailController.text;
                        final password = _passwordController.text;      
                        final userName = _usernameController.text;
                        final fullName = _fullNameController.text;                 
                        try
                        {
                          await globals.dataBase.auth.signUp(email: email, password: password,);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bruger Oprettet!'),backgroundColor: Colors.green));
                          // Sign In:
                          final userId = globals.dataBase.auth.currentUser!.id;
                          if (debug) print("globals.gsUserName=${userId}");
                          await globals.dataBase.auth.signInWithPassword(email: email,password: password,);
                          await globals.dataBase.from('profiles_tab').upsert({
                          'id': userId,
                          'username': userName,
                          'full_name': fullName,
                          'updated_at': DateTime.now().toIso8601String()
                        });
                          globals.SPHelper.sp.save("useremail", email);
                          globals.SPHelper.sp.save("userpassword", password);
                          Navigator.popAndPushNamed(context, RecordMap.route);

                        }
                        catch (e) 
                        {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Oprettelse af bruger lykkedes ikke! : $e'),backgroundColor: Colors.red,));                 
                        }                        
                      }
                      else
                      {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords matcher ikke!'),backgroundColor: Colors.red,));                 
                      }
                    }   
                },
                child: const Text('Opret ny bruger',style: TextStyle(fontSize: 30)),
              ), 
              ],
            )));
  }
}
