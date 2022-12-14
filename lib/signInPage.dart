import 'package:flutter/cupertino.dart';
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
  
  @override
  initState() 
  {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(title: const Text('A Cleaner World')),
      drawer: buildDrawer(context, signInPage.route),
      body: Text("Hello World")
      );      
  }

}

