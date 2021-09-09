
import 'package:voice_example/viewobject/common/Holder.dart';

class SendMessageRequestContentHolder extends Holder<SendMessageRequestContentHolder>
{
  final String body;

  SendMessageRequestContentHolder({
    this.body,
  });

  @override
  SendMessageRequestContentHolder fromMap(dynamicData)
  {
    return SendMessageRequestContentHolder(
      body: dynamicData['body'],
    );
  }

  @override
  Map toMap()
  {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['body'] = body;
    return map;
  }
}