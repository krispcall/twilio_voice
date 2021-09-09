import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/error/ResponseError.dart';
import 'package:voice_example/viewobject/model/pinContact/PinContact.dart';

class PinContactData extends Object<PinContactData> {
  PinContactData({
    this.status,
    this.pinContact,
    this.error,
  });

  int status;
  PinContact pinContact;
  ResponseError error;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  PinContactData fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return PinContactData(
        status: dynamicData['status'],
        pinContact: PinContact().fromMap(dynamicData['data']),
        error: ResponseError().fromMap(dynamicData['error']),
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(PinContactData object) {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['status'] = object.status;
      data['data'] = PinContact().toMap(object.pinContact);
      data['error'] = ResponseError().toMap(object.error);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<PinContactData> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<PinContactData> login = <PinContactData>[];
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
  List<Map<String, dynamic>> toMapList(List<PinContactData> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (PinContactData data in objectList)
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