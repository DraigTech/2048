import 'package:draig_2048/core/routing/app_router.dart';
import 'package:draig_2048/features/game/presentation/screens/game_screen.dart';
import 'package:go_router/go_router.dart';

/// The GoRouter instance used for managing the application's routing.
///
/// It defines the initial route and a list of routes for the application.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRouter.gameRoute,
  routes: [
    GoRoute(
      path: AppRouter.gameRoute,
      builder: (context, state) => const GameScreen(),
    ),
  ],
);
