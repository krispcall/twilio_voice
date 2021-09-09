/*
 * *
 *  * Created by Kedar on 7/14/21 1:09 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/14/21 1:09 PM
 *
 */

import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/addNotes/AddNoteResponseData.dart';

class AddNoteResponse extends Object<AddNoteResponse> {
  AddNoteResponse({
    this.addNoteResponseData,
  });

  AddNoteResponseData addNoteResponseData;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  AddNoteResponse fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return AddNoteResponse(
        addNoteResponseData: AddNoteResponseData().fromMap(dynamicData['addNote']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(AddNoteResponse object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['addNote'] = AddNoteResponseData().toMap(object.addNoteResponseData);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AddNoteResponse> fromMapList(List<dynamic> dynamicDataList) {
    final List<AddNoteResponse> login = <AddNoteResponse>[];

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
  List<Map<String, dynamic>> toMapList(List<AddNoteResponse> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (AddNoteResponse data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
