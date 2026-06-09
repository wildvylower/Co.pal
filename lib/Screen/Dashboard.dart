import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'dart:async';
import 'package:copal/Screen/Levels/LevelTemplate.dart';
import 'package:copal/data/level.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isMerem = false;
  late Timer timer;

  @override
  initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
      if (mounted) {
        setState(() => isMerem = true);

        Future.delayed(Duration(milliseconds: 100), () {
          if (mounted) {
            setState(() => isMerem = false);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final paddingScale = isMobile ? 10.0 : (isTablet ? 40.0 : 60.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/home(4).png'),
            fit: BoxFit.cover,
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: paddingScale,
              vertical: isMobile ? 8.0 : 12.0,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth;
                final scaleFactor =
                    isMobile ? 1.0 : (availableWidth / 900).clamp(0.8, 1.5);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //settings icon
                        FaIcon(
                          FontAwesomeIcons.gear,
                          size: 40 * scaleFactor,
                          color: Color(0xff7D9A36),
                        ),
                        //logo
                        Image.asset(
                          'assets/images/copalhomescreen.png',
                          height: 80 * scaleFactor,
                        ),
                        //daily mission notif
                        FaIcon(
                          FontAwesomeIcons.solidBell,
                          size: 40 * scaleFactor,
                          color: Color(0xffFFC400),
                        ),
                      ],
                    ),
                    SizedBox(height: 10 * scaleFactor),
                    Container(
                      width: double.infinity,
                      height: 60 * scaleFactor,
                      padding: EdgeInsets.all(5 * scaleFactor),
                      decoration: BoxDecoration(
                        color: Color(0xffFFF2DF),
                        borderRadius: BorderRadius.circular(36 * scaleFactor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: Offset(2, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              //avatar profile
                              Container(
                                width: 55 * scaleFactor,
                                height: scaleFactor * 55,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      'assets/images/profile.png',
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 5 * scaleFactor),
                              //name
                              Text(
                                'Ruby',
                                style: TextStyle(
                                  fontSize: 18 * scaleFactor,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff383838),
                                ),
                              ),
                              SizedBox(width: 5 * scaleFactor),
                              //free/prem hide dulu
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8 * scaleFactor,
                                  vertical: 4 * scaleFactor,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xff0086DB),
                                  borderRadius: BorderRadius.circular(
                                    32 * scaleFactor,
                                  ),
                                ),
                                child: Text(
                                  'Gratis',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12 * scaleFactor,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8 * scaleFactor,
                              vertical: 4 * scaleFactor,
                            ),
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                32 * scaleFactor,
                              ),
                            ),
                            child: Row(
                              children: [
                                //button gem
                                TextButton.icon(
                                  onPressed: () {},
                                  icon: FaIcon(
                                    FontAwesomeIcons.solidGem,
                                    size: 18 * scaleFactor,
                                    color: Color(0xff7171E9),
                                  ),
                                  label: Text(
                                    '5',
                                    style: TextStyle(
                                      fontSize: 16 * scaleFactor,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff383838),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5 * scaleFactor),
                                //button coin
                                TextButton.icon(
                                  onPressed: () {},
                                  icon: FaIcon(
                                    FontAwesomeIcons.coins,
                                    size: 18 * scaleFactor,
                                    color: Color(0xffFFC400),
                                  ),
                                  label: Text(
                                    '5',
                                    style: TextStyle(
                                      fontSize: 16 * scaleFactor,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff383838),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10 * scaleFactor),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //pet
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: isMobile ? 3 / 1 : 4 / 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff74D3FF),
                                  borderRadius: BorderRadius.circular(
                                    28 * scaleFactor,
                                  ),
                                ),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final h = constraints.maxHeight;
                                    final w = constraints.maxWidth;

                                    final sceneWidth = w * 0.55;

                                    return Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Positioned(
                                          left: 15 * scaleFactor,
                                          top: 15 * scaleFactor,
                                          bottom: 15 * scaleFactor,
                                          width: sceneWidth,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              20 * scaleFactor,
                                            ),
                                            child: Stack(
                                              children: [
                                                Positioned.fill(
                                                  child: Image.asset(
                                                    'assets/images/scenePet.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Align(
                                                  alignment: const Alignment(
                                                    0.0,
                                                    1.5,
                                                  ),
                                                  child: Image.asset(
                                                    isMerem
                                                        ? 'assets/images/kucingmerem.png'
                                                        : 'assets/images/kucingidle.png',
                                                    height: h * 0.6,
                                                    fit: BoxFit.contain,
                                                    gaplessPlayback: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: sceneWidth * 0.9,
                                          top: h * 0.05,
                                          child: SizedBox(
                                            width: w * 0.35,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/images/bublechat.png',
                                                  fit: BoxFit.contain,
                                                ),
                                                Positioned(
                                                  top: 15 * scaleFactor,
                                                  child: Image.asset(
                                                    'assets/images/cake.png',
                                                    width: w * 0.15,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        Positioned(
                                          right: 15 * scaleFactor,
                                          bottom: 15 * scaleFactor,
                                          child: Container(
                                            padding: EdgeInsets.all(
                                              20 * scaleFactor,
                                            ),
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: FaIcon(
                                              FontAwesomeIcons.chevronRight,
                                              size: 24 * scaleFactor,
                                              color: const Color(0xff383838),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 10 * scaleFactor),

                          //map
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: isMobile ? 3 / 1 : 4 / 3,
                              child: Container(
                                padding: EdgeInsets.all(20 * scaleFactor),
                                decoration: BoxDecoration(
                                  color: Color(0xffFF72A6),
                                  borderRadius: BorderRadius.circular(
                                    28 * scaleFactor,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: Image.asset(
                                              'assets/images/pestaultahberi.png',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          SizedBox(height: 10 * scaleFactor),
                                          Text(
                                            'Pemula',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14 * scaleFactor,
                                              color: Color(0xffFFFDF0),
                                            ),
                                          ),
                                          Text(
                                            'Pesta Ulang Tahun Beri',
                                            style: TextStyle(
                                              fontSize: 18 * scaleFactor,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xffFFFDF0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => LevelOneScreen(level : allLevels[0]),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(
                                          20 * scaleFactor,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xffFFFDF0),
                                          shape: BoxShape.circle,
                                        ),
                                        child: FaIcon(
                                          FontAwesomeIcons.chevronRight,
                                          size: 24 * scaleFactor,
                                          color: Color(0xff383838),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
