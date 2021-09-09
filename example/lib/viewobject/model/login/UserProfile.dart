
import 'package:voice_example/viewobject/common/Object.dart';

class UserProfile extends Object<UserProfile>
{
  UserProfile({
    this.status,
    this.profilePicture,
    this.firstName,
    this.lastName,
    this.email,
    this.defaultLanguage,
    this.defaultWorkspace,
    this.stayOnline,
  });

  String status;
  String profilePicture;
  String firstName;
  String lastName;
  String email;
  String defaultLanguage;
  String defaultWorkspace;
  bool stayOnline;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  UserProfile fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return UserProfile(
        status: dynamicData['status'],
        profilePicture: dynamicData['profilePicture'],
        firstName: dynamicData['firstname'],
        lastName: dynamicData['lastname'],
        email: dynamicData['email'],
        defaultLanguage: dynamicData['defaultLanguage'],
        defaultWorkspace: dynamicData['defaultWorkspace'],
        stayOnline: dynamicData['stayOnline'],
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(UserProfile object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['status'] = object.status;
      data['profilePicture'] = object.profilePicture;
      data['firstname'] = object.firstName;
      data['lastname'] = object.lastName;
      data['email'] = object.email;
      data['defaultLanguage'] = object.defaultLanguage;
      data['defaultWorkspace'] = object.defaultWorkspace;
      data['stayOnline'] = object.stayOnline;
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<UserProfile> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<UserProfile> userProfile = <UserProfile>[];
    if (dynamicDataList != null)
    {
      for (dynamic dynamicData in dynamicDataList)
      {
        if (dynamicData != null)
        {
          userProfile.add(fromMap(dynamicData));
        }
      }
    }
    return userProfile;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<UserProfile> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (UserProfile data in objectList)
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
