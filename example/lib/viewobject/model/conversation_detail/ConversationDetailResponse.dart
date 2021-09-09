import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/call/RecentConversationData.dart';

class ConversationDetailResponse extends Object<ConversationDetailResponse>
{
  RecentConversationData conversationData;

  ConversationDetailResponse({this.conversationData});

  @override
  ConversationDetailResponse fromMap(dynamicData)
  {
    if(dynamicData!=null)
    {
      return ConversationDetailResponse(
        conversationData: dynamicData['conversation'] != null ? RecentConversationData().fromMap(dynamicData['conversation']) : null,
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(object)
  {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.conversationData != null)
    {
      data['conversation'] = RecentConversationData().toMap(object.conversationData);
    }
    return data;
  }

  @override
  List<ConversationDetailResponse> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<ConversationDetailResponse> basketList = <ConversationDetailResponse>[];
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
  List<Map<String, dynamic>> toMapList(List<ConversationDetailResponse> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (ConversationDetailResponse data in objectList)
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