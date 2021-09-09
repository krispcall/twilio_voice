import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/workspace/plan/WorkSpacePlan.dart';
import 'package:quiver/core.dart';

class LoginWorkspace extends Object<LoginWorkspace> {
  LoginWorkspace({
    this.id,
    this.memberId,
    this.title,
    this.role,
    this.photo,
    this.status,
    this.plan
  });

  String id;
  String memberId;
  String title;
  String role;
  String photo;
  String status;
  PlanOverviewData plan;


  @override
  bool operator ==(dynamic other) => other is LoginWorkspace && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  LoginWorkspace fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return LoginWorkspace(
          id: dynamicData['id'],
          memberId: dynamicData['memberId'],
          title: dynamicData['title'],
          role: dynamicData['role'],
          photo: dynamicData['photo'],
          status: dynamicData['status'],
          plan: PlanOverviewData().fromMap(dynamicData['plan'])
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(LoginWorkspace object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['memberId'] = object.memberId;
      data['title'] = object.title;
      data['role'] = object.role;
      data['photo'] = object.photo;
      data['status'] = object.status;
      data['plan'] = PlanOverviewData().toMap(object.plan);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<LoginWorkspace> fromMapList(List<dynamic> dynamicDataList) {
    final List<LoginWorkspace> workSpace = <LoginWorkspace>[];
    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          workSpace.add(fromMap(dynamicData));
        }
      }
    }
    return workSpace;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<LoginWorkspace> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (LoginWorkspace data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
