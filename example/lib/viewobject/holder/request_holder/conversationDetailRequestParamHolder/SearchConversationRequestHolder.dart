import 'package:flutter/cupertino.dart';
import 'package:voice_example/viewobject/common/Holder.dart' show Holder;
import 'package:voice_example/viewobject/holder/request_holder/conversationDetailRequestParamHolder/ConversationDetailRequestParamHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/conversationDetailRequestParamHolder/SearchConversationRequestParamHolder.dart';

class SearchConversationRequestHolder extends Holder<SearchConversationRequestHolder>
{
  SearchConversationRequestHolder({
    @required this.channel,
    @required this.contact,
    @required this.param,
  });

  final String channel;
  final String contact;
  final SearchConversationRequestParamHolder param;

  @override
  Map<String, dynamic> toMap()
  {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['channel'] = channel;
    map['contact'] = contact;
    map['params'] = SearchConversationRequestParamHolder(first: param.first,search: param.search).toMap();
    return map;
  }

  @override
  SearchConversationRequestHolder fromMap(dynamic dynamicData)
  {
    return SearchConversationRequestHolder(
      channel: dynamicData['channel'],
      contact: dynamicData['contact'],
      param: SearchConversationRequestParamHolder().fromMap(dynamicData['params']),
    );
  }
}
