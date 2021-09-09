import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/error/ResponseError.dart';
import 'package:voice_example/viewobject/model/overview/OverviewData.dart';

class OverViewResponseData extends Object<OverViewResponseData> {
  OverViewResponseData({
    this.status,
    this.overviewData,
    this.error,
  });

  int status;
  OverViewData overviewData;
  ResponseError error;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  OverViewResponseData fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return OverViewResponseData(
        status: dynamicData['status'],
        overviewData: OverViewData().fromMap(dynamicData['data']),
        error: ResponseError().fromMap(dynamicData['error']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(OverViewResponseData object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['status'] = object.status;
      data['data'] = OverViewData().toMap(object.overviewData);
      data['error'] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<OverViewResponseData> fromMapList(List<dynamic> dynamicDataList) {
    final List<OverViewResponseData> login = <OverViewResponseData>[];

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
  List<Map<String, dynamic>> toMapList(List<OverViewResponseData> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (OverViewResponseData data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
