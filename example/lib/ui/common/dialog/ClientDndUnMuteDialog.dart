import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/utils/Utils.dart';

class ClientDndUnMuteDialog extends StatelessWidget
{
  final String clientName;
  final int dndEndTime;
  final Function onUmMuteTap;

  ClientDndUnMuteDialog({
    Key key,
    this.clientName,
    this.dndEndTime,
    this.onUmMuteTap
  }): super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: Column(
        children: <Widget>[
          Container(
              width: Dimens.space80.w,
              height: Dimens.space6.h,
              margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space6.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(Dimens.space33),
                ),
                color: CustomColors.bottomAppBarColor,
              )),
          Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: CustomColors.mainBackgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimens.space20.r),
                      topRight: Radius.circular(Dimens.space20.r)),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: CustomColors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(Dimens.space20.r),
                            topRight: Radius.circular(Dimens.space20.r)),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: Row(
                        children: [
                          Container(
                            width: Dimens.space40,
                            height: Dimens.space40,
                            margin: EdgeInsets.fromLTRB(Dimens.space12.w,
                                Dimens.space0, Dimens.space0, Dimens.space0),
                            padding: EdgeInsets.fromLTRB(Dimens.space0,
                                Dimens.space0, Dimens.space0, Dimens.space0),
                            child: RoundedNetworkImageHolder(
                              width: Dimens.space40,
                              height: Dimens.space40,
                              boxFit: BoxFit.cover,
                              iconUrl: CustomIcon.icon_notification,
                              iconColor: CustomColors.loadingCircleColor,
                              iconSize: Dimens.space20,
                              boxDecorationColor: CustomColors
                                  .loadingCircleColor
                                  .withOpacity(0.1),
                              outerCorner: Dimens.space25,
                              innerCorner: Dimens.space10,
                              imageUrl: "",
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: double.maxFinite,
                              margin: EdgeInsets.fromLTRB(Dimens.space10.w,
                                  Dimens.space0, Dimens.space0, Dimens.space0),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: const EdgeInsets.fromLTRB(
                                        Dimens.space0,
                                        Dimens.space0,
                                        Dimens.space0,
                                        Dimens.space0),
                                    child: Text(
                                      Utils.getString('unMuteConversation'),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                          color:
                                          CustomColors.textPrimaryColor,
                                          fontFamily: Config.manropeBold,
                                          fontSize: Dimens.space18.sp,
                                          letterSpacing: 0,
                                          height: 1,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    padding: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    child: Text(
                                      "${clientName}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                          color: CustomColors
                                              .textTertiaryColor,
                                          fontFamily: Config.heeboRegular,
                                          fontSize: Dimens.space14.sp,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(Dimens.space16.w,
                          Dimens.space16.h, Dimens.space16.w, Dimens.space16.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: CustomColors.mainDividerColor,
                            width: Dimens.space1.w),
                        borderRadius:
                        BorderRadius.all(Radius.circular(Dimens.space16.w)),
                        color: CustomColors.mainBackgroundColor,
                      ),
                      child: InkWell(
                        onTap: () {
                          onUmMuteTap();
                        },
                        child: Container(
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space16.w,
                                Dimens.space16.h,
                                Dimens.space16.w,
                                Dimens.space16.h),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.space16.w)),
                              color: Colors.white,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  CustomIcon.icon_notification,
                                  size: Dimens.space24.w,
                                  color: CustomColors.textPrimaryErrorColor,
                                ),
                                Expanded(
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.fromLTRB(
                                            Dimens.space0.w,
                                            Dimens.space0.h,
                                            Dimens.space0.w,
                                            Dimens.space0.h),
                                        padding: EdgeInsets.fromLTRB(
                                            Dimens.space10.w,
                                            Dimens.space0.h,
                                            Dimens.space0.w,
                                            Dimens.space0.h),
                                        child: Text(
                                          "${Utils.getString("unmute")} @${clientName}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                              color: CustomColors
                                                  .textPrimaryColor,
                                              fontFamily:
                                              Config.manropeSemiBold,
                                              fontSize: Dimens.space15.sp,
                                              fontWeight:
                                              FontWeight.normal),
                                        ))),
                              ],
                            )),
                      ),
                    ),
                    dndEndTime!=null?Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space18.w,
                            Dimens.space0.h, Dimens.space18.w, Dimens.space8.h),
                        child: RichText(
                          text: TextSpan(
                              text: Utils.getString("mutedMessage"),
                              style: Theme.of(context).textTheme.bodyText2.copyWith(
                                  color: CustomColors.textPrimaryColor,
                                  fontFamily: Config.heeboRegular,
                                  fontSize: Dimens.space14.sp,
                                  letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.w400,
                                  height: 1.42),
                              children: [
                                TextSpan(
                                  text: Utils.formatTimeStampToReadableDate(dndEndTime, 'MMM dd, hh:mm a'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                      color:
                                      CustomColors.loadingCircleColor,
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space14.sp,
                                      letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.w400,
                                      height: 1.42),
                                )
                              ]),
                        )):Container(
                      margin: EdgeInsets.fromLTRB(Dimens.space18.w,
                          Dimens.space0.h, Dimens.space18.w, Dimens.space8.h),
                      child: Text(
                          Utils.getString("mutedMessageUntillTurnOn"),
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: CustomColors.textPrimaryColor,
                              fontFamily: Config.heeboRegular,
                              fontSize: Dimens.space14.sp,
                              letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.w400,
                              height: 1.42)
                      ),

                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}