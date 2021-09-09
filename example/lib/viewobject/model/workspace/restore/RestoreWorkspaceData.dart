import 'package:voice_example/viewobject/model/error/ResponseError.dart';
import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/login/LoginWorkspace.dart';

class RestoreWorkspaceData extends Object<RestoreWorkspaceData> {
  RestoreWorkspaceData({
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
  RestoreWorkspaceData fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return RestoreWorkspaceData(
        status: dynamicData['status'],
        data: LoginWorkspace().fromMap(dynamicData['data']),
        error: ResponseError().fromMap(dynamicData['error']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(RestoreWorkspaceData object) {
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
  List<RestoreWorkspaceData> fromMapList(List<dynamic> dynamicDataList) {
    final List<RestoreWorkspaceData> login = <RestoreWorkspaceData>[];
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
  List<Map<String, dynamic>> toMapList(List<RestoreWorkspaceData> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (RestoreWorkspaceData data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
