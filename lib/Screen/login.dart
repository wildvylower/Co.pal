import 'package:copal/services/auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'dart:async';
import 'package:copal/Screen/Levels/LevelTemplate.dart';
import 'package:copal/data/level.dart';
import 'package:go_router/go_router.dart';
import 'package:copal/constants/images.dart';
import 'package:copal/services/pet_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void handleLogin() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      await AuthService.loginEmail(email, password);

      if (mounted) {
        context.replace('/dashboard');
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal Masuk'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void handleSignup() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final nama = nameController.text.trim();

      await AuthService.signUpEmail(email, password, nama);

      if (mounted) {
        context.replace('/dashboard');
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal Mendaftar'), backgroundColor: Colors.red),
      );
    } finally {
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
    final paddingScale = isMobile ? 20.0 : (isTablet ? 40.0 : 60.0);
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ResizeImage(const AssetImage(AppImages.login), width: 800),
              fit: BoxFit.cover,
            ),
          ),
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: paddingScale, vertical: 10),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;
              final scaleFactor =
                  isMobile ? 1.0 : (availableWidth / 900).clamp(0.8, 1.5);

              return Container(
                width: 600 * scaleFactor,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(paddingScale),
                child: SingleChildScrollView(
                  child :  
                   Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 10 * scaleFactor,
                  children: [
                    Image.asset(AppImages.splashMelek,
                    width: isMobile? 150 * scaleFactor: 200 * scaleFactor,
                    cacheWidth: 386,
                    ),
                    SizedBox(height: 10 * scaleFactor),
                    Form(
                      key: _formKey,
                      child: Column(
                        spacing: 10 * scaleFactor,
                        children: [
                          if (!_isLogin)
                            TextFormField(
                              controller: nameController,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Nama tidak boleh kosong';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                label: Text.rich(
                                  style: GoogleFonts.poppins(
                                    fontSize: 14 * scaleFactor,
                                  ),
                                  TextSpan(
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                    ),
                                    text: 'Nama',
                                    children: [
                                      TextSpan(
                                        text: " *",
                                        style: GoogleFonts.poppins(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                filled: true,
                                fillColor: Color(0xffD9F4FF),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10 * scaleFactor,
                                  vertical: 6 * scaleFactor,
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                            ),


                          TextFormField(
                            controller: emailController,
                            validator: (value) {
                              final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );
                              if (value == null || value.trim().isEmpty) {
                                return 'Email tidak boleh kosong';
                              } else if (!emailRegex.hasMatch(value.trim())) {
                                return 'Format email salah';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: Text.rich(
                                style: GoogleFonts.poppins(
                                  fontSize: 14 * scaleFactor,
                                ),
                                TextSpan(
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                  ),
                                  text: 'Email',
                                  children: [
                                    TextSpan(
                                      text: " *",
                                      style: GoogleFonts.poppins(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              filled: true,
                              fillColor: Color(0xffD9F4FF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10 * scaleFactor,
                                vertical: 6 * scaleFactor,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                          TextFormField(
                             controller: passwordController,
                             obscureText: _obscurePassword,
                             validator: (value) {
                               if (value == null) {
                                 return 'Password tidak boleh kosong';
                               } else if (value.length < 8) {
                                 return 'Panjang password minimal 8 karakter';
                               }
                               return null;
                             },
                             decoration: InputDecoration(
                               suffixIcon: IconButton(
                                 icon: FaIcon(
                                   _obscurePassword
                                       ? FontAwesomeIcons.eyeSlash
                                       : FontAwesomeIcons.eye,
                                   size: 14 * scaleFactor,
                                   color: Colors.grey[600],
                                 ),
                                 onPressed: () {
                                   setState(() {
                                     _obscurePassword = !_obscurePassword;
                                   });
                                 },
                               ),
                              label: Text.rich(
                                style: GoogleFonts.poppins(
                                  fontSize: 14 * scaleFactor,
                                ),
                                TextSpan(
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                  ),
                                  text: 'Password',
                                  children: [
                                    TextSpan(
                                      text: " *",
                                      style: GoogleFonts.poppins(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              filled: true,
                              fillColor: Color(0xffD9F4FF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10 * scaleFactor,
                                vertical: 6 * scaleFactor,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                          ResponsiveRowColumn(
                            
                            rowMainAxisAlignment: MainAxisAlignment.center,
                            layout : ResponsiveBreakpoints.of(context).isMobile? ResponsiveRowColumnType.ROW : ResponsiveRowColumnType.COLUMN,
                            rowSpacing: 10 * scaleFactor,
                            columnSpacing: 10 * scaleFactor,

                            children: [
                              ResponsiveRowColumnItem(
                                rowFlex: 1,
                              child:  TextButton(
                            onPressed: _isLoading ? null : () {
                              if (_formKey.currentState!.validate()) {
                                _isLogin ? handleLogin() : handleSignup();
                              }
                            },
                            style: TextButton.styleFrom(
                              minimumSize: Size(double.infinity, 40*scaleFactor),
                              backgroundColor: _isLoading ? Colors.grey : Color(0xff0086DC),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20 * scaleFactor,
                                vertical: 10 * scaleFactor,
                              ),
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    width: 20 * scaleFactor,
                                    height: 20 * scaleFactor,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                              _isLogin ? 'Masuk' : 'Daftar',
                              style: TextStyle(
                                fontSize: 14 * scaleFactor,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                              ),
                              ResponsiveRowColumnItem(
                                rowFlex: 1,
                                child: 
                                TextButton.icon(
                            onPressed: _isLoading ? null : () async {
                              try {
                                await AuthService.loginGoogle();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Gagal masuk dengan Google: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }, 
                            icon: FaIcon(FontAwesomeIcons.google, size: 14 * scaleFactor),
                            label: Text(
                              'Lanjutkan dengan Google',
                              style: GoogleFonts.poppins(color: Colors.black, fontSize: 12 * scaleFactor)
                            ),

                            style: TextButton.styleFrom(
                              minimumSize: Size(double.infinity, 40*scaleFactor),
                              backgroundColor: _isLoading ? Colors.grey.shade300 : Color(0xffFFF2DF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20 * scaleFactor,
                                vertical: 10 * scaleFactor,
                              ),
                            ),
                          ),
                                )
                            ],
                          ),
                         
                          
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text.rich(
                              TextSpan(
                                text:
                                    _isLogin
                                        ? 'Belum punya akun? '
                                        : 'Sudah punya akun? ',
                                style: GoogleFonts.poppins(color: Colors.black,
                                fontSize: 14 * scaleFactor),
                                children: [
                                  TextSpan(
                                    text:
                                        _isLogin
                                            ? 'Daftar sekarang!'
                                            : 'Login di sini',
                                    style: GoogleFonts.poppins(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue,
                                      fontSize: 14 * scaleFactor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                )
               
              );
            },
          ),
        ),
      ),
    );
  }
}
