import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService{
  static String get bannerAdUnitId => Platform.isAndroid ? 'ca-app-pub-1569743014889874~9216601509' :
  'ca-app-pub-1569743014889874~9216601509';

  static initialize(){
    if(MobileAds.instance==null){
      MobileAds.instance.initialize();

    }

  }
  static BannerAd creatBannerAd(){
    BannerAd ad = new BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.largeBanner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad)=> print('Ad Loaded'),
        onAdFailedToLoad: (Ad ad,LoadAdError error){
          ad.dispose();

        },
        onAdOpened: (Ad ad) => print('Ad Opened'),
        onAdClosed: (Ad ad) => print('ad closed'),
      ),


    );
    return ad;
  }
}