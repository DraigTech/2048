# 2048 Constitution

This document provides a consolidated overview of the technologies, architectural patterns, and commands used in this project.

## Core Principles

### I. Technology Stack
The project is built with the Dart language and the Flutter framework. The following libraries are integral to the development and should be used according to their established patterns:
- **UI Framework**: Flutter
- **Game Engine**: Flame
- **State Management**: flutter_bloc (BLoC)
- **Routing**: auto_route
- **Local Database**: Drift
- **Dependency Injection**: get_it
- **Localization**: `flutter_localizations` and `intl`, configured via `l10n.yaml`.
- **Code Generation**: `build_runner` is used to orchestrate code generation for assets (`flutter_gen_runner`), database (`drift`), and routing (`auto_route`).

### II. Architecture
The project follows a feature-based modular architecture to promote separation of concerns and scalability.
- **`lib/features/`**: Contains self-contained feature modules (e.g., `game`, `settings`).
- **`lib/core/`**: Contains shared components, source files, and generated code, including:
  - `di/`: Dependency injection setup.
  - `routing/`: Application routing setup.
  - `database/`: Database configuration.
  - `assets/`: Contains auto-generated Dart asset classes.
  - `l10n/`: Source localization files (`.arb`) and the auto-generated Dart localization classes.

### III. Code Style & Quality
A strict and consistent code style is enforced through static analysis.
- **Linting**: All code **must** strictly adhere to the rules defined in `analysis_options.yaml`.
- **Key Rules**: Pay close attention to `public_member_api_docs`, `directives_ordering`, `require_trailing_commas`, and `lines_longer_than_80_chars`.
- **Type Safety**: Strict type safety is enabled (`strict-casts`, `strict-inference`, `strict-raw-types`).
- **No Print Statements**: `avoid_print` rule is enforced. Use a proper logger for debugging.

### IV. Testing
Testing is a crucial part of the development process to ensure code quality and prevent regressions.
- **Framework**: `flutter_test` for unit and widget tests.
- **Location**: Tests should be placed in the `test/` directory, mirroring the `lib/` structure.
- **Execution**: Run tests via the `flutter test` command.

## Development Workflow

### Standard Commands
The following commands should be used to manage the development lifecycle:
- **Install/Update Dependencies**: `flutter pub get` (this also triggers `gen-l10n` for localizations).
- **Generate Code**: `dart run build_runner build --delete-conflicting-outputs` (This handles assets, database, routing, etc.).
- **Analyze Code**: `flutter analyze`
- **Run Tests**: `flutter test`

## Governance
This constitution serves as the primary guide for all development within this project. All code contributions and reviews must verify compliance with these principles. Amendments to this constitution require team consensus and documentation of the changes.

**Version**: 1.0.0 | **Last Amended**: 2025-11-12
