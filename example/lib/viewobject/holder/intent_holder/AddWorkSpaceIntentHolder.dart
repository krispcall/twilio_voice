/*
 * *
 *  * Created by Kedar on 8/10/21 1:10 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 8/10/21 1:10 PM
 *
 */


import 'package:flutter/cupertino.dart';

class AddWorkSpaceIntentHolder{

  final Function onAddWorkSpaceCallBack;
  final Function onIncomingTap;
  final Function onOutgoingTap;

  AddWorkSpaceIntentHolder({
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
    this.onAddWorkSpaceCallBack,
  });


}

