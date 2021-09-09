import 'package:voice_example/viewobject/common/Object.dart';

class RefreshToken extends Object<RefreshToken>
{
  RefreshToken({this.accessToken});

  String accessToken;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  RefreshToken fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return RefreshToken(
        accessToken: dynamicData['accessToken'],
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(RefreshToken object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['accessToken'] = object.accessToken;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<RefreshToken> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<RefreshToken> login = <RefreshToken>[];

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
  List<Map<String, dynamic>> toMapList(List<RefreshToken> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (RefreshToken data in objectList)
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
