import 'package:voice_example/viewobject/common/Object.dart';

class WorkspaceTag extends Object<WorkspaceTag>
{
  WorkspaceTag({
    this.id,
    this.title,
  });

  String id;
  String title;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  WorkspaceTag fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return WorkspaceTag(
        id: dynamicData['id'],
        title: dynamicData['title'],
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(WorkspaceTag object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['title'] = object.title;
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<WorkspaceTag> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<WorkspaceTag> userData = <WorkspaceTag>[];
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
  List<Map<String, dynamic>> toMapList(List<WorkspaceTag> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (WorkspaceTag data in objectList)
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