import 'package:flutter/material.dart';

// Calendar functions

class CF {
  static Color getColorByIndex(int idx) {
    final value = idx % 7;
    if (value == 0) {
      return Colors.red;
    } else if (value == 6) {
      return Colors.blue;
    } else {
      return Colors.black;
    }
  }
}
