import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'dart:async';
import 'package:copal/Screen/Levels/LevelTemplate.dart';
import 'package:copal/data/level.dart';

class PopupVocab extends StatefulWidget {
  final Level level;
  const PopupVocab({Key? key, required this.level}) : super(key: key);
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

          return Container(
            padding: EdgeInsets.all(20),
            width: 500 * scaleFactor,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/vocab.png'),
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
                        image: DecorationImage(image: AssetImage('assets/images/bgVocab.png'))
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
            
          );
        },)
      );
  }
}


