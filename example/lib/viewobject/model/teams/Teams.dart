/*
 * *
 *  * Created by Kedar on 7/30/21 9:41 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/30/21 9:41 AM
 *  
 */

import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/teams/Members.dart';

class Teams extends Object<Teams>
{
  Teams({
    this.id,
    this.name,
    this.online,
    this.total,
    this.picture,
    this.members,
  });

  String id;
  String name;
  int online;
  int total;
  String picture;
  List<Members> members;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  Teams fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return Teams(
        id: dynamicData['id'],
        name: dynamicData['name'],
        online: dynamicData['online'],
        total: dynamicData['total'],
        picture: dynamicData['picture'],
        members: Members().fromMapList(dynamicData['teamMembers']),

      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(Teams object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['name'] = object.name;
      data['online'] = object.online;
      data['total'] = object.total;
      data['picture'] = object.picture;
      data['teamMembers'] = Members().toMapList(object.members);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<Teams> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<Teams> userData = <Teams>[];
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
  List<Map<String, dynamic>> toMapList(List<Teams> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (Teams data in objectList)
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