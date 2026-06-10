import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'dart:async';
import 'package:copal/Screen/Levels/LevelTemplate.dart';
import 'package:copal/data/level.dart';
import 'package:copal/constants/images.dart';

class PopupFailed extends StatefulWidget {
  final Level level;
  final VoidCallback onRestart;
  const PopupFailed({Key? key, required this.level, required this.onRestart}) : super(key: key);
  @override 
  _PopupFailedState createState() => _PopupFailedState();
}

class _PopupFailedState extends State<PopupFailed> {
  

  
  @override
  Widget build(BuildContext context) {
     final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final paddingScale = isMobile ? 10.0 : (isTablet ? 20.0 : 30.0);

    return  SafeArea(
        child : LayoutBuilder(builder: (context, constraints){
          final availableWidth = constraints.maxWidth;
          final scaleFactor = isMobile ? 1.0 : (availableWidth / 900).clamp(0.8, 1.5);
          final letters = widget.level.vocab.split('');

          return Container(
            padding: EdgeInsets.all(20),
            width: 500 * scaleFactor,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(AppImages.copalFailed),
              fit: BoxFit.fitHeight,
              
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(widget.level.vocabImage,
                width: 100 * scaleFactor,),
                

                SizedBox(height: 20 * scaleFactor,),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    widget.onRestart();
                  },
                  child: Container(
                    padding: EdgeInsets.all(16 * scaleFactor),
                    decoration: const BoxDecoration(
                      color: Color(0xffFFCEE0),
                      shape: BoxShape.circle,
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.arrowRotateLeft,
                      color: const Color(0xff383838),
                      size: 28 * scaleFactor,
                    ),
                  ),
                )
                

              ],
            )
            
          );
        },)
      );
  }
}


