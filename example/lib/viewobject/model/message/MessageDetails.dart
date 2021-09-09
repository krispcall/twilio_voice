import 'package:quiver/core.dart';
import 'package:voice_example/viewobject/common/MapObject.dart';

class MessageDetails extends MapObject<MessageDetails> {
  MessageDetails({
    this.id,
    this.clientNumber,
    this.message,
    this.direction,
    this.date,
    this.timestamp,
    int sorting,
  }) {
    super.sorting = sorting;
  }

  String id;
  String clientNumber;
  String message;
  String direction;
  String date;
  String timestamp;

  @override
  bool operator ==(dynamic other) => other is MessageDetails && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  MessageDetails fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return MessageDetails(
        id: dynamicData['id'].toString(),
        clientNumber: dynamicData['client_number'],
        message: dynamicData['body'],
        direction: dynamicData['direction'],
        date: dynamicData['date'].toString(),
        timestamp: dynamicData['timestamp'].toString(),
        sorting: dynamicData['sorting'],
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['client_number'] = object.clientNumber;
      data['body'] = object.message;
      data['direction'] = object.direction;
      data['date'] = object.date;
      data['timestamp'] = object.timestamp;
      data['sorting'] = object.sorting;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<MessageDetails> fromMapList(List<dynamic> dynamicDataList) {
    final List<MessageDetails> listMessageDetails = <MessageDetails>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          listMessageDetails.add(fromMap(dynamicData));
        }
      }
    }
    return listMessageDetails;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<dynamic> objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data));
        }
      }
    }
    return dynamicList;
  }

  @override
  List<String> getIdList(List<dynamic> mapList) {
    final List<String> idList = <String>[];
    if (mapList != null) {
      for (dynamic MessageDetails in mapList) {
        if (MessageDetails != null) {
          idList.add(MessageDetails.id);
        }
      }
    }
    return idList;
  }

  @override
  List<String> getIdByKeyValue(List<dynamic> mapList, var key, var value) {
    final List<String> filterParamlist = <String>[];
    if (mapList != null) {
      for (dynamic messages in mapList) {
        if (MessageDetails().toMap(messages)["${key}"] == value) {
          if (messages != null) {
            filterParamlist.add(messages.id);
          }
        }
      }
    }
    return filterParamlist;
  }
}
