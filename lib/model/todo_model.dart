import 'package:isar/isar.dart';

part 'todo_model.g.dart';

@collection
class TodoModel {
  Id id = Isar.autoIncrement;
  late String title;
  String? content;
  int? color;
  bool? start;
  late int year;
  late int month;
  late int day;

  @Index()
  DateTime get dateTime => DateTime(year, month);

  TodoModel({
    required this.title,
    required this.year,
    required this.month,
    required this.day,
  });
}
