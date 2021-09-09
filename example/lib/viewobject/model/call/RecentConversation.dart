import 'package:voice_example/viewobject/common/MapObject.dart';
import 'package:voice_example/viewobject/model/call/RecentConversationData.dart';
import 'package:voice_example/viewobject/model/call/RecentConversationEdges.dart';
import 'package:voice_example/viewobject/model/pagination/PageInfo.dart';

class RecentConversation extends MapObject<RecentConversation>
{
  RecentConversation({
    this.recentConversationPageInfo,
    this.recentConversationEdges,
  })
  {
    super.sorting = sorting;
  }

  PageInfo recentConversationPageInfo;
  List<RecentConversationEdges> recentConversationEdges;

  @override
  String getPrimaryKey()
  {
    return '';
  }

  @override
  RecentConversation fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return RecentConversation(
          recentConversationPageInfo: PageInfo().fromMap(dynamicData['pageInfo']),
          recentConversationEdges: RecentConversationEdges().fromMapList(dynamicData['edges'])
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(RecentConversation object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['pageInfo'] = PageInfo().toMap(object.recentConversationPageInfo);
      data['edges'] = RecentConversationEdges().toMapList(object.recentConversationEdges);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<RecentConversation> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<RecentConversation> listMessages = <RecentConversation>[];
    if (dynamicDataList != null)
    {
      for (dynamic dynamicData in dynamicDataList)
      {
        if (dynamicData != null)
        {
          listMessages.add(fromMap(dynamicData));
        }
      }
    }
    return listMessages;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<dynamic> objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data));
        }
      }
    }
    return dynamicList;
  }

  @override
  List<String> getIdList(List<dynamic> mapList) {
    final List<String> idList = <String>[];
    if (mapList != null) {
      for (dynamic messages in mapList) {
        if (messages != null) {
          idList.add(messages.id);
        }
      }
    }
    return idList;
  }

  @override
  List<String> getIdByKeyValue(List<RecentConversation> mapList, var key, var value)
  {
    final List<String> filterParamList = <String>[];
    if (mapList != null)
    {
      for (dynamic clientInfo in mapList)
      {
        if(RecentConversationData().toMap(clientInfo)["$key"] == value)
        {
          if (clientInfo != null)
          {
            filterParamList.add(clientInfo.id);
          }
        }
      }
    }
    return filterParamList;
  }
}