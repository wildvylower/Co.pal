import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'dart:async';
import 'package:copal/Screen/Levels/LevelTemplate.dart';
import 'package:copal/data/level.dart';
import 'package:copal/Screen/Levels/popup/popupScore.dart';
import 'package:copal/constants/images.dart';
import 'package:copal/utils/scale_helper.dart';
import 'package:copal/Screen/Levels/popup/rewardPopup.dart';

class PopupVocab extends StatefulWidget {
  final Level level;
  final int star;
  final VoidCallback onRestart;


  const PopupVocab({super.key, required this.level, required this.star, required this.onRestart});
  @override 
  _PopupVocabState createState() => _PopupVocabState();
}

class _PopupVocabState extends State<PopupVocab> {
  

  
  @override
  Widget build(BuildContext context) {
     final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final paddingScale = isMobile ? 10.0 : (isTablet ? 20.0 : 30.0);

    return  SafeArea(
        child : LayoutBuilder(builder: (context, constraints){
          final scaleFactor = getGlobalScale(context);
          final letters = widget.level.vocab.split('');

          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child : 
            Container(
            padding: EdgeInsets.all(20),
            width: 500 * scaleFactor,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: ResizeImage(const AssetImage(AppImages.vocab), width: 600),
                fit: BoxFit.contain,
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(widget.level.vocabImage,
                width: 100 * scaleFactor,
                cacheWidth: 300,),
                

                SizedBox(height: 20 * scaleFactor,),

               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                
                children: 
                  letters.map((letter){
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 4* scaleFactor),
                      width : 40 * scaleFactor,
                      height: 40 * scaleFactor,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: ResizeImage(const AssetImage(AppImages.bgVocab), width: 200)
                        )
                      ),
                      child: Center(
                        child : Text(
                          letter,
                          style : TextStyle(
                            fontSize: 20 * scaleFactor,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff705050),
                          ),
                        )
                      ),

                    );
                  }).toList()

                
               )


              ],
            )
            )
          );
          
          
        },)
      );
  }
}


