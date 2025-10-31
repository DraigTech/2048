import 'package:_2048/core/routing/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:_2048/features/game/presentation/screens/game_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRouter.gameRoute,
  routes: [
    GoRoute(
      path: AppRouter.gameRoute,
      builder: (context, state) => const GameScreen(),
    ),
  ],
);
