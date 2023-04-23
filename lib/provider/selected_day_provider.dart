import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedDayProvider = StateProvider<int>((ref) {
  return DateTime.now().day;
});

final isClickOtherMonthProvider = StateProvider<bool>((ref) {
  return false;
});
