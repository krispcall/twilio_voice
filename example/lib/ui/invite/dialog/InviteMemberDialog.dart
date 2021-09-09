/*
 * *
 *  * Created by Kedar on 7/28/21 11:36 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/28/21 11:36 AM
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/ui/common/ButtonWidget.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/ui/common/CustomTextField.dart';
import 'package:voice_example/ui/common/dialog/ErrorDialog.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/utils/Validation.dart';

class InviteMemberDialog extends StatefulWidget {
  final Function onCallBack;

  InviteMemberDialog({Key key, this.onCallBack}) : super(key: key);

  @override
  _WorkSpaceDetailsDialogState createState() {
    return _WorkSpaceDetailsDialogState();
  }
}

class _WorkSpaceDetailsDialogState extends State<InviteMemberDialog>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    this.animationController = new AnimationController(
        vsync: this, duration: Config.animation_duration);
  }

  @override
  void dispose() {
    this.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }

          Navigator.pop(context);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    return Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space8.h,
            Dimens.space16.w, Dimens.space0.h),
        height: ScreenUtil().screenHeight * 0.80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(Dimens.space16.w),
              topLeft: Radius.circular(Dimens.space16.w)),
          color: CustomColors.white,
        ),
        child: SingleChildScrollView(
            child: Column(
          children: [
            PreferredSize(
              preferredSize:
                  Size(MediaQuery.of(context).size.width.w, kToolbarHeight.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: TextButton(
                          onPressed: _requestPop,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor: CustomColors.transparent,
                            alignment: Alignment.centerLeft,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                CustomIcon.icon_arrow_left,
                                color: CustomColors.loadingCircleColor,
                                size: Dimens.space22.w,
                              ),
                              Text(
                                Utils.getString('back'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      color: CustomColors.loadingCircleColor,
                                      fontFamily: Config.manropeBold,
                                      fontSize: Dimens.space15.sp,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                              ),
                            ],
                          )),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      Utils.getString("invite"),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: CustomColors.textPrimaryColor,
                            fontFamily: Config.manropeBold,
                            fontSize: Dimens.space16.sp,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                          ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space36.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                      width: Dimens.space120.w,
                      height: Dimens.space120.w,
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: PlainAssetImageHolder(
                        assetUrl: "assets/images/invitation.png",
                        width: Dimens.space120,
                        height: Dimens.space120,
                        assetWidth: Dimens.space152,
                        assetHeight: Dimens.space152,
                        boxFit: BoxFit.contain,
                        outerCorner: Dimens.space0,
                        innerCorner: Dimens.space120,
                        iconSize: Dimens.space120,
                        iconUrl: CustomIcon.icon_call,
                        iconColor: CustomColors.white,
                        boxDecorationColor: CustomColors.white,
                      )),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space20.h, Dimens.space0.w, Dimens.space10),
                    child: Text(
                      Utils.getString("inviteMembers"),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: Dimens.space20.sp,
                            color: CustomColors.textPrimaryColor,
                            fontFamily: Config.manropeBold,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                          ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space37.w,
                        Dimens.space0.h, Dimens.space37.w, Dimens.space0.h),
                    child: Text(Utils.getString("inviteMessage"),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: CustomColors.textTertiaryColor,
                              fontFamily: Config.heeboRegular,
                              fontSize: Dimens.space15.sp,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                            ),
                        textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space36.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              child: CustomTextField(
                height: Dimens.space48,
                titleText: Utils.getString("enterEmail"),
                containerFillColor: CustomColors.baseLightColor,
                borderColor: CustomColors.secondaryColor,
                corner: Dimens.space10,
                titleFont: Config.manropeBold,
                titleTextColor: CustomColors.textSecondaryColor,
                titleFontSize: Dimens.space14,
                titleFontStyle: FontStyle.normal,
                titleFontWeight: FontWeight.w700,
                titleMarginLeft: Dimens.space0,
                titleMarginRight: Dimens.space0,
                titleMarginBottom: Dimens.space6,
                titleMarginTop: Dimens.space0,
                hintText: Utils.getString(''),
                hintFontColor: CustomColors.textQuaternaryColor,
                hintFontFamily: Config.heeboRegular,
                hintFontSize: Dimens.space16,
                hintFontStyle: FontStyle.normal,
                hintFontWeight: FontWeight.normal,
                inputFontColor: CustomColors.textQuaternaryColor,
                inputFontFamily: Config.heeboRegular,
                inputFontSize: Dimens.space16,
                inputFontStyle: FontStyle.normal,
                inputFontWeight: FontWeight.normal,
                textEditingController: textEditingController,
                showTitle: true,
                autoFocus: false,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space24.h,
                  Dimens.space0.w, Dimens.space34.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              child: RoundedButtonWidget(
                width: double.maxFinite,
                height: Dimens.space54,
                buttonBackgroundColor: CustomColors.mainColor,
                buttonTextColor: CustomColors.white,
                corner: Dimens.space10,
                buttonBorderColor: CustomColors.mainColor,
                buttonFontFamily: Config.manropeSemiBold,
                buttonFontSize: Dimens.space16,
                titleTextAlign: TextAlign.center,
                buttonFontWeight: FontWeight.normal,
                buttonText: Utils.getString('next'),
                onPressed: () async {
                  if (MemberValidation.isValidMemberValidation(
                          textEditingController.text)
                      .isNotEmpty) {
                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return ErrorDialog(
                            message: MemberValidation.isValidMemberValidation(
                                textEditingController.text),
                          );
                        });
                  } else {
                    widget.onCallBack(textEditingController.text);
                  }
                },
              ),
            ),
          ],
        )));
  }
}
