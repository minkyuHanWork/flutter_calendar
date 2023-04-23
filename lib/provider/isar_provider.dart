import 'package:calendar/model/todo_model.dart';
import 'package:calendar/provider/calendar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class TodoCache {
  final DateTime dateTime;
  final List<TodoModel> todoList;

  TodoCache({
    required this.dateTime,
    required this.todoList,
  });

  TodoCache copyWith({
    DateTime? dateTime,
    List<TodoModel>? todoList,
  }) {
    return TodoCache(
      dateTime: dateTime ?? this.dateTime,
      todoList: todoList ?? this.todoList,
    );
  }
}

final todoCacheProvider = StateProvider<List<TodoCache>>((ref) {
  return <TodoCache>[];
});

// final todoCacheProvider =
//     StateNotifierProvider<TodoCacheNotifier, List<TodoCache>>((ref) {
//   return TodoCacheNotifier();
// });

// class TodoCacheNotifier extends StateNotifier<List<TodoCache>> {
//   TodoCacheNotifier() : super([]);

//   // 앱 실행 시 딱 한 번만 로컬 데이터에 저장된 데이터를 불러온다.
//   // 만약 추가되는 데이터가 있다면, 데이터베이스에 저장은 하되,
//   // 유저 경험을 위해 캐시로만 운영하고, 앱을 종료하고 다시 시작 시
//   // 추가된 데이터가 불러지는 것이다.
//   initData(List<TodoModel> todoList) {
//     todoList.map((todo) {
//       // 처음에 이 캐시는 모두 비어있다. state = []
//       // 만약 이 todoModel의 dateTime 이 이미 TodoCacheList 에 존재하는 경우?
//       // 해당 캐시의 todoList property 에 추가해야한다.
//       // 만약 존재하지 않는다면 새로 추가한다.
//     });
//   }
// }
