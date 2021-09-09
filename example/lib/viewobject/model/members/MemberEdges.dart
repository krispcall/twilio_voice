import 'package:azlistview/azlistview.dart';
import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/members/Members.dart';

class MemberEdges extends Object<MemberEdges> implements ISuspensionBean
{
  String cursor;
  Members members;
  String tagIndex;
  String namePinyin;
  bool isChecked = false;

  MemberEdges({this.cursor, this.members});

  @override
  MemberEdges fromMap(dynamicData)
  {
    if (dynamicData != null)
    {
      return MemberEdges(
        cursor: dynamicData['cursor'],
        members: Members().fromMap(dynamicData['node']),
      );
    } else {
      return null;
    }
  }

  @override
  List<MemberEdges> fromMapList(List dynamicDataList)
  {
    final List<MemberEdges> data = <MemberEdges>[];

    if (dynamicDataList != null)
    {
      for (dynamic dynamicData in dynamicDataList)
      {
        if (dynamicData != null) {
          data.add(fromMap(dynamicData));
        }
      }
    }
    return data;
  }

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  Map<String, dynamic> toMap(MemberEdges object)
  {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['cursor'] = object.cursor;
      data['node'] = Members().toMap(object.members);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Map<String, dynamic>> toMapList(List<MemberEdges> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (MemberEdges data in objectList)
      {
        if (data != null)
        {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }

  @override
  String getSuspensionTag() => tagIndex;

  @override
  bool isShowSuspension;
}