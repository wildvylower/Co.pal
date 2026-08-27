import 'dart:math';
import 'package:flutter/material.dart';

double getGlobalScale(BuildContext context) {
  final screenSize = MediaQuery.of(context).size;
  final double widthScale = screenSize.width / 850;
  final double heightScale = screenSize.height / 500;
  
  return min(widthScale, heightScale).clamp(0.4, 1.2);
}
