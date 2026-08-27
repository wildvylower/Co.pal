import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:copal/providers/auth_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'dart:async';
import 'dart:math';
import 'package:copal/Screen/Levels/LevelTemplate.dart';
import 'package:copal/data/level.dart';
import 'package:go_router/go_router.dart';
import 'package:copal/constants/images.dart';
import 'package:copal/services/pet_service.dart';
import 'package:copal/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:copal/providers/settings_provider.dart';
import 'package:copal/utils/scale_helper.dart';
import 'package:another_xlider/another_xlider.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Settings extends ConsumerStatefulWidget{
  const Settings({super.key});
  @override
  ConsumerState<Settings>createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings>{
  Map<String, dynamic>? _profileData;
  bool _isLoading = true;
  String? _imageUrl;
  final TextEditingController _nameController = TextEditingController();
  bool _isEdit = false;
  final FocusNode _nameFocusNode = FocusNode();
  XFile? _selectedFile;


  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile()async{
    final profile = ref.read(userProfileProvider);
 
    if(mounted){
      setState((){
        final profilePict = profile?['profile_pict'];
        if(profilePict!=null && profilePict.isNotEmpty){
          _imageUrl = Supabase.instance.client.storage.from("profile_pict").getPublicUrl(profilePict);
        }
         final fullName = (profile?['name'] ?? 'User') as String?;
         if(fullName!= null){
          _nameController.text = fullName;
        }
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
   
  }

  @override
  Widget build(BuildContext context) {

    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final paddingScale = isMobile ? 10.0 : (isTablet ? 40.0 : 60.0);

    final double scaleFactor = getGlobalScale(context);
    
    final profile = ref.watch(userProfileProvider);

    final fullName = (profile?['name'] ?? profile?['full_name']) as String?;
    
    final firstLetter = (fullName != null && fullName.trim().isNotEmpty) ? 
        fullName.trim().substring(0,1).toUpperCase() : 'U';

    return LayoutBuilder(builder: (context, constraints){
    return Container(
      padding: EdgeInsets.all(paddingScale),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xffF1D782),
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Color(0xffBD7D4F),
            width: 6 * scaleFactor
          )
          
        )
      ),
      child: SafeArea(child:
      SingleChildScrollView(
         child: Column(
        spacing: 20 * scaleFactor,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: ResizeImage(const AssetImage(AppImages.setting), width: 800),
                fit: BoxFit.fill,
              )),
              width: 361 * scaleFactor,
              height: 75 * scaleFactor,
              alignment: Alignment.center,
              child: Text('Pengaturan', 
            style: GoogleFonts.poppins(
            fontSize: 24 * scaleFactor,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          ),
          ),

          Row(
            spacing: 20 * scaleFactor,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
            
             Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
              width: 100 * scaleFactor,
              height: 100 * scaleFactor,
              decoration: BoxDecoration(
                color : (_selectedFile == null && _imageUrl == null  )? const Color(0xffFFCEE0) : Colors.transparent,
                image : _selectedFile != null ? DecorationImage(
                  image : kIsWeb 
                      ? NetworkImage(_selectedFile!.path) as ImageProvider
                      : FileImage(File(_selectedFile!.path)) as ImageProvider,
                  fit: BoxFit.cover,
                ) :
                _imageUrl != null ? DecorationImage(
                  image : NetworkImage(_imageUrl!),
                  fit: BoxFit.cover,
                  
                ) : null,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color : const Color(0xffBD7D4F),
                  width: 2
                )

              ),
              child: (_selectedFile==null && _imageUrl == null) ? Center(
                child: Text(firstLetter, 
                style: TextStyle(
                  color: const Color(0xffFF72A6),
                  fontSize: 32 * scaleFactor
                ),),
              ) : null
              
            ),
            Positioned(
              right : -5 * scaleFactor,
              bottom : -5 * scaleFactor,
              child: IconButton(
                onPressed: () async{
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  if(pickedFile != null){
                    setState((){
                      _selectedFile = pickedFile;
                      _imageUrl = null;
                    });
                  }
                  
                },
              icon: FaIcon(FontAwesomeIcons.camera,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 20 * scaleFactor,),
              style: IconButton.styleFrom(
                backgroundColor : const Color(0xffBD7D4F),
                shape : const CircleBorder(),
                padding: EdgeInsets.all(15 * scaleFactor),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),

              )
              
            )
            
              ],
            ),
            Expanded(
              child: 
              Form(
              child: TextFormField(
                controller: _nameController,
                focusNode: _nameFocusNode,
                readOnly: !_isEdit,
                style: TextStyle(
                  fontSize: 18 * scaleFactor,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xffFFF6C7),
                  suffixIcon: IconButton(
                  onPressed: (){
                    setState(() {
                      _isEdit =!_isEdit;
                      if (_isEdit) {
                        _nameFocusNode.requestFocus();
                      }
                    });
                  }, 
                  icon: FaIcon(FontAwesomeIcons.pen,
                  color: Color(0xffC5844C),
                  size: 14 * scaleFactor)
                  ),
                    border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10 * scaleFactor,
                          vertical: 6 * scaleFactor,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                  )

                
              
              
              )
              ),

            ),

          ],),
          Container(
            decoration: BoxDecoration(
              color : Color(0xffFFFDF0),
              borderRadius: BorderRadius.circular(10 * scaleFactor)
            ),
            padding: EdgeInsets.symmetric(horizontal: 20 * scaleFactor, vertical: 10 * scaleFactor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 Row(
            spacing: 2 * scaleFactor,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Text('Suara',
              style: TextStyle(
                fontSize: 18 * scaleFactor,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              )
              ),
              SizedBox(width: 10 * scaleFactor,),
              Expanded(
                child:  FlutterSlider(
                values: [ref.watch(volumeProvider)],
                min: 0.0,
                max: 100.0,
                handlerHeight: 36*scaleFactor,
                trackBar: FlutterSliderTrackBar(
                  activeTrackBar: BoxDecoration(
                    color: Color(0xff50B3DD),
                    borderRadius: BorderRadius.circular(10 * scaleFactor)
                  ),
                  inactiveTrackBar: BoxDecoration(
                    color:Color(0xffC5844C),
                     borderRadius: BorderRadius.circular(10 * scaleFactor)
                  ),
                  activeTrackBarHeight: 30 * scaleFactor,
                  inactiveTrackBarHeight: 30 * scaleFactor
                ),
                handler: FlutterSliderHandler(
                  decoration: BoxDecoration(

                  ),
                  child: Container(
                    height: 36 * scaleFactor,
                    width: 40 * scaleFactor,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color : Color(0xffFFEB88),
                      borderRadius: BorderRadius.circular(10 * scaleFactor)
                    ),
                    child: FaIcon(FontAwesomeIcons.volumeHigh,
                    size: 14 * scaleFactor,
                    color: Color(0xffC5844C)),
                  )
                ),
                onDragging: (handlerIndex, lowerValue, upperValue){
                  ref.read(volumeProvider.notifier).setVolume(lowerValue);
                },
                
              )
              )
             
          ],),
           Row(
            spacing: 2 * scaleFactor,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Text('Musik',
              style: TextStyle(
                fontSize: 18 * scaleFactor,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              )
              ),
              SizedBox(width: 10 * scaleFactor,),
              Expanded(
                child:  FlutterSlider(
                values: [ref.watch(musicProvider)],
                min: 0.0,
                max: 100.0,
                handlerHeight: 36*scaleFactor,
                trackBar: FlutterSliderTrackBar(
                  activeTrackBar: BoxDecoration(
                    color: Color(0xff50B3DD),
                    borderRadius: BorderRadius.circular(10 * scaleFactor)
                  ),
                  inactiveTrackBar: BoxDecoration(
                    color:Color(0xffC5844C),
                     borderRadius: BorderRadius.circular(10 * scaleFactor)
                  ),
                  activeTrackBarHeight: 30 * scaleFactor,
                  inactiveTrackBarHeight: 30 * scaleFactor
                ),
                handler: FlutterSliderHandler(
                  decoration: BoxDecoration(

                  ),
                  child: Container(
                    height: 36 * scaleFactor,
                    width: 40 * scaleFactor,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color : Color(0xffFFEB88),
                      borderRadius: BorderRadius.circular(10 * scaleFactor)
                    ),
                    child: FaIcon(FontAwesomeIcons.volumeHigh,
                    size: 14 * scaleFactor,
                    color: Color(0xffC5844C)),
                  )
                ),
                onDragging: (handlerIndex, lowerValue, upperValue){
                  ref.read(musicProvider.notifier).setMusic(lowerValue);
                },
                
              )
              )
             
          ],),

            ],)
          ),

          //button
          Row(
            spacing: 10 * scaleFactor,
            children: [
            Expanded(child: 
            TextButton.icon(
            onPressed: (){
              AuthService.logout();
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20 * scaleFactor, vertical: 10 * scaleFactor),
              backgroundColor: Color(0xffB24343),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10 * scaleFactor)
              )
            ), 
            icon: FaIcon(FontAwesomeIcons.rightFromBracket,
            color: Theme.of(context).colorScheme.onPrimary),
            label: Text(
              'Keluar',
              style: TextStyle(
                fontSize: 16 * scaleFactor,
                color: Theme.of(context).colorScheme.onPrimary
              ),
            ),
            ),),

             Expanded(child:TextButton(
            onPressed: () async {
              String? urlPhoto;
              if(_selectedFile != null){
                urlPhoto = await AuthService.uploadProfilePict(_selectedFile!);
              }
              await ref.read(userProfileProvider.notifier).updateProfile(
                newName: _nameController.text,
                newPhotoUrl: urlPhoto,
              );
              if (context.mounted) {
                Navigator.of(context).pop(); // Close drawer
              }
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20 * scaleFactor, vertical: 10 * scaleFactor),
              backgroundColor: Color(0xff0086DC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10 * scaleFactor)
              )
            ), 
           child: Text(
              'Simpan',
              style: TextStyle(
                fontSize: 16 * scaleFactor,
                color: Theme.of(context).colorScheme.onPrimary
              ),
            ),
            ))
            
            
          ],)
          
         
          
      
      
      ],),
      )
   
      )
        
    );
    }
    );
  }
}