import 'package:flutter/cupertino.dart';
import 'package:voice_example/viewobject/common/Holder.dart' show Holder;
import 'package:voice_example/viewobject/holder/request_holder/allContactRequestParamHolder/AllContactRequestParamHolder.dart';

class AllContactRequestHolder extends Holder<AllContactRequestHolder> {
  AllContactRequestHolder({
    @required this.param,
    @required this.tags,
  });

  final AllContactRequestParamHolder param;
  final String tags;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['params'] = AllContactRequestParamHolder(
            conversationType: param.conversationType,
            sort: param.sort,
            first: param.first,
            after: param.after,
            afterWith: param.afterWith)
        .toMap();
    if (tags != null) {
      map['tags'] = tags;
    }
    return map;
  }

  @override
  AllContactRequestHolder fromMap(dynamic dynamicData) {
    return AllContactRequestHolder(
      param: AllContactRequestParamHolder().fromMap(dynamicData['params']),
      tags: dynamicData['tags'],
    );
  }
}
