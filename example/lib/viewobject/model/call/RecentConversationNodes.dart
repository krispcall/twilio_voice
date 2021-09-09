import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/call/RecentConversationClientInfo.dart';
import 'package:voice_example/viewobject/model/call/RecentConversationContent.dart';
import 'package:voice_example/viewobject/model/allContact/Tags.dart';
import 'package:quiver/core.dart';


enum ConversationType { Call, Message, VoiceMail }

class RecentConversationNodes extends Object<RecentConversationNodes>
{
  RecentConversationNodes({
    this.id,
    this.createdAt,
    this.clientNumber,
    this.clientCountry,
    this.clientCountryFlag,
    this.clientProfilePicture,
    this.blocked,
    this.pinned,
    this.contactPinned,
    this.dndMissed,
    this.favourite,
    this.clientUnseenMsgCount,
    this.reject,
    this.conversationType,
    this.conversationStatus,
    this.direction,
    this.content,
    this.clientInfo,
    this.tags,
    this.notes,
  });

  String id;
  String createdAt;
  String clientNumber;
  String clientCountry;
  String clientCountryFlag;
  String clientProfilePicture;
  bool blocked;
  bool pinned;
  bool contactPinned;
  bool dndMissed;
  bool favourite;
  int clientUnseenMsgCount;
  bool reject;
  String conversationType;
  String conversationStatus;
  RecentConversationContent content;
  RecentConversationClientInfo clientInfo;
  String direction;
  List<Tags> tags;
  List<Tags> notes;

  @override
  bool operator ==(dynamic other) => other is RecentConversationNodes && id == other.id;

  @override
  int get hashCode
  {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String getPrimaryKey()
  {
    return id;
  }

  @override
  RecentConversationNodes fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return RecentConversationNodes(
        id: dynamicData['id'],
        createdAt: dynamicData['createdAt'],
        clientNumber: dynamicData['clientNumber'],
        clientCountry: dynamicData['clientCountry'],
        clientCountryFlag: dynamicData["clientCountryFlag"],
        clientProfilePicture: dynamicData["clientProfilePicture"],
        blocked: dynamicData['blocked'],
        pinned: dynamicData['pinned'],
        contactPinned: dynamicData['contactPinned'],
        dndMissed: dynamicData["dndMissed"],
        favourite: dynamicData["favourite"],
        clientUnseenMsgCount: dynamicData["clientUnseenMsgCount"],
        reject: dynamicData["reject"],
        conversationType: dynamicData["conversationType"],
        conversationStatus: dynamicData["conversationStatus"],
        content: dynamicData["content"] != null ? RecentConversationContent().fromMap(dynamicData["content"]) : null,
        clientInfo: dynamicData["clientInfo"] != null ? RecentConversationClientInfo().fromMap(dynamicData["clientInfo"]) : null,
        direction: dynamicData["direction"],
        tags: dynamicData["tags"] != null ? Tags().fromMapList(dynamicData["tags"]):null,
        notes: dynamicData["notes"] != null ?Tags().fromMapList(dynamicData["notes"]):null,
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(RecentConversationNodes object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['createdAt'] = object.createdAt;
      data['clientNumber'] = object.clientNumber;
      data['clientCountry'] = object.clientCountry;
      data['clientCountryFlag'] = object.clientCountryFlag;
      data['clientProfilePicture'] = object.clientProfilePicture;
      data["blocked"] = object.blocked;
      data["pinned"] = object.pinned;
      data["contactPinned"] = object.contactPinned;
      data["dndMissed"] = object.dndMissed;
      data["favourite"] = object.favourite;
      data["clientUnseenMsgCount"] = object.clientUnseenMsgCount;
      data["reject"] = object.reject;
      data['conversationStatus'] = object.conversationStatus;
      data['conversationType'] = object.conversationType;
      data['content'] = object.content != null ? RecentConversationContent().toMap(object.content) : null;
      data['clientInfo'] = object.clientInfo != null ? RecentConversationClientInfo().toMap(object.clientInfo) : null;
      data['direction'] = object.direction;
      data['tags'] = Tags().toMapList(object.tags);
      // data['note'] = Notes().toMapList(object.notes);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<RecentConversationNodes> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<RecentConversationNodes> basketList = <RecentConversationNodes>[];

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
  List<Map<String, dynamic>> toMapList(List<RecentConversationNodes> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (RecentConversationNodes data in objectList)
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

