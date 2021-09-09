import 'package:voice_example/viewobject/common/Object.dart';

class MemberLoginData extends Object<MemberLoginData>
{
  MemberLoginData({this.accessToken, this.refreshToken});

  String accessToken;
  String refreshToken;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  MemberLoginData fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return MemberLoginData(
        accessToken: dynamicData['accessToken'],
        refreshToken: dynamicData['refreshToken'],
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(MemberLoginData object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['accessToken'] = object.accessToken;
      data['refreshToken'] = object.refreshToken;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<MemberLoginData> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<MemberLoginData> login = <MemberLoginData>[];

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
  List<Map<String, dynamic>> toMapList(List<MemberLoginData> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (MemberLoginData data in objectList)
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
