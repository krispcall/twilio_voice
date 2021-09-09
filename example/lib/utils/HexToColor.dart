import 'package:flutter/cupertino.dart';

class HexToColor extends Color {
  static int _getColorFromHex(String hexColor)
  {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexToColor(final String hexColor) : super(_getColorFromHex(hexColor));
}