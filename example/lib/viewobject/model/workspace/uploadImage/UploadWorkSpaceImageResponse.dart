import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/error/ResponseError.dart';
import 'package:voice_example/viewobject/model/login/LoginWorkspace.dart';
import 'package:voice_example/viewobject/model/workspace/addWorkspace/AddWorkSpaceData.dart';

class UploadWorkSpaceImageResponse
    extends Object<UploadWorkSpaceImageResponse> {
  UploadWorkSpaceImageResponse({
    this.data,
  });

  AddWorkSpaceData data;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  UploadWorkSpaceImageResponse fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return UploadWorkSpaceImageResponse(
        data: AddWorkSpaceData().fromMap(dynamicData['changeWorkspacePhoto']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(UploadWorkSpaceImageResponse object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['changeWorkspacePhoto'] = AddWorkSpaceData().toMap(object.data);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<UploadWorkSpaceImageResponse> fromMapList(
      List<dynamic> dynamicDataList) {
    final List<UploadWorkSpaceImageResponse> login =
        <UploadWorkSpaceImageResponse>[];
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
  List<Map<String, dynamic>> toMapList(
      List<UploadWorkSpaceImageResponse> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (UploadWorkSpaceImageResponse data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
