import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'dart:async';
import 'package:copal/Screen/Levels/LevelTemplate.dart';
import 'package:copal/data/level.dart';
import 'package:go_router/go_router.dart';
import 'package:copal/constants/images.dart';
import 'package:copal/utils/scale_helper.dart';

class RewardPopup extends StatefulWidget {
  final Level level;
  const RewardPopup({super.key, required this.level});
  @override 
  _RewardPopupState createState() => _RewardPopupState();
}

class _RewardPopupState extends State<RewardPopup> {
  

  
  @override
  Widget build(BuildContext context) {
     final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final paddingScale = isMobile ? 10.0 : (isTablet ? 20.0 : 30.0);

    return  SafeArea(
        child : LayoutBuilder(builder: (context, constraints){
          final scaleFactor = getGlobalScale(context);
          

          return Container(
            padding: EdgeInsets.only(top:100 * scaleFactor, left: 20 * scaleFactor , right: 20 * scaleFactor, bottom: 20 * scaleFactor),
            width: 500 * scaleFactor,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: ResizeImage(const AssetImage(AppImages.reward), width: 600),
                fit: BoxFit.contain,
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30 * scaleFactor,),
                if(widget.level.rewardImage != null)
                Image.asset(widget.level.rewardImage!, 
                width : 100 * scaleFactor,
                height : 100 * scaleFactor,
                cacheWidth: 300),

                SizedBox(height : 30 * scaleFactor),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10 * scaleFactor,
                  children: [

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
                    final currentIndex = allLevels.indexWhere((lvl) => lvl.id == widget.level.id);
                    if (currentIndex != -1 && currentIndex + 1 < allLevels.length) {
                      final nextLevel = allLevels[currentIndex + 1];
                      context.go('/dashboard/map/level/${nextLevel.id}');
                    } else {
                      context.go('/dashboard');
                    }
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


