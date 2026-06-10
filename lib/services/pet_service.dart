import 'package:supabase_flutter/supabase_flutter.dart';

class PetService {
  static final _supabase = Supabase.instance.client;

  static String foodImage(String fileName){
   return _supabase.storage.from('foods').getPublicUrl(fileName);

  }

  static Future<({int coins, int gems})> getCoins() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return (coins: 0, gems: 0);
      
      final data = await _supabase
          .from('profiles') 
          .select('coins, gems')
          .eq('id', user.id)
          .maybeSingle();

      print("coins : $data");

      if (data != null) {
        final coins = (data['coins']??0) as int;
        final gems = (data['gems']?? 0)as int;
        return (coins : coins, gems: gems);
      }
    } catch (e) {
      print('Error fetching coins: $e');
    }
    return (coins: 0, gems: 0);
  }

  static Future<List<Map<String, dynamic>>> getItems(String category) async {
    try {
      final user = _supabase.auth.currentUser;
      if(user ==null) return[];
      final response = await _supabase.
      from('items').select('*, inventory(item_qty)').eq('category', category).eq('inventory.user_id', user.id);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching my items: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getInventory(String category) async{
    try{
      final user = _supabase.auth.currentUser;
      if(user ==null) return[];

      final response = await _supabase.from('inventory').select('item_qty, items!inner(*)').eq('user_id', user.id).eq('items.category', category);
      return List<Map<String, dynamic>>.from(response);
    }catch(e){
      print('Error fetching inventory: $e');
      return [];
    }
  }

  static Future<bool> buyItem({
    required String itemId,
    required int price,
    required int currentQty
  }
  )async{
    try{
      final user = _supabase.auth.currentUser;
      if(user ==null) return false;
      final profilData = await _supabase.from('profiles').select('coins').eq('id',user.id).maybeSingle();
      if(profilData == null){
        return false;
      }
      final int userCoins = profilData['coins'] ?? 0;
      if(userCoins<price){
        return false;
      }
      await _supabase.from('profiles').update({'coins' : userCoins - price}).eq('id', user.id);
      if(currentQty == 0){
        await _supabase.from('inventory').insert({
          'user_id':user.id,
          'item_id':itemId,
          'item_qty':1
          });
      }else{
        await _supabase.from('inventory').update({'item_qty':currentQty +1}).eq('user_id', user.id).eq('item_id', itemId);
      }
      return true;
    }catch(e){
      print('error $e');
      return false;
    }

  }
  
}