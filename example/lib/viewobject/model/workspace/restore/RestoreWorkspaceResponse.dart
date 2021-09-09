/*
 * *
 *  * Created by Kedar on 8/19/21 8:47 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 8/19/21 8:47 AM
 *
 */
import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/workspace/archive/ArchiveWorkSpaceData.dart';
import 'package:voice_example/viewobject/model/workspace/restore/RestoreWorkspaceData.dart';


class RestoreWorkspaceResponse extends Object<RestoreWorkspaceResponse> {
  RestoreWorkspaceResponse({
    this.data,
  });

  RestoreWorkspaceData data;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  RestoreWorkspaceResponse fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return RestoreWorkspaceResponse(
        data: RestoreWorkspaceData().fromMap(dynamicData['restoreWorkspace']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(RestoreWorkspaceResponse object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['restoreWorkspace'] = RestoreWorkspaceData().toMap(object.data);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<RestoreWorkspaceResponse> fromMapList(List<dynamic> dynamicDataList) {
    final List<RestoreWorkspaceResponse> login = <RestoreWorkspaceResponse>[];
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
  List<Map<String, dynamic>> toMapList(List<RestoreWorkspaceResponse> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (RestoreWorkspaceResponse data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}

