import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

final volumeProvider = StateNotifierProvider<VolumeNotifier, double>((ref){
  return VolumeNotifier();
});

class VolumeNotifier extends StateNotifier<double>{
  VolumeNotifier():super(50.0){
    _loadVolume();
  }
  //load volume awal
  Future<void> _loadVolume() async{
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getDouble('volume')??50.0 ;
  }

  //volume baru
  Future<void>setVolume(double newVolume) async{
    state = newVolume;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('volume', newVolume);


  }


}

final musicProvider = StateNotifierProvider<MusicNotifier, double>((ref){
  return MusicNotifier();
});

class MusicNotifier extends StateNotifier<double>{
  MusicNotifier():super(50.0){
    _loadMusic();
  }

  Future<void>_loadMusic() async{
    final prefsMusic = await SharedPreferences.getInstance();
    state = prefsMusic.getDouble('music')?? 50.0;
  }

  Future<void>setMusic(double newMusicVolume) async{
    state = newMusicVolume;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('music', newMusicVolume);
  }
}