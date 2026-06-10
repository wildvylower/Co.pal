import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'dart:async';
import 'package:copal/Screen/Dashboard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:copal/services/auth_service.dart';
import 'package:copal/constants/images.dart';



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
     context.go('/dashboard');
    });
  }

  Future<void> _checkLogin() async {
    try{
      await AuthService.checkLogin();
    }finally{
      if(mounted){
        setState((){
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
                  AppImages.splashMelek,
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