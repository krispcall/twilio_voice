
import 'RequestUni.dart';

class RequestLogin extends RequestUni<RequestLogin> {
  RequestLogin({
    this.email,
    this.password,
  });

  String email;
  String password;

  @override
  RequestLogin fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return RequestLogin(
        email : dynamicData['username'],
        password : dynamicData['password'],
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap()
  {
    var data = Map<String, dynamic>();
    data['username'] = email;
    data['password'] = password;
    return data;
  }

  RequestLogin.fromJson(Map<String, dynamic> json) {
    email = (json['username']);
    password = (json['password']);
  }
}
