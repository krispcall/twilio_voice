import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/ui/common/DateTimeTextWidget.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/model/call/RecentConversationEdges.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CallLogVerticalListItem extends StatelessWidget {
  const CallLogVerticalListItem({
    Key key,
    @required this.callLog,
    @required this.index,
    @required this.animationController,
    @required this.animation,
    @required this.onCallTap,
    @required this.onCheckBoxTap,
    @required this.onPressed,
    @required this.onLongPressed,
    @required this.onSelectAllTap,
    @required this.isCheckBoxVisible,
    @required this.selectAllCheck,
    @required this.slidAbleController,
    @required this.onPinTap,
  }) : super(key: key);

  final RecentConversationEdges callLog;
  final int index;
  final AnimationController animationController;
  final Animation<double> animation;
  final Function(String, String, String) onCallTap;
  final Function onPressed;
  final Function onLongPressed;
  final Function(bool) onCheckBoxTap;
  final Function(bool) onSelectAllTap;
  final bool isCheckBoxVisible;
  final bool selectAllCheck;
  final SlidableController slidAbleController;
  final Function(String, bool) onPinTap;
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Offstage(
                    offstage: index == 0 ? isCheckBoxVisible : true,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                      padding: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space12.h, Dimens.space20.w, Dimens.space12.h),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomCheckBox(
                            width: Dimens.space20,
                            height: Dimens.space20,
                            boxFit: BoxFit.contain,
                            iconUrl: Icons.check,
                            iconColor: CustomColors.white,
                            selectedColor: CustomColors.mainColor,
                            unSelectedColor: CustomColors.callInactiveColor,
                            iconSize: Dimens.space16,
                            outerCorner: Dimens.space6,
                            innerCorner: Dimens.space6,
                            assetHeight: Dimens.space20,
                            assetWidth: Dimens.space20,
                            isChecked: selectAllCheck,
                            onCheckBoxTap: (value)
                            {
                              onSelectAllTap(value);
                            },
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0, Dimens.space0, Dimens.space0),
                            child: Text(
                              Utils.getString("selectAll"),
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                  color:
                                  CustomColors.loadingCircleColor,
                                  fontFamily: Config.heeboRegular,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                    padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                    child: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.18,
                      closeOnScroll: true,
                      fastThreshold: 1,
                      controller: slidAbleController,
                      actions: [
                        TextButton(
                          onPressed: ()
                          {

                          },
                          style: TextButton.styleFrom(
                            alignment: Alignment.center,
                            backgroundColor: CustomColors.mainDividerColor,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Dimens.space0.r),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              RoundedNetworkImageHolder(
                                width: Dimens.space20,
                                height: Dimens.space20,
                                boxFit: BoxFit.cover,
                                iconUrl: CustomIcon.icon_more,
                                iconColor: CustomColors.white,
                                iconSize: Dimens.space16,
                                outerCorner: Dimens.space10,
                                innerCorner: Dimens.space10,
                                boxDecorationColor:
                                CustomColors.textQuaternaryColor,
                                imageUrl: "",
                                onTap: ()
                                {
                                },
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0,
                                    Dimens.space4.h,
                                    Dimens.space0,
                                    Dimens.space0),
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space0,
                                    Dimens.space0,
                                    Dimens.space0,
                                    Dimens.space0),
                                alignment: Alignment.center,
                                child: Text(
                                  Utils.getString("unread"),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                    color: CustomColors.textTertiaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space12.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed:()
                          {
                            onPinTap(callLog.recentConversationNodes.clientNumber,callLog.recentConversationNodes.contactPinned);
                          },
                          style: TextButton.styleFrom(
                            alignment: Alignment.center,
                            backgroundColor: CustomColors.warningColor,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.space0.r)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              RoundedNetworkImageHolder(
                                width: Dimens.space20,
                                height: Dimens.space20,
                                boxFit: BoxFit.cover,
                                iconUrl: CustomIcon.icon_pin,
                                iconColor: CustomColors.white,
                                iconSize: Dimens.space20,
                                outerCorner: Dimens.space10,
                                innerCorner: Dimens.space10,
                                boxDecorationColor:
                                CustomColors.transparent,
                                imageUrl: "",
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0,
                                    Dimens.space4.h,
                                    Dimens.space0,
                                    Dimens.space0
                                ),
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space0,
                                    Dimens.space0,
                                    Dimens.space0,
                                    Dimens.space0
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  callLog.recentConversationNodes.contactPinned!=null && callLog.recentConversationNodes.contactPinned?Utils.getString("unPin"):Utils.getString("pin"),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                    color: CustomColors.white,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space12.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      secondaryActions: <Widget>[
                        TextButton(
                          onPressed: ()
                          {

                          },
                          style: TextButton.styleFrom(
                            alignment: Alignment.center,
                            backgroundColor: CustomColors.mainDividerColor,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Dimens.space0.r),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              RoundedNetworkImageHolder(
                                width: Dimens.space20,
                                height: Dimens.space20,
                                boxFit: BoxFit.cover,
                                iconUrl: CustomIcon.icon_more,
                                iconSize: Dimens.space16,
                                iconColor: CustomColors.white,
                                outerCorner: Dimens.space10,
                                innerCorner: Dimens.space10,
                                boxDecorationColor:
                                CustomColors.textQuaternaryColor,
                                imageUrl: "",
                                onTap: ()
                                {
                                },
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0,
                                    Dimens.space4.h,
                                    Dimens.space0,
                                    Dimens.space0),
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space0,
                                    Dimens.space0,
                                    Dimens.space0,
                                    Dimens.space0),
                                alignment: Alignment.center,
                                child: Text(
                                  Utils.getString("more"),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                    color: CustomColors
                                        .textTertiaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space12.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: ()
                          {
                            onCallTap(callLog.recentConversationNodes.clientInfo!=null?callLog.recentConversationNodes.clientInfo.name:Utils.getString("unknown"), callLog.recentConversationNodes.clientNumber, callLog.recentConversationNodes.clientCountryFlag);
                          },
                          style: TextButton.styleFrom(
                            alignment: Alignment.center,
                            backgroundColor: CustomColors.loadingCircleColor,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Dimens.space0.r),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              RoundedNetworkImageHolder(
                                width: Dimens.space20,
                                height: Dimens.space20,
                                boxFit: BoxFit.cover,
                                iconUrl: CustomIcon.icon_call,
                                iconColor: CustomColors.white,
                                iconSize: Dimens.space20,
                                outerCorner: Dimens.space10,
                                innerCorner: Dimens.space10,
                                boxDecorationColor: CustomColors.transparent,
                                imageUrl: "",
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0,
                                    Dimens.space4.h,
                                    Dimens.space0,
                                    Dimens.space0),
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space0,
                                    Dimens.space0,
                                    Dimens.space0,
                                    Dimens.space0),
                                alignment: Alignment.center,
                                child: Text(
                                  Utils.getString("call"),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                    color: CustomColors.white,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space12.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      child: CallLogImageAndTextWidget(
                        callLog: callLog,
                        isCheckBoxVisible: isCheckBoxVisible,
                        onPressed: ()
                        {
                          onPressed();
                        },
                        onLongPressed: ()
                        {
                          onLongPressed();
                        },
                        onCheckBoxTap: (value)
                        {
                          onCheckBoxTap(value);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class CallLogImageAndTextWidget extends StatelessWidget
{
  const CallLogImageAndTextWidget({
    Key key,
    @required this.callLog,
    @required this.onCheckBoxTap,
    @required this.isCheckBoxVisible,
    @required this.onPressed,
    @required this.onLongPressed,
  }) : super(key: key);

  final RecentConversationEdges callLog;
  final Function(bool) onCheckBoxTap;
  final Function onPressed;
  final Function onLongPressed;
  final bool isCheckBoxVisible;

  @override
  Widget build(BuildContext context)
  {
    if (callLog != null)
    {
      if(callLog.recentConversationNodes.clientInfo!=null)
      {
      }
      return Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: callLog.check
                  ? CustomColors.mainBackgroundColor
                  : Colors.transparent,
              padding: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space10.h, Dimens.space20.w, Dimens.space10.h),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Offstage(
                  offstage: isCheckBoxVisible,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space12.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.centerLeft,
                    child: CustomCheckBox(
                      width: Dimens.space20,
                      height: Dimens.space20,
                      boxFit: BoxFit.contain,
                      iconUrl: Icons.check,
                      iconColor: CustomColors.white,
                      selectedColor: CustomColors.mainColor,
                      unSelectedColor: CustomColors.callInactiveColor,
                      iconSize: Dimens.space16,
                      outerCorner: Dimens.space6,
                      innerCorner: Dimens.space6,
                      assetHeight: Dimens.space20,
                      assetWidth: Dimens.space20,
                      isChecked: callLog.check,
                      onCheckBoxTap: (value)
                      {
                        onCheckBoxTap(value);
                      },
                    ),
                  ),
                ),
                Container(
                  width: Dimens.space48.w,
                  height: Dimens.space48.w,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                  child: RoundedNetworkImageHolder(
                    width: Dimens.space48,
                    height: Dimens.space48,
                    boxFit: BoxFit.cover,
                    containerAlignment: Alignment.bottomCenter,
                    iconUrl: CustomIcon.icon_profile,
                    iconColor: CustomColors.callInactiveColor,
                    iconSize: Dimens.space40,
                    boxDecorationColor: CustomColors.mainDividerColor,
                    outerCorner: Dimens.space16,
                    innerCorner: Dimens.space16,
                    imageUrl: callLog.recentConversationNodes.clientInfo!=null?callLog.recentConversationNodes.clientInfo.profilePicture:callLog.recentConversationNodes.clientProfilePicture,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
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
                              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              child: Text(
                                  callLog.recentConversationNodes.clientInfo!=null && callLog.recentConversationNodes.clientInfo.name!=null?callLog.recentConversationNodes.clientInfo.name:Utils.getString("unknown"),
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: callLog.recentConversationNodes.clientUnseenMsgCount==0?Config.manropeSemiBold:Config.manropeExtraBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  )
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(Dimens.space6.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              child: RoundedNetworkSvgHolder(
                                containerWidth: Dimens.space16,
                                containerHeight: Dimens.space16,
                                boxFit: BoxFit.contain,
                                imageWidth: Dimens.space16,
                                imageHeight: Dimens.space16,
                                outerCorner: Dimens.space0,
                                innerCorner: Dimens.space0,
                                iconUrl: CustomIcon.icon_person,
                                iconColor: CustomColors.white,
                                iconSize: Dimens.space16,
                                boxDecorationColor: Colors.transparent,
                                imageUrl: callLog.recentConversationNodes.clientCountryFlag!=null?Config.countryLogoUrl+callLog.recentConversationNodes.clientCountryFlag:"",
                              ),
                            )
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                          child: CallMessageVoiceMailWidget(callLog: callLog),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              child: Offstage(
                                offstage: callLog.recentConversationNodes.contactPinned!=null && callLog.recentConversationNodes.contactPinned?false:true,
                                child: RoundedNetworkImageHolder(
                                  width: Dimens.space18,
                                  height: Dimens.space18,
                                  boxFit: BoxFit.cover,
                                  iconUrl: CustomIcon.icon_pin,
                                  iconColor: CustomColors.warningColor,
                                  iconSize: Dimens.space12,
                                  outerCorner: Dimens.space0,
                                  innerCorner: Dimens.space0,
                                  boxDecorationColor:
                                  CustomColors.transparent,
                                  imageUrl: "",
                                ),
                              ),
                          ),
                          Container(
                              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              alignment: Alignment.center,
                              child: DateTimeTextWidget(
                                timestamp: callLog.recentConversationNodes.createdAt,
                                date: callLog.recentConversationNodes.createdAt,
                                format: DateFormat('yyyy-MM-ddThh:mm:ss.SSSSSS'),
                                dateFontColor: callLog.recentConversationNodes.clientUnseenMsgCount==0?CustomColors.textQuinaryColor:CustomColors.textTertiaryColor,
                                dateFontFamily: Config.manropeSemiBold,
                                dateFontSize: Dimens.space13,
                                dateFontStyle: FontStyle.normal,
                                dateFontWeight: FontWeight.normal,
                              )
                          ),
                        ],
                      ),
                      callLog.recentConversationNodes.clientUnseenMsgCount==0?
                      Container(
                        width: Dimens.space10.w,
                        height: Dimens.space10.h,
                      ):
                      Container(
                          width: Dimens.space10.w,
                          height: Dimens.space10.h,
                          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space12.h, Dimens.space0.w, Dimens.space0.h),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: CustomColors.textPrimaryErrorColor,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(Dimens.space5.r)),
                          )
                      )
                    ],
                  ),
                ),
              ],
            ),
            onPressed: ()
            {
              onPressed();
            },
            onLongPress: ()
            {
              onLongPressed();
            },
          )
      );
    }
    else
    {
      return Container();
    }
  }
}

