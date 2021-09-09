import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/addTag/AddTagResponseData.dart';

class AddTagResponse extends Object<AddTagResponse> {
  AddTagResponse({
    this.addTagsResponseData,
    this.addGlobalTag,
  });

  AddTagsResponseData addTagsResponseData;
  AddTagsResponseData addGlobalTag;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  AddTagResponse fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return AddTagResponse(
        addTagsResponseData:
            AddTagsResponseData().fromMap(dynamicData['addTag']),
        addGlobalTag:
            AddTagsResponseData().fromMap(dynamicData['addGlobalTag']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(AddTagResponse object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['addTag'] = AddTagsResponseData().toMap(object.addTagsResponseData);
      data['addGlobalTag'] = AddTagsResponseData().toMap(object.addGlobalTag);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AddTagResponse> fromMapList(List<dynamic> dynamicDataList) {
    final List<AddTagResponse> data = <AddTagResponse>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          data.add(fromMap(dynamicData));
        }
      }
    }
    return data;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<AddTagResponse> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (AddTagResponse data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
