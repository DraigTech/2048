import 'package:auto_route/auto_route.dart';
import 'package:draig_2048/core/routing/app_router.gr.dart';

/// Defines the routes and route names for the application.
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: GameRoute.page,
      initial: true,
    ),
  ];
}
