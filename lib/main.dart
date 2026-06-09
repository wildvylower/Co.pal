import 'package:flutter/material.dart';
import 'Screen/Dashboard.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Screen/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
   url: 'https://lwnokapcbqvqzzcswxbq.supabase.co',
   anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx3bm9rYXBjYnF2cXp6Y3N3eGJxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA4ODE1MjUsImV4cCI6MjA5NjQ1NzUyNX0.tpb9n4F5p3sxjh8KxYNeL4HeFEsNJxJH5ZxoBhwdRio',
 );
   await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
           builder:
          (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 700, name: MOBILE),
              const Breakpoint(start: 701, end: 1100, name: TABLET),
              const Breakpoint(start: 1101, end: 1920, name: DESKTOP),
            ],
          ),
      title: 'Copal App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.shantellSansTextTheme(),
      ),
      home: Splash(),
    );
  }
}