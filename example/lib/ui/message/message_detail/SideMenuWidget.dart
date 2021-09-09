import 'package:flutter/material.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/constant/RoutePaths.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/ui/common/TagsItemWidget.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/holder/intent_holder/MessageDetailIntentHolder.dart';
import 'package:voice_example/viewobject/model/allNotes/Notes.dart';
import 'package:voice_example/viewobject/model/call/RecentConversationNodes.dart';
import 'package:voice_example/viewobject/model/allContact/Tags.dart';

class SliderMenuWidget extends StatefulWidget
{
  const SliderMenuWidget({
    Key key,
    @required this.clientId,
    @required this.clientPhoneNumber,
    @required this.clientName,
    @required this.clientProfilePicture,
    @required this.isBlocked,
    @required this.countryId,
    @required this.countryFlagUrl,
    @required this.tags,
    @required this.notes,
    @required this.dndMissed,
    @required this.lastChatted,
    @required this.dndEnabled,
    @required this.onCallTap,
    @required this.onMuteTap,
    @required this.onUnMuteTap,
    @required this.onAddTagsTap,
    @required this.onTapSearchConversation,
    @required this.onNotesTap,
    @required this.onAddContactTap,
    @required this.onContactDetailTap,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
    @required this.makeCallWithSid,
  }) : super(key: key);

  final String clientId;
  final String clientPhoneNumber;
  final String clientName;
  final String clientProfilePicture;
  final String countryId;
  final String countryFlagUrl;
  final bool isBlocked;
  final List<Tags> tags;
  final List<Notes> notes;
  final Function onCallTap;
  final Function onMuteTap;
  final Function onUnMuteTap;
  final Function onAddTagsTap;
  final Function onNotesTap;
  final bool dndMissed;
  final String lastChatted;
  final bool dndEnabled;
  final Function onAddContactTap;
  final Function onContactDetailTap;
  final Function onTapSearchConversation;
  final Function onIncomingTap;
  final Function onOutgoingTap;
  final Function(String, String, String, String, String, String, String, String, String, String, String, String) makeCallWithSid;

  @override
  _SliderMenuWidgetState createState() => _SliderMenuWidgetState();
}

