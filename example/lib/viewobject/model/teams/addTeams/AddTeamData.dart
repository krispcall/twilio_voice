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

class AddTeamData extends Object<AddTeamData> {
  AddTeamData({
    this.status,
    this.teams,
    this.error,
  });

  int status;
  ResponseError error;
  Teams teams;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  AddTeamData fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return AddTeamData(
        status: dynamicData['status'],
        teams: Teams().fromMap(dynamicData['data']),
        error: ResponseError().fromMap(dynamicData['error']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(AddTeamData object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['status'] = object.status;
      data['data'] = Teams().toMap(object.teams);
      data['error'] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AddTeamData> fromMapList(List<dynamic> dynamicDataList) {
    final List<AddTeamData> login = <AddTeamData>[];

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
  List<Map<String, dynamic>> toMapList(List<AddTeamData> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (AddTeamData data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
