import 'package:firebase_admob/firebase_admob.dart';

class AdvertService {
  // static final AdvertService _instance = AdvertService._internal();
  // factory AdvertService() => _instance;
  // MobileAdTargetingInfo _targetingInfo;
  // final String _bannerAd = 'ca-app-pub-5871102290640680/4495050102';
  // final String _insertAd = 'ca-app-pub-5871102290640680/6738070067';
  // AdvertService._internal() {
  //   _targetingInfo = MobileAdTargetingInfo();
  // }

  // showBanner() {
  //   BannerAd banner = BannerAd(
  //     adUnitId: _bannerAd,
  //     size: AdSize.smartBanner,
  //     targetingInfo: _targetingInfo,
  //   );

  //   banner
  //     ..load()
  //     ..show(anchorOffset:56);

  //   banner.dispose();
  // }

  // showIntersitial() {
  //   InterstitialAd interstitialAd = InterstitialAd(
  //     adUnitId: _insertAd,
  //     targetingInfo: _targetingInfo,
  //   );
  //   interstitialAd
  //     ..load()
  //     ..show();
  //   interstitialAd.dispose();
  // }
  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['flutterio', 'beautiful apps'],
    contentUrl: 'https://flutter.io',
    childDirected: false, // or MobileAdGender.female, MobileAdGender.unknown
    testDevices: <String>[], // Android emulators are considered test devices
  );

  BannerAd bannerAd() {
    return BannerAd(
      // Replace the testAdUnitId with an ad unit id from the AdMob dash.
      // https://developers.google.com/admob/android/test-ads
      // https://developers.google.com/admob/ios/test-ads
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );
  }

  InterstitialAd interstitialAd() {
    return InterstitialAd(
      // Replace the testAdUnitId with an ad unit id from the AdMob dash.
      // https://developers.google.com/admob/android/test-ads
      // https://developers.google.com/admob/ios/test-ads
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );
  }
}
