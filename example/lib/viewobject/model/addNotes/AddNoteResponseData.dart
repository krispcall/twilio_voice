import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/addNotes/NoteTitle.dart';
import 'package:voice_example/viewobject/model/error/ResponseError.dart';
/*
 * *
 *  * Created by Kedar on 7/13/21 8:40 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/13/21 8:40 AM
 *  
 */

class AddNoteResponseData extends Object<AddNoteResponseData> {
  AddNoteResponseData({
    this.status,
    this.data,
    this.error,
  });

  int status;
  NoteTitle data;
  ResponseError error;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  AddNoteResponseData fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return AddNoteResponseData(
        status: dynamicData['status'],
        data: NoteTitle().fromMap(dynamicData['data']),
        error: ResponseError().fromMap(dynamicData['error']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(AddNoteResponseData object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['status'] = object.status;
      data['data'] = NoteTitle().toMap(object.data);
      data['error'] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AddNoteResponseData> fromMapList(List<dynamic> dynamicDataList) {
    final List<AddNoteResponseData> login = <AddNoteResponseData>[];

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
  List<Map<String, dynamic>> toMapList(List<AddNoteResponseData> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (AddNoteResponseData data in objectList)
      {
        if (data != null)
        {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
