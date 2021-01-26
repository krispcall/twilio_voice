


import 'package:voice_example/base/BaseViewCallback.dart';

abstract class LoginViewCallback extends BaseViewCallback {
  gotoLandingScreen();
  onCheckInternetComplete(bool isConnection);
  gotoSplashView();
  onBackPressed();
  configureNotification(String apiToken);
}

