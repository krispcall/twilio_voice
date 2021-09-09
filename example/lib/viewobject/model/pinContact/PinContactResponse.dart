import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/pinContact/PinContactData.dart';

class PinContactResponse extends Object<PinContactResponse>
{
  PinContactResponse({
    this.pinContactData,
  });

  PinContactData pinContactData;

  @override
  String getPrimaryKey()
  {
    return '';
  }

  @override
  PinContactResponse fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return PinContactResponse(
        pinContactData: PinContactData().fromMap(dynamicData['addPinned']),
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
      data['addPinned'] = PinContactData().toMap(object.pinContactData);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<PinContactResponse> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<PinContactResponse> voiceTokenResponseList = <PinContactResponse>[];
    if (dynamicDataList != null)
    {
      for (dynamic json in dynamicDataList)
      {
        if (json != null)
        {
          voiceTokenResponseList.add(fromMap(json));
        }
      }
    }
    return voiceTokenResponseList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<dynamic> objectList)
  {
    final List<dynamic> dynamicList = <dynamic>[];
    if (objectList != null) {
      for (dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data));
        }
      }
    }

    return dynamicList;
  }
}
