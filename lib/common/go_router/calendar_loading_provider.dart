import 'dart:async';

import 'package:calendar/model/calendar_model.dart';
import 'package:calendar/provider/calendar_provider.dart';
import 'package:calendar/view/calendar_layout.dart';
import 'package:calendar/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final calendartLoadingProivder =
    ChangeNotifierProvider<CalendarLoadingProivder>((ref) {
  return CalendarLoadingProivder(ref: ref);
});

class CalendarLoadingProivder extends ChangeNotifier {
  final Ref ref;
  CalendarLoadingProivder({
    required this.ref,
  }) {
    ref.listen<CalendarModel>(calendarProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }
  List<GoRoute> get route => [
        GoRoute(
          path: '/',
          name: CalendarLayout.routeName,
          builder: (_, __) => const CalendarLayout(),
        ),
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (_, __) => const SplashScreen(),
        ),
      ];

  FutureOr<String?> redirectLogic(_, GoRouterState state) {
    final calendarState = ref.read(calendarProvider);
    if (calendarState.year == 0) {
      return '/splash';
    } else {
      return '/';
    }
  }
}
