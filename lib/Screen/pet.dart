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
  const Pet({Key? key}) : super(key: key);

  @override
  State<Pet> createState() => _PetState();
}

enum Tab {food, apparel, furniture}

class _PetState extends State<Pet> {
  int coin = 0;
  int gem = 0;
  bool isLoading = true;

  Tab activeTab = Tab.food;
  List<Map<String, dynamic>> items = [];
  bool _isLoadingItems = true;

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

  Future<void> _loadItems() async{
    setState((){
      _isLoadingItems = true;
    });

    final categoryName = activeTab.name;
    final data = await PetService.getItems(categoryName);

    if(mounted){
      setState((){
        items = data;
        _isLoadingItems = false;
      });
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
            bottom : isMobile ? 8.0 : 12.0,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //coin dan gem
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //row coin
                                Container(
                                  width: 150* scaleFactor,
                                  height: 50 * scaleFactor,
                                  padding : EdgeInsets.all( 10 * scaleFactor),
                                  decoration: BoxDecoration(
                                    color : Color(0xffFFFCFD),
                                    borderRadius: BorderRadius.circular(20),
                                    border : Border.all(
                                      color : Color(0xff9B9B9B),
                                      width : 1 * scaleFactor,
                                    )
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
                                   width: 150* scaleFactor,
                                  height: 50 * scaleFactor,
                                  padding : EdgeInsets.all( 10 * scaleFactor),
                                  decoration: BoxDecoration(
                                    color : Color(0xffFFFCFD),
                                    borderRadius: BorderRadius.circular(20),
                                    border : Border.all(
                                      color : Color(0xff9B9B9B),
                                      width : 1 * scaleFactor,
                                    )
                                  ),

                                  child : Row(
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
                                )
                                
                              ],
                            ),

                            SizedBox(height: 40 * scaleFactor,),
                            Image.asset(AppImages.kucingIdle,
                            height: 200*scaleFactor,),
                            SizedBox(height: 40 * scaleFactor,),

                          ],
                        
                    ),
                  ),
                  SizedBox(width: 20 * scaleFactor,),
                  //kanan items
                  Padding(
                    padding: EdgeInsets.symmetric(vertical : 50 * scaleFactor),
                    child :  Column(
                    children: [
                      Row(
                        children : [
                          Container(
                            height: availableHeight - 100 * scaleFactor,
                            child : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildActiveTab(menuType: Tab.food, imagePath: AppImages.foods, scaleFactor: scaleFactor),
                              _buildActiveTab(menuType: Tab.apparel, imagePath: AppImages.apparel, scaleFactor: scaleFactor),
                              _buildActiveTab(menuType: Tab.furniture, imagePath: AppImages.furniture, scaleFactor: scaleFactor),

                          ],),

                          ),

                          


                          Container(
                          width: 400 * scaleFactor,
                          height: availableHeight - 100 * scaleFactor,
                          decoration : BoxDecoration(
                            color : Color(0xffFFFFFC),
                            border : Border.all(
                              color : Color(0xff705050),
                              width : 2 * scaleFactor,
                            ),
                          ),
                          child: GridView.builder(
                            padding: EdgeInsets.all(10 * scaleFactor),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3 , mainAxisSpacing: 4 *scaleFactor , crossAxisSpacing: 4 *scaleFactor) , itemCount: items.length, itemBuilder: (context, index){
                              final item = items[index];
                              final String imageName = item['image_name'];
                              final List inventoryList = item['inventory']?? [];
                              final int qty = inventoryList.isEmpty ? 0 : (inventoryList.first['item_qty'] ?? 0);
                              final int price = item['price'];

                              
                              return Padding(
                                padding: EdgeInsets.all(4 * scaleFactor),
                                child: _buildItemContainer(
                                  menuType: activeTab,
                                  image: imageName,
                                  scaleFactor: scaleFactor,
                                  qty :qty,
                                  price :price,
                                  onTap : ()async{
                                    final success = await PetService.buyItem(itemId: item['id'], price: price, currentQty: qty);
                                    if(success && mounted){
                                      _loadCoins();
                                      _loadItems();
                                    }else if(mounted){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content : Text('Koin tidak cukup'),
                                        )
                                      );
                                    }
                                    
                                  }
                                )
                              );
                            })
                        )

                        ]
                      )
                      
                    ],
                  )
                  )
                  
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
    required double scaleFactor
  }){
    final bool isActive = activeTab == menuType;
    return GestureDetector(
      onTap: (){
        if(activeTab != menuType){
          setState((){
            activeTab = menuType;
          });
          _loadItems();
        }

      },
      child: Container(
          width: 50 * scaleFactor,
          height: 100 * scaleFactor,
          padding: EdgeInsets.all(10 * scaleFactor),
          decoration : BoxDecoration(
            color : isActive ? Color(0xffFFDE72) : Color(0xffE1A977),
            border : Border.all(
              color :  Color(0xff705050),
              width : 2 * scaleFactor,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            )
          ),
          child: Center(
            child: Image.asset(
              imagePath,
              width: 30 * scaleFactor,
              height: 30 * scaleFactor,
              color: Color(0xff6E3C19),
              
            ),
          )

      )
    );

  }

  Widget _buildItemContainer({
    required Tab menuType,
    required String image,
    required double scaleFactor,
    required int qty,
    required int price,
    required VoidCallback onTap
  }){
    return GestureDetector(
      onTap : onTap,
      child : Container(
      width : 60 * scaleFactor,
      height: 60 * scaleFactor,
      padding: EdgeInsets.all(4 * scaleFactor),
      decoration : BoxDecoration(
        color : Color(0xffFFFAD8),
        borderRadius: BorderRadius.all(Radius.circular(4)),
       
      ),
      child : 
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        if(qty > 0)
        Align(
          alignment: Alignment.topLeft,
          child : Text('X $qty',
        style: TextStyle(
          fontSize: 16 * scaleFactor,
          color: Colors.black,
        ),
        ),
        ),
        
        Image.network(PetService.foodImage(image),
        width : 50 * scaleFactor,
        height:  50 * scaleFactor,
        ),
        SizedBox(height: 5 * scaleFactor,),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10 * scaleFactor,
          children: [
            Image.asset(AppImages.coins, width : 16 * scaleFactor),
             Text('$price',
              style: TextStyle(
                fontSize: 16 * scaleFactor,
                color: Colors.black,
                fontWeight: FontWeight.bold
              ),
              ) 
          ],
        )
       
      ],)
      
    )
    );
    
  }
}
