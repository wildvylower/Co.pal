import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:copal/services/auth_service.dart';

class AuthNotifier extends ChangeNotifier{
  AuthNotifier(){
    Supabase.instance.client.auth.onAuthStateChange.listen((data){
      notifyListeners();
    });
  }
}

final userProfileProvider =  StateNotifierProvider<UserProfileNotifier, Map<String, dynamic>?>((ref){
  return UserProfileNotifier();
  
});

class UserProfileNotifier extends StateNotifier<Map<String, dynamic>?>{
  UserProfileNotifier() : super(null){
    loadProfile();
    Supabase.instance.client.auth.onAuthStateChange.listen((data){
      final event = data.event;
      if(event == AuthChangeEvent.signedIn){
        loadProfile();
      } else if(event == AuthChangeEvent.signedOut){
        state = null;
      }
    });
  }

  
Future<void> loadProfile() async{
  final profile = await AuthService.getProfile();
  state = profile;
}

Future<void> updateProfile({required String newName, String? newPhotoUrl}) async{
  final updatedProfile = await AuthService.updateProfile(newName: newName, newPhotoUrl: newPhotoUrl);
  if(updatedProfile != null){
    state = updatedProfile;
  }
}
}



