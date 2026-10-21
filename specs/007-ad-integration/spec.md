# Feature Specification: Ad Integration

**Feature Branch**: `feature/ad-integration`  
**Created**: 2025-11-19  
**Status**: RETROACTIVE — documenting as-built behavior implemented 2025-11-19 via PR #25  
**Input**: As-built ad integration merged via PR #25 (Google Mobile Ads: interstitials on game reset/game over and banner ads in game UI). This spec is retroactive to satisfy the repo's spec-driven convention; no new behavior is specified or implemented here.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Banner Ads in Game View (Priority: P1)

As a player, I want to see a banner ad in the game view on supported platforms so that ad placements are visible without disrupting core gameplay layout.

**Why this priority**: Banner placement is the most visible ad surface introduced by the integration.

**Independent Test**: Open the game on a supported platform and verify the banner area renders via `MyAdsWidget` in both wide and narrow layouts; if no ad is loaded, the widget collapses gracefully.

**Acceptance Scenarios**:

1. **Given** the game screen is displayed in wide layout, **When** the UI renders, **Then** `MyAdsWidget` appears below the board/score area as added to `GameContentWidget`.
2. **Given** the game screen is displayed in narrow layout, **When** the UI renders, **Then** `MyAdsWidget` appears between the score layout and the board area with appropriate spacing.
3. **Given** the banner ad fails to load, **When** `getBannerAd` returns null or fails, **Then** `MyAdsWidget` renders as `SizedBox.shrink()` without breaking layout.

---

### User Story 2 - Interstitial Ads on Game Transitions (Priority: P2)

As the app, I want to show interstitial ads at key transition points (game reset / game over) so that monetization events occur without blocking user input flow in normal cases.

**Why this priority**: Interstitials are triggered on reset and game-over paths per the as-built implementation.

**Independent Test**: Trigger a game reset (new game via reset flow) and a game-over transition; verify `GameBloc` calls `AdService.showInterstitialAd()` at those points (as-built behavior).

**Acceptance Scenarios**:

1. **Given** a reset is requested via `GameResetEvent`, **When** `GameBloc` handles it, **Then** `adService.showInterstitialAd()` is called before emitting/resetting via `NewGameEvent()`.
2. **Given** the game reaches game-over in the flow handled by `GameBloc`, **When** the game-over path executes as-built, **Then** `adService.showInterstitialAd()` is called in that path (as implemented).
3. **Given** an interstitial is not ready or fails to show, **When** `AdServiceImpl` handles callbacks, **Then** it disposes the ad and attempts to reload (`loadInterstitialAd()`) without crashing.

---

### User Story 3 - Ad Service Initialization and Dependency Wiring (Priority: P3)

As the app infrastructure, I want ads initialized and wired through DI/providers so that the feature is available app-wide.

**Why this priority**: Required for the above surfaces to function.

**Independent Test**: Verify DI registers `AdService` singleton, `GameBloc` receives `adService`, `appProviders` provides `AdService`, and `main()`/app initialization paths are as-built.

**Acceptance Scenarios**:

1. **Given** app startup, **When** dependencies are configured, **Then** `AdServiceImpl` is registered as a singleton in `core/di/injection.dart` and `GameBloc` is constructed with `adService`.
2. **Given** the widget tree, **When** building providers, **Then** `Provider<AdService>` is available via `core/di/providers.dart`.
3. **Given** Android build, **When** manifest is read, **Then** `com.google.android.gms.ads.APPLICATION_ID` is present in `AndroidManifest.xml`. iOS/macOS plugin registration is updated as built.

---

### Edge Cases

- **Ad not ready**: If interstitial not loaded, `showInterstitialAd()` is a no-op in the current implementation.
- **Banner sizing**: `getBannerAd` uses `AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize` based on screen width; returns null if size cannot be determined.
- **Platform/plugin state**: Generated plugin registrants updated (macOS etc.) as part of integration.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST provide an `AdService` abstraction (`core/ads/ad_service.dart`) defining `init()`, `getBannerAd(context)`, `loadInterstitialAd()`, `showInterstitialAd()`.
- **FR-002**: The system MUST provide `AdServiceImpl` (`core/ads/ad_service_impl.dart`) using `google_mobile_ads` with as-built ad unit IDs for interstitial and banner.
- **FR-003**: The system MUST register `AdService` in DI and inject it into `GameBloc`; providers MUST expose it.
- **FR-004**: `GameBloc` MUST call `adService.showInterstitialAd()` on `GameResetEvent` and on the as-built game-over path.
- **FR-005**: `GameContentWidget` MUST display `MyAdsWidget` in wide and narrow layouts.
- **FR-006**: `MyAdsWidget` MUST initialize ads via `AdService`, load interstitial, load banner, and dispose banner on dispose.
- **FR-007**: Android manifest MUST include the Google Mobile Ads application ID.
- **FR-008**: `pubspec.yaml` MUST include `google_mobile_ads` dependency; plugin registrants and `pubspec.lock` reflect integration.

### Key Entities *(include if feature involves data)*

- **AdService**: Abstraction for ad operations.
- **AdServiceImpl**: Concrete implementation managing `InterstitialAd` lifecycle.
- **MyAdsWidget**: Banner ad UI widget.
- **GameBloc**: Extended with `adService` and ad triggers.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Ad surfaces are present in the UI as wired (banner in game content layouts).
- **SC-002**: Interstitial ads are triggered on reset and game-over as implemented.
- **SC-003**: DI/providers/manifest/pubspec are consistent with as-built integration.
- **SC-004**: Ad lifecycle is handled defensively (failures logged/disposed, reload attempted).
