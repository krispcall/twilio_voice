/*
 * *
 *  * Created by Kedar on 8/11/21 3:45 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 8/11/21 3:45 PM
 *
 */

import 'package:flutter/cupertino.dart';

class AddNewMemberIntentHolder{

  final Function onMemberSelected;
  final Function onIncomingTap;
  final Function onOutgoingTap;

  AddNewMemberIntentHolder({
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
    this.onMemberSelected
  });

}