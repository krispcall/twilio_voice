/*
 * *
 *  * Created by Kedar on 8/11/21 9:00 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 8/10/21 9:14 AM
 *
 */

import 'package:flutter/material.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/viewobject/model/members/MemberEdges.dart';

/*
 * *
 *  * Created by Kedar on 8/10/21 8:56 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 8/10/21 8:56 AM
 *
 */


class AddMemberItemWidget extends StatefulWidget {
  final MemberEdges item;
  AddMemberItemWidget({Key key, this.item}) : super(key: key);

  @override
  _AddMemberItemWidgetState createState() {
    return _AddMemberItemWidgetState();
  }
}

class _AddMemberItemWidgetState extends State<AddMemberItemWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
            child:Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              child: RoundedNetworkImageHolder(
                width: Dimens.space36,
                height: Dimens.space36,
                boxFit: BoxFit.cover,
                iconUrl: CustomIcon.icon_profile,
                iconColor: CustomColors.callInactiveColor,
                iconSize: Dimens.space30,
                boxDecorationColor: CustomColors.mainDividerColor,
                outerCorner: Dimens.space16,
                innerCorner: Dimens.space16,
                containerAlignment:
                Alignment.bottomCenter,
                imageUrl: "${Config.imageUrl}${widget.item.members.profilePicture}",
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h, Dimens.space10.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              child: Text(
                "${widget.item.members.firstName} ${widget.item.members.lastName}",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: CustomColors.textSecondaryColor,
                    fontFamily: Config.heeboRegular,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}