import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/error/ResponseError.dart';
import 'package:voice_example/viewobject/model/login/LoginWorkspace.dart';

class AddWorkSpaceData extends Object<AddWorkSpaceData> {
  AddWorkSpaceData({
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
  AddWorkSpaceData fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return AddWorkSpaceData(
        status: dynamicData['status'],
        data: LoginWorkspace().fromMap(dynamicData['data']),
        error: ResponseError().fromMap(dynamicData['error']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(AddWorkSpaceData object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['status'] = object.status;
      data['data'] = LoginWorkspace().toMap(object.data);
      data['error'] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AddWorkSpaceData> fromMapList(List<dynamic> dynamicDataList) {
    final List<AddWorkSpaceData> login = <AddWorkSpaceData>[];
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
  List<Map<String, dynamic>> toMapList(List<AddWorkSpaceData> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (AddWorkSpaceData data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
