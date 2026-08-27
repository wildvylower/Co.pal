import 'package:copal/Screen/Levels/popup/popupVocab.dart';
import 'package:copal/constants/images.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:copal/data/level.dart';
import 'package:copal/Screen/Levels/popup/popupFailed.dart';
import 'package:copal/Screen/Levels/popup/popupScore.dart';
import 'package:copal/Screen/Levels/popup/rewardPopup.dart';
import 'package:go_router/go_router.dart';

enum CatCommand { up, down, left, right }
enum catState {start, loading, finished, paused}
enum catAnimation{start, idleDepan, idleSamping, jalanDepan, jalanSamping, jalanBelakang, tenggelam}

class LevelTemplate extends FlameGame {
  final Level level;
  LevelTemplate({required this.level});
  late TiledComponent levelMap;
  late Vector2 catStartPosition;
  late Vector2 targetPosition;
  late SpriteAnimationGroupComponent cat;
  late List<Sprite> spriteTenggelam;
  final ValueNotifier<List<CatCommand>> commandListNotifier = ValueNotifier([]);
  final ValueNotifier<bool> subNotifier =  ValueNotifier(false);
  final Component subContainer = Component();

 

  final ValueNotifier<bool> soundNotifier = ValueNotifier(false);
  bool isMoving = false;

  final ValueNotifier<catState> catStateNotifier = ValueNotifier(catState.start);

  final ValueNotifier<bool> finishNotifier = ValueNotifier(false);
  final double tileSize = 90;

  bool isWater = false;
  bool isPath = true;



  @override
  Color backgroundColor() => const Color(0xffFFF2B3);

  @override
  Future<void> onLoad() async {
    levelMap = await TiledComponent.load(level.tileMapPath, Vector2.all(tileSize));
    add(levelMap);
    String character = "kucing";

    camera = CameraComponent.withFixedResolution(
      width: tileSize * 10,
      height: tileSize * 4,
    );
    camera.viewfinder.anchor = Anchor.topLeft;

    final startPose = SpriteAnimation.spriteList(
      [
        await loadSprite(level.Sprite)
      ],
      stepTime: 0.2
    );

    final idleDepan = SpriteAnimation.spriteList([
      await loadSprite("${character}_Idle.png")
    ], stepTime: 0.2);

    final idleSamping = SpriteAnimation.spriteList([
      await loadSprite("${character}_Idle_Samping.png")
    ], stepTime: 0.2);

    final jalanDepan = SpriteAnimation.spriteList([
      await loadSprite("${character}_Jalan_Depan.png"),
      await loadSprite("${character}_Idle.png")
    ], stepTime: 0.2);

    final jalanBelakang = SpriteAnimation.spriteList([
      await loadSprite("${character}_Jalan_Belakang.png"),
      await loadSprite("${character}_Belakang_Idle.png")

    ], stepTime: 0.2);

    final jalanSamping = SpriteAnimation.spriteList([
      await loadSprite("${character}_Jalan_Samping.png"),
      await loadSprite("${character}_Idle_Samping.png")
    ], stepTime: 0.2);

    final tenggelam = SpriteAnimation.spriteList([
      await loadSprite("${character}Tenggelam1.png"),
      await loadSprite("${character}Tenggelam2.png"),
      await loadSprite("${character}Tenggelam3.png")
    ], stepTime: 0.2);


    cat = SpriteAnimationGroupComponent<catAnimation>(
      animations: {
        catAnimation.start: startPose,
        catAnimation.idleDepan : idleDepan,
        catAnimation.idleSamping : idleSamping,
        catAnimation.jalanDepan : jalanDepan,
        catAnimation.jalanSamping : jalanSamping,
        catAnimation.jalanBelakang : jalanBelakang,
        catAnimation.tenggelam : tenggelam,
      },
      current: catAnimation.start,
      size: Vector2.all(tileSize * 0.5),
      position: Vector2((level.catStartPosition.x * tileSize), (level.catStartPosition.y * tileSize))
    );
    add(cat);

    catStartPosition = cat.position.clone();
  
  }


  void addCommand(CatCommand cmd) {
    if (catStateNotifier.value == catState.start) {
      commandListNotifier.value = [...commandListNotifier.value, cmd];
    }
  }

  bool getTileProperty(int targetX, int targetY, String propertyName){
      final tileLayer = levelMap.tileMap.getLayer<TileLayer>('Tile Layer 1');
    if(tileLayer != null && tileLayer.tileData != null){
      if (targetY < 0 || targetY >= tileLayer.tileData!.length) return false;
      if (targetX < 0 || targetX >= tileLayer.tileData![0].length) return false;
      
      final gid = tileLayer.tileData![targetY][targetX].tile;
      if(gid!=0){
        final tileDetail = levelMap.tileMap.map.tileByGid(gid);
        return tileDetail?.properties.getValue<bool>(propertyName)??false; }
      
    }
    return false;
  }

