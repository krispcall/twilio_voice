

import 'package:connectivity/connectivity.dart';
import 'package:voice_example/response/ResponseCallAccessToken.dart';
import 'package:voice_example/response/ResponseFormat.dart';
import 'package:voice_example/response/ResponseLogin.dart';
import 'package:voice_example/response/ResponseUni.dart';

abstract class ContentRepository {
  Future<ConnectivityResult> checkConnection();
  Future<ResponseFormat<R>> doApiGetCall<T extends ResponseUni<dynamic>, R>(T obj, String url);
  Future<ResponseFormat<R>> doApiPostCall<T extends ResponseUni<dynamic>, R>(T obj, String url, Map<String, dynamic> map);
  Future<ResponseFormat<ResponseLogin>> doLoginApiCall(Map<String, dynamic> map);
  Future<ResponseFormat<ResponseCallAccessMobileToken>> doCallAccessMobileTokenApiCall();

}
