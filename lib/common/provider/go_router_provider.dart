import 'package:excel_add_on/home/screen/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  List<GoRoute> route = [
    GoRoute(
      path: '/',
      name: HomeScreen.routeName,
      builder: (_, __) => const HomeScreen(),
    ),
  ];

  return GoRouter(
    routes: route,
    initialLocation: '/',
  );
});