class CallLogImageAndTextSearchWidget extends StatelessWidget
{
  const CallLogImageAndTextSearchWidget({
    Key key,
    @required this.callLog,
    @required this.onPressed,
  }) : super(key: key);

  final RecentConversationEdges callLog;
  final Function onPressed;

  @override
  Widget build(BuildContext context)
  {
    if (callLog != null)
    {
      return Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
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
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                  child: RoundedNetworkImageHolder(
                    width: Dimens.space48,
                    height: Dimens.space48,
                    boxFit: BoxFit.cover,
                    containerAlignment: Alignment.bottomCenter,
                    iconUrl: CustomIcon.icon_profile,
                    iconColor: CustomColors.callInactiveColor,
                    iconSize: Dimens.space40,
                    boxDecorationColor: CustomColors.mainDividerColor,
                    outerCorner: Dimens.space16,
                    innerCorner: Dimens.space16,
                    imageUrl: callLog.recentConversationNodes.clientInfo!=null?callLog.recentConversationNodes.clientInfo.profilePicture:"",
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
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
                              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              child: Text(
                                  callLog.recentConversationNodes.clientInfo!=null && callLog.recentConversationNodes.clientInfo.name!=null?callLog.recentConversationNodes.clientInfo.name:Utils.getString("unknown"),
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: callLog.recentConversationNodes.clientUnseenMsgCount==0?Config.manropeSemiBold:Config.manropeExtraBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  )
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(Dimens.space6.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              child: RoundedNetworkSvgHolder(
                                containerWidth: Dimens.space16,
                                containerHeight: Dimens.space16,
                                boxFit: BoxFit.contain,
                                imageWidth: Dimens.space16,
                                imageHeight: Dimens.space16,
                                outerCorner: Dimens.space0,
                                innerCorner: Dimens.space0,
                                iconUrl: CustomIcon.icon_person,
                                iconColor: CustomColors.white,
                                iconSize: Dimens.space16,
                                boxDecorationColor: Colors.transparent,
                                imageUrl: Config.countryLogoUrl+callLog.recentConversationNodes.clientCountryFlag,
                              ),
                            )
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                          child: CallMessageVoiceMailWidget(callLog: callLog),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            child: Offstage(
                              offstage: callLog.recentConversationNodes.contactPinned!=null && callLog.recentConversationNodes.contactPinned?false:true,
                              child: RoundedNetworkImageHolder(
                                width: Dimens.space18,
                                height: Dimens.space18,
                                boxFit: BoxFit.cover,
                                iconUrl: CustomIcon.icon_pin,
                                iconColor: CustomColors.warningColor,
                                iconSize: Dimens.space12,
                                outerCorner: Dimens.space0,
                                innerCorner: Dimens.space0,
                                boxDecorationColor:
                                CustomColors.transparent,
                                imageUrl: "",
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              alignment: Alignment.center,
                              child: DateTimeTextWidget(
                                timestamp: callLog.recentConversationNodes.createdAt,
                                date: callLog.recentConversationNodes.createdAt,
                                format: DateFormat('yyyy-MM-ddThh:mm:ss.SSSSSS'),
                                dateFontColor: callLog.recentConversationNodes.clientUnseenMsgCount==0?CustomColors.textQuinaryColor:CustomColors.textTertiaryColor,
                                dateFontFamily: Config.manropeSemiBold,
                                dateFontSize: Dimens.space13,
                                dateFontStyle: FontStyle.normal,
                                dateFontWeight: FontWeight.normal,
                              )
                          ),
                        ],
                      ),
                      Container(
                        width: Dimens.space10.w,
                        height: Dimens.space10.h,
                      )
                    ],
                  ),
                ),
              ],
            ),
            onPressed: ()
            {
              onPressed();
            },
          )
      );
    }
    else
    {
      return Container();
    }
  }
}

