import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/memberLogin/MemberLogin.dart';

class Member extends Object<Member>
{
  Member({
    this.data,
  });

  MemberLogin data;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  Member fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return Member(data: MemberLogin().fromMap(dynamicData['memberLogin']));
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(Member object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['data'] = MemberLogin().toMap(object.data);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<Member> fromMapList(List<dynamic> dynamicDataList) {
    final List<Member> login = <Member>[];

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
  List<Map<String, dynamic>> toMapList(List<Member> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (Member data in objectList)
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
