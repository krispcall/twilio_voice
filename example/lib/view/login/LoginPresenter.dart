

import 'dart:async';
import 'package:voice_example/base/BasePresenter.dart';
import 'package:voice_example/db/DaoLogin.dart';
import 'package:voice_example/enum/StatusEnum.dart';
import 'package:voice_example/repository/AuthRepository.dart';
import 'package:voice_example/repository/ContentRepository.dart';
import 'package:voice_example/repository/NetworkRepository.dart';
import 'package:voice_example/repository/SecureStorageRepository.dart';
import 'package:voice_example/request/RequestLogin.dart';
import 'package:voice_example/response/ResponseCallAccessToken.dart';
import 'package:voice_example/response/ResponseFormat.dart';
import 'package:voice_example/response/ResponseLogin.dart';
import 'package:voice_example/string/Strings.dart';

import 'LoginViewCallback.dart';

class LoginPresenter extends BasePresenter<LoginViewCallback> {
  NetworkRepository networkRepo;
  ContentRepository contentRepo;
  AuthRepository authRepo;
  SecureStorageRepository secureStorageRepo;
  DaoLogin daoLogin;
  LoginPresenter(this.contentRepo,this.secureStorageRepo,this.networkRepo,this.authRepo,this.daoLogin);

  ResponseFormat<ResponseLogin> responseLogin=ResponseFormat<ResponseLogin>(Status.NO_ACTION, '', null);
  StreamSubscription<ResponseFormat<ResponseLogin>> subscriptionLogin;
  StreamController<ResponseFormat<ResponseLogin>> streamControllerLogin;

  String primaryKey = 'id';

  @override
  init()
  {
    super.init();
    streamControllerLogin = StreamController<ResponseFormat<ResponseLogin>>.broadcast();
    subscriptionLogin =streamControllerLogin.stream.listen((ResponseFormat<ResponseLogin> responseFormat)
    {
      this.responseLogin = responseFormat;

      if (this.responseLogin != null && this.responseLogin.value != null)
      {
        notifyListeners();
      }
    });
  }

  @override
  void dispose()
  {
    subscriptionLogin.cancel();
    streamControllerLogin.close();

    isDispose=true;

    super.dispose();
  }

  @override
  onConnectionChanged(bool isConnection)
  {
    isConnectedToInternet=isConnection;
    view.onCheckInternetComplete(isConnection);
  }

  doLoginApiCall(RequestLogin requestLogin) async
  {
    isConnectedToInternet = isConnection(await contentRepo.checkConnection());
    view.showProgress();
    if (isConnectedToInternet)
    {
      final ResponseFormat<ResponseLogin> responseFormat = await contentRepo.doLoginApiCall(requestLogin.toMap());

      if (responseFormat.value!=null)
      {
        await daoLogin.deleteAll();
        await daoLogin.insert(primaryKey, responseFormat.value);
        if(!streamControllerLogin.isClosed)
        {
          streamControllerLogin.sink.add(responseFormat);
          secureStorageRepo.saveApiToken("Bearer "+responseFormat.value.accessToken);
          doCallAccessMobileTokenApiCall();
        }
        view.hideProgress();
      }
      else
      {
        view.showMessage(Strings.error);
        view.hideProgress();
      }
    }
    else
    {
      view.hideProgress();
    }
  }

  doCallAccessMobileTokenApiCall() async
  {
    isConnectedToInternet = isConnection(await contentRepo.checkConnection());
    view.showProgress();
    if (isConnectedToInternet)
    {
      final ResponseFormat<ResponseCallAccessMobileToken> responseFormat = await contentRepo.doCallAccessMobileTokenApiCall();

      if (responseFormat.value!=null)
      {
        secureStorageRepo.saveLoginId(responseFormat.value.token);
        view.configureNotification(responseFormat.value.token);
        view.hideProgress();
      }
      else
      {
        view.showMessage(Strings.error);
        view.hideProgress();
      }
    }
    else
    {
      view.hideProgress();
    }
  }

  void onBackPressed()
  {
    view.onBackPressed();
  }
}
