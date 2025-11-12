// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i2;
import 'package:draig_2048/features/game/presentation/screens/game_screen.dart'
    as _i1;

/// generated route for
/// [_i1.GameScreen]
class GameRoute extends _i2.PageRouteInfo<void> {
  const GameRoute({List<_i2.PageRouteInfo>? children})
    : super(GameRoute.name, initialChildren: children);

  static const String name = 'GameRoute';

  static _i2.PageInfo page = _i2.PageInfo(
    name,
    builder: (data) {
      return const _i1.GameScreen();
    },
  );
}
