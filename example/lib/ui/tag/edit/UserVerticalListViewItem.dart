import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/model/allContact/AllContactEdges.dart';

class UserListView extends StatelessWidget {
  const UserListView({
    Key key,
    @required this.contactEdges,
    @required this.onTap,
    @required this.animationController,
    @required this.offStage,
    @required this.animation,
  }) : super(key: key);

  final AllContactEdges contactEdges;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;
  final bool offStage;

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
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space10.h,
                    Dimens.space20.w, Dimens.space10.h),
                child: TextButton(
                  onPressed: onTap,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.center,
                  ),
                  child: UserVerticalListItemView(
                    contactEdges: contactEdges,
                    offStage: offStage,
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class UserVerticalListItemView extends StatelessWidget {
  const UserVerticalListItemView({
    Key key,
    @required this.contactEdges,
    @required this.offStage,
  }) : super(key: key);

  final AllContactEdges contactEdges;
  final bool offStage;

  @override
  Widget build(BuildContext context) {
    // if (contactEdges != null) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            child: RoundedNetworkImageHolder(
              width: Dimens.space36,
              height: Dimens.space36,
              boxFit: BoxFit.cover,
              iconUrl: CustomIcon.icon_profile,
              containerAlignment: Alignment.bottomCenter,
              iconColor: CustomColors.callInactiveColor,
              iconSize: Dimens.space30,
              boxDecorationColor: CustomColors.mainDividerColor,
              outerCorner: Dimens.space14,
              innerCorner: Dimens.space14,
              imageUrl: contactEdges.contactNode.profilePicture != null &&
                      contactEdges.contactNode.profilePicture.isNotEmpty
                  ? contactEdges.contactNode.profilePicture
                  : "",
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              alignment: Alignment.centerLeft,
              child: Text(
                contactEdges.contactNode.name != null &&
                        contactEdges.contactNode.name.isNotEmpty
                    ? contactEdges.contactNode.name
                    : Utils.getString("unknown"),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: CustomColors.textSenaryColor,
                      fontFamily: Config.manropeSemiBold,
                      fontSize: Dimens.space16.sp,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.normal,
                    ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            // child: RoundedAssetImageHolder(
            //   width: Dimens.space24,
            //   height: Dimens.space24,
            //   boxFit: BoxFit.cover,
            //   iconUrl: Icons.cancel,
            //   containerAlignment: Alignment.center,
            //   iconColor: CustomColors.grey,
            //   iconSize: Dimens.space24,
            //   boxDecorationColor: CustomColors.transparent,
            //   outerCorner: Dimens.space12,
            //   innerCorner: Dimens.space12,
            //   assetUrl: "",
            //   onTap: () {},
            // ),
          ),
        ],
      ),
    );
    // } else {
    //   return Container();
    // }
  }
}
