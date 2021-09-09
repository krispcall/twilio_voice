import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:voice_example/viewobject/model/country/CountryCode.dart';

class AddContactIntentHolder {

  final List<CountryCode> countryList;
  final CountryCode defaultCountryCode;
  final String phoneNumber;
  final Function onIncomingTap;
  final Function onOutgoingTap;

  AddContactIntentHolder({
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
    this.countryList,
    this.defaultCountryCode,
    this.phoneNumber
  });
}
