import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/call/RecentConversation.dart';
import 'package:voice_example/viewobject/model/error/ResponseError.dart';

class RecentConversationData extends Object<RecentConversationData>
{
  RecentConversationData({
    this.status,
    this.recentConversation,
    this.error,
  });

  int status;
  RecentConversation recentConversation;
  ResponseError error;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  RecentConversationData fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return RecentConversationData(
        status: dynamicData['status'],
        recentConversation: RecentConversation().fromMap(dynamicData['data']),
        error: ResponseError().fromMap(dynamicData['error']),
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(RecentConversationData object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['status'] = object.status;
      data['data'] = RecentConversation().toMap(object.recentConversation);
      data['error'] = ResponseError().toMap(object.error);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<RecentConversationData> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<RecentConversationData> login = <RecentConversationData>[];
    if (dynamicDataList != null)
    {
      for (dynamic dynamicData in dynamicDataList)
      {
        if (dynamicData != null)
        {
          login.add(fromMap(dynamicData));
        }
      }
    }
    return login;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<RecentConversationData> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (RecentConversationData data in objectList)
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