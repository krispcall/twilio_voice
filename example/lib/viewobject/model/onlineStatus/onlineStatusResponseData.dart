import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/error/ResponseError.dart';

class OnlineStatusResponseData<T> extends Object<OnlineStatusResponseData<T>> {
  OnlineStatusResponseData({
    this.status,
    this.data,
    this.error,
  });

  int status;
  StatusUpdatePayload data;
  ResponseError error;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  OnlineStatusResponseData<T> fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return OnlineStatusResponseData(
        status: dynamicData['status'],
        data: StatusUpdatePayload().fromMap(dynamicData['data']),
        error: ResponseError().fromMap(dynamicData['error']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(OnlineStatusResponseData<T> object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['status'] = object.status;
      data['data'] = StatusUpdatePayload().toMap(object.data);
      data['error'] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<OnlineStatusResponseData<T>> fromMapList(List<dynamic> dynamicDataList) {
    final List<OnlineStatusResponseData> login = <OnlineStatusResponseData>[];
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
  List<Map<String, dynamic>> toMapList(List<OnlineStatusResponseData<T>> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (OnlineStatusResponseData data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}



class StatusUpdatePayload<T> extends Object<StatusUpdatePayload<T>> {
  StatusUpdatePayload({
    this.id,
    this.onlineStatus,
  });

  String id;
  bool onlineStatus;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  StatusUpdatePayload<T> fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return StatusUpdatePayload(
        id: dynamicData['id'],
        onlineStatus: dynamicData['onlineStatus'],
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(StatusUpdatePayload<T> object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['onlineStatus'] = object.onlineStatus;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<StatusUpdatePayload<T>> fromMapList(List<dynamic> dynamicDataList) {
  }

  @override
  List<Map<String, dynamic>> toMapList(List<StatusUpdatePayload<T>> objectList) {

  }
}
