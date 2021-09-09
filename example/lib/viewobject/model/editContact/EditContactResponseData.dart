import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/allContact/Contact.dart';
import 'package:voice_example/viewobject/model/error/ResponseError.dart';

class EditContactResponseData extends Object<EditContactResponseData> {
  EditContactResponseData({
    this.status,
    this.contacts,
    this.error,
  });

  int status;
  Contacts contacts;
  ResponseError error;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  EditContactResponseData fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return EditContactResponseData(
        status: dynamicData['status'],
        contacts: Contacts().fromMap(dynamicData['data']),
        error: ResponseError().fromMap(dynamicData['error']),
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(EditContactResponseData object) {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['status'] = object.status;
      data['data'] = Contacts().toMap(object.contacts);
      data['error'] = ResponseError().toMap(object.error);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<EditContactResponseData> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<EditContactResponseData> login = <EditContactResponseData>[];
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
  List<Map<String, dynamic>> toMapList(List<EditContactResponseData> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (EditContactResponseData data in objectList)
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