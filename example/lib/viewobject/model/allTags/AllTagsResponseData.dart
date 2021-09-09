
import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/allContact/Tags.dart';
import 'package:voice_example/viewobject/model/error/ResponseError.dart';

class AllTagsResponseData extends Object<AllTagsResponseData> {
  AllTagsResponseData({
    this.status,
    this.listTags,
    this.error,
  });

  int status;
  List<Tags> listTags;
  ResponseError error;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  AllTagsResponseData fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return AllTagsResponseData(
        status: dynamicData['status'],
        listTags: Tags().fromMapList(dynamicData['data']),
        error: ResponseError().fromMap(dynamicData['error']),
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(AllTagsResponseData object) {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['status'] = object.status;
      data['data'] = Tags().toMapList(object.listTags);
      data['error'] = ResponseError().toMap(object.error);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<AllTagsResponseData> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<AllTagsResponseData> login = <AllTagsResponseData>[];
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
  List<Map<String, dynamic>> toMapList(List<AllTagsResponseData> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (AllTagsResponseData data in objectList)
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