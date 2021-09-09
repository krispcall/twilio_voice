import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/allContact/AllContactData.dart';
import 'package:voice_example/viewobject/model/error/ResponseError.dart';

class AllContactResponseData extends Object<AllContactResponseData> {
  AllContactResponseData({
    this.status,
    this.contactResponseData,
    this.error,
  });

  int status;
  AllContactData contactResponseData;
  ResponseError error;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  AllContactResponseData fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return AllContactResponseData(
        status: dynamicData['status'],
        contactResponseData: AllContactData().fromMap(dynamicData['data']),
        error: ResponseError().fromMap(dynamicData['error']),
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(AllContactResponseData object) {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['status'] = object.status;
      data['data'] = AllContactData().toMap(object.contactResponseData);
      data['error'] = ResponseError().toMap(object.error);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<AllContactResponseData> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<AllContactResponseData> login = <AllContactResponseData>[];
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
  List<Map<String, dynamic>> toMapList(List<AllContactResponseData> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (AllContactResponseData data in objectList)
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