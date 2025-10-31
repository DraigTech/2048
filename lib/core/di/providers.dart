import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'package:_2048/core/di/injection.dart';
import 'package:_2048/features/game/presentation/bloc/game_bloc.dart';

List<SingleChildWidget> get appProviders {
  return [
    BlocProvider<GameBloc>(
      create: (context) => getIt<GameBloc>(),
    ),
  ];
}
