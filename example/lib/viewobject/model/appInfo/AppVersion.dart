import 'package:quiver/core.dart';
import 'package:voice_example/viewobject/common/Object.dart';

class AppVersion extends Object<AppVersion>
{
  AppVersion({
    this.versionNo,
    this.versionForceUpdate,
    this.versionNeedClearData
  });
  String versionNo;
  bool versionForceUpdate;
  bool versionNeedClearData;

  @override
  bool operator ==(dynamic other) => other is AppVersion && versionNo == other.versionNo;


  @override
  int get hashCode => hash2(versionNo.hashCode, versionNo.hashCode);

  @override
  String getPrimaryKey()
  {
    return versionNo;
  }

  @override
  AppVersion fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      // return PSAppVersion(
      //     versionNo: "1.3.12",
      //     versionForceUpdate: "true",
      //     versionTitle: "Test",
      //     versionMessage: "Test",
      //     versionNeedClearData: "true"
      // );

      return AppVersion(
          versionNo: dynamicData['versionNo'],
          versionForceUpdate: dynamicData['versionForceUpdate'],
          versionNeedClearData: dynamicData['versionNeedClearData']
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
      data['versionNo'] = object.versionNo;
      data['versionForceUpdate'] = object.versionForceUpdate;
      data['versionNeedClearData'] = object.versionNeedClearData;
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<AppVersion> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<AppVersion> psAppVersionList = <AppVersion>[];
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
  List<Map<String, dynamic>> toMapList(List<AppVersion> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (AppVersion data in objectList)
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
