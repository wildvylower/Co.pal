import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'dart:async';
import 'package:copal/Screen/Levels/LevelTemplate.dart';
import 'package:copal/data/level.dart';
import 'package:go_router/go_router.dart';
import 'package:copal/constants/images.dart';

class PopupScore extends StatefulWidget {
  final Level level;
  final int star;
  final VoidCallback onRestart;
  const PopupScore({Key? key, required this.level, required this.star, required this.onRestart}) : super(key: key);
  @override 
  _PopupScoreState createState() => _PopupScoreState();
}

class _PopupScoreState extends State<PopupScore> {
  

  
  @override
  Widget build(BuildContext context) {
     final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final paddingScale = isMobile ? 10.0 : (isTablet ? 20.0 : 30.0);

    return  SafeArea(
        child : LayoutBuilder(builder: (context, constraints){
          final availableWidth = constraints.maxWidth;
          final scaleFactor = isMobile ? 1.0 : (availableWidth / 900).clamp(0.8, 1.5);
          

          return Container(
            padding: EdgeInsets.only(top:100 * scaleFactor, left: 20 * scaleFactor , right: 20 * scaleFactor, bottom: 20 * scaleFactor),
            width: 500 * scaleFactor,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(AppImages.score),
              fit: BoxFit.fitHeight,
              
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children : 
                  List.generate(3, (index){
                    final isMid = index ==1;
                    final isEarned = index < widget.star;

                    final starWidget = Opacity(opacity : isEarned? 1.0 : 0.2,
                    child : Image.asset(AppImages.star,
                    width: isMid ? 60 * scaleFactor : 50 * scaleFactor,
                    height: isMid ? 60 * scaleFactor : 50 * scaleFactor,
                    )
                    
                    );
                    return Padding(
                      padding: isMid ? EdgeInsets.only(bottom : 4) : EdgeInsets.zero,
                      child : starWidget
                      );
                  })
              
               ),

               SizedBox(height: 10 * scaleFactor,),

               if(widget.star == 3)
                Text('Kerja Bagus!',
                style: TextStyle(
                  fontSize: 20 * scaleFactor,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                
                ),

               if(widget.star == 2)
                Text('Coba Kode Yang Lebih Pendek Lagi!',
                style: TextStyle(
                  fontSize: 16 * scaleFactor,
                  color: Colors.white),
                ),
                
                

                if(widget.star == 1)
                Text('Lumayan!',
                style: TextStyle(
                  fontSize: 20 * scaleFactor,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                
                ),

                SizedBox(height: 10 * scaleFactor,),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 4 * scaleFactor,
                  children: [
                    GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    widget.onRestart();
                  },
                  child: Container(
                     width: 60*scaleFactor,
                    height: 60*scaleFactor,
                    alignment: Alignment.center,
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
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/dashboard');
                  },
                  child: Container(
                    width: 60*scaleFactor,
                    height: 60*scaleFactor,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(16 * scaleFactor),
                    decoration: const BoxDecoration(
                      color: Color(0xffFFF2B3),
                      shape: BoxShape.circle,
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.list,
                      color: const Color(0xff383838),
                      size: 28 * scaleFactor,
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    widget.onRestart();
                  },
                  child: Container(
                     width: 60*scaleFactor,
                    height: 60*scaleFactor,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(16 * scaleFactor),
                    decoration: const BoxDecoration(
                      color: Color(0xffCCE7F2),
                      shape: BoxShape.circle,
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.chevronRight,
                      color: const Color(0xff383838),
                      size: 28 * scaleFactor,
                    ),
                  ),
                )

                  ]
                )


              ]
               
               

              
            )
            
          );
        },)
      );
  }
}