  Future<bool> checkWater(int targetX, int targetY) async {

        isWater = getTileProperty(targetX, targetY, 'isWater');

        if(isWater){
          cat.current = catAnimation.tenggelam;
          await Future.delayed(const Duration(seconds: 1));
          
          finishNotifier.value = false;
          return true; 
        }
        return false;
  }

  Future<bool> checkPath(int targetX, int targetY) async{
    isPath = getTileProperty(targetX, targetY, 'isPath');
    if(!isPath){
      finishNotifier.value = false;
      return true;
    }
    return false;
  }

  

  Future<void> showSub()async{

    subContainer.removeAll(subContainer.children);
    final ListTiles = level.subTiles;

    for (int i=0; i<ListTiles.length ; i++){
      if(!subNotifier.value) break;
      final tiles = ListTiles[i];

      final posX = (tiles.x * tileSize) + (tileSize/2);
      final posY = (tiles.y * tileSize) + (tileSize/2);

      final baseStyle = Theme.of(buildContext!).textTheme.bodyMedium 
          ?? const TextStyle();

      final sub = TextComponent(
        text : '${i + 1}',
        position : Vector2(posX, posY),
        anchor : Anchor.center,
        textRenderer: TextPaint(
          style : baseStyle.copyWith(
            color : const Color(0xffFFCEE0), 
            fontSize: 28,
            fontWeight: FontWeight.bold,
          )
        )
      );
     subContainer.add(sub);
     await Future.delayed(const Duration(milliseconds: 1000));
    }
  }

  void toggleSub(){
    subNotifier.value = !subNotifier.value;
    if(subNotifier.value){
      add(subContainer);
      showSub();
      
    }else{
      subContainer.removeAll(subContainer.children);
      remove(subContainer);
    }
  }


  void runGame() async {


    if(catStateNotifier.value == catState.finished){
      Reset();
      commandListNotifier.value = [];
      return;
    }

    if(catStateNotifier.value == catState.loading || commandListNotifier.value.isEmpty){
      return;

    }

    catStateNotifier.value = catState.loading;
    final currentCommands = List<CatCommand>.from(commandListNotifier.value);
    int i =0;
    outerLoop: for (var cmd in currentCommands) {
      
  
      while (catStateNotifier.value == catState.paused) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      if (catStateNotifier.value == catState.start) {
        return;
      }

      if(level.ujung.isNotEmpty){
        while(true){
          await moveCat(cmd);
          await Future.delayed(const Duration(milliseconds: 600));
          final catX = (cat.position.x / tileSize).round();
          final catY = (cat.position.y / tileSize).round();
         
          bool isDrowning = await checkWater(catX, catY);
        if(isDrowning){
          break outerLoop; 
        }
      
        if(catStateNotifier.value == catState.finished){
          break outerLoop;
        }

        bool isOutPath = await checkPath(catX, catY);
        if(isOutPath){
          break outerLoop;
        }

        checkFinish();

        
        if(finishNotifier.value){
          break outerLoop;
        }
        if(catX == level.ujung[i].x && catY == level.ujung[i].y){
          i++;
          break;
          
        }
          
        }
      } else{
        await moveCat(cmd);
        await Future.delayed(const Duration(milliseconds: 600));
        final catX = (cat.position.x / tileSize).round();
        final catY = (cat.position.y / tileSize).round();
      
        bool isDrowning = await checkWater(catX, catY);
        if(isDrowning){
          break outerLoop; 
        }
      
        if(catStateNotifier.value == catState.finished){
          break outerLoop;
        }

        bool isOutPath = await checkPath(catX, catY);
        if(isOutPath){
          break outerLoop;
        }

        checkFinish();
        if(finishNotifier.value){
          break outerLoop;
        }
    }
    
    
   
      }

      if(catStateNotifier.value != catState.start){
        catStateNotifier.value = catState.finished;
      }
      
      
    
    
  }

  void Reset(){
    
    cat.position = catStartPosition.clone();
    cat.current = catAnimation.start;
    if(cat.isFlippedHorizontally){
      cat.flipHorizontallyAroundCenter();
    }
    if(!cat.isMounted){
      add(cat);
    }
    catStateNotifier.value = catState.start;
    finishNotifier.value = false;
    

  }

  void pauseGame(){
    if(catStateNotifier.value == catState.loading){
      catStateNotifier.value = catState.paused;
    }
  }

