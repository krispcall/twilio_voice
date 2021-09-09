
import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/login/LoginDataDetails.dart';

class LoginData extends Object<LoginData>
{
  LoginData({
    this.token,
    this.details,
  });

  String token;
  LoginDataDetails details;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  LoginData fromMap(dynamic dynamicData)
  {
    if (dynamicData != null) {
      return LoginData(
        token: dynamicData['token'],
        details: LoginDataDetails().fromMap(dynamicData['details']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(LoginData object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['token'] = object.token;
      data['details'] = LoginDataDetails().toMap(object.details);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<LoginData> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<LoginData> data = <LoginData>[];

    if (dynamicDataList != null)
    {
      for (dynamic dynamicData in dynamicDataList)
      {
        if (dynamicData != null)
        {
          data.add(fromMap(dynamicData));
        }
      }
    }
    return data;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<LoginData> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (LoginData data in objectList)
      {
        if (data != null)
        {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}