class CallMessageVoiceMailWidget extends StatelessWidget
{
  final RecentConversationEdges callLog;

  CallMessageVoiceMailWidget({Key key, this.callLog}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    if (callLog.recentConversationNodes.conversationType == "Call")
    {
      if (callLog.recentConversationNodes.direction.toLowerCase() == "incoming")
      {
        if (callLog.recentConversationNodes.conversationStatus == "NOANSWER")
        {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space6, Dimens.space0),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space16.w,
                  height: Dimens.space16.w,
                  boxFit: BoxFit.cover,
                  iconUrl: CustomIcon.icon_missed_call,
                  iconColor: CustomColors.redButtonColor,
                  boxDecorationColor: CustomColors.transparent,
                  iconSize: Dimens.space16.w,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                child:Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                  child: Text(
                      Utils.getString("missedCall"),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.button.copyWith(
                        color: CustomColors.redButtonColor,
                        fontSize: Dimens.space14.sp,
                        fontFamily: Config.heeboRegular,
                        fontWeight: FontWeight.normal,
                      )
                  ),
                ),
              ),
            ],
          );
        }
        else if (callLog.recentConversationNodes.conversationStatus == "BUSY")
        {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space6, Dimens.space0),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space16.w,
                  height: Dimens.space16.w,
                  boxFit: BoxFit.cover,
                  iconUrl: CustomIcon.icon_missed_call,
                  iconColor: CustomColors.redButtonColor,
                  boxDecorationColor: CustomColors.transparent,
                  iconSize: Dimens.space16.w,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                child:Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                  child: Text(
                      Utils.getString("missedCall"),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.button.copyWith(
                        color: CustomColors.redButtonColor,
                        fontSize: Dimens.space14.sp,
                        fontFamily: Config.heeboRegular,
                        fontWeight: FontWeight.normal,
                      )
                  ),
                )
              ),
            ],
          );
        }
        else
        {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space6, Dimens.space0),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space16.w,
                  height: Dimens.space16.w,
                  boxFit: BoxFit.cover,
                  iconUrl: CustomIcon.icon_incoming,
                  iconColor: CustomColors.callAcceptColor,
                  boxDecorationColor: CustomColors.transparent,
                  iconSize: Dimens.space16.w,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                  child:Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                    child: Text(
                        Utils.getString("inbound"),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.button.copyWith(
                          color: CustomColors.callAcceptColor,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                        )
                    ),
                  )
              ),
            ],
          );
        }
      }
      else
      {
        if (callLog.recentConversationNodes.conversationStatus == "NOANSWER")
        {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space6, Dimens.space0),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space16.w,
                  height: Dimens.space16.w,
                  boxFit: BoxFit.cover,
                  iconUrl: CustomIcon.icon_call_no_answer,
                  iconColor: CustomColors.redButtonColor,
                  boxDecorationColor: CustomColors.transparent,
                  iconSize: Dimens.space16.w,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                    child: Text(
                        Utils.getString("noAnswer"),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.button.copyWith(
                          color: CustomColors.redButtonColor,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                        )
                    ),
                  )
              ),
            ],
          );
        }
        else if (callLog.recentConversationNodes.conversationStatus == "BUSY")
        {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space6, Dimens.space0),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space16.w,
                  height: Dimens.space16.w,
                  boxFit: BoxFit.cover,
                  iconUrl: CustomIcon.icon_call_busy,
                  iconColor: CustomColors.redButtonColor,
                  boxDecorationColor: CustomColors.transparent,
                  iconSize: Dimens.space16.w,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                    child: Text(
                        Utils.getString("busy"),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.button.copyWith(
                          color: CustomColors.redButtonColor,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                        )
                    ),
                  )
              ),
            ],
          );
        }
        else if (callLog.recentConversationNodes.conversationStatus == "CALL CANCELED")
        {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space6, Dimens.space0),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space16.w,
                  height: Dimens.space16.w,
                  boxFit: BoxFit.cover,
                  iconUrl: CustomIcon.icon_call_cancelled,
                  iconColor: CustomColors.redButtonColor,
                  boxDecorationColor: CustomColors.transparent,
                  iconSize: Dimens.space16.w,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                    child: Text(
                        Utils.getString("callcanceled"),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.button.copyWith(
                          color: CustomColors.redButtonColor,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                        )
                    ),
                  )
              ),
            ],
          );
        }
        else if (callLog.recentConversationNodes.conversationStatus == "COMPLETED")
        {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space6, Dimens.space0),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space16.w,
                  height: Dimens.space16.w,
                  boxFit: BoxFit.cover,
                  iconUrl: CustomIcon.icon_outgoing,
                  iconColor: CustomColors.callAcceptColor,
                  boxDecorationColor: CustomColors.transparent,
                  iconSize: Dimens.space16.w,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                    child: Text(
                        Utils.getString("outBound"),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.button.copyWith(
                          color: CustomColors.callAcceptColor,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                        )
                    ),
                  )
              ),
            ],
          );
        }
        else
        {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space6, Dimens.space0),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space16.w,
                  height: Dimens.space16.w,
                  boxFit: BoxFit.cover,
                  iconUrl: CustomIcon.icon_outgoing,
                  iconColor: CustomColors.callAcceptColor,
                  boxDecorationColor: CustomColors.transparent,
                  iconSize: Dimens.space16.w,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  imageUrl: "",
                ),
              ),
              Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                    child: Text(
                        Utils.getString("outBound"),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.button.copyWith(
                          color: CustomColors.callAcceptColor,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                        )
                    ),
                  )
              ),
            ],
          );
        }
      }
    }
    else if (callLog.recentConversationNodes.conversationType == "Message")
    {
      return Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
        child: Text(
          callLog.recentConversationNodes.content.body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.button.copyWith(
            color: CustomColors.textPrimaryLightColor,
            fontFamily: Config.heeboRegular,
            fontSize: Dimens.space14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    else
    {
      return Container(
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
              alignment: Alignment.center,
              child: Icon(
                Icons.voicemail,
                size: Dimens.space14.w,
                color: CustomColors.warningColor,
              ),
            ),
            Expanded(
              child: Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    callLog.recentConversationNodes.clientInfo!=null && callLog.recentConversationNodes.clientInfo.name!=null?callLog.recentConversationNodes.clientInfo.name:Utils.getString("unknown")+Utils.getString("sentYouAVoiceMail"),
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: CustomColors.textPrimaryColor,
                      fontFamily: Config.heeboRegular,
                      fontSize: Dimens.space14.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  )
              ),
            ),
          ],
        ),
      );
    }
  }
}