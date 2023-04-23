import 'package:calendar/model/todo_model.dart';

enum MonthState {
  prev,
  currunt,
  next,
}

class DayModel {
  final int year;
  final int month;
  final int day;
  final MonthState inMonth;
  final bool picked;
  final bool today;
  final List<TodoModel> todoList;

  DayModel({
    required this.year,
    required this.month,
    required this.day,
    required this.inMonth,
    required this.picked,
    required this.today,
    this.todoList = const [],
  });

  DayModel copyWith({
    int? year,
    int? month,
    int? day,
    MonthState? inMonth,
    bool? picked,
    bool? today,
    List<TodoModel>? todoList,
  }) {
    return DayModel(
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
      inMonth: inMonth ?? this.inMonth,
      picked: picked ?? this.picked,
      today: today ?? this.today,
      todoList: todoList ?? this.todoList,
    );
  }
}
