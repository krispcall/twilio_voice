

import 'package:voice_example/base/BasePresenter.dart';
import 'package:voice_example/repository/AuthRepository.dart';
import 'package:voice_example/repository/NetworkRepository.dart';
import 'package:voice_example/repository/SecureStorageRepository.dart';

import 'SplashView.dart';

class SplashPresenter extends BasePresenter<SplashState> {
  NetworkRepository networkRepo;
  AuthRepository authRepo;
  SecureStorageRepository securestorageRepo;
  SplashPresenter(this.networkRepo,this.securestorageRepo,this.authRepo);

  @override
  init()
  {
    super.init();
    checkConnection();
  }

  @override
  void dispose()
  {
    isDispose=true;

    super.dispose();
  }

  checkConnection() async {
    print("checkConnection SplashPresenter");
    networkRepo.checkConnection().then((connectivityResult)
    {
      view.onCheckInternetComplete(isConnection(connectivityResult));
    }).catchError((error) {
      view.onError(error);
    });
  }
}
