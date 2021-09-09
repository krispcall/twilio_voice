import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/error/ResponseError.dart';

class InviteMemberData<T> extends Object<InviteMemberData<T>> {
  InviteMemberData({
    this.status,
    this.data,
    this.error,
  });

  int status;
  Map<String, dynamic> data;
  ResponseError error;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  InviteMemberData<T> fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return InviteMemberData(
        status: dynamicData['status'],
        data: dynamicData['data'],
        error: ResponseError().fromMap(dynamicData['error']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(InviteMemberData<T> object) {
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
  List<InviteMemberData<T>> fromMapList(List<dynamic> dynamicDataList) {
    final List<InviteMemberData> login = <InviteMemberData>[];
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
  List<Map<String, dynamic>> toMapList(List<InviteMemberData<T>> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (InviteMemberData data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
