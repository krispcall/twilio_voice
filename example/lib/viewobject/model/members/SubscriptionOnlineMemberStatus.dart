

import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/members/MemberStatus.dart';

class SubscriptionOnlineMemberStatusResponse extends Object<SubscriptionOnlineMemberStatusResponse>
{
  String event;
  MemberStatus message;

  SubscriptionOnlineMemberStatusResponse({this.event, this.message});

  @override
  SubscriptionOnlineMemberStatusResponse fromMap(dynamic)
  {
    return new SubscriptionOnlineMemberStatusResponse(
        message: dynamic['message'] != null ? MemberStatus().fromMap(dynamic['message']) : null,
        event: dynamic['event']);
  }



  Map<String, dynamic> toMap(SubscriptionOnlineMemberStatusResponse object)
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (object != null)
    {
      data['message'] = MemberStatus().toMap(object.message);
      data['event'] = object.event;
    }
    return data;
  }



  @override
  List<SubscriptionOnlineMemberStatusResponse> fromMapList(List<dynamic> dynamicDataList) {
    final List<SubscriptionOnlineMemberStatusResponse> list = <SubscriptionOnlineMemberStatusResponse>[];

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
  List<Map<String, dynamic>> toMapList(List<SubscriptionOnlineMemberStatusResponse> objectList)
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