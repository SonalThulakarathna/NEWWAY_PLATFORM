import 'package:flutter/material.dart';
import 'package:newway/pages/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://ultmmbquazebsddtgqlh.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVsdG1tYnF1YXplYnNkZHRncWxoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc4NTI0NjEsImV4cCI6MjA1MzQyODQ2MX0.DGv1YS3xqhWi_4-vDJvHFNKmV9UZxU6oWhGI84zeCDE',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}
