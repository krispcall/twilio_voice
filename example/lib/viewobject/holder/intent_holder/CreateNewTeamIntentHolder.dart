/*
 * *
 *  * Created by Kedar on 8/13/21 10:49 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 8/13/21 10:49 AM
 *
 */


import 'package:flutter/cupertino.dart';

class CreateNewTeamIntentHolder
{
  final Function onNewTeamCreated;
  final Function onIncomingTap;
  final Function onOutgoingTap;

  CreateNewTeamIntentHolder({
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
    this.onNewTeamCreated
  });


}