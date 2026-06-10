import 'package:flutter/material.dart';
import 'package:flame/components.dart';

class Level {
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


  const Level({
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
    this.itemAmount = 0

  });
}

// Daftar semua level
final List<Level> allLevels = [
  Level(
    id: 1,
    title: 'Pesta Ulang Tahun Beri',
    difficulty: 'Pemula',
    tileMapPath: 'lvl1Fix.tmx',
    catStartPosition: Vector2(0,2),
    targetFinish: Vector2(5,2),
    Sprite: 'kucingsampingidle.png',
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
  ),

];
