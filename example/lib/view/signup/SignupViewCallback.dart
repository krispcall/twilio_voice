
import 'package:voice_example/base/BaseViewCallback.dart';

abstract class SignUpViewCallback extends BaseViewCallback {
  onBackPressed();
  onCheckInternetComplete(bool isConnection);
  gotoSplashView();
  gotoLoginView();
}
