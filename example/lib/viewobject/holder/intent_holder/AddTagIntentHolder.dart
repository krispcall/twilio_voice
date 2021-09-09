/*
 * *
 *  * Created by Kedar on 7/14/21 1:58 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/14/21 1:58 PM
 *
 */

import 'package:flutter/cupertino.dart';
import 'package:voice_example/viewobject/model/allContact/Tags.dart';

class AddTagIntentHolder {
  const AddTagIntentHolder({
    @required this.clientId,
    @required this.countryId,
    @required this.address,
    @required this.company,
    @required this.number,
    @required this.name,
    @required this.email,
    @required this.visibility,
    @required this.profilePicture,
    @required this.tags,
    @required this.countryFlag,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
  });

  final String clientId;
  final String countryId;
  final String address;
  final String company;
  final String number;
  final String name;
  final String email;
  final bool visibility;
  final String profilePicture;
  final List<Tags> tags;
  final String countryFlag;
  final Function onIncomingTap;
  final Function onOutgoingTap;
}
