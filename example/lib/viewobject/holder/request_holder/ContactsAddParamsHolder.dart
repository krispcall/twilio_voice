import 'package:flutter/cupertino.dart';
import 'package:voice_example/viewobject/common/Holder.dart';

class ContactsAddParamsHolder extends Holder<ContactsAddParamsHolder> {
  ContactsAddParamsHolder({
    @required this.company,
    @required this.address,
    @required this.visibility,
    @required this.name,
    @required this.email,
    @required this.phoneNumber,
    @required this.country,
  });

  String country;
  String company;
  String address;
  bool visibility;
  final String name;
  final String email;
  final String phoneNumber;
  String profileImageUrl;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['country'] = country;
    map['company'] = company;
    map['address'] = address;
    map['visibility'] = visibility;
    map['name'] = name;
    map['email'] = email;
    map['number'] = phoneNumber;
    return map;
  }

  @override
  ContactsAddParamsHolder fromMap(dynamic dynamicData) {
    return ContactsAddParamsHolder(
      country: dynamicData['country'],
      company: dynamicData['company'],
      address: dynamicData['address'],
      visibility: dynamicData['visibility'],
      name: dynamicData['name'],
      email: dynamicData['email'],
      phoneNumber: dynamicData['number'],
    );
  }
}
