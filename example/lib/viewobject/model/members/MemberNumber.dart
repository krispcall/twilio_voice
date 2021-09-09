import 'package:voice_example/viewobject/common/Object.dart';

class MemberNumber extends Object<MemberNumber>
{
  String name;
  String number;
  String country;
  String countryLogo;
  String countryCode;

  MemberNumber({
    this.name,
    this.number,
    this.country,
    this.countryLogo,
    this.countryCode
  });

  @override
  MemberNumber fromMap(dynamicData)
  {
    if (dynamicData != null)
    {
      return MemberNumber(
        name: dynamicData['name'],
        number: dynamicData['number'],
        country: dynamicData['country'],
        countryLogo: dynamicData['countryLogo'],
        countryCode: dynamicData['countryCode'],
      );
    }
    else
    {
      return null;
    }
  }

  @override
  List<MemberNumber> fromMapList(List dynamicDataList)
  {
    final List<MemberNumber> data = <MemberNumber>[];

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
  String getPrimaryKey()
  {
    return "";
  }

  @override
  Map<String, dynamic> toMap(MemberNumber object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['name'] = object.name;
      data['number'] = object.number;
      data['country'] = object.country;
      data['countryLogo'] = object.countryLogo;
      data['countryCode'] = object.countryCode;
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<Map<String, dynamic>> toMapList(List<MemberNumber> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (MemberNumber data in objectList)
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