import 'package:flutter/cupertino.dart';
import 'package:voice_example/viewobject/common/Holder.dart';
import 'package:voice_example/viewobject/holder/request_holder/addTagsToContactRequestParamHolder/AddTagsToContactRequestParamHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/editContactRequestParamHolder/EditContactRequestParamHolder.dart';

class EditTagRequestParamHolder extends Holder<EditTagRequestParamHolder> {
  EditTagRequestParamHolder({
    @required this.data,
    @required this.id,
  });

  Map<String, dynamic> data;
  String id;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['data'] = data;
    map['id'] = id;
    return map;
  }

  @override
  EditTagRequestParamHolder fromMap(dynamic dynamicData)
  {
    return EditTagRequestParamHolder(
      data: dynamicData['data'],
      id: dynamicData['id'],
    );
  }
}
