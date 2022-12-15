import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
//Custom utils
import 'package:acleanworld/widgets/drawer.dart';
import 'package:acleanworld/utils/utils.dart';

class signInPage extends StatefulWidget
{
  static const String route = "/signInPage";
  const signInPage({Key? key}) : super(key: key);

  @override
  _signInPageState createState() => _signInPageState();
  
}

class _signInPageState extends State<signInPage> 
{
    // Database init
  static const supabaseUrl = 'https://zbqoritnaqhkridbyaxc.supabase.co';
  static const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpicW9yaXRuYXFoa3JpZGJ5YXhjIiwicm9sZSI6ImFub24iLCJpYXQiOjE2Njg2MzI0NDEsImV4cCI6MTk4NDIwODQ0MX0.NO3SvLCPEmXMFIVFiHBYV9ZLp0o2IFgndMzpkwQG_F0';
  final dataBase = SupabaseClient(supabaseUrl, supabaseKey);
  // Global 
  bool rememberMe = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passWordController = TextEditingController();
   

  @override
  initState() 
  {
    super.initState();
  }

  @override
  Widget build(BuildContext context) 
  {
      return Scaffold(
      appBar: AppBar(title: const Text('A Cleaner World Login')),
      drawer: buildDrawer(context, signInPage.route),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children:
        [
          Container(height: 50),
          Text("Log ind", style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold)),
          TextField(controller: _emailController,
                    autofocus: true,                    
                    decoration: InputDecoration(hintText: "Email",
                                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),
                                                                                  borderSide: const BorderSide(color: Colors.blue),
                                                                                 ),
                          
                                                ),                    
                   ),
          TextField(controller: _passWordController,
                    obscureText: true,
                    decoration: InputDecoration(hintText: "Password",
                                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),
                                                                                  borderSide: const BorderSide(color: Colors.blue),
                                                                                 ),
                                               ),
                   ),
          Checkbox(value: rememberMe, onChanged: (value){ toggleRememberMe(); }),
          Row(mainAxisAlignment: MainAxisAlignment.center,
          children: 
          [
            ElevatedButton(child: const Text("Login"),
                           onPressed: () { login(); },),            
          ])
        ]),         
        
        ); 
           
  }

  Future<void> login()  async 
  {
    final AuthResponse res;
    try {
      res = await dataBase.auth.signInWithPassword(email: _emailController.text,
                                                   password: _passWordController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Login godkendt!',style: TextStyle(color: Colors.greenAccent, backgroundColor: Colors.black, fontSize: 20)),));
    } 
    catch (e) {    
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('$e', style: TextStyle(color: Colors.redAccent, backgroundColor: Colors.black, fontSize: 20)),));
    }

    final Session? session = dataBase.auth.currentSession;  
        
    print(session?.toJson());    
    print(session?.user.toJson());

  /*
    final UserResponse userRes = await dataBase.auth.updateUser
    (
    UserAttributes(data: {"phone": "30 32 20 52"} ),
    );
  */  

  }

  void toggleRememberMe()
  {
    
  }

}

