import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/call/RecentConversationData.dart';

class RecentConversationResponse extends Object<RecentConversationResponse>
{
  RecentConversationData recentConversationData;

  RecentConversationResponse({this.recentConversationData});

  @override
  RecentConversationResponse fromMap(dynamicData)
  {
    return RecentConversationResponse(
      recentConversationData: dynamicData['recentConversation'] != null ? RecentConversationData().fromMap(dynamicData['recentConversation']) : null,
    );
  }

  @override
  Map<String, dynamic> toMap(object)
  {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.recentConversationData != null)
    {
      data['recentConversation'] = RecentConversationData().toMap(object.recentConversationData);
    }
    return data;
  }

  @override
  List<RecentConversationResponse> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<RecentConversationResponse> basketList = <RecentConversationResponse>[];
    if (dynamicDataList != null)
    {
      for (dynamic dynamicData in dynamicDataList)
      {
        if (dynamicData != null)
        {
          basketList.add(fromMap(dynamicData));
        }
      }
    }
    return basketList;
  }

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  List<Map<String, dynamic>> toMapList(List<RecentConversationResponse> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (RecentConversationResponse data in objectList)
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