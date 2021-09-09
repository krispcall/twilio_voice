/*
 * *
 *  * Created by Kedar on 7/30/21 3:12 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/30/21 3:12 PM
 *
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/viewobject/model/numbers/Numbers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NumberListItemView extends StatelessWidget {
  final Function onTap;
  final Numbers number;
  final AnimationController animationController;
  final Animation animation;
  final Function onPressed;
  final Function onLongPressed;

  NumberListItemView(
      {Key key,
      this.onTap,
      this.number,
      this.animationController,
      this.animation,
      this.onPressed,
      this.onLongPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: CustomColors.mainDividerColor,
            ),
          ),
          color: Colors.white,
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space12.h,
                Dimens.space20.w, Dimens.space12.h),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: Dimens.space48.w,
                height: Dimens.space48.w,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space48,
                  height: Dimens.space48,
                  boxFit: BoxFit.cover,
                  containerAlignment: Alignment.bottomCenter,
                  iconUrl: CustomIcon.icon_profile,
                  iconColor: CustomColors.callInactiveColor,
                  iconSize: Dimens.space40,
                  boxDecorationColor: CustomColors.mainDividerColor,
                  outerCorner: Dimens.space25,
                  innerCorner: Dimens.space25,
                  imageUrl: "${Config.countryLogoUrl}${number.countryLogo}",
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space12.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            child: Text("${number.name}",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: CustomColors.textPrimaryColor,
                                      fontFamily: Config.manropeBold,
                                      fontSize: Dimens.space16.sp,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                    )),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space6.h, Dimens.space0.w, Dimens.space0.h),
                        child: Text(
                          '${number.number}',
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: CustomColors.textPrimaryLightColor,
                              fontFamily: Config.heeboMedium,
                              fontSize: Dimens.space13.sp,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          onPressed: onTap,
        ));
  }
}
