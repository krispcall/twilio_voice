import 'package:flutter/cupertino.dart';
import 'package:voice_example/viewobject/common/Holder.dart';

class AddContactRequestParamHolder
    extends Holder<AddContactRequestParamHolder> {
  AddContactRequestParamHolder({
    @required this.company,
    @required this.visibility,
    @required this.name,
    @required this.phoneNumber,
    @required this.country,
    @required this.email,
    @required this.address,
    @required this.tags,
  });

  String country;
  String company;
  bool visibility;
  final String name;
  final String phoneNumber;
  String profileImageUrl;
  String email;
  String address;
  List<String> tags;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (country != null && country.isNotEmpty) {
      map['country'] = country;
    }
    if (company != null && company.isNotEmpty) {
      map['company'] = company;
    }
    if (visibility != null) {
      map['visibility'] = visibility;
    }
    if (name != null && name.isNotEmpty) {
      map['name'] = name;
    }
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      map['number'] = phoneNumber;
    }
    if (email != null && email.isNotEmpty) {
      map['email'] = email;
    }
    if (address != null && address.isNotEmpty) {
      map['address'] = address;
    }
    if (tags != null) {
      map['tags'] = tags != null ? tags.toList() : null;
    }
    return map;
  }

  @override
  AddContactRequestParamHolder fromMap(dynamic dynamicData) {
    return AddContactRequestParamHolder(
      country: dynamicData['country'],
      company: dynamicData['company'],
      visibility: dynamicData['visibility'],
      name: dynamicData['name'],
      phoneNumber: dynamicData['number'],
      email: dynamicData['email'],
      address: dynamicData['address'],
      tags: dynamicData['tags'],
    );
  }
}
