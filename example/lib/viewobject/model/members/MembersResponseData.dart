import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/error/ResponseError.dart';
import 'package:voice_example/viewobject/model/members/MemberData.dart';

class MemberResponseData extends Object<MemberResponseData>
{
  MemberResponseData({
    this.status,
    this.memberData,
    this.error,
  });

  int status;
  MemberData memberData;
  ResponseError error;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  MemberResponseData fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return MemberResponseData(
        status: dynamicData['status'],
        memberData: MemberData().fromMap(dynamicData['data']),
        error: ResponseError().fromMap(dynamicData['error']),
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(MemberResponseData object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['status'] = object.status;
      data['data'] = MemberData().toMap(object.memberData);
      data['error'] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<MemberResponseData> fromMapList(List<dynamic> dynamicDataList) {
    final List<MemberResponseData> login = <MemberResponseData>[];

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
  List<Map<String, dynamic>> toMapList(List<MemberResponseData> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (MemberResponseData data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}