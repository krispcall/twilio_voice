/*
 * *
 *  * Created by Kedar on 8/2/21 11:01 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 8/2/21 11:01 AM
 *  
 */

/*
 * *
 *  * Created by Kedar on 8/2/21 10:56 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 8/2/21 10:56 AM
 *  
 */
import 'package:voice_example/viewobject/common/Object.dart';
import 'package:quiver/core.dart';

class Card extends Object<Card>
{

  Card({
    this.id,
    this.name,
    this.expiryMonth,
    this.expiryYear,
    this.brand,
    this.lastDigit,
  });


  String id;
  String name;
  String expiryMonth;
  String expiryYear;
  String brand;
  String lastDigit;

  @override
  bool operator ==(dynamic other) => other is Card && id == other.id;

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
  Card fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return Card(
          id: dynamicData['id'],
          name: dynamicData['name'],
          expiryMonth: dynamicData['expiryMonth'],
          expiryYear: dynamicData['expiryYear'],
          brand: dynamicData['brand'],
          lastDigit: dynamicData['lastDigit'],
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(Card object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['name'] = object.name;
      data['expiryMonth'] = object.expiryMonth;
      data['expiryYear'] = object.expiryYear;
      data['brand'] = object.brand;
      data['lastDigit'] = object.lastDigit;
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<Card> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<Card> workSpace = <Card>[];
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
  List<Map<String, dynamic>> toMapList(List<Card> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (Card data in objectList)
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


