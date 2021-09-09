/*
 * *
 *  * Created by Kedar on 7/29/21 9:15 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/29/21 9:15 AM
 *
 */


import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/invite/InviteMemberData.dart';

class InviteMemberResponse extends Object<InviteMemberResponse> {
  InviteMemberData data;

  InviteMemberResponse({this.data});

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  InviteMemberResponse fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return InviteMemberResponse(
        data: InviteMemberData().fromMap(dynamicData['inviteMember']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(InviteMemberResponse object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['inviteMember'] = InviteMemberData().toMap(object.data);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<InviteMemberResponse> fromMapList(List dynamicDataList) {
    // TODO: implement fromMapList
    throw UnimplementedError();
  }

  @override
  List<Map<String, dynamic>> toMapList(List<InviteMemberResponse> objectList) {
    // TODO: implement toMapList
    throw UnimplementedError();
  }
}

