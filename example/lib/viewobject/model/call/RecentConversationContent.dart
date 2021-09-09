import 'package:voice_example/viewobject/common/Object.dart';

class RecentConversationContent extends Object<RecentConversationContent>
{
  String body;
  String callDuration;
  String callTime;
  String duration;
  String transferredAudio;

  RecentConversationContent({
    this.body,
    this.callDuration,
    this.callTime,
    this.duration,
    this.transferredAudio
  });

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  RecentConversationContent fromMap(dynamicData)
  {
    return RecentConversationContent(
        body: dynamicData['body'] != null ? dynamicData['body'] : null,
        callDuration: dynamicData['callDuration'],
        callTime: dynamicData['callTime'],
        duration: dynamicData['duration'],
        transferredAudio: dynamicData['transferedAudio']);
  }

  @override
  Map<String, dynamic> toMap(RecentConversationContent object)
  {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['body'] = object.body;
    data['callDuration'] = object.callDuration;
    data['callTime'] = object.callTime;
    data['duration'] = object.duration;
    data['transferedAudio'] = object.transferredAudio;
    return data;
  }

  @override
  List<RecentConversationContent> fromMapList(List dynamicDataList)
  {
    final List<RecentConversationContent> basketList = <RecentConversationContent>[];
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
  List<Map<String, dynamic>> toMapList(List<RecentConversationContent> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (RecentConversationContent data in objectList)
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
