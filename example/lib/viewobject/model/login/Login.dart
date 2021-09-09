
import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/error/ResponseError.dart';
import 'package:voice_example/viewobject/model/login/LoginData.dart';

class Login extends Object<Login>
{
  Login({
    this.status,
    this.data,
    this.error,
  });

  int status;
  LoginData data;
  ResponseError error;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  Login fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return Login(
        status: dynamicData['status'],
        data: LoginData().fromMap(dynamicData['data']),
        error: ResponseError().fromMap(dynamicData['error']),
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(Login object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['status'] = object.status;
      data['data'] = LoginData().toMap(object.data);
      data['error'] = ResponseError().toMap(object.error);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<Login> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<Login> login = <Login>[];

    if (dynamicDataList != null)
    {
      for (dynamic dynamicData in dynamicDataList)
      {
        if (dynamicData != null)
        {
          login.add(fromMap(dynamicData));
        }
      }
    }
    return login;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<Login> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (Login data in objectList)
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