/*
 * *
 *  * Created by Kedar on 7/30/21 9:09 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/30/21 9:09 AM
 *
 */

import 'package:voice_example/viewobject/model/error/ResponseError.dart';
import 'package:voice_example/viewobject/model/error/ResponseError.dart';
import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/teams/Teams.dart';

class TeamData extends Object<TeamData> {
  TeamData({
    this.status,
    this.teams,
    this.error,
  });

  int status;
  ResponseError error;
  List<Teams> teams;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  TeamData fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return TeamData(
        status: dynamicData['status'],
        teams: Teams().fromMapList(dynamicData['data']),
        error: ResponseError().fromMap(dynamicData['error']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(TeamData object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['status'] = object.status;
      data['data'] = Teams().toMapList(object.teams);
      data['error'] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<TeamData> fromMapList(List<dynamic> dynamicDataList) {
    final List<TeamData> login = <TeamData>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          login.add(fromMap(dynamicData));
        }
      }
    }
    return login;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<TeamData> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (TeamData data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
