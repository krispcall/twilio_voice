import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/deviceInfo/DeviceInfoData.dart';

class DeviceInfoResponse extends Object<DeviceInfoResponse>
{
  DeviceInfoResponse({
    this.deviceInfoData,
  });

  DeviceInfoData deviceInfoData;

  @override
  String getPrimaryKey()
  {
    return '';
  }

  @override
  DeviceInfoResponse fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return DeviceInfoResponse(
        deviceInfoData: DeviceInfoData().fromMap(dynamicData['deviceRegister']),
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
      data['deviceRegister'] = DeviceInfoData().toMap(object.appInfo);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<DeviceInfoResponse> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<DeviceInfoResponse> psAppInfoList = <DeviceInfoResponse>[];
    if (dynamicDataList != null)
    {
      for (dynamic json in dynamicDataList)
      {
        if (json != null)
        {
          psAppInfoList.add(fromMap(json));
        }
      }
    }
    return psAppInfoList;
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
