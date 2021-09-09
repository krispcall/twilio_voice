import 'package:voice_example/viewobject/common/Object.dart';

class RecentSearch extends Object<RecentSearch>
{
  RecentSearch({
    this.recentSearch,
  });

  String recentSearch;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  RecentSearch fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return RecentSearch(recentSearch:dynamicData['recentSearch']);
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(RecentSearch object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['recentSearch'] = object.recentSearch;
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<RecentSearch> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<RecentSearch> userData = <RecentSearch>[];
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
  List<Map<String, dynamic>> toMapList(List<RecentSearch> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (RecentSearch data in objectList)
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