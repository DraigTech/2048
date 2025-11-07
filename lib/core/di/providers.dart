import 'package:draig_2048/core/di/injection.dart';
import 'package:draig_2048/features/game/presentation/bloc/game_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

/// Provides a list of [SingleChildWidget] for the application's BLoC providers.
///
/// This getter sets up the [BlocProvider] for [GameBloc], allowing it to be
/// accessed throughout the widget tree.
List<SingleChildWidget> get appProviders {
  return [
    BlocProvider<GameBloc>(
      create: (context) => getIt<GameBloc>(),
    ),
  ];
}
