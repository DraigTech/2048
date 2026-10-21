import 'dart:async';

import 'package:draig_2048/core/ads/ad_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// A widget that displays a banner ad.
class MyAdsWidget extends StatefulWidget {
  /// Creates a [MyAdsWidget] instance.
  const MyAdsWidget({super.key});

  @override
  State<MyAdsWidget> createState() => _MyAdsWidgetState();
}

class _MyAdsWidgetState extends State<MyAdsWidget> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    unawaited(_loadAd());
  }

  Future<void> _loadAd() async {
    /// Initialize ads
    final adService = context.read<AdService>();
    await adService.init();
    adService.loadInterstitialAd();

    if (mounted) {
      /// Get banner ad
      final ad = await adService.getBannerAd(context: context);
      setState(() {
        _bannerAd = ad;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bannerAd = _bannerAd;
    if (bannerAd != null) {
      return Focus(
        focusNode: FocusNode(
          canRequestFocus: false,
          descendantsAreFocusable: false,
        ),
        child: SizedBox(
          width: bannerAd.size.width.toDouble(),
          height: bannerAd.size.height.toDouble(),
          child: AdWidget(ad: bannerAd),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Future<void> dispose() async {
    await _bannerAd?.dispose();
    super.dispose();
  }
}
