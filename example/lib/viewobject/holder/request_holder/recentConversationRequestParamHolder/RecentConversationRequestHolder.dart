import 'package:flutter/cupertino.dart';
import 'package:voice_example/viewobject/common/Holder.dart' show Holder;
import 'package:voice_example/viewobject/holder/request_holder/recentConversationRequestParamHolder/RecentConverstaionRequestParamHolder.dart';


class RecentConversationRequestHolder extends Holder<RecentConversationRequestHolder>
{
  RecentConversationRequestHolder({@required this.channel, @required this.param, first});

  final String channel;
  final RecentConversationRequestParamHolder param;

  @override
  Map<String, dynamic> toMap()
  {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['channel'] = channel;
    map['params'] = RecentConversationRequestParamHolder(conversationType: param.conversationType, sort: param.sort, first: param.first, after: param.after, afterWith: param.afterWith, search: param.search).toMap();
    return map;
  }

  @override
  RecentConversationRequestHolder fromMap(dynamic dynamicData)
  {
    return RecentConversationRequestHolder(
      channel: dynamicData['channel'],
      param: RecentConversationRequestParamHolder().fromMap(dynamicData['params']),
    );
  }
}