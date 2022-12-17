import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
//Custom utils
import 'package:acleanworld/widgets/drawer.dart';
import 'package:acleanworld/utils/utils.dart';

class signInPage extends StatefulWidget {
  static const String route = "/signInPage";
  const signInPage({Key? key}) : super(key: key);

  @override
  _signInPageState createState() => _signInPageState();
}

class _signInPageState extends State<signInPage> {
  // Database init
  static const supabaseUrl = 'https://zbqoritnaqhkridbyaxc.supabase.co';
  static const supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpicW9yaXRuYXFoa3JpZGJ5YXhjIiwicm9sZSI6ImFub24iLCJpYXQiOjE2Njg2MzI0NDEsImV4cCI6MTk4NDIwODQ0MX0.NO3SvLCPEmXMFIVFiHBYV9ZLp0o2IFgndMzpkwQG_F0';
  final dataBase = SupabaseClient(supabaseUrl, supabaseKey);
  // Global
  bool rememberMe = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passWordController = TextEditingController();

  @override
  initState() {
    super.initState();
    initSPHelper().whenComplete(() {
      print("SPHELPER init");
      print("useremail: ${SPHelper.sp.get("useremail")}");
      print("userpassword: ${SPHelper.sp.get("userpassword")}");
      _emailController.text = SPHelper.sp.get("useremail")!;
      _passWordController.text = SPHelper.sp.get("userpassword")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('A Cleaner World Login')),
      drawer: buildDrawer(context, signInPage.route),
      backgroundColor: Colors.blue,      
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Sign Up",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 24,
                    color: Color(0xffffffff),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 50, 0, 16),
                  child: TextField(
                    controller: TextEditingController(),
                    obscureText: false,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xff000000),
                    ),
                    decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22.0),
                        borderSide:
                            BorderSide(color: Color(0x00ffffff), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22.0),
                        borderSide:
                            BorderSide(color: Color(0x00ffffff), width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22.0),
                        borderSide:
                            BorderSide(color: Color(0x00ffffff), width: 1),
                      ),
                      hintText: "Name",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff000000),
                      ),
                      filled: true,
                      fillColor: Color(0xfff2f2f3),
                      isDense: false,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      prefixIcon: Icon(Icons.person,
                          color: Color(0xff3a57e8), size: 24),
                    ),
                  ),
                ),
                TextField(
                  controller: TextEditingController(),
                  obscureText: false,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22.0),
                      borderSide:
                          BorderSide(color: Color(0x00ffffff), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22.0),
                      borderSide:
                          BorderSide(color: Color(0x00ffffff), width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22.0),
                      borderSide:
                          BorderSide(color: Color(0x00ffffff), width: 1),
                    ),
                    hintText: "Email",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xff000000),
                    ),
                    filled: true,
                    fillColor: Color(0xfff2f2f3),
                    isDense: false,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    prefixIcon:
                        Icon(Icons.mail, color: Color(0xff3a57e8), size: 24),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 30),
                  child: TextField(
                    controller: TextEditingController(),
                    obscureText: true,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xff000000),
                    ),
                    decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22.0),
                        borderSide:
                            BorderSide(color: Color(0x00ffffff), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22.0),
                        borderSide:
                            BorderSide(color: Color(0x00ffffff), width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22.0),
                        borderSide:
                            BorderSide(color: Color(0x00ffffff), width: 1),
                      ),
                      hintText: "Password",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff000000),
                      ),
                      filled: true,
                      fillColor: Color(0xfff2f2f3),
                      isDense: false,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      prefixIcon:
                          Icon(Icons.lock, color: Color(0xff3a57e8), size: 24),
                      suffixIcon: Icon(Icons.visibility,
                          color: Color(0xff97989a), size: 24),
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {},
                  color: Color(0xffffd261),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.0),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  textColor: Color(0xff4d4d4d),
                  height: 50,
                  minWidth: MediaQuery.of(context).size.width,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Already have an account?",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xffe2dcdc),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Text(
                          "SignIn",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xffffffff),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                 Checkbox(
                  onChanged: (value) {},
                  activeColor: Color(0xff3a57e8),
                  autofocus: false,
                  checkColor: Color(0xffffffff),
                  hoverColor: Color(0x42000000),
                  splashRadius: 20,
                  value: true,
                ),
                Text(
                  "Husk mig!",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    final AuthResponse res;
    try {
      res = await dataBase.auth.signInWithPassword(
          email: _emailController.text, password: _passWordController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Login godkendt!',
            style: TextStyle(
                color: Colors.greenAccent,
                backgroundColor: Colors.black,
                fontSize: 20)),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$e',
            style: TextStyle(
                color: Colors.redAccent,
                backgroundColor: Colors.black,
                fontSize: 20)),
      ));
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

  void toggleRememberMe() {}

  /*
      body: Align(
        alignment: Alignment.center, widthFactor: 3, child:
      Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children:
        [
          Container(height: 20),
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
        
        )

  */

}
