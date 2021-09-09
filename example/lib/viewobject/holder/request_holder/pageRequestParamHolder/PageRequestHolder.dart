import 'package:flutter/cupertino.dart';
import 'package:voice_example/viewobject/common/Holder.dart';
import 'package:voice_example/viewobject/holder/request_holder/callLogsRequestParamHolder/PageRequestParamHolder.dart';

class PageRequestHolder extends Holder<PageRequestHolder>
{
  PageRequestHolder({
    @required this.param,
    first
  });

  final PageRequestParamHolder param;

  @override
  Map<String, dynamic> toMap()
  {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['pageParams'] = PageRequestParamHolder(q: param.q, sort: param.sort, first: param.first, after: param.after, afterWith: param.afterWith).toMap();
    return map;
  }

  @override
  PageRequestHolder fromMap(dynamic dynamicData)
  {
    return PageRequestHolder(
      param: dynamicData['pageParams'],
    );
  }
}
