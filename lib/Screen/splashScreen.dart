import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'dart:async';
import 'package:copal/Screen/Dashboard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _checkLogin();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(),
        ),
      );
    });
  }

  Future<void> _checkLogin() async {
    print("=== DEBUG: _checkLogin started ===");
    try {
      // Memaksa keluar untuk membersihkan sesi lama di HP/emulator
      await Supabase.instance.client.auth.signOut(scope: SignOutScope.local);
      print("=== DEBUG: Berhasil keluar (Sign Out) dari sesi lama ===");

      final session = Supabase.instance.client.auth.currentSession;
      print("=== DEBUG: currentSession is ${session != null ? 'NOT null' : 'null'} ===");

      if (session == null) {
        print("=== DEBUG: Attempting to sign in anonymously... ===");
        final response = await Supabase.instance.client.auth.signInAnonymously();
        print("=== DEBUG: signInAnonymously response: $response ===");
        print("=== DEBUG: response.user: ${response.user} ===");
        print("=== DEBUG: response.user?.id: ${response.user?.id} ===");
        print("=== DEBUG: response.session: ${response.session} ===");
        if (response.user != null) {
          print("=== DEBUG: Anonymous sign in BERHASIL! User ID: ${response.user!.id} ===");
        } else {
          print("=== DEBUG: signInAnonymously TIDAK error, tapi user NULL. Kemungkinan diblok RLS atau fitur belum aktif ===");
        }
      } else {
        print("=== DEBUG: Already logged in as: ${session.user.id} ===");
      }
    } on AuthException catch (e) {
      print("=== DEBUG: AuthException: message=${e.message}, statusCode=${e.statusCode} ===");
    } catch(e, stack) {
      print("=== DEBUG: Error caught: $e ===");
      print("=== DEBUG: StackTrace: $stack ===");
    } finally {
      print("=== DEBUG: _checkLogin finished ===");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final paddingScale = isMobile ? 10.0 : (isTablet ? 40.0 : 60.0);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: paddingScale,
            vertical: isMobile ? 8.0 : 12.0,
          ),
          alignment: Alignment.center,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;
              final scaleFactor =
                  isMobile ? 1.0 : (availableWidth / 900).clamp(0.8, 1.5);
              return Center(
                child: Image.asset(
                  'assets/images/splashmelek.png',
                  width: 500 * scaleFactor,
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}