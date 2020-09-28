import 'package:flutter/material.dart';

// Kochava Colors
Color kochavaOrange = HexColor.fromHex('#eb5f00');
Color kochavaGrey = HexColor.fromHex('#454545');
Color kochavaGreen = HexColor.fromHex('#61a60e');
Color kochavaBlack = HexColor.fromHex('#231f20');
Color kochavaWhite = HexColor.fromHex('#fff');
Color kochavaRed = HexColor.fromHex('#be202e');
Color kochavaBlue = HexColor.fromHex('#03b3e3');

// Hex color extension
extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
