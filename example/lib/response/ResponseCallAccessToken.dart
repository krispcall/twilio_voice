
import 'ResponseUni.dart';

class ResponseCallAccessMobileToken extends ResponseUni<ResponseCallAccessMobileToken> {
  String token;
  String identity;

  ResponseCallAccessMobileToken({this.token, this.identity});

  ResponseCallAccessMobileToken.fromJson(Map<String, dynamic> json) {
    token=(json['token']).toString();
    identity=json['identity'];
  }

  @override
  ResponseCallAccessMobileToken fromMap(dynamic dynamicData) {
    if (dynamicData != null)
    {
      return ResponseCallAccessMobileToken(
        token: dynamicData['token'],
        identity: dynamicData['identity'],
      );
    }
    else
    {
      return null;
    }
  }

  @override
  String getPrimaryKey() {
    return '';
  }

  @override
  Map<String, dynamic> toMap(ResponseCallAccessMobileToken object) {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['token'] = object.token;
      data['identity'] = object.identity;
      return data;
    }
    else
    {
      return null;
    }
  }
}