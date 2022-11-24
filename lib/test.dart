import 'dart:async';
import 'package:supabase/supabase.dart';

Future<void> main() async {
  const supabaseUrl = 'https://zbqoritnaqhkridbyaxc.supabase.co';
  const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpicW9yaXRuYXFoa3JpZGJ5YXhjIiwicm9sZSI6ImFub24iLCJpYXQiOjE2Njg2MzI0NDEsImV4cCI6MTk4NDIwODQ0MX0.NO3SvLCPEmXMFIVFiHBYV9ZLp0o2IFgndMzpkwQG_F0';
  final supabase = SupabaseClient(supabaseUrl, supabaseKey);

  // query data
  final data =
      await supabase.from('trips_tab').select().order('user_id', ascending: true);
  print(data);

  // insert data
  await supabase.from('trips_tab').insert([
    {'user_id': 'HEVI','description': 'Singapore trip','trip_data': 'Trip data points'},
  ]);

}