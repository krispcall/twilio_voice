import 'package:flutter/cupertino.dart';
import 'package:voice_example/viewobject/common/Holder.dart' show Holder;
import 'package:voice_example/viewobject/holder/request_holder/sendMessageRequestParamHolder/SendMessageRequestContentHolder.dart';


class SendMessageRequestHolder extends Holder<SendMessageRequestHolder>
{
  SendMessageRequestHolder({
    @required this.conversationType,
    @required this.channel,
    @required this.contact,
    @required this.content,
  });

  final String conversationType;
  final String channel;
  final String contact;
  final SendMessageRequestContentHolder content;

  @override
  Map<String, dynamic> toMap()
  {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['conversationType'] = conversationType;
    map['channel'] = channel;
    map['contact'] = contact;
    map['content'] = SendMessageRequestContentHolder(body: content.body).toMap();
    return map;
  }

  @override
  SendMessageRequestHolder fromMap(dynamic dynamicData)
  {
    return SendMessageRequestHolder(
      conversationType: dynamicData['conversationType'],
      channel: dynamicData['channel'],
      contact: dynamicData['contact'],
      content: SendMessageRequestContentHolder().fromMap(dynamicData['content']),
    );
  }
}
