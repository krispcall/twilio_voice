import 'package:voice_example/viewobject/common/MapObject.dart';

class PageInfo  extends MapObject<PageInfo>
{
  PageInfo({
    this.startCursor,
    this.endCursor,
    this.hasNextPage,
    this.hasPreviousPage
  });

  String startCursor;
  String endCursor;
  bool hasNextPage;
  bool hasPreviousPage;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  PageInfo fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return PageInfo(
        startCursor: dynamicData['startCursor'],
        endCursor: dynamicData['endCursor'],
        hasNextPage: dynamicData['hasNextPage'],
        hasPreviousPage: dynamicData['hasPreviousPage'],
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(PageInfo object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['startCursor'] = object.startCursor;
      data['endCursor'] = object.endCursor;
      data['hasNextPage'] = object.hasNextPage;
      data['hasPreviousPage'] = object.hasPreviousPage;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<PageInfo> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<PageInfo> basketList = <PageInfo>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          basketList.add(fromMap(dynamicData));
        }
      }
    }
    return basketList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<PageInfo> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (PageInfo data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }

  @override
  List<String> getIdList(List<dynamic> mapList) {
    final List<String> idList = <String>[];
    if (mapList != null) {
      for (dynamic messages in mapList) {
        if (messages != null) {
          idList.add(messages.id);
        }
      }
    }
    return idList;
  }

  @override
  List<String> getIdByKeyValue(List<dynamic> mapList,var key, var value)
  {
    // TODO: implement getIdByKeyValue
    throw UnimplementedError();
  }
}
