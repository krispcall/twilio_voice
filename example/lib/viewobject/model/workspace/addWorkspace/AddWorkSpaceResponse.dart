import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/error/ResponseError.dart';
import 'package:voice_example/viewobject/model/login/LoginWorkspace.dart';
import 'package:voice_example/viewobject/model/workspace/addWorkspace/AddWorkSpaceData.dart';

class AddWorkSpaceResponse extends Object<AddWorkSpaceResponse> {
  AddWorkSpaceResponse({
    this.data,
  });

  AddWorkSpaceData data;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  AddWorkSpaceResponse fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return AddWorkSpaceResponse(
        data: AddWorkSpaceData().fromMap(dynamicData['addWorkspace']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(AddWorkSpaceResponse object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['addWorkspace'] = AddWorkSpaceData().toMap(object.data);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AddWorkSpaceResponse> fromMapList(List<dynamic> dynamicDataList) {
    final List<AddWorkSpaceResponse> login = <AddWorkSpaceResponse>[];
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
  List<Map<String, dynamic>> toMapList(List<AddWorkSpaceResponse> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (AddWorkSpaceResponse data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
