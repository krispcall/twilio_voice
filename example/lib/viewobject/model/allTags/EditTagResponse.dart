import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/allTags/AllTagsResponseData.dart';
import 'package:voice_example/viewobject/model/allTags/EditTagTitleData.dart';

class EditTagResponse extends Object<EditTagResponse>
{
  EditTagResponse({
    this.editTagData,
  });

  EditTagTitleData editTagData;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  EditTagResponse fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return EditTagResponse(
        editTagData: EditTagTitleData().fromMap(dynamicData['editTag']),
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(EditTagResponse object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['editTag'] = EditTagTitleData().toMap(object.editTagData);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<EditTagResponse> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<EditTagResponse> data = <EditTagResponse>[];

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
  List<Map<String, dynamic>> toMapList(List<EditTagResponse> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (EditTagResponse data in objectList)
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