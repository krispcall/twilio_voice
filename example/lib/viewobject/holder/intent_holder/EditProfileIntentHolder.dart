import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:voice_example/viewobject/model/country/CountryCode.dart';

class EditProfileIntentHolder
{
  const EditProfileIntentHolder({
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
    this.selectedCountryCode,
    this.phoneNumber,
    this.name,
    this.email,
    this.id,
    this.onSuccess
  });

  final CountryCode selectedCountryCode;
  final String phoneNumber;
  final String name;
  final String email;
  final String id;
  final VoidCallback onSuccess;
  final Function onIncomingTap;
  final Function onOutgoingTap;
}
