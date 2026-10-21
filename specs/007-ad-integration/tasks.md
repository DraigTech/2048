# Task List: Ad Integration

**Purpose**: Retroactive task list documenting as-built work from PR #25 (merged 2025-11-19). No new implementation tasks.

---

## Phase 1: Ads Core (As-Built)
- [X] T001 Create `lib/core/ads/ad_service.dart` defining ad service interface.
- [X] T002 Create `lib/core/ads/ad_service_impl.dart` implementing Google Mobile Ads integration.
- [X] T003 Add `google_mobile_ads` dependency to `pubspec.yaml`.

## Phase 2: DI & Providers (As-Built)
- [X] T004 Register `AdServiceImpl` singleton and inject into `GameBloc` in `lib/core/di/injection.dart`.
- [X] T005 Provide `AdService` via `lib/core/di/providers.dart`.

## Phase 3: Game Integration (As-Built)
- [X] T006 Update `GameBloc` to accept `adService` and trigger interstitials on `GameResetEvent` and game-over path.
- [X] T007 Create `lib/features/game/presentation/widgets/my_ad_widget.dart` for banner ads.
- [X] T008 Update `GameContentWidget` layouts to include `MyAdsWidget` in wide and narrow views.

## Phase 4: Platform & Config (As-Built)
- [X] T009 Add Google Mobile Ads APPLICATION_ID to `android/app/src/main/AndroidManifest.xml`.
- [X] T010 Update plugin registrants (`macos/Flutter/GeneratedPluginRegistrant.swift`, etc.) and `pubspec.lock` as built.
- [X] T011 Update `lib/main.dart` imports as needed.

## Phase 5: Verification (Retroactive)
- [X] T012 Merge PR #25 into main.
- [X] T013 Create retroactive spec 007 documentation.
- [X] T014 Run verification: `pub get`, `analyze`, `test`, `build web`.
