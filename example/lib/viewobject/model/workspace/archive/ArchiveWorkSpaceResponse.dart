/*
 * *
 *  * Created by Kedar on 8/19/21 8:47 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 8/19/21 8:47 AM
 *
 */
import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/workspace/archive/ArchiveWorkSpaceData.dart';







class ArchiveWorkSpaceResponse extends Object<ArchiveWorkSpaceResponse> {
  ArchiveWorkSpaceResponse({
    this.data,
  });

  ArchiveWorkSpaceData data;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  ArchiveWorkSpaceResponse fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ArchiveWorkSpaceResponse(
        data: ArchiveWorkSpaceData().fromMap(dynamicData['removeWorkspace']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(ArchiveWorkSpaceResponse object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['removeWorkspace'] = ArchiveWorkSpaceData().toMap(object.data);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ArchiveWorkSpaceResponse> fromMapList(List<dynamic> dynamicDataList) {
    final List<ArchiveWorkSpaceResponse> login = <ArchiveWorkSpaceResponse>[];
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
  List<Map<String, dynamic>> toMapList(List<ArchiveWorkSpaceResponse> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (ArchiveWorkSpaceResponse data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}

