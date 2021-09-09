import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/error/ResponseError.dart';
import 'package:voice_example/viewobject/model/members/MemberData.dart';
import 'package:voice_example/viewobject/model/numbers/Numbers.dart';

class NumberData extends Object<NumberData>
{
  NumberData({
    this.status,
    this.numbers,
    this.error,
  });

  int status;
  List<Numbers> numbers;
  ResponseError error;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  NumberData fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return NumberData(
        status: dynamicData['status'],
        numbers: Numbers().fromMapList(dynamicData['data']),
        error: ResponseError().fromMap(dynamicData['error']),
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(NumberData object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['status'] = object.status;
      data['data'] = Numbers().toMapList(object.numbers);
      data['error'] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<NumberData> fromMapList(List<dynamic> dynamicDataList) {
    final List<NumberData> login = <NumberData>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          login.add(fromMap(dynamicData));
        }
      }
    }
    return login;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<NumberData> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (NumberData data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}