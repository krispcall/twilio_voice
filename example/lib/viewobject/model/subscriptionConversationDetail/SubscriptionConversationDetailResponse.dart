import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/call/RecentConversationNodes.dart';
/*
 * *
 *  * Created by Kedar on 6/29/21 9:12 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 6/29/21 9:12 AM
 *
 */

class SubscriptionConversationDetailResponse extends Object<SubscriptionConversationDetailResponse>
{
  String event;
  RecentConversationNodes message;

  SubscriptionConversationDetailResponse({this.event, this.message});

  @override
  SubscriptionConversationDetailResponse fromMap(dynamic)
  {
    return new SubscriptionConversationDetailResponse(
        message: dynamic['message'] != null ? RecentConversationNodes().fromMap(dynamic['message']) : null,
        event: dynamic['event']);
  }



  Map<String, dynamic> toMap(SubscriptionConversationDetailResponse object)
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (object != null)
    {
      data['message'] = RecentConversationNodes().toMap(object.message);
      data['event'] = object.event;
    }
    return data;
  }



  @override
  List<SubscriptionConversationDetailResponse> fromMapList(List<dynamic> dynamicDataList) {
    final List<SubscriptionConversationDetailResponse> list = <SubscriptionConversationDetailResponse>[];

    if (dynamicDataList != null)
    {
      for (dynamic dynamicData in dynamicDataList)
      {
        if (dynamicData != null)
        {
          list.add(fromMap(dynamicData));
        }
      }
    }
    return list;
  }

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  List<Map<String, dynamic>> toMapList(List<SubscriptionConversationDetailResponse> objectList)
  {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (dynamic data in objectList)
      {
        if (data != null)
        {
          dynamicList.add(toMap(data));
        }
      }
    }
    return dynamicList;
  }
}
