import 'package:copal/Screen/Levels/LevelTemplate.dart';
import 'package:copal/data/level.dart';
import 'package:copal/data/story.dart';
import 'package:flutter/material.dart';
import 'Screen/Dashboard.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Screen/splashScreen.dart';
import 'Screen/pet.dart';
import 'package:go_router/go_router.dart';
import 'Screen/login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:copal/providers/auth_provider.dart';
import 'Screen/Levels/map.dart';


final GoRouter _router = GoRouter(
  refreshListenable: AuthNotifier(),
  redirect :(context, state){
    final session = Supabase.instance.client.auth.currentSession;
    final loggedIn = session != null;
    final toLogin = state.matchedLocation == '/login';
    final toSplash = state.matchedLocation =='/';
    if(!loggedIn && !toLogin && !toSplash){
      return '/login';
    }
    if(loggedIn &&( toLogin || toSplash)){
      return '/dashboard';
    }
    return null;
 
  },
  routes : [
    GoRoute(
      path : '/',
      builder: (context, state) => const Splash(),
    ),
    GoRoute( 
      path: '/login',
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => Dashboard(),
      routes: [
        GoRoute(path: 'map',
        builder: (context, state) => MapTemplate(story: stories[0]),
        routes: [
            GoRoute(
          path: 'level/:id',
          builder: (context, state){
            final idString = state.pathParameters['id'];
            final id = int.tryParse(idString ?? '1');
            final currentLevel = allLevels.firstWhere((lvl)=>
            lvl.id==id);
            return LevelOneScreen(
              key: ValueKey(currentLevel.id),
              level: currentLevel,
            );
          }
        ),
        ]
        ),
        GoRoute(
          path: 'pet',
          builder: (context, state) => Pet(),
        )
      ],
    ),
  ]
);

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
  runApp(
    ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
          routerConfig: _router,
           builder:
          (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 900, name: MOBILE),
              const Breakpoint(start: 901, end: 1200, name: TABLET),
              const Breakpoint(start: 1201, end: 1920, name: DESKTOP),
            ],
          ),
      title: 'Copal App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: const ColorScheme.light(
          onSurface: Color(0xFF383838), // Hitam
          onPrimary: Color(0xFFFFFFFF), // Putih
          secondary: Color(0xFF705050), // Coklat
        ),
        textTheme: GoogleFonts.shantellSansTextTheme().apply(
          bodyColor: const Color(0xFF383838),
          displayColor: const Color(0xFF383838),
        ),
      ),
    );
  }
}