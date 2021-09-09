/*
 * *
 *  * Created by Kedar on 8/3/21 11:07 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 8/3/21 11:07 AM
 *
 */
import 'package:flutter/cupertino.dart';

class AddGlobalTagViewHolder
{
  final String workspaceName;
  final String workspaceImage;
  final Function onIncomingTap;
  final Function onOutgoingTap;
  final Function onCallBack;
  AddGlobalTagViewHolder( {
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
    this.workspaceName,
    this.workspaceImage,
    this.onCallBack,
  });


}
