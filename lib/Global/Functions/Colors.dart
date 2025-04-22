import 'package:flutter/material.dart';

MaterialColor Create_Material_Color(Color color) {
  List strengths = <double>[.05];
  final Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

Map<String, FontWeight> weights = {
  '400': FontWeight.w400,
  '500': FontWeight.w500,
  '600': FontWeight.w600,
  '700': FontWeight.w700,
  'Bold': FontWeight.bold,
};

Color Get_Splash_Color = const Color(0xFFFF6A00);
Color Get_Blue_SHEIN = const Color(0xFFf4f9fd);

Color Get_White = Colors.white;
Color Get_White50 = Colors.white.withOpacity(0.5);
Color Get_White60 = Colors.white.withOpacity(0.6);
Color Get_White70 = Colors.white.withOpacity(0.7);
Color Get_White80 = Colors.white.withOpacity(0.8);
Color Get_White90 = Colors.white.withOpacity(0.9);

Color Get_Black = Colors.black;
Color Get_Black30 = Colors.black.withOpacity(0.03);
Color Get_Black38 = Colors.black38;
Color Get_Black45 = Colors.black45;
Color Get_Black54 = Colors.black54;
Color Get_Black75 = Colors.black.withOpacity(0.75);
Color Get_Black80 = Colors.black.withOpacity(0.80);
Color Get_Black87 = Colors.black87;

Color Get_RedAccent = Colors.redAccent;
Color Get_RedAccent10 = Colors.redAccent.withOpacity(0.1);

Color Get_Red = Colors.red;
Color Get_Red40 = Colors.red.withOpacity(0.4);
Color Get_Red50 = Colors.red.withOpacity(0.5);
Color Get_Red55 = Colors.red.withOpacity(0.55);
Color Get_Red70 = Colors.red.withOpacity(0.7);
Color Get_Red80 = Colors.red.withOpacity(0.8);
Color Get_Red200 = Colors.red.shade200;

Color Get_Grey = Colors.grey;
Color Get_Grey25 = Colors.grey.withOpacity(0.25);
Color Get_Grey50 = Colors.grey.withOpacity(0.5);
Color Get_Grey70 = Colors.grey.withOpacity(0.7);
Color Get_Grey80 = Colors.grey.withOpacity(0.8);
Color Get_Grey90 = Colors.grey.withOpacity(0.9);
Color Get_Grey200 = Colors.grey.shade200;
Color Get_Grey300 = Colors.grey.shade300;
Color Get_Grey400 = Colors.grey.shade400;
Color Get_Grey900_90 = Colors.grey.shade900.withOpacity(0.9);

Color Get_Purple = Colors.purple;
Color Get_Purple20 = Colors.purple.withOpacity(0.2);

Color Get_BlueGrey50 = Colors.blueGrey.shade50;
Color Get_BlueGrey400 = Colors.blueGrey.shade400;

Color Get_BlueShade = const Color(0xFF97a7b2);

Color Get_BlueDark = const Color(0xFF7b91a0);
Color Get_BlueDark50 = const Color(0xFF7b91a0).withOpacity(0.5);
Color Get_BlueDark80 = const Color(0xFF7b91a0).withOpacity(0.8);
Color Get_BlueDark90 = const Color(0xFF7b91a0).withOpacity(0.9);

Color Get_Blue = const Color(0xFF44afed);
// Color Get_Primary10 = const Color(0xFF44afed).withOpacity(0.1);
// Color Get_Primary20 = const Color(0xFF44afed).withOpacity(0.2);

Color Get_Cyan = Colors.cyan;

Color Get_Primary = const Color.fromRGBO(144, 49, 170, 1);
Color Get_Primary10 = Get_Primary.withOpacity(0.1);
Color Get_Primary20 = Get_Primary.withOpacity(0.2);
Color Get_Primary30 = Get_Primary.withOpacity(0.3);

Color Get_Secondary = const Color(0xFFf4f7f9);

Color Get_Active = const Color(0xFF34c75a);

Color Get_Shein = const Color.fromRGBO(246, 246, 246, 1);

Color Get_Whatsapp = const Color(0XFFf2f2f6);

Color Get_Warning = const Color.fromRGBO(249, 240, 215, 1.0);

Color Get_Trans = Colors.transparent;

Color Get_Gold = const Color.fromRGBO(244, 206, 75, 1);

Color Get_Orange = const Color.fromRGBO(236, 170, 66, 1);

Color Get_Loading = Colors.blueGrey.shade50.withOpacity(0.5);
