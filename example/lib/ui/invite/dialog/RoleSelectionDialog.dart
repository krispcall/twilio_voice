import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/ui/common/ButtonWidget.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/utils/Utils.dart';

/*
 * *
 *  * Created by Kedar on 7/28/21 12:55 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/28/21 12:55 PM
 *
 */

List<RoleType> roleList = [
  RoleType(
      roleName: "Member",
      assetUrl: "",
      settingAssetUrl: "assets/images/member_setting_icon.svg",
      roleDesc: "Members only have access to their personal information",
      inviteLink: "invite/member"),
  RoleType(
      roleName: "Admin",
      assetUrl: "",
      settingAssetUrl: "assets/images/icon_admin_setting.svg",
      roleDesc: "Admin users have access to all the workspace settings",
      inviteLink: "invite/member")
];

class RoleSelectionDialog extends StatefulWidget {
  final String email;
  final Function onRoleSelected;

  RoleSelectionDialog({Key key, @required this.email, this.onRoleSelected})
      : super(key: key);

  @override
  _RoleSelectionDialogState createState() {
    return _RoleSelectionDialogState();
  }
}

class _RoleSelectionDialogState extends State<RoleSelectionDialog>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  RoleType selectedRole;

  @override
  void initState() {
    super.initState();
    this.selectedRole = roleList[0];
    this.animationController = new AnimationController(
        vsync: this, duration: Config.animation_duration);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

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
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
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
                      Utils.getString("role"),
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
            RoleRadioListBuilder(
              onRoleTap: (RoleType value) {
                this.selectedRole = value;
              },
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
                buttonText: Utils.getString('sendInvitation'),
                onPressed: () {
                  widget.onRoleSelected(selectedRole);
                },
              ),
            ),
          ],
        ));
  }
}

class RoleRadioListBuilder extends StatefulWidget {
  final Function onRoleTap;

  RoleRadioListBuilder({Key key, this.onRoleTap}) : super(key: key);

  @override
  _RoleRadioListBuilderState createState() {
    return _RoleRadioListBuilderState();
  }
}

class _RoleRadioListBuilderState extends State<RoleRadioListBuilder> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space36.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) {
          return Container(
            height: Dimens.space16,
          );
        },
        itemCount: roleList.length,
        itemBuilder: (context, index) {
          return ImageAndTextWidget(
            roleTap: (RoleType value, int index) {
              widget.onRoleTap(value);
              setState(() {
                selectedIndex = index;
              });
            }, // callback function, setstate for parent
            index: index,
            isSelected: selectedIndex == index ? true : false,
            roleType: roleList[index],
          );
        },
      ),
    );
  }
}

class ImageAndTextWidget extends StatefulWidget {
  final RoleType roleType;
  final int index;
  final bool isSelected;

  final Function(RoleType, int) roleTap;

  ImageAndTextWidget({
    Key key,
    this.roleType,
    this.roleTap,
    this.index,
    this.isSelected,
  }) : super(key: key);

  _CustomItemState createState() => _CustomItemState();
}

class _CustomItemState extends State<ImageAndTextWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        child: InkWell(
          onTap: () {
            widget.roleTap(widget.roleType, widget.index);
          },
          child: Container(
            decoration: widget.isSelected
                ? BoxDecoration(
                    color: CustomColors.loadingCircleColor.withOpacity(0.1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    border: Border.all(
                        color: CustomColors.loadingCircleColor, width: 1))
                : BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    border: Border.all(
                        color: CustomColors.callInactiveColor, width: 1)),
            padding: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space20.h,
                Dimens.space20.w, Dimens.space20.h),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: Dimens.space52.w,
                  height: Dimens.space52.w,
                  child: Stack(
                    children: [
                      Container(
                          width: Dimens.space48.w,
                          height: Dimens.space48.w,
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
                          child: PlainAssetImageHolder(
                            assetUrl: "",
                            width: Dimens.space48,
                            height: Dimens.space48,
                            assetWidth: Dimens.space48,
                            assetHeight: Dimens.space48,
                            boxFit: BoxFit.cover,
                            outerCorner: Dimens.space20,
                            innerCorner: Dimens.space20,
                            iconSize: Dimens.space48,
                            iconUrl: CustomIcon.icon_profile,
                            iconColor: CustomColors.mainDividerColor,
                            boxDecorationColor: CustomColors.bottomAppBarColor,
                          )),
                      Positioned(
                          bottom: Dimens.space8.h,
                          right: 0,
                          child: RoundedAssetSvgHolder(
                            containerWidth: Dimens.space20,
                            containerHeight: Dimens.space20,
                            boxFit: BoxFit.cover,
                            imageWidth: Dimens.space20,
                            imageHeight: Dimens.space20,
                            outerCorner: Dimens.space0,
                            innerCorner: Dimens.space0,
                            iconUrl: CustomIcon.icon_call,
                            iconColor: CustomColors.mainColor,
                            iconSize: Dimens.space16,
                            boxDecorationColor: Colors.transparent,
                            assetUrl: "${widget.roleType.settingAssetUrl}",
                            onTap: () {},
                          ))
                    ],
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
                          child: Text("${widget.roleType.roleName}",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.manropeExtraBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                  )),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(Dimens.space0,
                                Dimens.space0, Dimens.space0, Dimens.space0),
                            child: Text("${widget.roleType.roleDesc}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style:
                                    Theme.of(context).textTheme.button.copyWith(
                                          color: CustomColors.textTertiaryColor,
                                          fontSize: Dimens.space14.sp,
                                          fontFamily: Config.heeboRegular,
                                          fontWeight: FontWeight.w400,
                                        )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class RoleType {
  String roleName, assetUrl, settingAssetUrl, roleDesc, inviteLink;

  RoleType(
      {this.roleName,
      this.assetUrl,
      this.settingAssetUrl,
      this.roleDesc,
      this.inviteLink});
}
