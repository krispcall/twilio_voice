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


class AddNoteToContactRequestHolder extends Holder<AddNoteToContactRequestHolder> {
  AddNoteToContactRequestHolder({
    @required this.clientId,
    @required this.data
  });

  final String clientId;
  final AddNoteToContactRequestParamHolder data;

  @override
  Map<String, dynamic> toMap()
  {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['clientId'] = clientId;
    map['data'] = data.toMap();
    return map;
  }

  @override
  AddNoteToContactRequestHolder fromMap(dynamic dynamicData) {
    return AddNoteToContactRequestHolder(
      clientId: dynamicData['clientId'],
      data: AddNoteToContactRequestParamHolder().fromMap(dynamicData['data']),
    );
  }
}
