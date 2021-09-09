import 'package:voice_example/viewobject/model/error/ResponseError.dart';
import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/login/LoginWorkspace.dart';

class ArchiveWorkSpaceData extends Object<ArchiveWorkSpaceData> {
  ArchiveWorkSpaceData({
    this.status,
    this.data,
    this.error,
  });

  int status;
  LoginWorkspace data;
  ResponseError error;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  ArchiveWorkSpaceData fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ArchiveWorkSpaceData(
        status: dynamicData['status'],
        data: LoginWorkspace().fromMap(dynamicData['data']),
        error: ResponseError().fromMap(dynamicData['error']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(ArchiveWorkSpaceData object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['status'] = object.status;
      data['data'] = object.data;
      data['error'] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ArchiveWorkSpaceData> fromMapList(List<dynamic> dynamicDataList) {
    final List<ArchiveWorkSpaceData> login = <ArchiveWorkSpaceData>[];
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
  List<Map<String, dynamic>> toMapList(List<ArchiveWorkSpaceData> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (ArchiveWorkSpaceData data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
