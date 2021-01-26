
import 'dart:async';
import 'package:voice_example/base/BasePresenter.dart';
import 'package:voice_example/db/DaoLogin.dart';
import 'package:voice_example/enum/StatusEnum.dart';
import 'package:voice_example/repository/AuthRepository.dart';
import 'package:voice_example/repository/ContentRepository.dart';
import 'package:voice_example/repository/NetworkRepository.dart';
import 'package:voice_example/repository/SecureStorageRepository.dart';
import 'package:voice_example/response/ResponseFormat.dart';
import 'package:voice_example/response/ResponseLogin.dart';
import 'SignupViewCallback.dart';

class SignUpPresenter extends BasePresenter<SignUpViewCallback> {

  NetworkRepository networkRepo;
  ContentRepository contentRepo;
  AuthRepository authRepo;
  SecureStorageRepository secureStorageRepo;
  DaoLogin daoLogin;
  SignUpPresenter(this.contentRepo,this.secureStorageRepo,this.authRepo,this.networkRepo,this.daoLogin);

  ResponseFormat<ResponseLogin> responseSignUp=ResponseFormat<ResponseLogin>(Status.NO_ACTION, '', null);
  StreamSubscription<ResponseFormat<ResponseLogin>> subscriptionSignUp;
  StreamController<ResponseFormat<ResponseLogin>> streamControllerSignUp;

  String primaryKey = 'id';

  @override
  init()
  {
    super.init();
    streamControllerSignUp = StreamController<ResponseFormat<ResponseLogin>>.broadcast();
    subscriptionSignUp =streamControllerSignUp.stream.listen((ResponseFormat<ResponseLogin> responseFormat)
    {
      this.responseSignUp = responseFormat;

      if (this.responseSignUp != null && this.responseSignUp.value != null)
      {
        notifyListeners();
      }
    });
  }

  @override
  void dispose()
  {
    subscriptionSignUp.cancel();
    streamControllerSignUp.close();

    isDispose=true;

    super.dispose();
  }

  @override
  onConnectionChanged(bool isConnection)
  {
    isConnectedToInternet=isConnection;
    view.onCheckInternetComplete(isConnection);
  }

  void onBackPressed() {
    view.onBackPressed();
  }

  void gotoLoginView()
  {
    if(isConnectedToInternet)
    {
      view.gotoLoginView();
    }
    else
    {

    }
  }
}
