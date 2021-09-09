import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/contactDetail/ContactDetailResponseData.dart';

class ContactDetailResponse extends Object<ContactDetailResponse>
{
  ContactDetailResponse({
    this.contactDetailResponseData,
  });

  ContactDetailResponseData contactDetailResponseData;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  ContactDetailResponse fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return ContactDetailResponse(
        contactDetailResponseData: ContactDetailResponseData().fromMap(dynamicData['contact']),
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(ContactDetailResponse object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['contact'] = ContactDetailResponseData().toMap(object.contactDetailResponseData);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<ContactDetailResponse> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<ContactDetailResponse> data = <ContactDetailResponse>[];

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
  List<Map<String, dynamic>> toMapList(List<ContactDetailResponse> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (ContactDetailResponse data in objectList)
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