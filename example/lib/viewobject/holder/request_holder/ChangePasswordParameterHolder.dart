import 'package:voice_example/viewobject/common/Holder.dart' show Holder;
import 'package:flutter/cupertino.dart';

class ChangePasswordParameterHolder extends Holder<ChangePasswordParameterHolder>
{
  ChangePasswordParameterHolder({@required this.currentPassword, @required this.newPassword,@required this.confirmPassword});

  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  @override
  Map<String, dynamic> toMap()
  {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['current_password'] =currentPassword;
    map['new_password'] = newPassword;
    map['confirm_new_password'] = confirmPassword;

    return map;
  }

  @override
  ChangePasswordParameterHolder fromMap(dynamic dynamicData)
  {
    return ChangePasswordParameterHolder(
      currentPassword: dynamicData['current_password'],
      newPassword: dynamicData['new_password'],
      confirmPassword: dynamicData['confirm_new_password'],
    );
  }
}
