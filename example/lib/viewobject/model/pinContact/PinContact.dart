import 'package:quiver/core.dart';
import 'package:voice_example/viewobject/common/Object.dart';

class PinContact extends Object<PinContact> {
  PinContact({
    this.status,
  });

  bool status;

  @override
  bool operator ==(dynamic other) => other is PinContact && status == other.status;


  @override
  int get hashCode => hash2(status.hashCode, status.hashCode);

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  PinContact fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return PinContact(
        status: dynamicData['success'],
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['success'] = object.status;
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<PinContact> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<PinContact> voiceTokenList = <PinContact>[];
    if (dynamicDataList != null)
    {
      for (dynamic json in dynamicDataList)
      {
        if (json != null)
        {
          voiceTokenList.add(fromMap(json));
        }
      }
    }
    return voiceTokenList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<PinContact> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (PinContact data in objectList)
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
