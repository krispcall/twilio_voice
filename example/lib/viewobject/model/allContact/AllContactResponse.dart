import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/allContact/AllContactResponseData.dart';

class AllContactResponse extends Object<AllContactResponse>
{
  AllContactResponse({
    this.contactResponse,
  });

  AllContactResponseData contactResponse;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  AllContactResponse fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return AllContactResponse(
        contactResponse: AllContactResponseData().fromMap(dynamicData['contacts']),
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(AllContactResponse object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['contacts'] = AllContactResponseData().toMap(object.contactResponse);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<AllContactResponse> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<AllContactResponse> data = <AllContactResponse>[];

    if (dynamicDataList != null)
    {
      for (dynamic dynamicData in dynamicDataList)
      {
        if (dynamicData != null)
        {
          data.add(fromMap(dynamicData));
        }
      }
    }
    return data;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<AllContactResponse> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (AllContactResponse data in objectList)
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