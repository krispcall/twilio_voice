import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/allContact/AllContactEdges.dart';
import 'package:voice_example/viewobject/model/pagination/PageInfo.dart';

class AllContactData extends Object<AllContactData>
{
  AllContactData({
    this.contactEdges,
    this.pageInfo,
  });

  List<AllContactEdges> contactEdges;
  PageInfo pageInfo;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  AllContactData fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return AllContactData(
        contactEdges: AllContactEdges().fromMapList(dynamicData['edges']),
        pageInfo: PageInfo().fromMap(dynamicData['pageInfo']),
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(AllContactData object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['edges'] = AllContactEdges().toMapList(object.contactEdges);
      data['pageInfo'] = PageInfo().toMap(object.pageInfo);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<AllContactData> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<AllContactData> basketList = <AllContactData>[];

    if (dynamicDataList != null)
    {
      for (dynamic dynamicData in dynamicDataList)
      {
        if (dynamicData != null)
        {
          basketList.add(fromMap(dynamicData));
        }
      }
    }
    return basketList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<AllContactData> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (AllContactData data in objectList)
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