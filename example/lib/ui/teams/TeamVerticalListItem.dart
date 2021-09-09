/*
 * *
 *  * Created by Kedar on 7/29/21 1:59 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/29/21 1:59 PM
 *
 */

import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/viewobject/model/teams/Teams.dart';

class TeamVerticalListItem extends StatelessWidget {
  const TeamVerticalListItem({
    Key key,
    @required this.team,
    @required this.animationController,
    @required this.animation,
    @required this.onPressed,
    @required this.onLongPressed,
  }) : super(key: key);

  final Teams team;
  final AnimationController animationController;
  final Animation<double> animation;
  final Function onPressed;
  final Function onLongPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 100 * (1.0 - animation.value), 0.0),
              child: Container(
                margin: EdgeInsets.fromLTRB(
                    Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                padding: EdgeInsets.fromLTRB(
                    Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                child: ImageAndTextWidget(
                  team: team,
                  onPressed: () {
                    onPressed();
                  },
                  onLongPressed: () {
                  },
                ),
              ),
            ),
          );
        });
  }
}

class ImageAndTextWidget extends StatelessWidget {
  const ImageAndTextWidget({
    Key key,
    @required this.team,
    @required this.onPressed,
    @required this.onLongPressed,
  }) : super(key: key);

  final Teams team;
  final Function onPressed;
  final Function onLongPressed;

  @override
  Widget build(BuildContext context) {

    if (team != null) {
      return Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: CustomColors.mainDividerColor,
              ),
            ),
          ),
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space16.h,
                  Dimens.space20.w, Dimens.space16.h),
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
                    width: Dimens.space40,
                    height: Dimens.space40,
                    boxFit: BoxFit.cover,
                    containerAlignment: Alignment.center,
                    iconUrl: CustomIcon.icon_profile,
                    iconColor: CustomColors.callInactiveColor,
                    iconSize: Dimens.space30,
                    boxDecorationColor: CustomColors.mainDividerColor,
                    outerCorner: Dimens.space16,
                    innerCorner: Dimens.space16,
                    imageUrl: team.picture,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space10.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: Text("${team.name}",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                      color: CustomColors.textSecondaryColor,
                                      fontFamily: Config.manropeBold,
                                      fontSize: Dimens.space14.sp,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      height: 1)),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space2.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(Dimens.space0,
                                Dimens.space0, Dimens.space0, Dimens.space0),
                            child: CounterWidget(
                              count: "${team.online}/${team.total} Members",
                              color: CustomColors.callAcceptColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              onPressed();
            },
            onLongPress: () {
              onLongPressed();
            },
          ));
    } else {
      return Container();
    }
  }
}

class CounterWidget extends StatelessWidget {
  final String count;
  final Color color;

  const CounterWidget({Key key, this.count, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator CounterWidget - FRAME - HORIZONTAL
    return Container(
      margin: EdgeInsets.fromLTRB(
          Dimens.space0, Dimens.space0, Dimens.space6.w, Dimens.space0),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              width: Dimens.space10.w,
              height: Dimens.space10.w,
              decoration: BoxDecoration(
                color: color,
                borderRadius:
                    BorderRadius.all(Radius.circular(Dimens.space10.r)),
              )),
          SizedBox(width: Dimens.space5.h),
          Text(
            '${count}',
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: CustomColors.textPrimaryLightColor,
                  fontFamily: Config.manropeSemiBold,
                  fontSize: Dimens.space13.sp,
                  letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.normal,
                ),
          ),
        ],
      ),
    );
  }
}
