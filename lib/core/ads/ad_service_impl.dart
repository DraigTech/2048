import 'dart:async';

import 'package:draig_2048/core/ads/ad_service.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Concrete implementation of [AdService] using Google Mobile Ads.
///
/// This class handles the initialization and display of various ad formats
/// provided by the Google Mobile Ads SDK.
class AdServiceImpl extends AdService {
  InterstitialAd? _interstitialAd;

  @override
  Future<void> init() async {
    await MobileAds.instance.initialize();
  }

  @override
  Future<void> loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: 'ca-app-pub-5795313355924108/5085282664',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (err) {
          debugPrint('InterstitialAd failed to load: $err');
        },
      ),
    );
  }

  @override
  Future<void> showInterstitialAd() async {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) async {
          await ad.dispose();
          await loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, err) async {
          debugPrint('InterstitialAd failed to show: $err');
          await ad.dispose();
          await loadInterstitialAd();
        },
      );
      await _interstitialAd!.show();
      _interstitialAd = null;
    }
  }

  @override
  Future<BannerAd?> getBannerAd({
    required BuildContext context,
  }) async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.of(context).size.width.truncate(),
    );

    if (size == null) {
      // Unable to get width of anchored banner.
      return null;
    }

    final bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/9214589741',
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          // Called when an ad is successfully received.
          debugPrint('Ad was loaded.');
        },
        onAdFailedToLoad: (ad, err) async {
          // Called when an ad request failed.
          debugPrint('Ad failed to load with error: $err');
          await ad.dispose();
        },
      ),
    );

    await bannerAd.load();
    return bannerAd;
  }
}
