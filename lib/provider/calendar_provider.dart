import 'dart:async';
import 'dart:io';

import 'package:calendar/model/calendar_model.dart';
import 'package:calendar/model/day_model.dart';
import 'package:calendar/model/todo_model.dart';
import 'package:calendar/provider/isar_provider.dart';
import 'package:calendar/view/calendar_layout.dart';
import 'package:calendar/view/splash_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:collection/collection.dart';

final calendarProvider =
    StateNotifierProvider<CalendarNotifier, CalendarModel>((ref) {
  return CalendarNotifier(ref: ref);
});

class CalendarNotifier extends StateNotifier<CalendarModel> {
  final Ref ref;
  late Isar isar;
  CalendarNotifier({
    required this.ref,
  }) : super(CalendarModel(year: 0, month: 0, days: [])) {
    initCalendar();
  }

  Future<void> initIsar() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      isar = await Isar.open(
        [TodoModelSchema],
        directory: dir.path,
      );
    } catch (e) {
      print('gawgawr');
      print(e.toString());
    }
  }

  void initCalendar({
    int? year,
    int? month,
  }) {
    Future.delayed(const Duration(seconds: 1))
        .then((_) => initIsar().then((value) {
              final today = DateTime.now();
              final cYear = year ?? today.year;
              final cMonth = month ?? today.month;
              final days = setDays(cYear: cYear, cMonth: cMonth);

              state = CalendarModel(year: cYear, month: cMonth, days: days);
              isToday();
            }));
  }

  void prevMonth() {
    int year = state.year;
    int prevMonth = state.month - 1;
    if (state.month == 1) {
      prevMonth = 12;
      year -= 1;
    }

    final days = setDays(cYear: year, cMonth: prevMonth);

    state = CalendarModel(year: year, month: prevMonth, days: days);
    isToday();
  }

  void nextMonth() {
    int year = state.year;
    int nextMonth = state.month + 1;
    if (state.month == 12) {
      nextMonth = 1;
      year += 1;
    }
    final days = setDays(cYear: year, cMonth: nextMonth);

    state = CalendarModel(year: year, month: nextMonth, days: days);
    isToday();
  }

  List<DayModel> setDays({
    required int cYear,
    required int cMonth,
  }) {
    // 해당 년, 월의 데이터 가져오기.
    final cache = ref.read(todoCacheProvider);

    List<TodoModel> todoListCache;
    if (cache.isNotEmpty) {
      todoListCache = cache
          .firstWhere(
            (e) => e.dateTime == DateTime(cYear, cMonth),
            orElse: () => TodoCache(dateTime: DateTime(0, 0, 0), todoList: []),
          )
          .todoList;
    } else {
      todoListCache = [];
    }
    print(todoListCache);
    // 이번 달의 날짜 구하기

    List<DayModel> cMonthDays = [];
    final lastDay = DateTime(cYear, cMonth + 1, 0).day;
    for (int i = 1; i <= lastDay; i++) {
      // 데이터를 가져와서 날짜에 맞춰 데이터 리스트로 만들기.
      // 리스트로 만들어진 데이터를 추가하기
      final List<TodoModel> temp =
          todoListCache.where((element) => element.day == i).toList();
      cMonthDays.add(
        DayModel(
          year: cYear,
          month: cMonth,
          day: i,
          inMonth: MonthState.currunt,
          picked: false,
          today: false,
          todoList: temp,
        ),
      );
    }

    // 이전 달의 날짜
    List<DayModel> prevMonthDays = [];
    final firstDate = DateTime(cYear, cMonth, 1).weekday;
    final prevMonthFirstDay = DateTime(cYear, cMonth, 0).day;
    if (firstDate != 7) {
      for (int i = firstDate - 1; i >= 0; i--) {
        prevMonthDays.add(
          DayModel(
            year: cYear,
            month: cMonth - 1,
            day: prevMonthFirstDay - i,
            inMonth: MonthState.prev,
            picked: false,
            today: false,
          ),
        );
      }
    }

    final tempDays = prevMonthDays + cMonthDays;

    // 다음 달의 날짜
    List<DayModel> followingMonthDays = [];
    for (var i = 1; i <= 42 - tempDays.length; i++) {
      followingMonthDays.add(
        DayModel(
          year: cYear,
          month: cMonth + 1,
          day: i,
          inMonth: MonthState.next,
          picked: false,
          today: false,
        ),
      );
    }

    return tempDays + followingMonthDays;
  }

  void isToday() {
    final now = DateTime.now();

    // 년도가 틀리면 바로 리턴
    final year = now.year;
    final sYear = state.year;
    if (year != sYear) {
      return;
    }

    // 월이 틀리면 바로 리턴
    final month = now.month;
    final sMonth = state.month;
    if (month != sMonth) {
      return;
    }

    // 년도와 월이 동일함.
    // 현재 state.days 에는 오늘이 포함됨.
    final day = now.day;
    final days = state.days
        .map((e) => e.day == day ? e.copyWith(today: true) : e)
        .toList();
    state = state.copyWith(days: days);
  }

  addtoDo(TodoModel todoModel) {
    // 일정 간편 추가
    final days = state.days
        .map((e) => (e.day == todoModel.day && e.inMonth == MonthState.currunt)
            ? e.copyWith(todoList: [...e.todoList, todoModel])
            : e)
        .toList();
    print('간편일정 UI에 추가!');
    state = state.copyWith(days: days);
  }

  // 일정 추가하기.
  Future<bool> wirteTodo(TodoModel todoModel) async {
    try {
      ref.read(calendarProvider.notifier).addtoDo(todoModel);
      await isar.writeTxn(() async {
        await isar.todoModels
            .put(todoModel)
            .then((value) => print('$value 추가됨!'));
      });
      return true;
    } catch (e) {
      print('추가 실패하심');
      return false;
    }
  }
}
