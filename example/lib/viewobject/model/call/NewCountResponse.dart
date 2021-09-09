import 'package:voice_example/viewobject/ResponseData.dart';
import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/call/RecentConversationData.dart';

class NewCountResponse extends Object<NewCountResponse> {
  ResponseData newCount;

  NewCountResponse({this.newCount});

  @override
  NewCountResponse fromMap(dynamicData) {
    return NewCountResponse(
      newCount: dynamicData['newCount'] != null
          ? ResponseData().fromMap(dynamicData['newCount'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toMap(object) {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.newCount != null) {
      data['newCount'] = ResponseData().toMap(object.newCount);
    }
    return data;
  }

  @override
  List<NewCountResponse> fromMapList(List<dynamic> dynamicDataList) {
    final List<NewCountResponse> basketList = <NewCountResponse>[];
    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          basketList.add(fromMap(dynamicData));
        }
      }
    }
    return basketList;
  }

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  List<Map<String, dynamic>> toMapList(List<NewCountResponse> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (NewCountResponse data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
