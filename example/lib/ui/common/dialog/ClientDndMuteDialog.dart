import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/utils/Utils.dart';

class ClientDndMuteDialog extends StatelessWidget
{
  final String clientName;
  final String mutedDate;
  final Function onMuteTap;

  ClientDndMuteDialog({
    Key key,
    this.clientName,
    this.mutedDate,
    this.onMuteTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
              width: Dimens.space80.w,
              height: Dimens.space6.h,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space6.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(Dimens.space33),
                ),
                color: CustomColors.bottomAppBarColor,
              )
          ),
          Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                decoration: BoxDecoration(
                  color: CustomColors.mainBackgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimens.space20.r),
                      topRight: Radius.circular(Dimens.space20.r)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space16.h, Dimens.space16.w, Dimens.space18.h),
                      decoration: BoxDecoration(
                        color: CustomColors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(Dimens.space20.r),
                            topRight: Radius.circular(Dimens.space20.r)
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: Dimens.space40,
                            height: Dimens.space40,
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            child: RoundedNetworkImageHolder(
                              width: Dimens.space40,
                              height: Dimens.space40,
                              boxFit: BoxFit.cover,
                              iconUrl: CustomIcon.icon_notification,
                              iconColor: CustomColors.loadingCircleColor,
                              iconSize: Dimens.space20,
                              boxDecorationColor: CustomColors.loadingCircleColor.withOpacity(0.09),
                              outerCorner: Dimens.space10,
                              innerCorner: Dimens.space0,
                              imageUrl: "",
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: double.maxFinite,
                              margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                    child: Text(
                                      Utils.getString("muteConversation"),
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
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                    child: Text(
                                      clientName!=null?clientName:Utils.getString("unknown"),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                          color: CustomColors.textTertiaryColor,
                                          fontFamily: Config.heeboRegular,
                                          fontSize: Dimens.space14.sp,
                                          fontWeight: FontWeight.normal,
                                          fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space16.h, Dimens.space16.w, Dimens.space16.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: CustomColors.mainDividerColor,
                            width: Dimens.space1.w),
                        borderRadius:
                        BorderRadius.all(Radius.circular(Dimens.space16.w)),
                        color: CustomColors.mainBackgroundColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(Dimens.space16.w),
                                  topRight: Radius.circular(Dimens.space16.w)
                              ),
                              color: Colors.white,
                            ),
                            child: InkWell(
                              onTap: () => onMuteTap(30, false),
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                  padding: EdgeInsets.fromLTRB(Dimens.space17.w, Dimens.space18.h, Dimens.space17.w, Dimens.space18.h),
                                  child: Text(
                                    Utils.getString("mute30mins"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color:
                                        CustomColors.textPrimaryColor,
                                        fontFamily:
                                        Config.manropeSemiBold,
                                        fontSize: Dimens.space15.sp,
                                        fontWeight: FontWeight.normal),
                                  )
                              ),
                            ),
                          ),
                          Divider(
                            color: CustomColors.mainDividerColor,
                            height: Dimens.space1,
                            thickness: Dimens.space1,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: CustomColors.mainDividerColor,
                                ),
                              ),
                              color: Colors.white,
                            ),
                            child: InkWell(
                              onTap: () => onMuteTap(60, false),
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                  padding: EdgeInsets.fromLTRB(Dimens.space17.w, Dimens.space18.h, Dimens.space17.w, Dimens.space18.h),
                                  child: Text(
                                    Utils.getString("mute1hour"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color:
                                        CustomColors.textPrimaryColor,
                                        fontFamily:
                                        Config.manropeSemiBold,
                                        fontSize: Dimens.space15.sp,
                                        fontWeight: FontWeight.normal),
                                  )
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: CustomColors.mainDividerColor,
                                ),
                              ),
                              color: Colors.white,
                            ),
                            child: InkWell(
                              onTap: () => onMuteTap(8 * 60, false),
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                  padding: EdgeInsets.fromLTRB(Dimens.space17.w, Dimens.space18.h, Dimens.space17.w, Dimens.space18.h),
                                  child: Text(
                                    Utils.getString("mute8hour"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color:
                                        CustomColors.textPrimaryColor,
                                        fontFamily:
                                        Config.manropeSemiBold,
                                        fontSize: Dimens.space15.sp,
                                        fontWeight: FontWeight.normal),
                                  )),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: CustomColors.mainDividerColor,
                                ),
                              ),
                              color: Colors.white,
                            ),
                            child:  InkWell(
                              onTap: () => onMuteTap(24 * 60, false),
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                  padding: EdgeInsets.fromLTRB(Dimens.space17.w, Dimens.space18.h, Dimens.space17.w, Dimens.space18.h),
                                  child: Text(
                                    Utils.getString("mute24hour"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color:
                                        CustomColors.textPrimaryColor,
                                        fontFamily:
                                        Config.manropeSemiBold,
                                        fontSize: Dimens.space15.sp,
                                        fontWeight: FontWeight.normal
                                    ),
                                  )
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(Dimens.space16.w),
                                  bottomRight:
                                  Radius.circular(Dimens.space16.w)),
                              color: Colors.white,
                            ),
                            child: InkWell(
                              onTap: () => onMuteTap(null, false),
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                  padding: EdgeInsets.fromLTRB(Dimens.space17.w, Dimens.space18.h, Dimens.space17.w, Dimens.space18.h),
                                  child: Text(
                                    Utils.getString("muteUntillBack"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color:
                                        CustomColors.textPrimaryColor,
                                        fontFamily:
                                        Config.manropeSemiBold,
                                        fontSize: Dimens.space15.sp,
                                        fontWeight: FontWeight.normal
                                    ),
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space0.h, Dimens.space20.w, Dimens.space8.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(
                        Utils.getString("notifyMessage"),
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: CustomColors.textPrimaryColor,
                            fontFamily: Config.heeboRegular,
                            fontSize: Dimens.space14.sp,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ),
        ],
      ),
    );
  }
}