  void resumeGame(){
    if(catStateNotifier.value == catState.paused){
      catStateNotifier.value = catState.loading;
    }
  }

  

  void checkFinish(){
    final catX = (cat.position.x / tileSize).round();
    final catY = (cat.position.y / tileSize).round();

    if(catX == level.targetFinish.x && catY == level.targetFinish.y){
      finishNotifier.value = true;
      cat.current = catAnimation.start;
    }

  }

  Future<void> moveCat(CatCommand cmd) async {
    Vector2 delta = Vector2.zero();
    switch (cmd) {
      case CatCommand.up: delta = Vector2(0, -tileSize);cat.current = catAnimation.jalanBelakang; break;
      case CatCommand.down: delta = Vector2(0, tileSize); cat.current = catAnimation.jalanDepan; break;
      case CatCommand.left: delta = Vector2(-tileSize, 0); cat.current = catAnimation.jalanSamping; 
      if(!cat.isFlippedHorizontally) cat.flipHorizontallyAroundCenter(); break;
      case CatCommand.right: delta = Vector2(tileSize, 0); cat.current = catAnimation.jalanSamping;
      if(cat.isFlippedHorizontally) cat.flipHorizontallyAroundCenter(); break;
    }
    cat.add(MoveByEffect(delta, EffectController(duration: 0.5)));
  }
}



class LevelOneScreen extends StatefulWidget {
  final Level level;
  const LevelOneScreen({super.key, required this.level});

  @override
  State<LevelOneScreen> createState() => _LevelOneScreenState();
}

class _LevelOneScreenState extends State<LevelOneScreen> {
  late LevelTemplate _game;
  int star = 3;


  @override
  void initState() {
    super.initState();
    _game = LevelTemplate(level: widget.level);
    _game.catStateNotifier.addListener(_onFinish);
  }

