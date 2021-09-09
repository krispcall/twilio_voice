/*
 * *
 *  * Created by Kedar on 7/30/21 1:06 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/30/21 1:06 PM
 *  
 */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/login_workspace/LoginWorkspaceProvider.dart';
import 'package:voice_example/repository/LoginWorkspaceRepository.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:provider/provider.dart';

import '../CustomImageHolder.dart';

class BalanceDialog extends StatefulWidget {
  final Function onTap;
  final double amount;
  BalanceDialog({
    Key key,
    this.onTap,
    this.amount,s
  }) : super(key: key);

  @override
  _BalanceDialogState createState() => _BalanceDialogState();
}

class _BalanceDialogState extends State<BalanceDialog>
    with SingleTickerProviderStateMixin {
  LoginWorkspaceProvider workspaceProvider;

  LoginWorkspaceRepository workspaceRepository;
  Animation<double> animation;
  AnimationController animationController;

  @override
  void initState() {
    animationController = new AnimationController(
        vsync: this, duration: Config.animation_duration);
    workspaceRepository =
        Provider.of<LoginWorkspaceRepository>(context, listen: false);
    animationController.forward();
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginWorkspaceProvider>(
        lazy: false,
        create: (BuildContext context) {
          this.workspaceProvider =
              LoginWorkspaceProvider(loginWorkspaceRepository: workspaceRepository);
          return workspaceProvider;
        },
        child: Consumer<LoginWorkspaceProvider>(builder: (context, provider, child) {
          return Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimens.space20.r),
                    topRight: Radius.circular(Dimens.space20.r)),
              ),
              margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space0,
                  Dimens.space20.w, Dimens.space0.h),
              child: Column(
                children: [
                  Container(
                      width: Dimens.space80.w,
                      height: Dimens.space6.h,
                      margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0,
                          Dimens.space0, Dimens.space6.h),
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
                        padding: EdgeInsets.fromLTRB(Dimens.space0,
                            Dimens.space30.h, Dimens.space0, Dimens.space0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.space20.r)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(
                              width: Dimens.space64.w,
                              height: Dimens.space64.w,
                              alignment: Alignment.center,
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
                                width: Dimens.space64,
                                height: Dimens.space64,
                                assetHeight: Dimens.space38,
                                assetWidth: Dimens.space38,
                                boxFit: BoxFit.cover,
                                iconUrl: CustomIcon.icon_profile,
                                iconColor: CustomColors.callInactiveColor,
                                iconSize: Dimens.space38,
                                boxDecorationColor:
                                    CustomColors.mainDividerColor,
                                outerCorner: Dimens.space64,
                                innerCorner: Dimens.space0,
                                assetUrl: "assets/images/image_credit.png",
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space18.h,
                                  Dimens.space0.w,
                                  Dimens.space10),
                              child: Text(
                                Utils.getString("credits"),
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      fontSize: Dimens.space20.sp,
                                      color: CustomColors.textPrimaryColor,
                                      fontFamily: Config.manropeBold,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  margin: EdgeInsets.fromLTRB(
                                      Dimens.space37.w,
                                      Dimens.space0.h,
                                      Dimens.space37.w,
                                      Dimens.space0.h),
                                  child: Text(
                                      " Workspace has \$${widget.amount} credit remaining. Credits can be purchased via your web app.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            color:
                                                CustomColors.textTertiaryColor,
                                            fontFamily: Config.heeboRegular,
                                            fontSize: Dimens.space15.sp,
                                            fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.normal,
                                          ),
                                      textAlign: TextAlign.center),
                                )),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space20.h),
                              child: TextButton(
                                onPressed: widget.onTap,
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.fromLTRB(
                                      Dimens.space0.w,
                                      Dimens.space10.h,
                                      Dimens.space0.w,
                                      Dimens.space10.h),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  alignment: Alignment.center,
                                ),
                                child: Text(
                                  Utils.getString("continueWebsite"),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          fontSize: Dimens.space14.sp,
                                          color: CustomColors.loadingCircleColor,
                                          fontFamily: Config.manropeSemiBold,
                                          fontWeight: FontWeight.normal,
                                          fontStyle: FontStyle.normal,
                                          height: 1.0666666666666667),
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: FractionalOffset.center,
                    margin: new EdgeInsets.fromLTRB(Dimens.space0,
                        Dimens.space20.h, Dimens.space0, Dimens.space20.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                          new Radius.circular(Dimens.space14.r)),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: new Container(
                        height: Dimens.space50.h,
                        alignment: FractionalOffset.center,
                        child: new Text(
                          Utils.getString("cancel"),
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: CustomColors.textPrimaryColor,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal,
                              fontFamily: Config.heeboBlack,
                              fontSize: Dimens.space15.sp),
                        ),
                      ),
                    ),
                  )
                ],
              ));
        }));
  }
}
