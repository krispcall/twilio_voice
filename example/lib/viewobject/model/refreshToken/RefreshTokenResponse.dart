import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/refreshToken/RefreshTokenResponseData.dart';

class RefreshTokenResponse extends Object<RefreshTokenResponse>
{
  RefreshTokenResponse({
    this.refreshTokenResponseData,
  });

  RefreshTokenResponseData refreshTokenResponseData;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  RefreshTokenResponse fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return RefreshTokenResponse(refreshTokenResponseData: RefreshTokenResponseData().fromMap(dynamicData['refreshToken']));
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(RefreshTokenResponse object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['refreshToken'] = RefreshTokenResponseData().toMap(object.refreshTokenResponseData);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<RefreshTokenResponse> fromMapList(List<dynamic> dynamicDataList) {
    final List<RefreshTokenResponse> login = <RefreshTokenResponse>[];

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
  List<Map<String, dynamic>> toMapList(List<RefreshTokenResponse> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (RefreshTokenResponse data in objectList)
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
