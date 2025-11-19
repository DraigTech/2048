import 'dart:async';

import 'package:draig_2048/core/di/injection.dart';
import 'package:draig_2048/core/di/providers.dart';
import 'package:draig_2048/core/l10n/app_localizations.dart';
import 'package:draig_2048/core/routing/app_router.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Main entry point of the application.
///
/// This function initializes Flutter bindings, sets preferred orientations,
/// configures dependency injection, initializes audio, and runs the app.
Future<void> main() async {
  /// Ensure the Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  /// Set the orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  /// Initialize dependencies
  configureDependencies();

  /// Initialize FlameAudio
  FlameAudio.updatePrefix('');

  /// Run app
  runApp(MyApp());
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  /// Creates a [MyApp] instance.
  MyApp({super.key});

  final _appRoute = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: appProviders,
      child: MaterialApp.router(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: _appRoute.config(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
