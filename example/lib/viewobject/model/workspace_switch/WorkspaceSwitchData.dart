import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/error/ResponseError.dart';
import 'package:voice_example/viewobject/model/login/UserProfile.dart';

class WorkspaceSwitchData extends Object<WorkspaceSwitchData> {
  WorkspaceSwitchData({
    this.status,
    this.data,
    this.error,
  });

  int status;
  UserProfile data;
  ResponseError error;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  WorkspaceSwitchData fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return WorkspaceSwitchData(
        status: dynamicData['status'],
        data: UserProfile().fromMap(dynamicData['data']),
        error: ResponseError().fromMap(dynamicData['error']),
      );
    }
    else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(WorkspaceSwitchData object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['status'] = object.status;
      data['data'] = UserProfile().toMap(object.data);
      data['error'] = ResponseError().toMap(object.error);
      return data;
    }
    else {
      return null;
    }
  }

  @override
  List<WorkspaceSwitchData> fromMapList(List<dynamic> dynamicDataList) {
    final List<WorkspaceSwitchData> login = <WorkspaceSwitchData>[];

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
  List<Map<String, dynamic>> toMapList(List<WorkspaceSwitchData> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (WorkspaceSwitchData data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}