class _SliderMenuWidgetState extends State<SliderMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.mainBackgroundColor,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space24.h,
              Dimens.space16.w, Dimens.space0.h),
          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            border: Border.all(
                color: CustomColors.mainDividerColor, width: Dimens.space1.w),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(Dimens.space16.w),
                topLeft: Radius.circular(Dimens.space16.w)),
            color: CustomColors.mainBackgroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                    Dimens.space16.w, Dimens.space24.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(Dimens.space16.w),
                      topLeft: Radius.circular(Dimens.space16.w)),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      color: CustomColors.white,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space20.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: Dimens.space40,
                            height: Dimens.space40,
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
                            child: RoundedNetworkImageHolder(
                              width: Dimens.space40,
                              height: Dimens.space40,
                              boxFit: BoxFit.cover,
                              iconUrl: CustomIcon.icon_profile,
                              containerAlignment: Alignment.bottomCenter,
                              iconColor: CustomColors.callInactiveColor,
                              iconSize: Dimens.space34,
                              boxDecorationColor: CustomColors.mainDividerColor,
                              outerCorner: Dimens.space14,
                              innerCorner: Dimens.space14,
                              imageUrl: widget.clientProfilePicture != null
                                  ? widget.clientProfilePicture
                                  : "",
                            ),
                          ),
                          Expanded(
                            child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space14.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      children: [
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
                                            widget.clientName != null
                                                ? widget.clientName
                                                : Utils.getString("unknown"),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                    fontFamily:
                                                        Config.manropeBold,
                                                    fontSize: Dimens.space16.sp,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: CustomColors
                                                        .textPrimaryColor,
                                                    fontStyle:
                                                        FontStyle.normal),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              Dimens.space6.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
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
                                            boxDecorationColor:
                                                Colors.transparent,
                                            imageUrl: widget.countryFlagUrl != null
                                                ? Config.countryLogoUrl +
                                                    widget.countryFlagUrl
                                                : "",
                                          ),
                                        )
                                      ],
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
                                        widget.clientPhoneNumber,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontFamily: Config.heeboMedium,
                                                fontSize: Dimens.space13.sp,
                                                fontWeight: FontWeight.normal,
                                                color: CustomColors
                                                    .textTertiaryColor,
                                                fontStyle: FontStyle.normal),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: (widget.tags != null && widget.tags.length != 0)
                          ? Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space20.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              height: Dimens.space24.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.tags.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                        Dimens.space8.w,
                                        Dimens.space0.h),
                                    padding: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    height: Dimens.space24.h,
                                    child: TagsItemWidget(
                                      tags: widget.tags[index],
                                      fromContact: true,
                                    ),
                                  );
                                },
                                physics: AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                              ),
                            )
                          : Container(),
                    )
                  ],
                ),
              ),
              Divider(
                color: CustomColors.mainDividerColor,
                height: Dimens.space1,
                thickness: Dimens.space1,
              ),
              widget.isBlocked?Container(): Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                      Dimens.space20.h, Dimens.space16.w, Dimens.space20.h),
                  alignment: Alignment.center,
                  color: CustomColors.bottomAppBarColor,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space7.w,
                                Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space11.h,
                                    Dimens.space0.w,
                                    Dimens.space11.h),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                backgroundColor: CustomColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(Dimens.space10.r),
                                ),
                              ),
                              onPressed: widget.dndEnabled != null && widget.dndEnabled
                                  ? widget.onUnMuteTap
                                  : widget.onMuteTap,
                              child: Container(
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
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
                                        alignment: Alignment.center,
                                        child: Icon(
                                          widget.dndEnabled != null && widget.dndEnabled
                                              ? CustomIcon.icon_muted
                                              : CustomIcon.icon_notification,
                                          color: widget.dndEnabled != null &&
                                                  widget.dndEnabled
                                              ? CustomColors
                                                  .textPrimaryErrorColor
                                              : CustomColors.loadingCircleColor,
                                          size: Dimens.space20.w,
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space6.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          alignment: Alignment.center,
                                          child: Text(
                                            widget.dndEnabled != null && widget.dndEnabled
                                                ? Utils.getString("muted")
                                                : Utils.getString("alwaysOn")
                                                    .toLowerCase(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                    fontFamily:
                                                        Config.heeboRegular,
                                                    fontSize: Dimens.space12.sp,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: CustomColors
                                                        .textTertiaryColor,
                                                    fontStyle:
                                                        FontStyle.normal),
                                          ))
                                    ],
                                  )),
                            )),
                      ),
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space7.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space11.h,
                                    Dimens.space0.w,
                                    Dimens.space11.h),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                backgroundColor: CustomColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(Dimens.space10.r),
                                ),
                              ),
                              onPressed: widget.onCallTap,
                              child: Container(
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
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
                                        alignment: Alignment.center,
                                        child: Icon(
                                          CustomIcon.icon_call,
                                          color:
                                              CustomColors.loadingCircleColor,
                                          size: Dimens.space20.w,
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space6.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          alignment: Alignment.center,
                                          child: Text(
                                            Utils.getString("call")
                                                .toLowerCase(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                    fontFamily:
                                                        Config.heeboRegular,
                                                    fontSize: Dimens.space12.sp,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: CustomColors
                                                        .textTertiaryColor,
                                                    fontStyle:
                                                        FontStyle.normal),
                                          ))
                                    ],
                                  )),
                            )),
                      ),
                    ],
                  )),
              Divider(
                color: CustomColors.mainDividerColor,
                height: Dimens.space1,
                thickness: Dimens.space1,
              ),
              //Add Notes
              Container(
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                alignment: Alignment.center,
                height: Dimens.space52.h,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                        Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
                    backgroundColor: CustomColors.white,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: widget.onNotesTap,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          child: Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              CustomIcon.icon_add_notes,
                              size: Dimens.space16.w,
                              color: CustomColors.textTertiaryColor,
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
                                      Utils.getString("notes"),
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
                                    ))),
                          ],
                        ),
                      )),
                      Container(
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space10.w,
                              Dimens.space5.h,
                              Dimens.space10.w,
                              Dimens.space5.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.space16.r)),
                            border: Border.all(
                              color: CustomColors.textQuinaryColor,
                              width: Dimens.space1.h,
                            ),
                            color: CustomColors.white,
                            shape: BoxShape.rectangle,
                          ),
                          child: Text(
                            widget.notes != null && widget.notes.isNotEmpty
                                ? widget.notes.length.toString()
                                : Utils.getString("0"),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    color: CustomColors.textTertiaryColor,
                                    fontFamily: Config.heeboMedium,
                                    fontSize: Dimens.space13.sp,
                                    fontWeight: FontWeight.normal),
                          )),
                      Icon(
                        CustomIcon.icon_arrow_right,
                        size: Dimens.space24.w,
                        color: CustomColors.textQuinaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                color: CustomColors.mainDividerColor,
                height: Dimens.space1,
                thickness: Dimens.space1,
              ),

              //Call Recording
              callRecording(context),
              Divider(
                color: CustomColors.mainDividerColor,
                height: Dimens.space1,
                thickness: Dimens.space1,
              ),

              //Search
              Container(
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space8.h,
                    Dimens.space16.w, Dimens.space8.h),
                alignment: Alignment.center,
                height: Dimens.space52.h,
                color: CustomColors.white,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    backgroundColor: CustomColors.white,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () async {
                    widget.onTapSearchConversation();
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        CustomIcon.icon_search,
                        size: Dimens.space16.w,
                        color: CustomColors.textTertiaryColor,
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
                                Utils.getString("searchConversation"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        color: CustomColors.textPrimaryColor,
                                        fontFamily: Config.manropeSemiBold,
                                        fontSize: Dimens.space15.sp,
                                        fontWeight: FontWeight.normal),
                              ))),
                    ],
                  ),
                ),
              ),
              Divider(
                color: CustomColors.mainDividerColor,
                height: Dimens.space1,
                thickness: Dimens.space1,
              ),
              //Add Tags
              Container(
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space8.h,
                    Dimens.space16.w, Dimens.space8.h),
                alignment: Alignment.center,
                height: Dimens.space52.h,
                color: CustomColors.white,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    backgroundColor: CustomColors.white,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: widget.onAddTagsTap,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        CustomIcon.icon_tag,
                        size: Dimens.space16.w,
                        color: CustomColors.textTertiaryColor,
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
                                Utils.getString("addTags"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        color: CustomColors.textPrimaryColor,
                                        fontFamily: Config.manropeSemiBold,
                                        fontSize: Dimens.space15.sp,
                                        fontWeight: FontWeight.normal),
                              ))),
                    ],
                  ),
                ),
              ),
              Divider(
                color: CustomColors.mainDividerColor,
                height: Dimens.space1,
                thickness: Dimens.space1,
              ),
              SizedBox(
                height: Dimens.space30.h,
              ),
              Divider(
                color: CustomColors.mainDividerColor,
                height: Dimens.space1,
                thickness: Dimens.space1,
              ),
              DetailWidget(
                isContact: widget.clientId!=null && widget.clientId.isNotEmpty,
                onAddContactTap: widget.onAddContactTap,
                onContactDetailTap: widget.onContactDetailTap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget callRecording(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      alignment: Alignment.center,
      height: Dimens.space52.h,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
              Dimens.space16.w, Dimens.space0.h),
          backgroundColor: CustomColors.white,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () {
          Navigator.pushNamed(context, RoutePaths.recordingView,
              arguments: MessageDetailIntentHolder(
                clientName: widget.clientName,
                clientPhoneNumber: widget.clientPhoneNumber,
                clientProfilePicture: widget.clientProfilePicture,
                clientId: widget.clientId,
                lastChatted: "",
                countryId: "",
                countryFlagUrl: "",
                isBlocked: false,
                dndMissed: false,
                isContact: false,
                onIncomingTap: ()
                {
                  widget.onIncomingTap();
                },
                onOutgoingTap: ()
                {
                  widget.onOutgoingTap();
                },
                makeCallWithSid: (channelNumber, channelName, channelSid, channelFlagUrl, outgoingNumber, workspaceSid, memberId, voiceToken, outgoingName, outgoingId, outgoingFlagUrl, outgoingProfilePicture)
                {
                  widget.makeCallWithSid(channelNumber, channelName, channelSid, channelFlagUrl, outgoingNumber, workspaceSid, memberId, voiceToken, outgoingName, outgoingId, outgoingFlagUrl, outgoingProfilePicture);
                },
              )
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    CustomIcon.icon_recording,
                    size: Dimens.space16.w,
                    color: CustomColors.textTertiaryColor,
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
                            Utils.getString("callRecording"),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal),
                          ))),
                ],
              ),
            )),
            Container(
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space5.h,
                    Dimens.space10.w, Dimens.space5.h),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimens.space16.r)),
                  border: Border.all(
                    color: CustomColors.textQuinaryColor,
                    width: Dimens.space1.h,
                  ),
                  color: CustomColors.white,
                  shape: BoxShape.rectangle,
                ),
                child: Text(
                  Utils.getString("0"),
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: CustomColors.textTertiaryColor,
                      fontFamily: Config.heeboMedium,
                      fontSize: Dimens.space13.sp,
                      fontWeight: FontWeight.normal),
                )),
            Icon(
              CustomIcon.icon_arrow_right,
              size: Dimens.space24.w,
              color: CustomColors.textQuinaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class ImageAndTextWidget extends StatelessWidget {
  const ImageAndTextWidget({
    Key key,
    this.clientNumber,
    this.clientName,
    this.clientProfilePicture,
    this.callLogNode,
  }) : super(key: key);

  final String clientNumber;
  final String clientName;
  final String clientProfilePicture;
  final RecentConversationNodes callLogNode;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(
            Dimens.space0, Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: Dimens.space48,
              height: Dimens.space48,
              margin: EdgeInsets.fromLTRB(Dimens.space12.w, Dimens.space0,
                  Dimens.space0, Dimens.space0),
              padding: EdgeInsets.fromLTRB(
                  Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
              child: RoundedNetworkImageHolder(
                width: Dimens.space48,
                height: Dimens.space48,
                boxFit: BoxFit.cover,
                iconUrl: CustomIcon.icon_profile,
                iconColor: CustomColors.callInactiveColor,
                iconSize: Dimens.space48,
                boxDecorationColor: CustomColors.mainDividerColor,
                outerCorner: Dimens.space16,
                innerCorner: Dimens.space16,
                imageUrl: callLogNode.clientInfo != null
                    ? callLogNode.clientInfo.profilePicture
                    : "",
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                width: double.maxFinite,
                margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0,
                    Dimens.space0, Dimens.space0),
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                          margin: const EdgeInsets.fromLTRB(Dimens.space0,
                              Dimens.space0, Dimens.space0, Dimens.space0),
                          child: Text(
                            clientName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.manropeBold,
                                    fontSize: Dimens.space16.sp,
                                    letterSpacing: 0,
                                    height: 1,
                                    fontWeight: FontWeight.w700),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: Dimens.space0.w),
                          child: RoundedNetworkSvgHolder(
                            containerWidth: Dimens.space20.w,
                            containerHeight: Dimens.space20.w,
                            boxFit: BoxFit.contain,
                            imageWidth: Dimens.space16.w,
                            imageHeight: Dimens.space16.w,
                            imageUrl: "",
                            outerCorner: Dimens.space0.w,
                            innerCorner: Dimens.space0.w,
                            iconUrl: CustomIcon.icon_person,
                            iconColor: CustomColors.white,
                            iconSize: Dimens.space16.w,
                            boxDecorationColor: Colors.transparent,
                          ),
                        )
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(
                        "${clientNumber}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: CustomColors.textTertiaryColor,
                            fontFamily: Config.manropeSemiBold,
                            fontSize: Dimens.space10.sp,
                            letterSpacing: 0,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}

class DetailWidget extends StatelessWidget
{
  const DetailWidget({
    Key key,
    this.isContact,
    this.onContactDetailTap,
    this.onAddContactTap,
  }) : super(key: key);

  final bool isContact;
  final Function onContactDetailTap;
  final Function onAddContactTap;

  @override
  Widget build(BuildContext context)
  {
    return Container(
      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Offstage(
            offstage: !isContact,
            child: Container(
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              alignment: Alignment.center,
              height: Dimens.space52.h,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                      Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
                  backgroundColor: CustomColors.white,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: onContactDetailTap,
                child: Container(
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
                      Utils.getString("contactDetails"),
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
          ),
          Offstage(
            offstage: isContact,
            child: Container(
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              alignment: Alignment.center,
              height: Dimens.space52.h,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                      Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
                  backgroundColor: CustomColors.white,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: onAddContactTap,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                              Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                              Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                CustomIcon.icon_plus_rounded,
                                size: Dimens.space16.w,
                                color: CustomColors.loadingCircleColor,
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
                                        Utils.getString("addContacts"),
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
                                      ))),
                            ],
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(
            color: CustomColors.mainDividerColor,
            height: Dimens.space1,
            thickness: Dimens.space1,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space8.h,
                Dimens.space16.w, Dimens.space8.h),
            alignment: Alignment.center,
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
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                backgroundColor: CustomColors.white,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () async {},
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: Container(
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
                            Utils.getString("shareContact"),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    color: CustomColors.textQuinaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal),
                          ))),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space8.h,
                Dimens.space16.w, Dimens.space8.h),
            alignment: Alignment.center,
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
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                backgroundColor: CustomColors.white,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () async {},
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.delete_outlined,
                    size: Dimens.space16.w,
                    color: CustomColors.textQuinaryColor,
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
                            Utils.getString("archiveConversation"),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    color: CustomColors.textQuinaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal),
                          ))),
                ],
              ),
            ),
          ),
          SizedBox(
            height: Dimens.space30.h,
          ),
          Divider(
            color: CustomColors.mainDividerColor,
            height: Dimens.space1,
            thickness: Dimens.space1,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space8.h,
                Dimens.space16.w, Dimens.space8.h),
            alignment: Alignment.center,
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
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                backgroundColor: CustomColors.white,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () async {},
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: Container(
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
                            Utils.getString("blockContact"),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    color: CustomColors.textQuinaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal),
                          ))),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space16.h),
            padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space8.h,
                Dimens.space16.w, Dimens.space8.h),
            alignment: Alignment.center,
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
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                backgroundColor: CustomColors.white,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () async {},
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: Container(
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
                            Utils.getString("reportContact"),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    color: CustomColors.textQuinaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal),
                          ))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
