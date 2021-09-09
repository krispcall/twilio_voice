import 'package:quiver/core.dart';
import 'package:voice_example/viewobject/common/Object.dart';

class DeviceInfo extends Object<DeviceInfo>
{
  DeviceInfo({
    this.id,
    this.platform,
    this.fcmToken,
    this.version,
  });
  String id;
  String platform;
  String fcmToken;
  String version;

  @override
  bool operator ==(dynamic other) => other is DeviceInfo && id == other.id;


  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String getPrimaryKey()
  {
    return id;
  }

  @override
  DeviceInfo fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return DeviceInfo(
          id: dynamicData['id'],
          platform: dynamicData['platform'],
          fcmToken: dynamicData['fcmToken'],
          version: dynamicData['version'],
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
      data['id'] = object.id;
      data['platform'] = object.platform;
      data['fcmToken'] = object.fcmToken;
      data['version'] = object.version;
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<DeviceInfo> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<DeviceInfo> psAppVersionList = <DeviceInfo>[];
    if (dynamicDataList != null)
    {
      for (dynamic json in dynamicDataList)
      {
        if (json != null)
        {
          psAppVersionList.add(fromMap(json));
        }
      }
    }
    return psAppVersionList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<DeviceInfo> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (DeviceInfo data in objectList)
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
