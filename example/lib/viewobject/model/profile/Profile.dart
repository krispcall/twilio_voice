import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/profile/ProfileData.dart';

class Profile extends Object<Profile>
{
  Profile({
    this.profile,
  });

  ProfileData profile;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  Profile fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return Profile(profile: ProfileData().fromMap(dynamicData['profile']),);
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(Profile object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['workspace'] = ProfileData().toMap(object.profile);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<Profile> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<Profile> userData = <Profile>[];
    if (dynamicDataList != null)
    {
      for (dynamic dynamicData in dynamicDataList)
      {
        if (dynamicData != null)
        {
          userData.add(fromMap(dynamicData));
        }
      }
    }
    return userData;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<Profile> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (Profile data in objectList)
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