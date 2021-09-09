import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/addNoteByNumber/AddNoteByNumber.dart';
import 'package:voice_example/viewobject/model/error/ResponseError.dart';
/*
 * *
 *  * Created by Kedar on 7/13/21 8:40 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/13/21 8:40 AM
 *  
 */

class AddNoteByNumberResponseData extends Object<AddNoteByNumberResponseData> {
  AddNoteByNumberResponseData({
    this.status,
    this.data,
    this.error,
  });

  int status;
  AddNoteByNumber data;
  ResponseError error;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  AddNoteByNumberResponseData fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return AddNoteByNumberResponseData(
        status: dynamicData['status'],
        data: AddNoteByNumber().fromMap(dynamicData['data']),
        error: ResponseError().fromMap(dynamicData['error']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(AddNoteByNumberResponseData object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['status'] = object.status;
      data['data'] = AddNoteByNumber().toMap(object.data);
      data['error'] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AddNoteByNumberResponseData> fromMapList(List<dynamic> dynamicDataList) {
    final List<AddNoteByNumberResponseData> login = <AddNoteByNumberResponseData>[];

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
  List<Map<String, dynamic>> toMapList(List<AddNoteByNumberResponseData> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (AddNoteByNumberResponseData data in objectList)
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
