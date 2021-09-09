import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/numbers/Agents.dart';

class Numbers extends Object<Numbers>
{
  String id;
  String name;
  String number;
  String country;
  String countryLogo;
  String countryCode;
  List<Agents>  agents;

  Numbers({
    this.id,
    this.name,
    this.number,
    this.country,
    this.countryLogo,
    this.countryCode,
    this.agents,
  });

  @override
  Numbers fromMap(dynamicData)
  {
    if (dynamicData != null)
    {
      return Numbers(
        name: dynamicData['name'],
        number: dynamicData['number'],
        country: dynamicData['country'],
        countryLogo: dynamicData['countryLogo'],
        countryCode: dynamicData['countryCode'],
        agents: Agents().fromMapList(dynamicData['agents']),
      );
    }
    else
    {
      return null;
    }
  }

  @override
  List<Numbers> fromMapList(List dynamicDataList)
  {
    final List<Numbers> data = <Numbers>[];

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
  Map<String, dynamic> toMap(Numbers object)
  {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['name'] = object.name;
      data['number'] = object.number;
      data['country'] = object.country;
      data['countryLogo'] = object.countryLogo;
      data['countryCode'] = object.countryCode;
      data['agents'] = Agents().toMapList(object.agents);
      return data;
    }
    else
    {
      return null;
    }
  }

  @override
  List<Map<String, dynamic>> toMapList(List<Numbers> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null)
    {
      for (Numbers data in objectList)
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