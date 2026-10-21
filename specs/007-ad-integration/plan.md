# Implementation Plan: Ad Integration

**Feature Branch**: `feature/ad-integration`  
**Feature Spec**: [spec.md](./spec.md)  
**Status**: RETROACTIVE — documenting as-built implementation merged via PR #25 (2025-11-19)

---

## Technical Context

- **Project Type**: Mobile (Flutter)
- **Primary Language**: Dart
- **Ads SDK**: `google_mobile_ads` ^6.0.0
- **Architecture**: Clean Architecture, Feature-based Modules
- **State Management**: `flutter_bloc` (BLoC)
- **Dependency Injection**: `get_it`, `provider`

### Affected Components (As-Built)

- **Core/Ads**:
  - `lib/core/ads/ad_service.dart` (abstraction)
  - `lib/core/ads/ad_service_impl.dart` (implementation)
- **DI/Providers**:
  - `lib/core/di/injection.dart` (register `AdServiceImpl` singleton, inject into `GameBloc`)
  - `lib/core/di/providers.dart` (provide `AdService`)
- **Game**:
  - `lib/features/game/presentation/bloc/game_bloc.dart` (add `adService`, trigger on `GameResetEvent` and game-over path)
  - `lib/features/game/presentation/screens/lce/game_content_widget.dart` (add `MyAdsWidget` in wide/narrow layouts)
  - `lib/features/game/presentation/widgets/my_ad_widget.dart` (banner widget)
- **App/Platform**:
  - `lib/main.dart` (imports as-built)
  - `android/app/src/main/AndroidManifest.xml` (ads APPLICATION_ID)
  - `macos/Flutter/GeneratedPluginRegistrant.swift`, `pubspec.lock`, `pubspec.yaml`

---

## Constitution Check (Pre-Design)

- [X] **I. Technology Stack**: Uses established stack plus `google_mobile_ads` as added.
- [X] **II. Architecture**: Changes fit existing module structure.
- [X] **III. Code Style & Quality**: As-built code follows project conventions.
- [X] **IV. Testing**: Existing tests remain green (no ad-specific tests added in PR).

**Result**: Retroactive plan documenting as-built state.

---

## Phase 0: Research

No new research required — documenting as-built integration.

**Output**: N/A (retroactive)

---

## Phase 1: Design & Contracts

As-built design is documented in spec.md. No new contracts introduced.

**Outputs**:
- **Spec**: [spec.md](./spec.md)
- **Data Model**: N/A (no new persisted entities)
- **Quickstart Guide**: N/A
- **API Contracts**: N/A

---

## Phase 2: Implementation (As-Built)

Implemented in PR #25 across the following areas:

1. **Ads Core**: Create `AdService` and `AdServiceImpl` with init/getBanner/loadInterstitial/showInterstitial.
2. **DI Wiring**: Register singleton and inject into `GameBloc`.
3. **UI Integration**: Add banner widget and place in game layouts.
4. **Game Flow**: Trigger interstitials on reset and game-over.
5. **Platform Config**: Update manifest, plugin registrants, dependencies.

---

## Constitution Check (Post-Design)

- [X] **I. Technology Stack**: Consistent with as-built.
- [X] **II. Architecture**: Consistent with as-built.
- [X] **III. Code Style & Quality**: Consistent with as-built.
- [X] **IV. Testing**: Existing tests unaffected.

**Result**: Retroactive documentation complete.
