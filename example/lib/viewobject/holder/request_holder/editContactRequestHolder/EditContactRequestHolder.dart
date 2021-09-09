import 'package:flutter/cupertino.dart';
import 'package:voice_example/viewobject/common/Holder.dart';
import 'package:voice_example/viewobject/holder/request_holder/addTagsToContactRequestParamHolder/AddTagsToContactRequestParamHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/editContactRequestParamHolder/EditContactRequestParamHolder.dart';

class EditContactRequestHolder extends Holder<EditContactRequestHolder> {
  EditContactRequestHolder({
    @required this.data,
    @required this.id,
  });

  EditContactRequestParamHolder data;
  String id;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['data'] = data.toMap();
    map['id'] = id;
    return map;
  }

  @override
  EditContactRequestHolder fromMap(dynamic dynamicData)
  {
    return EditContactRequestHolder(
      data: EditContactRequestParamHolder().fromMap(dynamicData['data']),
      id: dynamicData['id'],
    );
  }
}
