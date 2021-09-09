import 'package:voice_example/viewobject/common/Object.dart';

class WorkspaceChannel extends Object<WorkspaceChannel> {

  // {
  // "id": "5vdcVWZWV2MtEgHTE8M7dw",
  // "countryLogo": "/storage/flags/afg.svg",
  // "country": "7opfWxvyTNhWq9yArDRrEv",
  // "countryCode": "+93",
  // "number": "+14153048396",
  // "name": "Sabnam",
  // "dndEndtime": null,
  // "dndEnabled": false,
  // "dndRemainingTime": null,
  // "dndOn": "2021-05-31T06:04:51.737118+00:00",
  // "unseenMessageCount": 142
  // }

  WorkspaceChannel({
    this.id,
    this.name,
    this.number,
    this.countryCode,
    this.countryLogo,
    this.unseenMessageCount,
  });

  String id;
  String name;
  String number;
  String countryCode;
  String countryLogo;
  int unseenMessageCount;

  String dndOn;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  WorkspaceChannel fromMap(dynamic dynamicData) {
    if (dynamicData != null)
    {
      return WorkspaceChannel(
        id: dynamicData['id'],
        name: dynamicData['name'],
        number: dynamicData['number'],
        countryCode: dynamicData['countryCode'],
        countryLogo: dynamicData['countryLogo'],
        unseenMessageCount: dynamicData['unseenMessageCount'],
      );
    }
    else
    {
      return null;
    }
  }

  WorkspaceChannel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    number = json['number'];
    countryCode = json['countryCode'];
    countryLogo = json['countryLogo'];
    unseenMessageCount = json['unseenMessageCount'];
  }

  @override
  Map<String, dynamic> toMap(WorkspaceChannel object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['name'] = object.name;
      data['number'] = object.number;
      data['countryCode'] = object.countryCode;
      data['countryLogo'] = object.countryLogo;
      data['unseenMessageCount'] = object.unseenMessageCount;
      return data;
    } else {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['number'] = this.number;
    data['countryCode'] = this.countryCode;
    data['countryLogo'] = this.countryLogo;
    data['unseenMessageCount'] = this.unseenMessageCount;
    return data;
  }

  @override
  List<WorkspaceChannel> fromMapList(List<dynamic> dynamicDataList) {
    final List<WorkspaceChannel> userData = <WorkspaceChannel>[];
    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          userData.add(fromMap(dynamicData));
        }
      }
    }
    return userData;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<WorkspaceChannel> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (WorkspaceChannel data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
