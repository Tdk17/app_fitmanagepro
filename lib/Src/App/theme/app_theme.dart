import 'package:flutter/material.dart';

class AppTheme {
  static const green = Color(0xFF34C759);

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.transparent,
      useMaterial3: true,
    );
  }

  // 👇 ADICIONE ISSO
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF070707),
      Color.fromARGB(255, 13, 104, 1),
      Color(0xFF000000),
    ],
  );
}
