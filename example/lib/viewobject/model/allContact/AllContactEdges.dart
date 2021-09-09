import 'package:azlistview/azlistview.dart';
import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/allContact/Contact.dart';

class AllContactEdges extends Object<AllContactEdges> implements ISuspensionBean
{
  AllContactEdges({this.cursor, this.contactNode, this.id, this.sorting, this.check});

  String id;
  String cursor;
  Contacts contactNode;
  int sorting;
  bool check = false;
  String tagIndex;
  String namePinyin;

  @override
  String getPrimaryKey()
  {
    return cursor;
  }

  @override
  AllContactEdges fromMap(dynamic dynamicData) {

    if (dynamicData != null)
    {
      return AllContactEdges(
          cursor: dynamicData['cursor'],
          contactNode: Contacts().fromMap(dynamicData['node']),
          id: dynamicData['id'],
          sorting: dynamicData['sorting'],
          check: dynamicData['check']);
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(AllContactEdges object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['cursor'] = object.cursor;
      data['node'] = object.contactNode != null ? Contacts().toMap(object.contactNode) : null;
      data['id'] = object.id;
      data['sorting'] = object.sorting;
      data['check'] = object.check;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AllContactEdges> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<AllContactEdges> basketList = <AllContactEdges>[];

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
  List<Map<String, dynamic>> toMapList(List<AllContactEdges> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (AllContactEdges data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }

  @override
  String getSuspensionTag() => tagIndex;

  @override
  bool isShowSuspension;
}