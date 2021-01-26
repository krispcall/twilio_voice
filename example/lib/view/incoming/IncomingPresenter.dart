
import 'package:voice_example/base/BasePresenter.dart';
import 'package:voice_example/db/DaoLogin.dart';
import 'package:voice_example/repository/AuthRepository.dart';
import 'package:voice_example/repository/ContentRepository.dart';
import 'package:voice_example/repository/NetworkRepository.dart';
import 'package:voice_example/repository/SecureStorageRepository.dart';
import 'IncomingViewCallback.dart';

class IncomingPresenter extends BasePresenter<IncomingViewCallback> {
  NetworkRepository networkRepo;
  ContentRepository contentRepo;
  AuthRepository authRepo;
  SecureStorageRepository secureStorageRepo;
  DaoLogin daoLogin;
  IncomingPresenter(this.contentRepo,this.secureStorageRepo,this.networkRepo,this.authRepo,this.daoLogin);

  String primaryKey = 'id';

  @override
  init()
  {
    super.init();
  }

  @override
  void dispose()
  {
    isDispose=true;

    super.dispose();
  }

  @override
  onConnectionChanged(bool isConnection)
  {
    isConnectedToInternet=isConnection;
    view.onCheckInternetComplete(isConnection);
  }

  void onBackPressed()
  {
    view.onBackPressed();
  }
}
