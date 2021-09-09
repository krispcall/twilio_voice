import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/error/ResponseError.dart';
import 'package:voice_example/viewobject/model/login/LoginWorkspace.dart';

class WorkspacelistData extends Object<WorkspacelistData> {
  WorkspacelistData({
    this.status,
    this.data,
    this.error,
  });

  int status;
  List<LoginWorkspace> data;
  ResponseError error;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  WorkspacelistData fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return WorkspacelistData(
        status: dynamicData['status'],
        data: LoginWorkspace().fromMapList(dynamicData['data']),
        error: ResponseError().fromMap(dynamicData['error']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(WorkspacelistData object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['status'] = object.status;
      data['data'] = LoginWorkspace().toMapList(object.data);
      data['error'] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<WorkspacelistData> fromMapList(List<dynamic> dynamicDataList) {
    final List<WorkspacelistData> login = <WorkspacelistData>[];
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
  List<Map<String, dynamic>> toMapList(List<WorkspacelistData> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (WorkspacelistData data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
