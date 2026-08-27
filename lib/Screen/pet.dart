import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'dart:async';
import 'package:copal/Screen/Levels/LevelTemplate.dart';
import 'package:copal/data/level.dart';
import 'package:go_router/go_router.dart';
import 'package:copal/services/pet_service.dart';
import 'package:copal/constants/images.dart';

class Pet extends StatefulWidget {
  const Pet({super.key});

  @override
  State<Pet> createState() => _PetState();
}

enum Tab { food, apparel, furniture }

class _PetState extends State<Pet> {
  int coin = 0;
  int gem = 0;
  bool isLoading = true;
  int hunger = 0;
  int mood = 0;

  Tab activeTab = Tab.food;
  List<Map<String, dynamic>> items = [];
  bool _isLoadingItems = true;
  bool _isInventory = true;

  @override
  void initState() {
    super.initState();
    _loadCoins();
    _loadItems();
  }

  Future<void> _loadCoins() async {
    final (coins: c, gems: g) = await PetService.getCoins();

    if (mounted) {
      setState(() {
        coin = c;
        gem = g;
        isLoading = false;
      });
    }
  }

  Future<void> _loadItems({bool allowRedirect = true}) async {
    setState(() {
      _isLoadingItems = true;
      items = []; // Kosongkan list item lama saat loading dimulai
    });

    final categoryName = activeTab.name;
    var data = _isInventory? await PetService.getInventory(categoryName) :
    await PetService.getItems(categoryName);
    final bool needRedirect = allowRedirect && _isInventory && 
    (data.isEmpty);

     if(needRedirect){
          data = await PetService.getItems(categoryName);
     }

    if (mounted) {
      setState(() {
        items = data??[];
        if(needRedirect){
          _isInventory = false;
        }
        
        _isLoadingItems = false;
       
      });
    }
  }
  Future<void>_updateHunger(String itemId)async{
    final categoryName = activeTab.name;
    final result  = await PetService.eatFood(category: categoryName, itemId: itemId);
    if(result.success){
      if(mounted){
        setState((){
          hunger = result.hunger;
          _loadItems();
        });
      }
    }else{
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            'Pet Sudah Kenyang',
          ),
        ),
      );
      
    }


  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final paddingScale = isMobile ? 10.0 : (isTablet ? 40.0 : 60.0);

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.pet),
              fit: BoxFit.cover,
            ),
          ),
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(
            left: paddingScale,
            top: isMobile ? 8.0 : 12.0,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;
              final availableHeight = constraints.maxHeight;
              final scaleFactor =
                  isMobile ? 1.0 : (availableWidth / 900).clamp(0.8, 1.5);
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //kiri pet
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //coin dan gem
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //row coin
                            Container(
                              width: 129 * scaleFactor,
                              height: 50 * scaleFactor,
                              padding: EdgeInsets.all(10 * scaleFactor),
                              decoration: BoxDecoration(
                                color: Color(0xffFFFCFD),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Color(0xff9B9B9B),
                                  width: 1 * scaleFactor,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    AppImages.coins,
                                    width: 20 * scaleFactor,
                                    height: 20 * scaleFactor,
                                  ),
                                  Text(
                                    isLoading ? '0' : '$coin',
                                    style: TextStyle(
                                      fontSize: 16 * scaleFactor,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //row gem
                            Container(
                              width: 120 * scaleFactor,
                              height: 50 * scaleFactor,
                              padding: EdgeInsets.all(10 * scaleFactor),
                              decoration: BoxDecoration(
                                color: Color(0xffFFFCFD),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Color(0xff9B9B9B),
                                  width: 1 * scaleFactor,
                                ),
                              ),

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    AppImages.gem,
                                    width: 20 * scaleFactor,
                                    height: 20 * scaleFactor,
                                  ),
                                  Text(
                                    isLoading ? '0' : '$gem',
                                    style: TextStyle(
                                      fontSize: 16 * scaleFactor,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),

                        Expanded(child: Image.asset(
                          AppImages.kucingIdle,
                          fit: BoxFit.contain,
                        )),
                        
                        SizedBox(height: 20 * scaleFactor),

                        //bar
                        Container(
                          width: 500 * scaleFactor,
                          height: 120 * scaleFactor,
                          padding : EdgeInsets.symmetric(horizontal: 20 * scaleFactor, vertical: 10 * scaleFactor),
                          decoration : BoxDecoration(
                            color : Color(0xffFFF2DF),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)
                              ),
                            border : Border(
                              top : BorderSide(color : Color(0xffE8B469),width: 1 * scaleFactor),
                              left : BorderSide(color : Color(0xffE8B469),width: 1 * scaleFactor),
                              right : BorderSide(color : Color(0xffE8B469),width: 1 * scaleFactor)
                            )
                          ),
                          child :Column(
                            spacing: 10 * scaleFactor,
                            children : [
                             Row(
                              spacing: 20 * scaleFactor,
                              children: [
                              Text('Mood',
                              style: TextStyle(
                                fontSize: 16 * scaleFactor,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                              Expanded(child: LinearProgressIndicator(
                                value : mood/100,
                                color : Color(0xffFF921E),
                                backgroundColor: Color(0xffFFE99F),
                                minHeight: 40 * scaleFactor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              ),
                              
                              Image.asset(AppImages.hepi,
                              width : 30 * scaleFactor,
                              height: 30 * scaleFactor,
                              )
                             ],),

                              Row(
                              spacing: 20 * scaleFactor,
                              children: [
                              Text('Energy',
                              style : TextStyle(
                                fontSize: 16 * scaleFactor,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),),
                              Expanded(child: LinearProgressIndicator(
                                value : hunger/100,
                                color : Color(0xffFFCA1E),
                                backgroundColor: Color(0xffFFE99F),
                                minHeight: 40 * scaleFactor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              ),
                              
                              Image.asset(AppImages.bolt,
                              width : 30 * scaleFactor,
                              height: 30 * scaleFactor,
                              )
                             ],)
                      ],
                    ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20 * scaleFactor),
                  //kanan items
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap : (){
                          setState((){
                            _isInventory = !_isInventory;
                          });
                          _loadItems(allowRedirect: false);
                        },
                        child : Container(
                        width: 100 * scaleFactor,
                        height: 50 * scaleFactor,
                        decoration: BoxDecoration(
                          color: Color(0xffFFFFFC),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                          border: Border(
                            top: BorderSide(
                              color: Color(0xff705050),
                              width: 1 * scaleFactor,
                            ),
                            left: BorderSide(
                              color: Color(0xff705050),
                              width: 1 * scaleFactor,
                            ),
                            bottom: BorderSide(
                              color: Color(0xff705050),
                              width: 1 * scaleFactor,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.all(10 * scaleFactor),
                        alignment: Alignment.center,
                        child: FaIcon(
                          _isInventory
                              ? FontAwesomeIcons.briefcase
                              : FontAwesomeIcons.cartShopping,
                          size: 20 * scaleFactor,
                          color: Color(0xff705050),
                        ),
                      ),

                      ),
                        Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10 * scaleFactor,
                        ),
                        child: IntrinsicHeight(
                          child:  Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              child: Column(
                                spacing: 10 * scaleFactor,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: _buildActiveTab(
                                    menuType: Tab.food,
                                    imagePath: AppImages.foods,
                                    scaleFactor: scaleFactor,
                                  ),),
                                  Expanded(child:  _buildActiveTab(
                                    menuType: Tab.apparel,
                                    imagePath: AppImages.apparel,
                                    scaleFactor: scaleFactor,
                                  )),
                                  
                                 
                                  Expanded(child: _buildActiveTab(
                                    menuType: Tab.furniture,
                                    imagePath: AppImages.furniture,
                                    scaleFactor: scaleFactor,
                                  ))
                                ],
                              ),
                            ),
                            Container(
                              width: 400 * scaleFactor,
                              height: availableHeight - 100 * scaleFactor,
                              decoration: BoxDecoration(
                                color: Color(0xffFFFFFC),
                                border: Border.all(
                                  color: Color(0xff705050),
                                  width: 2 * scaleFactor,
                                ),
                              ),
                              child: GridView.builder(
                                padding: EdgeInsets.all(10 * scaleFactor),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 4 * scaleFactor,
                                  crossAxisSpacing: 4 * scaleFactor,
                                ),
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  final item = items[index];

                                  final String imageName;
                                  final int qty;
                                  final int price;
                                  final String itemId;

                                  if (_isInventory && item['items'] != null) {
                                    final itemDetails =
                                        item['items'] as Map<String, dynamic>;
                                    imageName = itemDetails['image_name'] ?? '';
                                    qty = item['item_qty'] ?? 0;
                                    price = itemDetails['price'] ?? 0;
                                    itemId = itemDetails['id'] ?? '';
                                  } else {
                                    imageName = item['image_name'] ?? '';
                                    final List inventoryList =
                                        item['inventory'] ?? [];
                                    qty = inventoryList.isEmpty
                                        ? 0
                                        : (inventoryList.first['item_qty'] ?? 0);
                                    price = item['price'] ?? 0;
                                    itemId = item['id'] ?? '';
                                  }

                                  return Padding(
                                    padding: EdgeInsets.all(
                                      4 * scaleFactor,
                                    ),
                                    child: _isInventory
                                        ? _inventory(
                                            menuType: activeTab,
                                            image: imageName,
                                            scaleFactor: scaleFactor,
                                            qty: qty,
                                            onTap: () async {
                                              await _updateHunger(itemId);
                                            },
                                          )
                                        : _buildItemContainer(
                                            menuType: activeTab,
                                            image: imageName,
                                            scaleFactor: scaleFactor,
                                            price: price,
                                            category: activeTab.name,
                                            onTap: () async {
                                              final success =
                                                  await PetService.buyItem(
                                                itemId: itemId,
                                                price: price,
                                                category: activeTab.name,
                                                image: imageName,
                                              );
                                              if (success && mounted) {
                                                _loadCoins();
                                                _loadItems();
                                              } else if (mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Koin tidak cukup',
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        )
                       
                      ),

                    
                      
                      
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTab({
    required Tab menuType,
    required String imagePath,
    required double scaleFactor,
  }) {
    final bool isActive = activeTab == menuType;
    return GestureDetector(
      onTap: () {
        if (activeTab != menuType) {
          setState(() {
            activeTab = menuType;
          });
          _loadItems();
        }
      },
      child: Container(
        padding: EdgeInsets.all(10 * scaleFactor),
        decoration: BoxDecoration(
          color: isActive ? Color(0xffFFDE72) : Color(0xffE1A977),
          border: Border(
                         top: BorderSide(
                          color: Color(0xff705050),
                          width: 1 * scaleFactor
                         ),
                         left: BorderSide(
                          color: Color(0xff705050),
                          width: 1 * scaleFactor
                         ),
                         bottom: BorderSide(
                          color: Color(0xff705050),
                          width: 1 * scaleFactor
                         )
                        ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: Center(
          child: Image.asset(
            imagePath,
            width: 30 * scaleFactor,
            height: 30 * scaleFactor,
            color: Color(0xff6E3C19),
          ),
        ),
      ),
    );
  }

  Widget _buildItemContainer({
    required Tab menuType,
    required String image,
    required double scaleFactor,
    required int price,
    required VoidCallback onTap,
    required String category
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60 * scaleFactor,
        height: 60 * scaleFactor,
        padding: EdgeInsets.all(4 * scaleFactor),
        decoration: BoxDecoration(
          color: Color(0xffFFFAD8),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.network(
              PetService.foodImage(image),
              width: 50 * scaleFactor,
              height: 50 * scaleFactor,
            ),
            SizedBox(height: 5 * scaleFactor),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10 * scaleFactor,
              children: [
                Image.asset(AppImages.coins, width: 16 * scaleFactor),
                Text(
                  '$price',
                  style: TextStyle(
                    fontSize: 16 * scaleFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _inventory({
    required Tab menuType,
    required String image,
    required double scaleFactor,
    required int qty,
    required VoidCallback onTap
  }){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60 * scaleFactor,
        height: 60 * scaleFactor,
        padding: EdgeInsets.all(4 * scaleFactor),
        decoration: BoxDecoration(
          color: Color(0xffFFFAD8),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.network(
              PetService.foodImage(image),
              width: 50 * scaleFactor,
              height: 50 * scaleFactor,
            ),
            SizedBox(height: 5 * scaleFactor),

                Text(
                  'x $qty',
                  style: TextStyle(
                    fontSize: 16 * scaleFactor,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              
          ],
        ),
      ),
    );
    

  }
}
