import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/allContact/Contact.dart';

class AddNoteByNumber extends Object<AddNoteByNumber>
{
  AddNoteByNumber({
    this.id,
    this.title,
    this.contacts,
  });

  String id;
  String title;
  Contacts contacts;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  AddNoteByNumber fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return AddNoteByNumber(
        id: dynamicData['id'],
        title: dynamicData['title'],
        contacts: Contacts().fromMap(dynamicData['client']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(AddNoteByNumber object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['title'] = object.title;
      data['client'] = Contacts().toMap(object.contacts);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<AddNoteByNumber> fromMapList(List<dynamic> dynamicDataList) {
    final List<AddNoteByNumber> login = <AddNoteByNumber>[];

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
  List<Map<String, dynamic>> toMapList(List<AddNoteByNumber> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (AddNoteByNumber data in objectList)
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
