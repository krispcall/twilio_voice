import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/appInfo/AppInfoData.dart';

class AppInfo extends Object<AppInfo>
{
  AppInfo({
    this.appRegisterInfo,
  });

  AppInfoData appRegisterInfo;

  @override
  String getPrimaryKey()
  {
    return '';
  }

  @override
  AppInfo fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return AppInfo(
        appRegisterInfo: AppInfoData().fromMap(dynamicData['appRegisterInfo']),
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
      data['data'] = AppInfoData().toMap(object.appInfo);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<AppInfo> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<AppInfo> psAppInfoList = <AppInfo>[];
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
