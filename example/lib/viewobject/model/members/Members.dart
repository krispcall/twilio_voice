import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/members/MemberNumber.dart';

class Members extends Object<Members>
{
  String id;
  String firstName;
  String lastName;
  String role;
  String gender;
  String email;
  String createdOn;
  String profilePicture;
  bool online;
  int unSeenMsgCount;
  List<MemberNumber> numbers;
  bool onCall;

  Members({
    this.id,
    this.firstName,
    this.lastName,
    this.role,
    this.gender,
    this.email,
    this.createdOn,
    this.profilePicture,
    this.numbers,
    this.online,
    this.unSeenMsgCount,
    this.onCall,
  });

  @override
  Members fromMap(dynamicData)
  {
    if (dynamicData != null)
    {
      return Members(
        id: dynamicData['id'],
        firstName: dynamicData['firstname'],
        lastName: dynamicData['lastname'],
        role: dynamicData['role'],
        gender: dynamicData['gender'],
        email: dynamicData['email'],
        createdOn: dynamicData['createdOn'],
        profilePicture: dynamicData['profilePicture'],
        online: dynamicData['online'],
        unSeenMsgCount: dynamicData['unSeenMsgCount'],
        numbers: MemberNumber().fromMapList(dynamicData['numbers']),
          onCall: dynamicData['onCall'],
      );
    }
    else
    {
      return null;
    }
  }

  @override
  List<Members> fromMapList(List dynamicDataList)
  {
    final List<Members> data = <Members>[];

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
  String getPrimaryKey()
  {
    return "id";
  }

  @override
  Map<String, dynamic> toMap(Members object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['firstname'] = object.firstName;
      data['lastname'] = object.lastName;
      data['role'] = object.role;
      data['gender'] = object.gender;
      data['email'] = object.email;
      data['createdOn'] = object.createdOn;
      data['profilePicture'] = object.profilePicture;
      data['online'] = object.online;
      data['unSeenMsgCount'] = object.unSeenMsgCount;
      data['numbers'] = MemberNumber().toMapList(object.numbers);
      data['onCall'] = object.onCall;
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<Map<String, dynamic>> toMapList(List<Members> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (Members data in objectList)
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