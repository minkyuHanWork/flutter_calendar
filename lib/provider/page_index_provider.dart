import 'package:calendar/provider/calendar_provider.dart';
import 'package:calendar/provider/selected_day_provider.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final pageIndexProvider = StateProvider<int>((ref) {
//   return 100000;
// });

// final pageControllerProvider =
//     Provider<PageController>((ref) => PageController(initialPage: 200000));

final pageControllerProvider =
    StateNotifierProvider<PageControllerNotifier, PageController>((ref) {
  return PageControllerNotifier(ref: ref);
});

class PageControllerNotifier extends StateNotifier<PageController> {
  final Ref ref;
  final pagePrevTrottle = Throttle(const Duration(milliseconds: 500),
      initialValue: null, checkEquality: false);
  final pageNextTrottle = Throttle(const Duration(milliseconds: 500),
      initialValue: null, checkEquality: false);
  PageControllerNotifier({required this.ref})
      : super(PageController(initialPage: 200000)) {
    pagePrevTrottle.values.listen((state) {
      _prevPage();
    });
    pageNextTrottle.values.listen((state) {
      _nextPage();
    });
  }

  throttlePrev() {
    pagePrevTrottle.setValue(null);
  }

  throttleNext() {
    pageNextTrottle.setValue(null);
  }

  _nextPage() {
    state.nextPage(
        duration: const Duration(milliseconds: 400), curve: Curves.ease);
    // ref.read(calendarProvider.notifier).nextMonth();
  }

  _prevPage() {
    state.previousPage(
        duration: const Duration(milliseconds: 400), curve: Curves.ease);
    // ref.read(calendarProvider.notifier).prevMonth();
  }
}
