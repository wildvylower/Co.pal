import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:copal/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:copal/Screen/Settings.dart';
import 'package:copal/providers/auth_provider.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});
  @override
  ConsumerState<Dashboard> createState()=> _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  bool isMerem = false;
  late Timer timer;
  int coin = 0;
  int gem = 0;
  String name = 'User';
  bool isLoading = true;
  late VoidCallback _routerListener; 
  GoRouterDelegate? _routerDelegate;

  @override
  initState() {
    super.initState();
    _loadCoinAndGem();
    _routerListener = (){
      if(mounted){
        final String currentPath = GoRouter.of(context).routerDelegate.currentConfiguration.uri.path;

        if(currentPath == '/dashboard'){
          _loadCoinAndGem();
        }
      }
    };
    WidgetsBinding.instance.addPostFrameCallback((_){
      GoRouter.of(context).routerDelegate.addListener(_routerListener);
    });
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
      if (mounted) {
        setState(() => isMerem = true);
        _routerDelegate = GoRouter.of(context).routerDelegate;
        _routerDelegate?.addListener((_routerListener));

        Future.delayed(Duration(milliseconds: 100), () {
          if (mounted) {
            setState(() => isMerem = false);
          }
        });
      }
    });
  }

  


Future<void> _loadCoinAndGem() async{
    final (coins : c, gems : g)= await PetService.getCoins();
    
 
    if(mounted){
      setState((){
        coin = c;
        gem = g;
        isLoading = false;
      });
    }
}

  @override
  void dispose() {
    _routerDelegate?.removeListener(_routerListener);
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final paddingScale = isMobile ? 10.0 : (isTablet ? 40.0 : 60.0);
    final profile = ref.watch(userProfileProvider);
    final userName = profile?['name'] ?? 'User';
    final userPhoto = profile?['profile_pict'] ?? '';

    String? photoUrl;
    if(userPhoto !=null && userPhoto.isNotEmpty){
      photoUrl = Supabase.instance.client.storage.from('profile_pict').getPublicUrl(userPhoto);
    }
    

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        width : MediaQuery.sizeOf(context).width / 2,
        child: Settings(),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.home),
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
                        IconButton(
                          onPressed: (){
                           Scaffold.of(context).openDrawer();
                          }, 
                        icon:  FaIcon(
                          FontAwesomeIcons.gear,
                          size: 40 * scaleFactor,
                          color: Color(0xff7D9A36),
                        ),),
                       
                        //logo
                        Image.asset(
                          AppImages.copalHomeScreen,
                          height: 80 * scaleFactor,
                          cacheWidth: 730,
                          cacheHeight: 154,
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
                                    image: ResizeImage(
                                      photoUrl != null? NetworkImage(photoUrl) :
                                      AssetImage(AppImages.profile),
                                      width: 150, // Ukuran di RAM dibatasi agar tidak boros
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 5 * scaleFactor),
                              //name
                              Text(
                                userName,
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
                                    '$gem',
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
                                    '$coin',
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
                                                    AppImages.scenePet,
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
                                                        ? AppImages.kucingMerem
                                                        : AppImages.kucingIdle,
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
                                                  AppImages.bubbleChat,
                                                  fit: BoxFit.contain,
                                                ),
                                                Positioned(
                                                  top: 15 * scaleFactor,
                                                  child: Image.asset(
                                                    AppImages.cake,
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
                                          child: GestureDetector(
                                            onTap :(){
                                              context.go('/dashboard/pet');
                                            },
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
                                          )
                                          
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
                                              AppImages.pestaUltahBeri,
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
                                        context.go('/dashboard/map');
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
