import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/editContact/EditContactResponseData.dart';

class EditContactResponse extends Object<EditContactResponse>
{
  EditContactResponse({
    this.editContactResponseData,
  });

  EditContactResponseData editContactResponseData;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  EditContactResponse fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return EditContactResponse(
        editContactResponseData: EditContactResponseData().fromMap(dynamicData['editContact']),
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(EditContactResponse object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['editContact'] = EditContactResponseData().toMap(object.editContactResponseData);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<EditContactResponse> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<EditContactResponse> data = <EditContactResponse>[];

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
  List<Map<String, dynamic>> toMapList(List<EditContactResponse> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (EditContactResponse data in objectList)
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