/*
 * *
 *  * Created by Kedar on 7/29/21 9:01 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/29/21 9:01 AM
 *  
 */

import 'package:flutter/cupertino.dart';
import 'package:voice_example/viewobject/common/Holder.dart';

class InviteMemberParamHolder extends Holder<InviteMemberParamHolder> {
  InviteMemberParamHolder({
    @required this.email,
    @required this.role,
    @required this.inviteLink,
  });

  String email;
  String role;
  String inviteLink;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['email'] = email;
    map['role'] = role;
    map['inviteLink'] = inviteLink;
    return map;
  }

  @override
  InviteMemberParamHolder fromMap(dynamic dynamicData) {
    return InviteMemberParamHolder(
      email: dynamicData['email'],
      role: dynamicData['role'],
      inviteLink: dynamicData['inviteLink'],
    );
  }
}