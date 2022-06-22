import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor indicaiRed = const MaterialColor(
    0xff940101, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    const <int, Color>{
      50: const Color(0xff850101), //10%
      100: const Color(0xff760101), //20%
      200: const Color(0xff680101), //30%
      300: const Color(0xff590101), //40%
      400: const Color(0xff4a0101), //50%
      500: const Color(0xff3b0000), //60%
      600: const Color(0xff2c0000), //70%
      700: const Color(0xff1e0000), //80%
      800: const Color(0xff0f0000), //90%
      900: const Color(0xff000000), //100%
    },
  );
}
