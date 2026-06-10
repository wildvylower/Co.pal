import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'dart:async';
import 'package:copal/Screen/Levels/LevelTemplate.dart';
import 'package:copal/data/level.dart';
import 'package:copal/Screen/Levels/popup/popupScore.dart';
import 'package:copal/constants/images.dart';

class PopupVocab extends StatefulWidget {
  final Level level;
  final int star;
  final VoidCallback onRestart;


  const PopupVocab({Key? key, required this.level, required this.star, required this.onRestart}) : super(key: key);
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
          final availableWidth = constraints.maxWidth;
          final scaleFactor = isMobile ? 1.0 : (availableWidth / 900).clamp(0.8, 1.5);
          final letters = widget.level.vocab.split('');

          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context, builder: (_) => Dialog(
                  backgroundColor: Colors.transparent,
                  child: PopupScore(level : widget.level, star : widget.star, onRestart: widget.onRestart,)
              ),);
            },
            child : 
            Container(
            padding: EdgeInsets.all(20),
            width: 500 * scaleFactor,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(AppImages.vocab),
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

               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                
                children: 
                  letters.map((letter){
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 4* scaleFactor),
                      width : 40 * scaleFactor,
                      height: 40 * scaleFactor,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(AppImages.bgVocab))
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


