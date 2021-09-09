import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/allContact/Tags.dart';
import 'package:voice_example/viewobject/model/error/ResponseError.dart';

class AddTagsResponseData extends Object<AddTagsResponseData>
{
  AddTagsResponseData({
    this.status,
    this.tag,
    this.error,
  });

  int status;
  Tags tag;
  ResponseError error;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  AddTagsResponseData fromMap(dynamic dynamicData)
  {
    if (dynamicData != null) {
      return AddTagsResponseData(
        status: dynamicData['status'],
        tag: Tags().fromMap(dynamicData['data']),
        error: ResponseError().fromMap(dynamicData['error']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(AddTagsResponseData object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['status'] = object.status;
      data['data'] = Tags().toMap(object.tag);
      data['error'] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AddTagsResponseData> fromMapList(List<dynamic> dynamicDataList) {
    final List<AddTagsResponseData> login = <AddTagsResponseData>[];

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
  List<Map<String, dynamic>> toMapList(List<AddTagsResponseData> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (AddTagsResponseData data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}