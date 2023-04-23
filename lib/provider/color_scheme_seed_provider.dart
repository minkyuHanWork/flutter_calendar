import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final colorSchemeSeedProvider = StateProvider<Color>((ref) {
  return Colors.purple;
});
