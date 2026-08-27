import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:copal/data/level.dart';
import 'package:copal/data/story.dart';
import 'package:go_router/go_router.dart';
import 'package:copal/constants/images.dart';
import 'package:copal/services/level_service.dart';

class MapTemplate extends StatefulWidget{
  final Story story;
  const MapTemplate({super.key, required this.story});
  
  @override
  State<MapTemplate> createState() => _MapTemplateState();
}

class _MapTemplateState extends State<MapTemplate> {
 Map<int, ({int stars, bool isCompleted})> _levelProgress = {};
 bool _isLoading = true;

@override 
void initState() {
    super.initState();
    _loadLevelProgress();
  }

Future<void>_loadLevelProgress() async{
  try{
    final progressData = await LevelService.getLevelProgress();
    if(!mounted) return;
    final Map<int, ({int stars, bool isCompleted})> progressMap = {};
    for( final row in progressData){
      final int levelId = (row['level_id']??0) as int ; 
      final int stars = (row['stars'] ?? 0 ) as int;
      final bool isCompleted = (row['is_completed'] ?? false) as bool;
      progressMap[levelId] = (stars: stars, isCompleted: isCompleted);
    }

    setState((){_levelProgress = progressMap;_isLoading = false;});


  } catch(e) {
    print('Error loading level progress: $e');
    if(mounted) setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal memuat progres level. Periksa koneksi internet."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
  }
}


Widget buildLevelNode(Level level){
  final nodeSize = 150.0;
  final progress = _levelProgress[level.id];
  final starCount = progress?.stars ?? level.star;
  final isCompleted = progress?.isCompleted ?? false;


  final bool isLocked = level.id > 1 && !(_levelProgress[level.id - 1]?.isCompleted ?? false);

  return GestureDetector(
    onTap: (){
      if(!isLocked){

        print("Pergi ke level ${level.id}");
        context.go('/dashboard/map/level/${level.id}');
      } else{
                ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Level masih terkunci, selesaikan dulu level sebelumnya!"),
          duration: Duration(seconds: 2),)
        );
      }
    },
    child: Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: nodeSize, 
          height: nodeSize,
          decoration: BoxDecoration(
           image: DecorationImage(
            image:  AssetImage(AppImages.kayu),
            fit: BoxFit.contain
           ),
          ),
        ),
        Positioned(
          top: -50,
          child: Container(
            width: 85,
            height: 85,
            decoration: BoxDecoration(
              color: Color(0xffFFF5EE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: isLocked? Center(
              child: Image.asset(AppImages.lock)
            ): Center(
              child: Text(
                "${level.id}",
                style: const TextStyle(
                  color: Color(0xffB77D4C),
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
        ),
        // ⭐ Bintang HANYA muncul jika level sudah terbuka DAN sudah pernah diselesaikan (isCompleted)
        if (!isLocked && isCompleted)
          Positioned(
            top: 20,
            child: Row(
              children: List.generate(3, (index) {
                final isEarned = index < starCount;
                
                final Widget starWidget = isEarned
                    ? Image.asset(
                        AppImages.star,
                        width: 45,
                        height: 45,
                        cacheWidth: 100,
                      )
                    : const Icon(
                        Icons.star_outline_rounded, // ⭐ Bintang Outlined
                        size: 42,
                        color: Color(0xFFB77D4C),
                      );

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: starWidget,
                );
              }),
            ),
          ),
          // child: Image(
          //   image: ResizeImage(AssetImage(AppImages.star), 
          //   width: 50, 
          //   height: 50)))
      ],
    ),
  );
}



  @override
  Widget build(BuildContext context) {

      final isMobile = ResponsiveBreakpoints.of(context).isMobile;
      final isTablet = ResponsiveBreakpoints.of(context).isTablet;
      final paddingScale = isMobile ? 10.0 : (isTablet ? 40.0 : 60.0);
      
    return Scaffold(
      body : SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child :ClipRect(
            child : FittedBox(
              fit : BoxFit.cover,
              child: SizedBox(
                width: 1920,
                height: 1080,
                child: Stack(
                  children : [
                    Positioned.fill(
                      child : Image.asset(
                        widget.story.mapImage,
                        fit : BoxFit.fill
                      )
                    ),
                    ...allLevels.where((lvl) => lvl.id_story == widget.story.id).map((level){
                      return Align(
                        alignment: level.mapPosition,
                        child: buildLevelNode(level)
                      );
                    }).toList()
                  ]
                )
              )
            )
          )
        )
        )
    );
  }
}