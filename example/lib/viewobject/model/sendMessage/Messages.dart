import 'package:voice_example/viewobject/common/MapObject.dart';
import 'package:voice_example/viewobject/model/call/RecentConversationContent.dart';
import 'package:quiver/core.dart';

class Messages extends MapObject<Messages>
{
  final String id;
  final String agentProfilePicture;
  final String clientNumber;
  final String channelNumber;

  final String clientCountry;

  final String clientProfilePicture;

  final String channelCountry;

  final String createdAt;

  final bool pinned;

  final bool seen;

  final RecentConversationContent content;

  final String conversationType;

  final String conversationStatus;

  final String direction;

  final String sms;

  final bool contactPinned;

  final String agentFirstname;

  final String agentId;

  final String agentLastname;

  final bool blocked;

  final String clientid;

  final String clientName;

  final bool dndMissed;

  final bool favourite;

  final bool reject;

  bool check;

  Messages({this.id, this.agentProfilePicture, this.clientNumber, this.channelNumber, this.clientCountry, this.clientProfilePicture, this.channelCountry, this.createdAt, this.pinned, this.seen, this.content, this.conversationType, this.conversationStatus, this.direction, this.sms, this.contactPinned, this.agentFirstname, this.agentId, this.agentLastname, this.blocked, this.clientid, this.clientName, this.dndMissed, this.favourite, this.reject, this.check});

  @override
  bool operator ==(dynamic other) => other is Messages && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  Messages fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return  Messages(
        id :dynamicData['id'],
        agentProfilePicture :dynamicData['agentProfilePicture'],
        clientNumber :dynamicData['clientNumber'],
        channelNumber :dynamicData['channelNumber'],
        clientCountry :dynamicData['clientCountry'],
        clientProfilePicture :dynamicData['clientProfilePicture'],
        channelCountry :dynamicData['channelCountry'],
        createdAt :dynamicData['createdAt'],
        pinned :dynamicData['pinned'],
        seen :dynamicData['seen'],
        content : RecentConversationContent().fromMap(dynamicData['content']),
        conversationType :dynamicData['conversationType'],
        conversationStatus :dynamicData['conversationStatus'],
        direction :dynamicData['direction'],
        sms :dynamicData['sms'],
        contactPinned :dynamicData['contactPinned'],
        agentFirstname :dynamicData['agentFirstname'],
        agentId :dynamicData['agentId'],
        agentLastname :dynamicData['agentLastname'],
        blocked :dynamicData['blocked'],
        clientid :dynamicData['clientid'],
        clientName :dynamicData['clientName'],
        dndMissed :dynamicData['dndMissed'],
        favourite :dynamicData['favourite'],
        reject :dynamicData['reject'],
        check :dynamicData['check'],
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['agentProfilePicture'] = object.agentProfilePicture;
      data['clientNumber'] = object.clientNumber;
      data['channelNumber'] = object.channelNumber;
      data['clientCountry'] = object.clientCountry;
      data['clientProfilePicture'] = object.clientProfilePicture;
      data['channelCountry'] = object.channelCountry;
      data['createdAt'] = object.createdAt;
      data['pinned'] = object.pinned;
      data['seen'] = object.seen;
      data['content'] = RecentConversationContent().toMap(object.content);
      data['conversationType'] = object.conversationType;
      data['conversationStatus'] = object.conversationStatus;
      data['direction'] = object.direction;
      data['sms'] = object.sms;
      data['contactPinned'] = object.contactPinned;
      data['agentFirstname'] = object.agentFirstname;
      data['agentId'] = object.agentId;
      data['agentLastname'] = object.agentLastname;
      data['blocked'] = object.blocked;
      data['clientid'] = object.clientid;
      data['clientName'] = object.clientName;
      data['dndMissed'] = object.dndMissed;
      data['favourite'] = object.favourite;
      data['reject'] = object.reject;
      data['check'] = object.check;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Messages> fromMapList(List<dynamic> dynamicDataList) {
    final List<Messages> listMessages = <Messages>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
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
  List<String> getIdList(List<dynamic> mapList)
  {
    final List<String> idList = <String>[];
    if (mapList != null)
    {
      for (dynamic messages in mapList)
      {
        if (messages != null) {
          idList.add(messages.id);
        }
      }
    }
    return idList;
  }

  @override
  List<String> getIdByKeyValue(List<dynamic> mapList, var key, var value)
  {
    final List<String> filterParamList = <String>[];
    if (mapList != null)
    {
      for (dynamic clientInfo in mapList)
      {
        if(Messages().toMap(clientInfo)["$key"] == value)
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
