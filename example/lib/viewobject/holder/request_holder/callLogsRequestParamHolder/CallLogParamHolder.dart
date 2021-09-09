import 'package:flutter/cupertino.dart';
import 'package:voice_example/viewobject/common/Holder.dart' show Holder;
import 'package:voice_example/viewobject/holder/request_holder/callLogsRequestParamHolder/PageRequestParamHolder.dart';

class CallLogParamHolder extends Holder<CallLogParamHolder>
{
  CallLogParamHolder({@required this.channel, @required this.param, first});

  final String channel;
  final PageRequestParamHolder param;

  @override
  Map<String, dynamic> toMap()
  {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['channel'] = channel;
    map['params'] = PageRequestParamHolder(q: param.q, sort: param.sort, first: param.first, after: param.after, afterWith: param.afterWith).toMap();
    return map;
  }

  @override
  CallLogParamHolder fromMap(dynamic dynamicData)
  {
    return CallLogParamHolder(
      channel: dynamicData['channel'],
      param: dynamicData['params'],
    );
  }
}
