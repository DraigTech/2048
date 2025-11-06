# Quickstart Guide

This guide provides the basic steps to get the 2048 game project up and running.

## Prerequisites

- Flutter SDK: Make sure you have the Flutter SDK installed. You can find instructions at https://flutter.dev/docs/get-started/install
- An editor like Visual Studio Code or Android Studio with the Flutter plugin.

## Getting Started

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd 2048
   ```

2. **Get dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the code generator**:
   ```bash
   flutter pub run build_runner build
   ```

4. **Run the app**:
   ```bash
   flutter run
   ```

## Project Structure

The project follows the Clean Architecture principles, with the code organized into three layers:

- **Data**: Contains data sources and repositories.
- **Domain**: Contains business logic, entities, and use cases.
- **Presentation**: Contains UI (widgets, screens) and state management (BLoC).