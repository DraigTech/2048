import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// This file defines the abstract interface for an advertising service
/// and its concrete implementation.
///
/// The `AdService` abstract class specifies the contract for
/// initializing, showing interstitial, and showing rewarded ads.
abstract class AdService {
  /// Initializes the advertising service.
  ///
  /// This method should be called before any other ad-related operations.
  Future<void> init();

  /// Retrieves a banner ad.
  ///
  /// The `context` is used to determine the appropriate ad size.
  /// Returns a `Future` that completes with a `BannerAd` if successful,
  /// otherwise `null`.
  Future<BannerAd?> getBannerAd({
    required BuildContext context,
  });

  /// Loads an interstitial ad.
  void loadInterstitialAd();

  /// Shows an interstitial ad.
  void showInterstitialAd();
}
