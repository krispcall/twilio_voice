import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/allContact/Tags.dart';
import 'package:voice_example/viewobject/model/error/ResponseError.dart';

class EditTagTitleData extends Object<EditTagTitleData> {
  EditTagTitleData({
    this.status,
    this.data,
    this.error,
  });

  int status;
  dynamic data;
  ResponseError error;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  EditTagTitleData fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return EditTagTitleData(
        status: dynamicData['status'],
        data: dynamicData['data'],
        error: ResponseError().fromMap(dynamicData['error']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(EditTagTitleData object) {
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
  List<EditTagTitleData> fromMapList(List<dynamic> dynamicDataList) {
    final List<EditTagTitleData> login = <EditTagTitleData>[];
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
  List<Map<String, dynamic>> toMapList(List<EditTagTitleData> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (EditTagTitleData data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
