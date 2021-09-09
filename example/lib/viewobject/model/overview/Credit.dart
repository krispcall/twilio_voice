/*
 * *
 *  * Created by Kedar on 8/2/21 10:56 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 8/2/21 10:56 AM
 *  
 */

import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/login/LoginWorkspace.dart';
import 'package:voice_example/viewobject/model/login/UserProfile.dart';
import 'package:quiver/core.dart';

class Credit extends Object<Credit>
{
  Credit({
    this.id,
    this.amount,
  });

  String id;
  double amount;

  @override
  bool operator ==(dynamic other) => other is Credit && id == other.id;

  @override
  int get hashCode
  {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String getPrimaryKey()
  {
    return id;
  }

  @override
  Credit fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return Credit(
        id: dynamicData['id'],
        amount: dynamicData['amount'],
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(Credit object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['amount'] = object.amount;
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<Credit> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<Credit> workSpace = <Credit>[];
    if (dynamicDataList != null)
    {
      for (dynamic dynamicData in dynamicDataList)
      {
        if (dynamicData != null)
        {
          workSpace.add(fromMap(dynamicData));
        }
      }
    }
    return workSpace;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<Credit> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (Credit data in objectList)
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


