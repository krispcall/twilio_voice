import 'package:flutter/cupertino.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/model/workspace/workspace_detail/WorkspaceChannel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkspaceNumberListItemView extends StatelessWidget
{
  const WorkspaceNumberListItemView({
    Key key,
    @required this.workspaceChannel,
    @required this.animationController,
    @required this.animation,
    @required this.selectedChannel,
    @required this.count,
    @required this.onChannelTap,
  }) : super(key: key);

  final WorkspaceChannel workspaceChannel;
  final AnimationController animationController;
  final Animation<double> animation;
  final WorkspaceChannel selectedChannel;
  final int count;
  final Function onChannelTap;

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
                  decoration: selectedChannel.id==workspaceChannel.id?BoxDecoration(
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
                        child: RoundedNetworkSvgHolder(
                          containerWidth: Dimens.space36,
                          containerHeight: Dimens.space36,
                          boxFit: BoxFit.contain,
                          imageWidth: Dimens.space20,
                          imageHeight: Dimens.space20,
                          imageUrl: Config.countryLogoUrl+workspaceChannel.countryLogo,
                          outerCorner: Dimens.space300,
                          innerCorner: Dimens.space2,
                          iconUrl: CustomIcon.icon_person,
                          iconColor: CustomColors.mainColor,
                          iconSize: Dimens.space20,
                          boxDecorationColor: selectedChannel.id==workspaceChannel.id ?CustomColors.mainSecondaryColor:CustomColors.mainBackgroundColor,
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
                                workspaceChannel.name,
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                  color: selectedChannel.id==workspaceChannel.id ?CustomColors.white:CustomColors.textSecondaryColor,
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
                              child: Text(
                                workspaceChannel.number,
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                  color: selectedChannel.id==workspaceChannel.id ?CustomColors.white:CustomColors.textPrimaryLightColor,
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
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: TextHolder(
                          width: Dimens.space24,
                          height: Dimens.space24,
                          text: workspaceChannel.unseenMessageCount>99?Utils.getString("99+"):workspaceChannel.unseenMessageCount.toString(),
                          corner: Dimens.space8,
                          textColor: CustomColors.white,
                          containerColor: CustomColors.callDeclineColor,
                          fontFamily: Config.manropeBold,
                          fontWeight: FontWeight.normal,
                          fontSize: workspaceChannel.unseenMessageCount>99?Dimens.space11:Dimens.space11,
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
                  onChannelTap();
                },
              ),
            ),
          );
        });
  }
}

