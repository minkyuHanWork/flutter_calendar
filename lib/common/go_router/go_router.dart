import 'package:calendar/common/go_router/calendar_loading_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final provider = ref.read(calendartLoadingProivder);
  return GoRouter(
    initialLocation: '/splash',
    routes: provider.route,
    refreshListenable: provider,
    redirect: provider.redirectLogic,
  );
});
