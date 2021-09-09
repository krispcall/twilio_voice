/*
 * *
 *  * Created by Kedar on 7/20/21 2:29 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/20/21 2:29 PM
 *  
 */
import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/error/ResponseError.dart';
import 'package:voice_example/viewobject/model/workspace/workspace_detail/WorkspaceChannel.dart';


class ChannelData extends Object<ChannelData>
{
  ChannelData({
    this.status,
    this.data,
    this.error,
  });

  int status;
  List<WorkspaceChannel> data;
  ResponseError error;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  ChannelData fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return ChannelData(
        status: dynamicData['status'],
        data: WorkspaceChannel().fromMapList(dynamicData['data']),
        error: ResponseError().fromMap(dynamicData['error']),
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(ChannelData object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['status'] = object.status;
      data['data'] = WorkspaceChannel().toMapList(object.data);
      data['error'] = ResponseError().toMap(object.error);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<ChannelData> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<ChannelData> login = <ChannelData>[];

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
  List<Map<String, dynamic>> toMapList(List<ChannelData> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (ChannelData data in objectList)
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