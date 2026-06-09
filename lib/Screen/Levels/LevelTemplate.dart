import 'package:copal/Screen/Levels/popup/popupVocab.dart';
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

enum CatCommand { up, down, left, right }
enum catState {start, loading, finished}

class LevelTemplate extends FlameGame {
  final Level level;
  LevelTemplate({required this.level});

  late Vector2 catStartPosition;
  late Vector2 targetPosition;
  late SpriteComponent cat;
  final ValueNotifier<List<CatCommand>> commandListNotifier = ValueNotifier([]);
  final ValueNotifier<bool> subNotifier =  ValueNotifier(false);
  final Component subContainer = Component();

  final ValueNotifier<bool> soundNotifier = ValueNotifier(false);
  bool isMoving = false;

  final ValueNotifier<catState> catStateNotifier = ValueNotifier(catState.start);

  final ValueNotifier<bool> finishNotifier = ValueNotifier(false);
  final double tileSize = 90;

  @override
  Color backgroundColor() => const Color(0xffFFF2B3);

  @override
  Future<void> onLoad() async {
    final levelMap = await TiledComponent.load(level.tileMapPath, Vector2.all(tileSize));
    add(levelMap);

    camera = CameraComponent.withFixedResolution(
      width: tileSize * 10,
      height: tileSize * 4,
    );
    camera.viewfinder.anchor = Anchor.topLeft;

    cat = SpriteComponent()
      ..sprite = await loadSprite(level.Sprite)
      ..size = Vector2.all(tileSize * 0.5)
      ..position = Vector2((level.catStartPosition.x * tileSize), (level.catStartPosition.y * tileSize));
    add(cat);

    catStartPosition = cat.position.clone();
  }

  void addCommand(CatCommand cmd) {
    if (catStateNotifier.value == catState.start) {
      commandListNotifier.value = [...commandListNotifier.value, cmd];
    }
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
      cat.position =  catStartPosition.clone();
      commandListNotifier.value = [];
      catStateNotifier.value = catState.start;
      finishNotifier.value = false;
      return;
    }

    if(catStateNotifier.value == catState.loading || commandListNotifier.value.isEmpty){
      return;

    }

    catStateNotifier.value = catState.loading;
    final currentCommands = List<CatCommand>.from(commandListNotifier.value);
    for (var cmd in currentCommands) {
      await moveCat(cmd);
      await Future.delayed(const Duration(milliseconds: 600));
    }
    
    
    checkFinish();
    catStateNotifier.value = catState.finished;
    
  }

  void checkFinish(){
    final catX = (cat.position.x / tileSize).round();
    final catY = (cat.position.y / tileSize).round();

    if(catX == level.targetFinish.x && catY == level.targetFinish.y){
      finishNotifier.value = true;
    }

  }

  Future<void> moveCat(CatCommand cmd) async {
    Vector2 delta = Vector2.zero();
    switch (cmd) {
      case CatCommand.up: delta = Vector2(0, -tileSize); break;
      case CatCommand.down: delta = Vector2(0, tileSize); break;
      case CatCommand.left: delta = Vector2(-tileSize, 0); break;
      case CatCommand.right: delta = Vector2(tileSize, 0); break;
    }
    cat.add(MoveByEffect(delta, EffectController(duration: 0.5)));
  }
}



class LevelOneScreen extends StatefulWidget {
  final Level level;
  const LevelOneScreen({Key? key, required this.level}) : super(key: key);

  @override
  State<LevelOneScreen> createState() => _LevelOneScreenState();
}

class _LevelOneScreenState extends State<LevelOneScreen> {
  late LevelTemplate _game;

  @override
  void initState() {
    super.initState();
    _game = LevelTemplate(level: widget.level);
    _game.catStateNotifier.addListener(_onFinish);
  }

  void _onFinish(){

    if(_game.catStateNotifier.value == catState.finished){
      if(_game.finishNotifier.value == true){
        showDialog(context: context, builder: (_) => Dialog(
          backgroundColor: Colors.transparent,
          child: PopupVocab(level : widget.level)
      ),
      barrierColor: const Color.fromARGB(140, 0, 0, 0),
      barrierDismissible: true
      );
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
  

  @override 
  void dispose(){
    _game.finishNotifier.removeListener(_onFinish);
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
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 10 * scaleFactor),
                  itemCount: commands.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(8.0 * scaleFactor),
                      child: Image.asset(
                        _getImagePath(commands[index]),
                        width: 30 * scaleFactor,
                        height: 30 * scaleFactor,
                      ),
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
                  final playImage = 'assets/images/play.png';
                  return _cmdBtn(playImage, Color(0xffFFC400), () => game.runGame(), scaleFactor, 6);
                }
                ),
              
              _cmdBtn('assets/images/kanan.png', Color(0xff73D4FF), () => game.addCommand(CatCommand.right), scaleFactor, 6),
              _cmdBtn('assets/images/kiri.png', Color(0xffFFCEE0), () => game.addCommand(CatCommand.left), scaleFactor, 6),
              _cmdBtn('assets/images/atas.png', Color(0xffFFF2B3), () => game.addCommand(CatCommand.up), scaleFactor, 6),
              _cmdBtn('assets/images/bawah.png', Color(0xffBCBEFF), () => game.addCommand(CatCommand.down), scaleFactor, 6),
              ValueListenableBuilder<bool>(
              valueListenable: game.subNotifier, 
              builder: (context, isSubActive, child){
                final subImage = isSubActive ? "assets/images/sub_disabled.png" : "assets/images/sub.png";
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
      case CatCommand.up: return 'assets/images/atas.png';
      case CatCommand.down: return 'assets/images/bawah.png';
      case CatCommand.left: return 'assets/images/kiri.png';
      case CatCommand.right: return 'assets/images/kanan.png';
    }
  }
  

  

 
}