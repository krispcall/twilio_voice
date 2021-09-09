/*
 * *
 *  * Created by Kedar on 7/14/21 1:09 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/14/21 1:09 PM
 *
 */

import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/members/MembersResponseData.dart';
import 'package:voice_example/viewobject/model/numbers/NumberData.dart';

class NumberResponse extends Object<NumberResponse>
{
  NumberData data;

  NumberResponse({this.data});

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  NumberResponse fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return NumberResponse(
        data: NumberData().fromMap(dynamicData['numbers']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(NumberResponse object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['numbers'] = NumberData().toMap(object.data);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<NumberResponse> fromMapList(List dynamicDataList)
  {
    final List<NumberResponse> login = <NumberResponse>[];

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
  List<Map<String, dynamic>> toMapList(List<NumberResponse> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (NumberResponse data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}

