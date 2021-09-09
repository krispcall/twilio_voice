import 'package:voice_example/viewobject/common/Object.dart';
import 'package:quiver/core.dart';

class Sound extends Object<Sound>
{
  Sound({
    this.id,
    this.name,
    this.assetUrl,
  });

  final String id;
  final String name;
  final String assetUrl;

  @override
  bool operator ==(dynamic other) => other is Sound && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  Sound fromMap(dynamic dynamicData)
  {
    if (dynamicData != null) {
      return Sound(
        id: dynamicData['id'],
        name: dynamicData['name'],
        assetUrl: dynamicData['assetUrl'],
      );
    } else {
      return null;
    }
  }

  Sound fromJson(dynamic dynamicData) {
    if (dynamicData != null) {
      return Sound(
        id: dynamicData['id'],
        name: dynamicData['name'],
        assetUrl: dynamicData['assetUrl'],
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(Sound object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['name'] = object.name;
      data['assetUrl'] = object.assetUrl;
      return data;
    } else {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    data['assetUrl'] = this.assetUrl;
    return data;
  }

  @override
  List<Sound> fromMapList(List<dynamic> dynamicDataList) {
    final List<Sound> commentList = <Sound>[];

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
  List<Map<String, dynamic>> toMapList(List<Sound> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (Sound data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }

    return mapList;
  }
}
