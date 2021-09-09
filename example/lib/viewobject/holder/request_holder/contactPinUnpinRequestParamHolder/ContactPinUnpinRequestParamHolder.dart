import 'package:voice_example/viewobject/common/Holder.dart';

class ContactPinUnPinRequestParamHolder extends Holder<ContactPinUnPinRequestParamHolder>
{
  final bool pinned;

  ContactPinUnPinRequestParamHolder({
    this.pinned,
  });

  @override
  ContactPinUnPinRequestParamHolder fromMap(dynamicData)
  {
    return ContactPinUnPinRequestParamHolder(
      pinned: dynamicData['pinned'],
    );
  }

  @override
  Map toMap()
  {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['pinned'] = pinned;
    return map;
  }
}
