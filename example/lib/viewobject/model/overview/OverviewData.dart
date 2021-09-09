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
import 'package:voice_example/viewobject/model/overview/Card.dart';
import 'package:voice_example/viewobject/model/overview/Credit.dart';
import 'package:voice_example/viewobject/model/overview/Plan.dart';
import 'package:quiver/core.dart';

class OverViewData extends Object<OverViewData>
{


//   {
//   "status": 200,
//   "data": {
//   "customerId": "cus_JvE1gSZm53Z1Gd",
//   "currentPeriodEnd": "August 30 2021",
//   "hideKrispcallBranding": false,
//   "dueAmount": 25.0,
//   "subscriptionActive": "Active",
//   "card": {
//   "id": "pm_1JHNa4FI0mKBQmYkflndlt6Z",
//   "name": "Kedar Jirel",
//   "expiryMonth": "12",
//   "expiryYear": "2022",
//   "brand": "visa",
//   "lastDigit": "4242"
//   },
//   "credit": {
//   "id": "6AKS93CPn86vNN3zBKGcqh",
//   "amount": 1.0
//   },
//   "plan": {
//   "id": "MGVr5QQz2GNZoQQ3N72Feb",
//   "title": "Standard",
//   "rate": 25.0
//   }
//   },
//   "error": null
//   }
// }
  OverViewData({
    this.customerId,
    this.currentPeriodEnd,
    this.hideKrispcallBranding,
    this.dueAmount,
    this.subscriptionActive,
    this.card,
    this.credit,
    this.plan,
  });


  String customerId;
  String currentPeriodEnd;
  bool hideKrispcallBranding;
  double dueAmount;
  String subscriptionActive;
  Card card;
  Credit credit;
  Plan plan;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  OverViewData fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return OverViewData(
        customerId: dynamicData['customerId'],
        currentPeriodEnd: dynamicData['currentPeriodEnd'],
        hideKrispcallBranding: dynamicData['hideKrispcallBranding'],
        dueAmount: dynamicData['dueAmount'],
        subscriptionActive: dynamicData['subscriptionActive'],
        card: Card().fromMap(dynamicData['card']),
        credit: Credit().fromMap(dynamicData['credit']),
        plan: Plan().fromMap(dynamicData['plan']),
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(OverViewData object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['customerId'] = object.customerId;
      data['currentPeriodEnd'] = object.currentPeriodEnd;
      data['hideKrispcallBranding'] = object.hideKrispcallBranding;
      data['dueAmount'] = object.dueAmount;
      data['subscriptionActive'] = object.subscriptionActive;
      data['card'] = Card().toMap(object.card);
      data['credit'] = Credit().toMap(object.credit);
      data['plan'] = Plan().toMap(object.plan);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<OverViewData> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<OverViewData> workSpace = <OverViewData>[];
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
  List<Map<String, dynamic>> toMapList(List<OverViewData> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (OverViewData data in objectList)
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