  void _onFinish(){
    if(_game.catStateNotifier.value == catState.start){
      star = 3;
    }

    if(_game.catStateNotifier.value == catState.finished){
      if(_game.finishNotifier.value == true){

        final stars = _countStar();
        showDialog(context: context, builder: (_) => Dialog(
          backgroundColor: Colors.transparent,
          child: PopupVocab(level : widget.level, star : stars, onRestart : _game.runGame)
      ),
      barrierColor: const Color.fromARGB(140, 0, 0, 0),
      barrierDismissible: true
      ).then((_){
        showDialog(
                context: context, builder: (_) => Dialog(
                  backgroundColor: Colors.transparent,
                  child: PopupScore(level : widget.level, star : stars, onRestart: _game.runGame,)
              ),
              barrierDismissible: true,
        ).then((result){
          if (result == 'restart' || result == 'home') return;

          void goToNextLevel() {
            final currentIndex = allLevels.indexWhere((lvl) => lvl.id == widget.level.id);
            if (currentIndex != -1 && currentIndex + 1 < allLevels.length) {
              final nextLevel = allLevels[currentIndex + 1];
              context.replace('/dashboard/map/level/${nextLevel.id}');
            } else {
              context.replace('/dashboard');
            }
          }

          if (widget.level.rewardImage != null) {
            showDialog(
              context: context, builder: (_) => Dialog(
                backgroundColor: Colors.transparent,
                child: RewardPopup(level: widget.level)
              )
            ).then((_) {
               goToNextLevel();
            });
          } else {
             goToNextLevel();
          }
        });
      });
    } else if(_game.finishNotifier.value == false){
      showDialog(context: context, builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: PopupFailed(level : widget.level, onRestart : _game.runGame)
      ),
      barrierColor: const Color.fromARGB(140, 0, 0, 0),
      barrierDismissible: true
      );
    }
  }
  }

  int _countStar(){
    if(_game.commandListNotifier.value.length > _game.level.maksComand){
      star = star-1;
    }
    return star;
  }

  void removeComand(int index){
    if(_game.catStateNotifier.value != catState.start){
      _game.Reset();
    }
    if(_game.catStateNotifier.value == catState.start){
      final currentComand = List<CatCommand>.from(_game.commandListNotifier.value);
      currentComand.removeAt(index);

      _game.commandListNotifier.value = currentComand;
    }
  }
  

  @override 
  void dispose(){
    _game.catStateNotifier.removeListener(_onFinish);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final paddingScale = isMobile ? 10.0 : (isTablet ? 20.0 : 30.0);

    return Scaffold(
      backgroundColor: const Color(0xffFFF2B3),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth;
            final scaleFactor = isMobile ? 1.0 : (availableWidth / 900).clamp(0.8, 1.5);
            
            return Column(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: paddingScale * scaleFactor, left: paddingScale * scaleFactor, right: paddingScale * scaleFactor),
                    child: Center(
                      child: ClipRRect(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: SizedBox(
                            width: _game.tileSize * 10,
                            height: _game.tileSize * 4,
                            child: GameWidget(game: _game),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xff689028),
                  ),
                  child: _buildToolbar(context, _game, scaleFactor),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, LevelTemplate game, double scaleFactor) {
    return Container(
      padding: EdgeInsets.only(bottom: 20 * scaleFactor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder<List<CatCommand>>(
            valueListenable: game.commandListNotifier,
            builder: (context, commands, child) {
              return Container(
                margin: EdgeInsets.all(15 * scaleFactor),
                height: 60 * scaleFactor,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15 * scaleFactor),
                ),
                child: ReorderableListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 10 * scaleFactor),
                  itemCount: commands.length,
                  onReorder: (oldIndex, newIndex) {
                    if(_game.catStateNotifier.value != catState.start){
                      _game.Reset();
                    }
                    if(_game.catStateNotifier.value == catState.start){
                      if(oldIndex < newIndex){
                        newIndex -= 1;
                      }
                      final currentComand = List<CatCommand>.from(_game.commandListNotifier.value);
                      final command = currentComand.removeAt(oldIndex);
                      currentComand.insert(newIndex, command);
                      _game.commandListNotifier.value = currentComand;
                    }
                  },
                  buildDefaultDragHandles: false,
                  itemBuilder: (context, index) {
                    return ReorderableDragStartListener(
                      key: ValueKey('$index-${commands[index]}'),
                      index: index,
                      child: Padding(
                      padding: EdgeInsets.all(8.0 * scaleFactor),
                      child: GestureDetector(
                        onTap : (){
                          removeComand(index);
                        },
                        child :  Image.asset(
                        _getImagePath(commands[index]),
                        width: 30 * scaleFactor,
                        height: 30 * scaleFactor,
                      ),
                      )
                      
                     
                    )
                      );
                    
                  },
                ),
              );
            },
          ),
          Container(
            width: 330* scaleFactor,
            decoration: BoxDecoration(
              color: Color(0xffFFF2DF),
              borderRadius: BorderRadius.circular(10 * scaleFactor),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10 * scaleFactor),
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder<catState>(
                valueListenable: game.catStateNotifier, 
                builder: (context, state, child){
                  final playImage = AppImages.play;
                  final paused = AppImages.pause;
                  if(state==catState.loading) {
                    return _cmdBtn(paused, Color(0xffFFC400), () => game.pauseGame(), scaleFactor, 6);
                    
                  } else if( state==catState.paused){
                    return _cmdBtn(playImage, Color(0xffFFC400), () => game.resumeGame(), scaleFactor, 6);
                  }else {
                    return _cmdBtn(playImage, Color(0xffFFC400), () => game.runGame(), scaleFactor, 6);
                  }
                  
                }
                ),
              
              _cmdBtn(AppImages.kanan, Color(0xff73D4FF), () => game.addCommand(CatCommand.right), scaleFactor, 6),
              _cmdBtn(AppImages.kiri, Color(0xffFFCEE0), () => game.addCommand(CatCommand.left), scaleFactor, 6),
              _cmdBtn(AppImages.atas, Color(0xffFFF2B3), () => game.addCommand(CatCommand.up), scaleFactor, 6),
              _cmdBtn(AppImages.bawah, Color(0xffBCBEFF), () => game.addCommand(CatCommand.down), scaleFactor, 6),
              ValueListenableBuilder<bool>(
              valueListenable: game.subNotifier, 
              builder: (context, isSubActive, child){
                final subImage = isSubActive ? AppImages.subDisabled : AppImages.sub;
                return _cmdBtn(subImage, Color(0xffFFF2DF), () => game.toggleSub(), scaleFactor, 16);
              }
            )
            ],
          ) ,
            )
            
            
          )
          
        ],
      ),
    );
  }

  Widget _cmdBtn(String ImagePath, Color color, VoidCallback onTap, double scaleFactor, double padding) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 55 * scaleFactor,
        height: 55 * scaleFactor,
        padding: EdgeInsets.all(padding * scaleFactor),
        decoration: BoxDecoration(
          color: color,
          
        ),
        child: Image.asset(
          ImagePath,
          width: 30 * scaleFactor,
          height: 30 * scaleFactor,
        ),
      ),
    );
  }

  String _getImagePath(CatCommand cmd) {
    switch (cmd) {
      case CatCommand.up: return AppImages.atas;
      case CatCommand.down: return AppImages.bawah;
      case CatCommand.left: return AppImages.kiri;
      case CatCommand.right: return AppImages.kanan;
    }
  }
  

  

 
}