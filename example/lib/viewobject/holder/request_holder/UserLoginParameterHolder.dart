import 'package:flutter/cupertino.dart';
import 'package:voice_example/viewobject/common/Holder.dart';

class UserLoginParameterHolder extends Holder<UserLoginParameterHolder> {
  UserLoginParameterHolder({
    @required this.details,
    @required this.client,
    @required this.deviceId,
  });

  final UserLoginParamDetails details;
  final String client;
  final String deviceId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['details'] = details.toMap();
    map['client'] = client;
    map['device'] = deviceId;
    return map;
  }

  @override
  UserLoginParameterHolder fromMap(dynamic dynamicData) {
    return UserLoginParameterHolder(
      details: UserLoginParamDetails().fromMap(dynamicData['details']),
      client: dynamicData['client'],
      deviceId: dynamicData['device'],
    );
  }
}

class UserLoginParamDetails extends Holder<UserLoginParamDetails> {
  UserLoginParamDetails({this.userEmail, this.userPassword, this.kind});

  final String userEmail;
  final String userPassword;
  final String kind;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['login'] = userEmail;
    map['password'] = userPassword;
    map['kind'] = kind;
    return map;
  }

  @override
  UserLoginParamDetails fromMap(dynamic dynamicData) {
    return UserLoginParamDetails(
      userEmail: dynamicData['username'],
      userPassword: dynamicData['password'],
      kind: dynamicData['kind'],
    );
  }
}
