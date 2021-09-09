import 'package:voice_example/viewobject/ResponseData.dart';
import 'package:voice_example/viewobject/model/allContact/Tags.dart';
import 'package:voice_example/viewobject/common/MapObject.dart';
import 'package:quiver/core.dart';
import 'package:voice_example/viewobject/common/Object.dart';

class Contacts extends MapObject<Contacts>
{
  Contacts({
    this.id,
    this.name,
    this.country,
    this.company,
    this.number,
    this.email,
    this.profilePicture,
    this.blocked,
    this.dndEnabled,
    this.dndDuration,
    this.dndEndtime,
    this.visibility,
    this.tags,
    this.notes,
    this.createdOn,
    this.address,
    this.flagUrl,
    this.dndMissed,
  });

  String id;
  String name;
  String country;
  String company;
  String number;
  String email;
  String profilePicture;
  bool blocked;
  bool dndEnabled;
  int dndDuration;
  int dndEndtime;
  bool visibility;
  List<Tags> tags;
  List<Tags> notes;
  String createdOn;
  String address;
  String flagUrl;
  bool dndMissed;

  @override
  bool operator ==(dynamic other) => other is Contacts && id == other.id;

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
  Contacts fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return Contacts(
        id: dynamicData['id'],
        name: dynamicData['name'],
        country: dynamicData['country'],
        company: dynamicData['company'],
        number: dynamicData['number'],
        email: dynamicData['email'],
        profilePicture: dynamicData['profilePicture'],
        blocked: dynamicData['blocked']!=null?dynamicData['blocked']:false,
        dndEnabled: dynamicData['dndEnabled']!=null?dynamicData['dndEnabled']:false,
        dndDuration: dynamicData['dndDuration'],
        dndEndtime: dynamicData['dndEndtime'],
        visibility: dynamicData['visibility'],
        tags: Tags().fromMapList(dynamicData["tags"]),
        notes: Tags().fromMapList(dynamicData["notes"]),
        createdOn: dynamicData['createdOn'],
        address: dynamicData['address'],
        flagUrl: dynamicData['flagUrl'],
        dndMissed: false,
      );
        // Todo dnd missed in contact
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(Contacts object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['name'] = object.name;
      data['country'] = object.country;
      data['company'] = object.company;
      data['number'] = object.number;
      data['email'] = object.email;
      data['country'] = object.country;
      data["profilePicture"] = object.profilePicture;
      data["blocked"] = object.dndEnabled;
      data["dndEnabled"] = object.dndEnabled;
      data["dndDuration"] = object.dndDuration;
      data["dndEndtime"] = object.dndEndtime;
      data["visibility"] = object.visibility;
      data["blocked"] = object.blocked;
      data["profilePicture"] = object.profilePicture;
      data['tags'] = Tags().toMapList(object.tags);
      data['notes'] = Tags().toMapList(object.notes);
      data['createdOn'] = object.createdOn;
      data['address'] =object.address;
      data['flagUrl'] =object.flagUrl;
      data['dndMissed'] =object.dndMissed;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Contacts> fromMapList(List<dynamic> dynamicDataList) {
    final List<Contacts> basketList = <Contacts>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          basketList.add(fromMap(dynamicData));
        }
      }
    }
    return basketList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<Contacts> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (Contacts data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
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
  List<String> getIdByKeyValue(List<Contacts> mapList, key, value) {
    final List<String> filterParamlist = <String>[];
    if (mapList != null) {
      for (dynamic messages in mapList) {
        if (Contacts().toMap(messages)["${key}"] == value) {
          if (messages != null) {
            filterParamlist.add(messages.id);
          }
        }
      }
    }
    return filterParamlist;
  }
}

//Delete Contacts
class DeleteContactResponse extends Object<DeleteContactResponse> {
/*  {
  "data": {
  "deleteContacts": {
  "status": 200,
  "error": null,
  "data": {
  "success": true
  }
  }
  }
  }*/

  DeleteContactResponse({
    this.data,
  });

  ResponseData data;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  DeleteContactResponse fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return DeleteContactResponse(
        data: ResponseData().fromMap(dynamicData['deleteContacts']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(DeleteContactResponse object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['deleteContacts'] = ResponseData().toMap(object.data);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<DeleteContactResponse> fromMapList(List<dynamic> dynamicDataList) {
    final List<DeleteContactResponse> data = <DeleteContactResponse>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          data.add(fromMap(dynamicData));
        }
      }
    }
    return data;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<DeleteContactResponse> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (DeleteContactResponse data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
