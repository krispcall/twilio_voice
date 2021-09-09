import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/members/MemberEdges.dart';
import 'package:voice_example/viewobject/model/pagination/PageInfo.dart';

class MemberData extends Object<MemberData>
{
  List<MemberEdges> memberEdges;
  PageInfo pageInfo;

  MemberData({this.memberEdges, this.pageInfo});

  @override
  MemberData fromMap(dynamicData)
  {
    if (dynamicData != null)
    {
      return MemberData(
        memberEdges: MemberEdges().fromMapList(dynamicData['edges']),
        pageInfo: PageInfo().fromMap(dynamicData['pageInfo']),
      );
    }
    else
    {
      return null;
    }
  }

  @override
  List<MemberData> fromMapList(List dynamicDataList)
  {
    final List<MemberData> data = <MemberData>[];

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
    return "";
  }

  @override
  Map<String, dynamic> toMap(MemberData object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['edges'] = MemberEdges().toMapList(object.memberEdges);
      data['pageInfo'] = PageInfo().toMap(object.pageInfo);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<Map<String, dynamic>> toMapList(List<MemberData> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (MemberData data in objectList)
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