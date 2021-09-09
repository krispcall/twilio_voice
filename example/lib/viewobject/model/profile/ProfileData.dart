
import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/error/ResponseError.dart';
import 'package:voice_example/viewobject/model/login/UserProfile.dart';

class ProfileData extends Object<ProfileData>
{
  ProfileData({
    this.status,
    this.data,
    this.error,
  });

  int status;
  UserProfile data;
  ResponseError error;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  ProfileData fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return ProfileData(
        status: dynamicData['status'],
        data: UserProfile().fromMap(dynamicData['data']),
        error: ResponseError().fromMap(dynamicData['error']),
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(ProfileData object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['status'] = object.status;
      data['data'] = UserProfile().toMap(object.data);
      data['error'] = ResponseError().toMap(object.error);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<ProfileData> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<ProfileData> login = <ProfileData>[];

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
  List<Map<String, dynamic>> toMapList(List<ProfileData> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (ProfileData data in objectList)
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