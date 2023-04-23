import 'package:calendar/model/day_model.dart';

class CalendarModel {
  final int year;
  final int month;
  final List<DayModel> days;

  CalendarModel({
    required this.year,
    required this.month,
    required this.days,
  });

  CalendarModel copyWith({
    int? year,
    int? month,
    List<DayModel>? days,
  }) {
    return CalendarModel(
      year: year ?? this.year,
      month: month ?? this.month,
      days: days ?? this.days,
    );
  }
}
