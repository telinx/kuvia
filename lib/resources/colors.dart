import 'package:flutter/material.dart';
// 100% — FF
// 95% — F2
// 90% — E6
// 85% — D9
// 80% — CC
// 75% — BF
// 70% — B3
// 65% — A6
// 60% — 99
// 55% — 8C
// 50% — 80
// 45% — 73
// 40% — 66
// 35% — 59
// 30% — 4D
// 25% — 40
// 20% — 33
// 15% — 26
// 10% — 1A
// 5% — 0D
// 0% — 00
class AppColors {
  // static const Color app_main = Colors.white;

  static const Color divider = Color(0xffe5e5e5);

  static const Color app_main = Color.fromRGBO(252, 66, 169, 1);
  static const Color dark_app_main = Color.fromRGBO(252, 66, 169, 1);

  static const Color text_white = Color.fromRGBO(255, 255, 255, 1);

  static const Color bg_color = Color(0xfff1f1f1);
  static const Color dark_bg_color = Color(0xFF18191A);

  static const Color bg_gray = Color(0xFFF6F6F6);
  static const Color dark_bg_gray = Color(0xFF1F1F1F);

  static const Color material_bg = Color(0xFFFFFFFF);
  static const Color dark_material_bg = Color(0xFF303233);

  static const Color bg_gray_ = Color(0xFFFAFAFA);
  static const Color dark_bg_gray_ = Color(0xFF242526);

  static const Color text = Color.fromRGBO(60, 60, 60, 1); 
  static const Color dark_text = Color.fromRGBO(244,246,247, 1);
  
  static const Color text_gray = Color.fromRGBO(160, 160, 160, 1);
  static const Color dark_text_gray =  Color.fromRGBO(178,183,184, 1); 


  static const Color head_text_gray = Color.fromRGBO(108, 108, 108, 1);
  static const Color head_dark_text_gray = Color(0xFF666666);

  static const Color price_text = Color.fromRGBO(255, 156, 109, 1);
  static const Color dark_price_text= Color.fromRGBO(255, 156, 109, 1);

  static const Color text_gray_c = Color(0xFFcccccc);
  static const Color dark_button_text = Color(0xFFF2F2F2);
  
  static const Color line = Color.fromRGBO(160, 160, 160, 0.2);
  static const Color dark_line = Color(0xFF3A3C3D);

  static const Color red = Color(0xFFFF4759);
  static const Color dark_red = Color(0xFFE03E4E);
  
  static const Color text_disabled = Color(0xFFD4E2FA);
  static const Color dark_text_disabled = Color(0xFFCEDBF2);

  static const Color button_disabled = Color(0xFF96BBFA);
  static const Color dark_button_disabled = Color(0xFF83A5E0);

  static const Color unselected_item_color = Color.fromRGBO(1, 1, 1, 0.6);
  static const Color dark_unselected_item_color = Color(0xFFB8B8B8);
}

Map<String, Color> circleAvatarMap = {
  'A': Colors.blueAccent,
  'B': Colors.blue,
  'C': Colors.cyan,
  'D': Colors.deepPurple,
  'E': Colors.deepPurpleAccent,
  'F': Colors.blue,
  'G': Colors.green,
  'H': Colors.lightBlue,
  'I': Colors.indigo,
  'J': Colors.blue,
  'K': Colors.blue,
  'L': Colors.lightGreen,
  'M': Colors.blue,
  'N': Colors.brown,
  'O': Colors.orange,
  'P': Colors.purple,
  'Q': Colors.black,
  'R': Colors.red,
  'S': Colors.blue,
  'T': Colors.teal,
  'U': Colors.purpleAccent,
  'V': Colors.black,
  'W': Colors.brown,
  'X': Colors.blue,
  'Y': Colors.yellow,
  'Z': Colors.grey,
  '#': Colors.blue,
};

Map<String, Color> themeColorMap = {
  'gray': Colors.grey.withOpacity(0.3),
  'blue': Colors.blue,
  'blueAccent': Colors.blueAccent,
  'cyan': Colors.cyan,
  'deepPurple': Colors.deepPurple,
  'deepPurpleAccent': Colors.deepPurpleAccent,
  'deepOrange': Colors.deepOrange,
  'green': Colors.green,
  'indigo': Colors.indigo,
  'indigoAccent': Colors.indigoAccent,
  'orange': Colors.orange,
  'purple': Colors.purple,
  'pink': Colors.pink,
  'red': Colors.red,
  'teal': Colors.teal,
  'black': Colors.black,
};


Map<String, Color> avatarBgColorMap = {
  'A': Color.fromRGBO(0, 0, 102, 1.0),
  'B': Color.fromRGBO(0, 51, 51, 1.0),
  'C': Color.fromRGBO(0, 51, 102, 1.0),
  'D': Color.fromRGBO(0, 51, 103, 1.0),
  'E': Color.fromRGBO(0, 102, 51, 1.0),
  'F': Color.fromRGBO(0, 102, 102, 1.0),
  'G': Color.fromRGBO(0, 102, 153, 1.0),
  'H': Color.fromRGBO(0, 153, 51, 1.0),
  'I': Color.fromRGBO(0, 153, 153, 1.0),
  'J': Color.fromRGBO(0, 153, 204, 1.0),
  'K': Color.fromRGBO(0, 204, 102, 1.0),
  'L': Color.fromRGBO(0, 204, 153, 1.0),
  'M': Color.fromRGBO(0, 204, 204, 1.0),
  'N': Color.fromRGBO(51, 0, 51, 1.0),
  'O': Color.fromRGBO(51, 0, 102, 1.0),
  'P': Color.fromRGBO(51, 51, 51, 1.0),
  'Q': Color.fromRGBO(51, 51, 103, 1.0),
  'R': Color.fromRGBO(51, 153, 102, 1.0),
  'S': Color.fromRGBO(51, 153, 153, 1.0),
  'T': Color.fromRGBO(51, 153, 204, 1.0),
  'U': Color.fromRGBO(102, 51, 102, 1.0),
  'V': Color.fromRGBO(102, 51, 153, 1.0),
  'W': Color.fromRGBO(102, 102, 102, 1.0),
  'X': Color.fromRGBO(102, 102, 153, 1.0),
  'Y': Color.fromRGBO(102, 102, 153, 1.0),
  'Z': Color.fromRGBO(153, 0, 0, 1.0),
  '#': Color.fromRGBO(153, 0, 102, 1.0),
};