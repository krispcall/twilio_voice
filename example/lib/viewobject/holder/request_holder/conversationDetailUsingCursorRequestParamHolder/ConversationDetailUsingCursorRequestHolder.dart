import 'package:flutter/cupertino.dart';
import 'package:voice_example/viewobject/common/Holder.dart' show Holder;
import 'package:voice_example/viewobject/holder/request_holder/conversationDetailRequestParamHolder/ConversationDetailRequestParamHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/conversationDetailUsingCursorRequestParamHolder/SearchConversationRequestUsingCursorParamHolder.dart';

class ConversationDetailUsingCursorRequestHolder extends Holder<ConversationDetailUsingCursorRequestHolder>
{
  ConversationDetailUsingCursorRequestHolder({
    @required this.channel,
    @required this.contact,
    @required this.param,
  });

  final String channel;
  final String contact;
  final SearchConversationUsingCursorRequestParamHolder param;

  @override
  Map<String, dynamic> toMap()
  {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['channel'] = channel;
    map['contact'] = contact;
    map['params'] = SearchConversationUsingCursorRequestParamHolder(last: param.last,beforeWith: param.beforeWith).toMap();
    return map;
  }

  @override
  ConversationDetailUsingCursorRequestHolder fromMap(dynamic dynamicData)
  {
    return ConversationDetailUsingCursorRequestHolder(
      channel: dynamicData['channel'],
      contact: dynamicData['contact'],
      param: SearchConversationUsingCursorRequestParamHolder().fromMap(dynamicData['params']),
    );
  }
}
