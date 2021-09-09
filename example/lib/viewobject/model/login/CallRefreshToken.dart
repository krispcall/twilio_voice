import 'package:voice_example/viewobject/common/Object.dart';

class CallRefreshToken extends Object<CallRefreshToken>
{
  CallRefreshToken({this.apiToken,this.identity});
  String  apiToken;
  String  identity;
  @override
  String getPrimaryKey()
  {
    return '';
  }

  @override
  CallRefreshToken fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return CallRefreshToken(
          apiToken: dynamicData['access_token'],
          identity: dynamicData['identity']);
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['access_token'] =object.apiToken;
      data['identity'] = object.identity;
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<CallRefreshToken> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<CallRefreshToken> psAppInfoList = <CallRefreshToken>[];

    if (dynamicDataList != null)
    {
      for (dynamic json in dynamicDataList)
      {
        if (json != null)
        {
          psAppInfoList.add(fromMap(json));
        }
      }
    }
    return psAppInfoList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<dynamic> objectList)
  {
    final List<dynamic> dynamicList = <dynamic>[];
    if (objectList != null)
    {
      for (dynamic data in objectList)
      {
        if (data != null)
        {
          dynamicList.add(toMap(data));
        }
      }
    }

    return dynamicList;
  }
}