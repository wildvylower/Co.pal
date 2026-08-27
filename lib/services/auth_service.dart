import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AuthService {
  static final _supabase = Supabase.instance.client;

  static Future<User?> checkLogin() async {
    try {
      // await _supabase.auth.signOut(scope: SignOutScope.local);

      final session = _supabase.auth.currentSession;

      
        return session?.user;
      
    } catch(e){
         print('Auth error: $e');
         return null;
      }
  }

  static Future<void>loginGoogle() async{
    await _supabase.auth.signInWithOAuth(OAuthProvider('google'));
  }

  static Future<void>logout() async{
    await _supabase.auth.signOut();
  }

  static Future<void>loginEmail(String email, password )async{
    await _supabase.auth.signInWithPassword(password: password, email: email);
  }

  static Future<void>signUpEmail(String email, password, nama) async {
    await _supabase.auth.signUp(
      password: password,
      email: email,
      data: {'full_name': nama},
    );
  }
 
 static Future<Map<String, dynamic>?> getProfile([String? id]) async{
 
   try {
    final user = _supabase.auth.currentUser;
    final id = user?.id;
    if (id == null) return null;
    final response = await _supabase.from('profiles').select('*').eq('id', id).limit(1);
    return response.isEmpty ? null : response.first;
   } catch (e) {
    print('Error fetching profile: $e');
    return null; 
   }
 }

 static Future<Map<String, dynamic>?> updateProfile({required String newName, String? newPhotoUrl}) async {
  try{
    final user = _supabase.auth.currentUser;
    final id = user?.id;
    if(id == null) return null;
    final response = await _supabase.from('profiles').update({
      'name': newName,
      if(newPhotoUrl != null) 'profile_pict' : newPhotoUrl
    }).eq('id', id).select().limit(1);
    return response.isEmpty ? null : response.first;
  }catch(e){
    print('Error updating profile : $e');
    return null;
  }
 }

 static Future<String?> uploadProfilePict(XFile imageFile) async{
  try{
    final user = _supabase.auth.currentUser;
    final id = user?.id;
    if(id==null) return null;
    final fileName = '$id/profile_${DateTime.now().millisecondsSinceEpoch}.png';
    final bytes= await imageFile.readAsBytes();
    await _supabase.storage.from('profile_pict').uploadBinary(
      fileName, 
      bytes, 
      fileOptions: const FileOptions(upsert: true)
      );
      return fileName;
  } catch(e){
    print('error uploading image : $e');
    return null;
  }
 }

}