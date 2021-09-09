import 'package:voice_example/viewobject/common/Object.dart';

class ResponseError extends Object<ResponseError>
{
  ResponseError({
    this.code,
    this.message,
  });

  int code;
  String message;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  ResponseError fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return ResponseError(
        code:dynamicData['code'],
        message:dynamicData['message'],
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(ResponseError object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['code'] = object.code;
      data['message'] = object.message;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ResponseError> fromMapList(List<dynamic> dynamicDataList) {
    final List<ResponseError> error = <ResponseError>[];
    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          error.add(fromMap(dynamicData));
        }
      }
    }
    return error;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<ResponseError> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (ResponseError data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}