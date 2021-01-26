


import 'package:voice_example/base/BaseViewCallback.dart';

abstract class IncomingViewCallback extends BaseViewCallback {
  gotoLandingScreen();
  onCheckInternetComplete(bool isConnection);
  gotoSplashView();
  onBackPressed();
}

