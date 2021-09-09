/*
 * *
 *  * Created by Kedar on 7/21/21 11:29 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/21/21 11:29 AM
 *  
 */

import 'package:voice_example/viewobject/common/Holder.dart' show Holder;
import 'package:flutter/cupertino.dart';
import 'package:voice_example/viewobject/holder/request_holder/addNotesToContactRequestParamHolder/AddNoteToContactRequestParamHolder.dart';


class AddNoteByNumberRequestHolder extends Holder<AddNoteByNumberRequestHolder> {
  AddNoteByNumberRequestHolder({
    @required this.contact,
    @required this.data
  });

  final String contact;
  final AddNoteToContactRequestParamHolder data;

  @override
  Map<String, dynamic> toMap()
  {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['contact'] = contact;
    map['data'] = data.toMap();
    return map;
  }

  @override
  AddNoteByNumberRequestHolder fromMap(dynamic dynamicData) {
    return AddNoteByNumberRequestHolder(
      contact: dynamicData['contact'],
      data: AddNoteToContactRequestParamHolder().fromMap(dynamicData['data']),
    );
  }
}
