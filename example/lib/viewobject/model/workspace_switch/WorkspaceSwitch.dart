import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/workspace_switch/WorkspaceSwitchData.dart';

class WorkspaceSwitch extends Object<WorkspaceSwitch>
{
  WorkspaceSwitch({
    this.workspaceSwitch,
  });

  WorkspaceSwitchData workspaceSwitch;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  WorkspaceSwitch fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return WorkspaceSwitch(workspaceSwitch: WorkspaceSwitchData().fromMap(dynamicData['changeDefaultWorkspace']),);
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(WorkspaceSwitch object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['workspace'] = WorkspaceSwitchData().toMap(object.workspaceSwitch);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<WorkspaceSwitch> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<WorkspaceSwitch> userData = <WorkspaceSwitch>[];
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
  List<Map<String, dynamic>> toMapList(List<WorkspaceSwitch> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (WorkspaceSwitch data in objectList)
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