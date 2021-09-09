import 'package:flutter/cupertino.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/model/workspace/workspace_detail/WorkspaceTeam.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkspaceTeamListItemView extends StatelessWidget
{
  const WorkspaceTeamListItemView({
    Key key,
    @required this.workspaceTeam,
    @required this.animationController,
    @required this.animation,
    @required this.index,
    @required this.selectedIndex,
    @required this.count,
  }) : super(key: key);

  final WorkspaceTeam workspaceTeam;
  final AnimationController animationController;
  final Animation<double> animation;
  final int index;
  final int selectedIndex;
  final int count;

  @override
  Widget build(BuildContext context)

  {
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child)
        {
          return FadeTransition(
            opacity: animation,
            child: Transform(
              transform: Matrix4.translationValues(0.0, 100 * (1.0 - animation.value), 0.0),
              child: TextButton(
                child:Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space9.w, Dimens.space9.h, Dimens.space10.w, Dimens.space9.h),
                  decoration: index==selectedIndex?BoxDecoration(
                      color: CustomColors.mainColor,
                      borderRadius: BorderRadius.all(Radius.circular(Dimens.space8.r)
                      )
                  ):BoxDecoration(
                    color: CustomColors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(Dimens.space8.r)
                    ),
                  ),
                  child:Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: RoundedNetworkImageHolder(
                          width: Dimens.space36,
                          height: Dimens.space36,
                          boxFit: BoxFit.fill,
                          imageUrl: workspaceTeam.picture,
                          outerCorner: Dimens.space18,
                          innerCorner: Dimens.space18,
                          iconUrl: CustomIcon.icon_person,
                          iconColor: CustomColors.mainColor,
                          iconSize: Dimens.space20,
                          boxDecorationColor: index==selectedIndex?CustomColors.mainSecondaryColor:CustomColors.mainBackgroundColor,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.fromLTRB(Dimens.space12.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              child: Text(
                                workspaceTeam.name,
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                  color: index==selectedIndex?CustomColors.white:CustomColors.textSecondaryColor,
                                  fontFamily: Config.manropeBold,
                                  fontSize: Dimens.space14.sp,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.fromLTRB(Dimens.space12.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                    child: RoundedNetworkImageHolder(
                                      width: Dimens.space11,
                                      height: Dimens.space11,
                                      boxFit: BoxFit.cover,
                                      iconUrl: Icons.circle,
                                      iconColor: workspaceTeam.online==1?CustomColors.callAcceptColor:CustomColors.callDeclineColor,
                                      iconSize: Dimens.space12,
                                      boxDecorationColor: workspaceTeam.online==1?CustomColors.callAcceptColor:CustomColors.callDeclineColor,
                                      outerCorner:Dimens.space300,
                                      innerCorner: Dimens.space0,
                                      containerAlignment: Alignment.center,
                                      imageUrl: "",
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.fromLTRB(Dimens.space4.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                    child: Text(
                                      workspaceTeam.total.toString()+"/1",
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                        color: index==selectedIndex?CustomColors.white:CustomColors.textPrimaryLightColor,
                                        fontFamily: Config.manropeMedium,
                                        fontSize: Dimens.space13.sp,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.fromLTRB(Dimens.space4.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                    child: Text(
                                      workspaceTeam.online==1?Utils.getString("online"):Utils.getString("offline"),
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                        color: index==selectedIndex?CustomColors.white:CustomColors.textPrimaryLightColor,
                                        fontFamily: Config.manropeMedium,
                                        fontSize: Dimens.space13.sp,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: ()
                {

                },
              ),
            ),
          );
        });
  }
}

