
import 'package:voice_example/viewobject/common/Holder.dart';

class ContactDetailRequestParamHolder extends Holder<ContactDetailRequestParamHolder>
{
  final String uid;

  ContactDetailRequestParamHolder({
    this.uid,
  });

  @override
  ContactDetailRequestParamHolder fromMap(dynamicData)
  {
    return ContactDetailRequestParamHolder(
      uid: dynamicData['uid'],
    );
  }

  @override
  Map toMap()
  {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['uid'] = uid;
    return map;
  }
}