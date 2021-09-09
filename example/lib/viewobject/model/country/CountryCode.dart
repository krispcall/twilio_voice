import 'dart:convert';
import 'package:voice_example/viewobject/common/Object.dart';
import 'package:quiver/core.dart';

class CountryCode extends Object<CountryCode>
{
  CountryCode({
    this.id,
    this.name,
    this.flagUri,
    this.code,
    this.dialCode,
    this.length,
  });

  String id;
  String name;
  String flagUri;
  String code;
  String dialCode;
  String length;

  @override
  bool operator ==(dynamic other) => other is CountryCode && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  CountryCode fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return CountryCode(
        id: dynamicData['uid'],
        name: dynamicData['name'],
        flagUri: dynamicData['flagUrl'],
        code: dynamicData['alphaTwoCode'],
        dialCode: dynamicData['dialingCode'],
        length: dynamicData['length'],
      );
    }
    else
    {
      return null;
    }
  }

   CountryCode.fromJson(Map<String, dynamic> dynamicData)
   {
     this.id = dynamicData['uid'];
     this.name = dynamicData['name'];
     this.flagUri = dynamicData['flagUrl'];
     this.code = dynamicData['alphaTwoCode'];
     this.dialCode = dynamicData['dialingCode'];
     this.length = dynamicData['length'];
   }


  CountryCode fromJson(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return CountryCode(
        id: dynamicData['uid'],
        name: dynamicData['name'],
        flagUri: dynamicData['flagUrl'],
        code: dynamicData['alphaTwoCode'],
        dialCode: dynamicData['dialingCode'],
        length: dynamicData['length'],
      );
    }
    else
    {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(CountryCode object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['uid'] = object.id;
      data['name'] = object.name;
      data['flagUrl'] = object.flagUri;
      data['alphaTwoCode'] = object.code;
      data['dialingCode'] = object.dialCode;
      data['length'] = object.length;
      return data;
    } else {
      return null;
    }
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = this.id;
    data['name'] = this.name;
    data['flagUrl'] = this.flagUri;
    data['alphaTwoCode'] = this.code;
    data['dialingCode'] = this.dialCode;
    data['length'] = this.length;
    return data;
  }

  @override
  List<CountryCode> fromMapList(List<dynamic> dynamicDataList) {
    final List<CountryCode> commentList = <CountryCode>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          commentList.add(fromMap(dynamicData));
        }
      }
    }
    return commentList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<CountryCode> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (CountryCode data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }

    return mapList;
  }
}

CountryCode countryResponseFromJson(String str) => CountryCode.fromJson(json.decode(str));

List<CountryCode> countryCodeFromJson(String str) => List<CountryCode>.from(json.decode(str).map((x) => CountryCode.fromJson(x)));

String countryCodeToJson(List<CountryCode> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

