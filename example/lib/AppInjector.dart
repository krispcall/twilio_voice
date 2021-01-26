
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:voice_example/repository/AuthRepository.dart';
import 'package:voice_example/repository/AuthRepositoryImpl.dart';
import 'package:voice_example/repository/ContentRepository.dart';
import 'package:voice_example/repository/NetworkRepository.dart';
import 'package:voice_example/repository/NetworkRepositoryImpl.dart';
import 'package:voice_example/repository/SecureStorageRepository.dart';
import 'package:voice_example/repository/SecureStorageRepositoryImpl.dart';
import 'package:voice_example/view/incoming/IncomingPresenter.dart';
import 'package:voice_example/view/login/LoginPresenter.dart';
import 'package:voice_example/view/signup/SignupPresenter.dart';
import 'package:voice_example/view/splash/SplashPresenter.dart';
import 'db/DaoLogin.dart';
import 'repository/ContentRepositoryImpl.dart';

class AppInjector {
  static const String BASE_URL = "base_url";

  static inject() {
    final injector = Injector.getInjector();

    //strings
    injector.map<String>((i) => "http://128.199.75.138/api/", key: BASE_URL);

    //repositories
    injector.map<NetworkRepository>((i) => NetworkRepositoryImpl(), isSingleton: true);
    injector.map<SecureStorageRepository>((i) => SecureStorageRepositoryImpl(), isSingleton: true);
    injector.map<AuthRepository>((i) => AuthRepositoryImpl(i.get()), isSingleton: true);
    injector.map<ContentRepository>((i) => ContentRepositoryImpl(), isSingleton: true);
    injector.map<DaoLogin>((i) => DaoLogin(), isSingleton: true);

    //presenters
    injector.map<SplashPresenter>((i) => SplashPresenter(i.get(),i.get(),i.get()));
    injector.map<LoginPresenter>((i) => LoginPresenter(i.get(),i.get(),i.get(),i.get(),i.get()));
    injector.map<SignUpPresenter>((i) => SignUpPresenter(i.get(),i.get(),i.get(),i.get(),i.get()));
    injector.map<IncomingPresenter>((i) => IncomingPresenter(i.get(),i.get(),i.get(),i.get(),i.get()));
  }
}
