import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final _supabase = Supabase.instance.client;

  static Future<User?> checkLogin() async {
    try {
      // await _supabase.auth.signOut(scope: SignOutScope.local);

      final session = _supabase.auth.currentSession;

      if(session==null){
        final response = await _supabase.auth.signInAnonymously();
        return response.user;
      }else{
        return session.user;
      }
    } catch(e){
         print('Auth error: $e');
         return null;
      }
  }
}