import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/appInfo/AppVersion.dart';
import 'package:voice_example/viewobject/model/error/ResponseError.dart';

class AppInfoData extends Object<AppInfoData> {
  AppInfoData({
    this.status,
    this.appVersion,
    this.error,
  });

  int status;
  AppVersion appVersion;
  ResponseError error;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  AppInfoData fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return AppInfoData(
        status: dynamicData['status'],
        appVersion: AppVersion().fromMap(dynamicData['data']),
        error: ResponseError().fromMap(dynamicData['error']),
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(AppInfoData object) {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['status'] = object.status;
      data['data'] = AppVersion().toMap(object.appVersion);
      data['error'] = ResponseError().toMap(object.error);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<AppInfoData> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<AppInfoData> login = <AppInfoData>[];
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
  List<Map<String, dynamic>> toMapList(List<AppInfoData> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (AppInfoData data in objectList)
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