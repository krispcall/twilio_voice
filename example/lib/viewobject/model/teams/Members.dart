/*
 * *
 *  * Created by Kedar on 7/30/21 9:39 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/30/21 9:39 AM
 *
 */

import 'package:voice_example/viewobject/common/Object.dart';

class Members extends Object<Members> {
  Members({
    this.id,
    this.firstname,
    this.lastname,
    this.online,
    this.profilePicture,
  });

  String id;
  String firstname;
  String lastname;
  bool online;
  String profilePicture;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  Members fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Members(
        id: dynamicData['id'],
        firstname: dynamicData['firstname'],
        lastname: dynamicData['lastname'],
        online: dynamicData['online'],
        profilePicture: dynamicData['profilePicture'],
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(Members object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['firstname'] = object.firstname;
      data['lastname'] = object.lastname;
      data['online'] = object.online;
      data['profilePicture'] = object.profilePicture;

      return data;
    } else {
      return null;
    }
  }

  @override
  List<Members> fromMapList(List<dynamic> dynamicDataList) {
    final List<Members> userData = <Members>[];
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
  List<Map<String, dynamic>> toMapList(List<Members> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (Members data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
