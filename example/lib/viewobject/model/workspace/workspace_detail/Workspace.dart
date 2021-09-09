import 'package:voice_example/viewobject/common/Object.dart';

import 'WorkspaceData.dart';

class Workspace extends Object<Workspace>
{
  Workspace({
    this.workspace,
  });

  WorkspaceData workspace;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  Workspace fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return Workspace(workspace: WorkspaceData().fromMap(dynamicData['workspace']));
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(Workspace object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['workspace'] = WorkspaceData().toMap(object.workspace);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<Workspace> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<Workspace> userData = <Workspace>[];
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
  List<Map<String, dynamic>> toMapList(List<Workspace> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (Workspace data in objectList)
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