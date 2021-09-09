import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/model/members/MemberEdges.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MemberListItemView extends StatelessWidget {
  const MemberListItemView({
    Key key,
    @required this.memberEdges,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final MemberEdges memberEdges;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context)
  {
    if (memberEdges != null && memberEdges != null)
    {
      String firstName = memberEdges.members.firstName!=null?memberEdges.members.firstName:Utils.getString("unknown");
      String lastName = memberEdges.members.lastName!=null?memberEdges.members.lastName:"";
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space7.h, Dimens.space20.w, Dimens.space7.h),
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
              child:Stack(
                alignment: Alignment.center,
                children: [
                  Container(
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
                      imageUrl: memberEdges.members.profilePicture!=null?memberEdges.members.profilePicture:"",
                    ),
                  ),
                  Positioned(
                    right: Dimens.space0.w,
                    bottom: Dimens.space0.w,
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: RoundedNetworkImageHolder(
                        width: Dimens.space13,
                        height: Dimens.space13,
                        boxFit: BoxFit.cover,
                        iconUrl: Icons.circle,
                        iconColor: memberEdges.members.online!=null && memberEdges.members.online?CustomColors.callAcceptColor:CustomColors.callInactiveColor,
                        iconSize: Dimens.space10,
                        boxDecorationColor: CustomColors.white,
                        outerCorner: Dimens.space300,
                        innerCorner: Dimens.space300,
                        imageUrl: "",
                        onTap: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h, Dimens.space10.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                child: Text(
                  firstName+" "+lastName,
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
    else
    {
      return Container();
    }
  }
}

class MemberListSearchItemWidget extends StatelessWidget {
  const MemberListSearchItemWidget({
    Key key,
    @required this.memberEdges,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final MemberEdges memberEdges;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context)
  {
    if (memberEdges != null && memberEdges != null)
    {
      String firstName = memberEdges.members.firstName!=null?memberEdges.members.firstName:Utils.getString("unknown");
      String lastName = memberEdges.members.lastName!=null?memberEdges.members.lastName:"";
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
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
              child:Stack(
                alignment: Alignment.center,
                children: [
                  Container(
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
                      imageUrl: memberEdges.members.profilePicture!=null?memberEdges.members.profilePicture:"",
                    ),
                  ),
                  Positioned(
                    right: Dimens.space0.w,
                    bottom: Dimens.space0.w,
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: RoundedNetworkImageHolder(
                        width: Dimens.space13,
                        height: Dimens.space13,
                        boxFit: BoxFit.cover,
                        iconUrl: Icons.circle,
                        iconColor: memberEdges.members.online!=null && memberEdges.members.online?CustomColors.callAcceptColor:CustomColors.callInactiveColor,
                        iconSize: Dimens.space10,
                        boxDecorationColor: CustomColors.white,
                        outerCorner: Dimens.space300,
                        innerCorner: Dimens.space300,
                        imageUrl: "",
                        onTap: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h, Dimens.space10.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                child: Text(
                  firstName+" "+lastName,
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
    else
    {
      return Container();
    }
  }
}