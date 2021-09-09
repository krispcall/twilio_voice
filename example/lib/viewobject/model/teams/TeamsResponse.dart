/*
 * *
 *  * Created by Kedar on 7/30/21 8:56 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/30/21 8:56 AM
 *  
 */


import 'package:voice_example/viewobject/model/teams/TeamData.dart';
import 'package:voice_example/viewobject/model/error/ResponseError.dart';
import 'package:voice_example/viewobject/common/Object.dart';


class TeamsResponse extends Object<TeamsResponse> {
  TeamsResponse({
    this.data,
  });

  TeamData data;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  TeamsResponse fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return TeamsResponse(
        data: TeamData().fromMap(dynamicData['teams']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(TeamsResponse object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['teams'] = TeamData().toMap(object.data);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<TeamsResponse> fromMapList(List<dynamic> dynamicDataList) {
    final List<TeamsResponse> login = <TeamsResponse>[];

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
  List<Map<String, dynamic>> toMapList(List<TeamsResponse> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (TeamsResponse data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
