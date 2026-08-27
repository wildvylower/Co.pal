import 'package:supabase_flutter/supabase_flutter.dart';

class PetService {
  static final _supabase = Supabase.instance.client;

  static String foodImage(String fileName) {
    return _supabase.storage.from('foods').getPublicUrl(fileName);
  }

  static Future<({int coins, int gems})> getCoins() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return (coins: 0, gems: 0);

      final rawData = await _supabase
          .from('profiles')
          .select('coins, gems')
          .eq('id', user.id)
          .limit(1);
      final data = rawData.isEmpty ? null : rawData.first;
      print("coins : $data");

      if (data != null) {
        final coins = (data['coins'] ?? 0) as int;
        final gems = (data['gems'] ?? 0) as int;
        return (coins: coins, gems: gems);
      }
    } catch (e) {
      print('Error fetching coins: $e');
    }
    return (coins: 0, gems: 0);
  }

  static Future<List<Map<String, dynamic>>> getItems(String category) async {
    try {
      final response = await _supabase
          .from('items')
          .select('*')
          .eq('category', category);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching my items: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getInventory(
    String category,
  ) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return [];

      final response = await _supabase
          .from('inventory')
          .select('item_qty, items!inner(*)')
          .eq('user_id', user.id)
          .eq('items.category', category);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching inventory: $e');
      return [];
    }
  }

  static Future<bool> buyItem({
    required String itemId,
    required int price,
    required String category,
    required String image,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;
      final rawProfilData = await _supabase
          .from('profiles')
          .select('coins')
          .eq('id', user.id)
          .limit(1);
      final profilData = rawProfilData.isEmpty ? null : rawProfilData.first;
      if (profilData == null) {
        return false;
      }
      final int userCoins = profilData['coins'] ?? 0;
      if (userCoins < price) {
        // Coin tidak cukup
        return false;
      }

      // Cek apakah item sudah ada di inventory langsung dari database (menggunakan List untuk keamanan jika ada duplikat)
      final List<Map<String, dynamic>> response = await _supabase
          .from('inventory')
          .select('item_qty')
          .eq('user_id', user.id)
          .eq('item_id', itemId);

      final Map<String, dynamic>? inventoryData =
          response.isEmpty ? null : response.first;

      // Potong koin user
      await _supabase
          .from('profiles')
          .update({'coins': userCoins - price})
          .eq('id', user.id);

      // Tentukan insert atau update berdasarkan data asli database
      if (inventoryData == null) {
        await _supabase.from('inventory').insert({
          'user_id': user.id,
          'item_id': itemId,
          'item_qty': 1,
          'item_type': category,
          'image_name': image,
        });
      } else {
        final int currentQty = inventoryData['item_qty'] ?? 0;
        await _supabase
            .from('inventory')
            .update({'item_qty': currentQty + 1})
            .eq('user_id', user.id)
            .eq('item_id', itemId);
      }
      return true;
    } catch (e) {
      print('error $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getPetStatus() async{
    try{
      final user = _supabase.auth.currentUser;
      if(user == null) return null;

      final rawResponse = await _supabase.from('pet_state').select('*').eq('id',user.id).limit(1);
      final response = rawResponse.isEmpty ? null : rawResponse.first;
      return response;
    }catch (e) {
      print('Error fetching my items: $e');
      return null;
    }
  }

  static Future<({int hunger, bool success})> eatFood({required String category,required String itemId}) async{
    try{
      final user = _supabase.auth.currentUser;
      if (user == null) return (hunger : 0, success: false);
      final petState = await getPetStatus();
      if(petState == null) return (hunger : 0, success: false);
      final int hunger = petState['hunger'] ?? 0;
      final rawItemData = await _supabase.from('items').select('energy, inventory!inner(item_qty)').eq('id', itemId).eq('inventory.user_id', user.id).limit(1);
      final itemData = rawItemData.isEmpty ? null : rawItemData.first;
      final int energy = itemData?['energy'] ?? 0;
      final List inventoryList = itemData?['inventory']??[];
      final int qtyItem = inventoryList.isEmpty ? 0 : inventoryList.first['item_qty']?? 0;

      
      if(hunger < 100){
        final int updateHunger = (hunger + energy).clamp(0,100);
        await _supabase.from('pet_state').update({'hunger' : updateHunger}).eq('id',user.id);
        if(qtyItem > 1){
          
        await _supabase.from('inventory').update({'item_qty' : qtyItem-1}).eq('user_id', user.id). eq('item_id', itemId);
        }else{
          await _supabase.from('inventory').delete().eq('user_id', user.id).eq('item_id', itemId);
        }
        return (hunger : updateHunger, success: true);
      } else {
        return (hunger : 100 , success: false);

      }


      
    }catch (e) {
      print('Error fetching my items: $e');
      return (hunger: 0, success:false);
    }
   


  }
}


