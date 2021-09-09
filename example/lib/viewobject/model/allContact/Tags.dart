import 'package:quiver/core.dart';
import 'package:voice_example/viewobject/common/Object.dart';

class Tags extends Object<Tags> {
  Tags({
    this.id,
    this.title,
    this.colorCode,
    this.count,
    this.backgroundColorCode,
    this.check,
  });

  String id;
  String title;
  String colorCode;
  int count;
  String backgroundColorCode;
  bool check;

  @override
  bool operator ==(dynamic other) => other is Tags && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  Tags fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Tags(
        id: dynamicData['id'].toString(),
        title: dynamicData['title'],
        colorCode: dynamicData['colorCode'],
        count: dynamicData['count'],
        backgroundColorCode: dynamicData['backgroundColorCode'],
        check: false,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(Tags object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['title'] = object.title;
      data['colorCode'] = object.colorCode;
      data['count'] = object.count;
      data['backgroundColorCode'] = object.backgroundColorCode;
      data['check'] = object.check;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Tags> fromMapList(dynamicDataList) {
    final List<Tags> basketList = <Tags>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          basketList.add(fromMap(dynamicData));
        }
      }
    }
    return basketList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<Tags> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (Tags data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
