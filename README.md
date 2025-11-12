# 2048 Game

A 2048 game built with Flutter and Flame.

## Features

- Classic 2048 gameplay
- Swipe controls
- High score tracking
- Game over detection
- Sound effects

## Getting Started

### Prerequisites

- Flutter SDK: Make sure you have the Flutter SDK installed. For installation instructions, refer to the [official Flutter documentation](https://flutter.dev/docs/get-started/install).

### Installation

1.  Clone the repository:
    ```bash
    git clone https://github.com/DraigTech/2048.git
    ```
2.  Navigate to the project directory:
    ```bash
    cd 2048
    ```
3.  Install dependencies:
    ```bash
    flutter pub get
    ```

### Running the Application

1.  Run the code generation:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```
2.  Run the app:
    ```bash
    flutter run
    ```

## Project Structure

The project follows a feature-based modular architecture:

-   `lib/features/`: Contains self-contained feature modules (e.g., `game`, `settings`).
-   `lib/core/`: Contains shared components, source files, and generated code.

For more details on the project's architecture and principles, see the [Constitution](/.specify/memory/constitution.md).