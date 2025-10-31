import 'package:_2048/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: AppRouter.gameRoute,
      builder: (context, state) => const Placeholder(), // TODO: Replace with actual GameScreen
    ),
  ],
);
