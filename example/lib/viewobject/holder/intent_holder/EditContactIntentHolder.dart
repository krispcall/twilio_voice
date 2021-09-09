import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:voice_example/viewobject/model/allContact/Tags.dart';

class EditContactIntentHolder {
  final String editName;
  final String contactName;
  final String contactNumber;
  final String email;
  final String company;
  final String address;
  final String photoUpload;
  final List<Tags> tags;
  final bool visibility;
  final String id;
  final Function onIncomingTap;
  final Function onOutgoingTap;

  EditContactIntentHolder({
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
    this.editName,
    this.contactName,
    this.contactNumber,
    this.email,
    this.company,
    this.address,
    this.photoUpload,
    this.tags,
    this.visibility,
    this.id
  });
}
