import 'dart:async';
import 'package:http/http.dart' as http;
import 'AuthRepository.dart';
import 'SecureStorageRepository.dart';

class AuthRepositoryImpl extends AuthRepository {

  String baseUrl;
  String _results = 'data';
  SecureStorageRepository secureRepo;
  AuthRepository authRepo;

  AuthRepositoryImpl(this.secureRepo);

  @override
  Future<bool> isLoggedIn() async {
    final token = await secureRepo.getApiToken();
    return Future.value(token != null);
  }

  @override
  Future<bool> authorize() async
  {
    String banner="https://api.stopgrab.com/public/api/myprofile";

    var map = new Map<String, dynamic>();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/x-www-form-urlencoded',
      'Authorization':'Bearer '+ await secureRepo.getApiToken(),
    };
    final response = await http.post(
        Uri.parse('$banner?$_results=${toString()}'),
        headers: requestHeaders,
        body: map);
    if (response.statusCode >= 200 && response.statusCode<300)
    {
      return true;
    }
    else if(response.statusCode ==401)
    {
      logout();
      return false;
    }
    else{
      return true;
    }
  }

  @override
  Future<bool> logout() async {
    await secureRepo.deleteApiToken();
    await secureRepo.deleteLoginId();
    return true;
  }

}
