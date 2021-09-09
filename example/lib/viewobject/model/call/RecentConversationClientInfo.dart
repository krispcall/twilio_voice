import 'package:voice_example/viewobject/common/MapObject.dart';
import 'package:quiver/core.dart';

class RecentConversationClientInfo extends MapObject<RecentConversationClientInfo>
{
  RecentConversationClientInfo({
    this.id,
    this.name,
    this.country,
    this.createdBy,
    this.profilePicture,
    this.number
  });

  String id;
  String name;
  String country;
  String createdBy;
  String profilePicture;
  String number;

  @override
  bool operator ==(dynamic other) => other is RecentConversationClientInfo && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String getPrimaryKey()
  {
    return id;
  }

  @override
  RecentConversationClientInfo fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return RecentConversationClientInfo(
          id: dynamicData['id'],
          name: dynamicData['name'],
          country: dynamicData['country'],
          createdBy: dynamicData['createdBy'],
          profilePicture: dynamicData['profilePicture'],
          number: dynamicData['number']);
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(RecentConversationClientInfo object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['name'] = object.name;
      data['country'] = object.country;
      data['createdBy'] = object.createdBy;
      data['profilePicture'] = object.profilePicture;
      data['number'] = object.number;
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<RecentConversationClientInfo> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<RecentConversationClientInfo> basketList = <RecentConversationClientInfo>[];
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
  List<Map<String, dynamic>> toMapList(List<RecentConversationClientInfo> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (RecentConversationClientInfo data in objectList)
      {
        if (data != null)
        {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }

  @override
  List<String> getIdList(List<dynamic> mapList)
  {
    final List<String> idList = <String>[];
    if (mapList != null)
    {
      for (dynamic messages in mapList)
      {
        if (messages != null)
        {
          idList.add(messages.id);
        }
      }
    }
    return idList;
  }

  @override
  List<String> getIdByKeyValue(List<dynamic> mapList, var key, var value)
  {
    final List<String> filterParamlist = <String>[];
    if (mapList != null)
    {
      for (dynamic clientInfo in mapList)
      {
        if (RecentConversationClientInfo().toMap(clientInfo)["$key"] == value)
        {
          if (clientInfo != null)
          {
            filterParamlist.add(clientInfo.id);
          }
        }
      }
    }
    return filterParamlist;
  }
}
