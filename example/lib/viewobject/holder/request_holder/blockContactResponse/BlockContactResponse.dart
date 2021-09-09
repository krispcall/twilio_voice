/*
 * *
 *  * Created by Kedar on 7/29/21 9:15 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/29/21 9:15 AM
 *
 */


import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/blockContact/BlockContactData.dart';
import 'package:voice_example/viewobject/model/invite/InviteMemberData.dart';

class BlockContactResponse extends Object<BlockContactResponse> {
  BlockContactData data;

  BlockContactResponse({this.data});

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  BlockContactResponse fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return BlockContactResponse(
        data: BlockContactData().fromMap(dynamicData['blockContact']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(BlockContactResponse object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['blockContact'] = BlockContactData().toMap(object.data);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<BlockContactResponse> fromMapList(List dynamicDataList) {
    // TODO: implement fromMapList
    throw UnimplementedError();
  }

  @override
  List<Map<String, dynamic>> toMapList(List<BlockContactResponse> objectList) {
    // TODO: implement toMapList
    throw UnimplementedError();
  }
}

