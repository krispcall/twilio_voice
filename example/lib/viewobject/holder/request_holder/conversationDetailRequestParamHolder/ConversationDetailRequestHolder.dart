import 'package:flutter/cupertino.dart';
import 'package:voice_example/viewobject/common/Holder.dart' show Holder;
import 'package:voice_example/viewobject/holder/request_holder/conversationDetailRequestParamHolder/ConversationDetailRequestParamHolder.dart';

class ConversationDetailRequestHolder
    extends Holder<ConversationDetailRequestHolder> {
  ConversationDetailRequestHolder({
    @required this.channel,
    @required this.contact,
    @required this.param,
  });

  final String channel;
  final String contact;
  final ConversationDetailRequestParamHolder param;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['channel'] = channel;
    map['contact'] = contact;
    map['params'] = ConversationDetailRequestParamHolder(
            conversationType: param.conversationType,
            sort: param.sort,
            first: param.first,
            after: param.after,
            afterWith: param.afterWith,
            beforeWith: param.beforeWith,
            last: param.last,
            before: param.before)
        .toMap();
    return map;
  }

  @override
  ConversationDetailRequestHolder fromMap(dynamic dynamicData) {
    return ConversationDetailRequestHolder(
      channel: dynamicData['channel'],
      contact: dynamicData['contact'],
      param:
          ConversationDetailRequestParamHolder().fromMap(dynamicData['params']),
    );
  }
}
