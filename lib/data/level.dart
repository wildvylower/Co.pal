import 'package:flutter/material.dart';
import 'package:flame/components.dart';

class Level {
  final int id_story;
  final Alignment mapPosition;
  final int id;
  final String title;
  final String difficulty;
  final String tileMapPath;
  final Vector2 catStartPosition;
  final Vector2 targetFinish;
  final String Sprite;
  final bool isLocked;
  final String vocab;
  final String vocabImage;
  final List<Vector2> subTiles;
  final int maksComand ; 
  final int itemAmount;
  final String? rewardImage;
  final List<Vector2> ujung;
  final int star;


  const Level({
    required this.id_story,
    required this.mapPosition,
    required this.id,
    required this.title,
    required this.difficulty,
    required this.tileMapPath,
    required this.catStartPosition,
    required this.targetFinish,
    required this.Sprite,
    this.isLocked = false,
    required this.vocab,
    required this.vocabImage,
    required this.subTiles,
    this.maksComand = 0,
    this.itemAmount = 0,
    this.rewardImage,
    this.ujung = const [],
    this.star = 0

  });
}

// Daftar semua level
//1
final List<Level> allLevels = [
  Level(
    id_story: 1,
    mapPosition: Alignment(-0.78, 0.22),
    id: 1,
    title: 'Pesta Ulang Tahun Beri',
    difficulty: 'Pemula',
    tileMapPath: 'lvl1Fix.tmx',
    catStartPosition: Vector2(0,2),
    targetFinish: Vector2(5,2),
    Sprite: 'kucing_Idle_Samping.png',
    isLocked: false,
    vocab: 'TELUR',
    vocabImage: 'assets/images/telur.png',
    maksComand : 5,
    subTiles: [
      Vector2(1,2),
      Vector2(2,2),
      Vector2(3,2),
      Vector2(4,2),
      Vector2(5,2)
    ],
    ujung: [
      Vector2(5,2)
    ],
    star: 0
  ),

  //2
  Level(
    id_story: 1,
    mapPosition: Alignment(-0.36, -0.15),
    id: 2,
    title: 'Pesta Ulang Tahun Beri',
    difficulty: 'Pemula',
    tileMapPath: 'lvl2.tmx',
    catStartPosition: Vector2(3,0),
    targetFinish: Vector2(3,2),
    Sprite: 'kucing_Idle.png',
    isLocked: false,
    vocab: 'STROBERI',
    vocabImage: 'assets/images/tobeli.png',
    maksComand : 2,
    subTiles: [
      Vector2(3,1),
      Vector2(3,2),
    ],
    ujung: [
      Vector2(3,2),
    ],
    star: 0
  ),

  //3
  Level(
    id_story: 1,
    mapPosition: Alignment(-0.10, 0.38),
    id: 3,
    title: 'Pesta Ulang Tahun Beri',
    difficulty: 'Pemula',
    tileMapPath: 'lvl3.tmx',
    catStartPosition: Vector2(2,2),
    targetFinish: Vector2(6,1),
    Sprite: 'kucing_Idle.png',
    isLocked: false,
    vocab: 'KUE',
    vocabImage: 'assets/images/cake.png',
    maksComand : 5,
    subTiles: [
      Vector2(3,2),
      Vector2(4,2),
      Vector2(5,2),
      Vector2(6,2),
      Vector2(6,1),
    ],
    ujung:[
      Vector2(6,2),
      Vector2(6,1)
    ],
    star: 0
  ),

  //4
   Level(
    id_story: 1,
    mapPosition: Alignment(0.32, 0.1),
    id: 4,
    title: 'Pesta Ulang Tahun Beri',
    difficulty: 'Pemula',
    tileMapPath: 'lvl4.tmx',
    catStartPosition: Vector2(2,1),
    targetFinish: Vector2(9,2),
    Sprite: 'kucing_Idle.png',
    isLocked: false,
    vocab: 'KUE',
    vocabImage: 'assets/images/cake.png',
    maksComand : 8,
    subTiles: [
      Vector2(3,1),
      Vector2(4,1),
      Vector2(5,1),
      Vector2(5,2),
      Vector2(6,2),
      Vector2(7,2),
      Vector2(8,2),
      Vector2(9,2),
    ],
    rewardImage: 'assets/images/cake.png',
    ujung: [
      Vector2(5,1),
      Vector2(5,2),
      Vector2(9,2)
    ], 
    star: 0
  ),
  //5
   Level(
    id_story: 1,
    mapPosition: Alignment(0.50, -0.46),
    id: 5,
    title: 'Pesta Ulang Tahun Beri',
    difficulty: 'Pemula',
    tileMapPath: 'lvl5.tmx',
    catStartPosition: Vector2(0,2),
    targetFinish: Vector2(6,2),
    Sprite: 'kucing_Idle.png',
    isLocked: true,
    vocab: 'KUE',
    vocabImage: 'assets/images/cake.png',
    maksComand : 8,
    subTiles: [
      Vector2(1,2),
      Vector2(2,2),
      Vector2(3,2),
      Vector2(3,1),
      Vector2(3,0),
      Vector2(4,0),
      Vector2(5,0),
      Vector2(6,0),
      Vector2(6,1),
      Vector2(6,2), 
    ],
    rewardImage: 'assets/images/cake.png',
    ujung: [
      Vector2(3,2),
      Vector2(3,0),
      Vector2(6,0),
      Vector2(6,2)
    ],
    star: 0
  )


];
