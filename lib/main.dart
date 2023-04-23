import 'package:calendar/common/default_value.dart';
import 'package:calendar/common/go_router/go_router.dart';
import 'package:calendar/common/type_def.dart';
import 'package:calendar/model/todo_model.dart';
import 'package:calendar/provider/calendar_provider.dart';
import 'package:calendar/provider/color_scheme_seed_provider.dart';
import 'package:calendar/provider/isar_provider.dart';
import 'package:calendar/view/calendar_layout.dart';
import 'package:calendar/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final List<TodoCache> cache = await getCacheData();
  print(cache);

  runApp(ProviderScope(
    child: MyApp(),
    overrides: [todoCacheProvider.overrideWith((ref) => cache)],
  ));
}

Future<List<TodoCache>> getCacheData() async {
  // 앱 실행 시 딱 한 번만 로컬 데이터에 저장된 데이터를 불러온다.
  // 만약 추가되는 데이터가 있다면, 데이터베이스에 저장은 하되,
  // 유저 경험을 위해 캐시로만 운영하고, 앱을 종료하고 다시 시작 시
  // 추가된 데이터가 불러지는 것이다.

  // isar 을 초기화하고, 데이터를 불러온다.
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [TodoModelSchema],
    directory: dir.path,
  );
  final List<TodoModel> todoList = await isar.todoModels.where().findAll();
  print('${todoList.length} 개의 일정이 존재합니다');

  // 처음에 이 캐시는 모두 비어있다. state = []
  // 만약 이 todoModel의 dateTime 이 이미 TodoCacheList 에 존재하는 경우?
  // 해당 캐시의 todoList property 에 추가해야한다.
  // 만약 존재하지 않는다면 새로 추가한다.
  List<TodoCache> cache = [];

  await Future.wait(todoList.map((todo) async {
    // 모든 캐시 데이터 내 해당하는 datetime이 있는지 확인 ?
    TodoCache isIn = cache.firstWhere(
      (element) => element.dateTime == todo.dateTime,
      orElse: () => TodoCache(dateTime: DateTime(0, 0, 0), todoList: []),
    );

    // 해당하는 datetime이 없다면? 새로이 cache를 추가한다.
    if (isIn.dateTime == DateTime(0, 0, 0)) {
      cache.add(TodoCache(dateTime: todo.dateTime, todoList: [todo]));
    }
    // 이미 데이터가 존재한다면 해당하는 cache의 todolist만 변경해준다(추가).
    else {
      cache = cache
          .map((e) => e.dateTime == todo.dateTime
              ? e.copyWith(todoList: [...e.todoList, todo])
              : e)
          .toList();
    }
  }));

  isar.close();
  return cache;
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorSeed = ref.watch(colorSchemeSeedProvider);
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        useMaterial3: true,
        colorSchemeSeed: colorSeed,
      ),
      routerConfig: router,
    );
  }
}
