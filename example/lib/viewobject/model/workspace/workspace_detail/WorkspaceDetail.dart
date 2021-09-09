import 'package:voice_example/viewobject/common/Object.dart';

import 'WorkspaceChannel.dart';
import 'WorkspaceMember.dart';
import 'WorkspaceTag.dart';
import 'WorkspaceTeam.dart';

class WorkspaceDetail extends Object<WorkspaceDetail>
{
  WorkspaceDetail({
    this.id,
    this.title,
    this.notification,
    this.photo,
    this.workspaceTeam,
    this.workspaceMember,
    this.workspaceChannel,
    this.workspaceTag,
  });

  String id;
  String title;
  bool notification;
  String photo;

  List<WorkspaceTeam> workspaceTeam;
  List<WorkspaceMember> workspaceMember;
  List<WorkspaceChannel> workspaceChannel;
  List<WorkspaceTag> workspaceTag;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  WorkspaceDetail.fromJson(Map<String, dynamic> dynamicData)
  {
    title= dynamicData['title'];
    id= dynamicData['id'];
    notification= dynamicData['notification'];
    photo= dynamicData['photo'];
    workspaceTeam= WorkspaceTeam().fromMapList(dynamicData['teams']);
    workspaceMember= WorkspaceMember().fromMapList(dynamicData['members']);
    workspaceChannel= WorkspaceChannel().fromMapList(dynamicData['channels']);
    workspaceTag= WorkspaceTag().fromMapList(dynamicData['tags']);
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['id'] = this.id;
    data['notification'] = this.notification;
    data['photo'] = this.photo;
    data['teams'] = WorkspaceTeam().toMapList(this.workspaceTeam);
    data['members'] = WorkspaceMember().toMapList(this.workspaceMember);
    data['channels'] = WorkspaceChannel().toMapList(this.workspaceChannel);
    data['tags'] = WorkspaceTag().toMapList(this.workspaceTag);
    return data;
  }

  @override
  WorkspaceDetail fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return WorkspaceDetail(
        title: dynamicData['title'],
        id: dynamicData['id'],
        notification: dynamicData['notification'],
        photo: dynamicData['photo'],
        workspaceTeam: WorkspaceTeam().fromMapList(dynamicData['teams']),
        workspaceMember: WorkspaceMember().fromMapList(dynamicData['members']),
        workspaceChannel: WorkspaceChannel().fromMapList(dynamicData['channels']),
        workspaceTag: WorkspaceTag().fromMapList(dynamicData['tags']),
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(WorkspaceDetail object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['title'] = object.title;
      data['id'] = object.id;
      data['notification'] = object.notification;
      data['photo'] = object.photo;
      data['teams'] = WorkspaceTeam().toMapList(object.workspaceTeam);
      data['members'] = WorkspaceMember().toMapList(object.workspaceMember);
      data['channels'] = WorkspaceChannel().toMapList(object.workspaceChannel);
      data['tags'] = WorkspaceTag().toMapList(object.workspaceTag);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<WorkspaceDetail> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<WorkspaceDetail> userData = <WorkspaceDetail>[];
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
  List<Map<String, dynamic>> toMapList(List<WorkspaceDetail> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (WorkspaceDetail data in objectList)
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