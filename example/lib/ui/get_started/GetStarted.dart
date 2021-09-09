import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/constant/RoutePaths.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/ui/common/ButtonWidget.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/ui/common/dialog/ConfirmDialogView.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GetStarted extends StatefulWidget {

  @override
  GetStartedState createState() => GetStartedState();
}

class GetStartedState extends State<GetStarted>
    with SingleTickerProviderStateMixin {
  int index = 0;
  List<String> imgList = [];

  @override
  void initState() {
    super.initState();
    imgList = [
      'assets/images/girl_background.png',
      'assets/images/girl_background.png',
      'assets/images/girl_background.png',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: CustomColors.transparent,
        resizeToAvoidBottomInset: true,
        body: Container(
          height: MediaQuery.of(context).size.height.sh,
          width: MediaQuery.of(context).size.width.sw,
          color: CustomColors.transparent,
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CarouselSlider.builder(
                itemCount: imgList.length,
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height.sh,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      this.index = index;
                    });
                  },
                ),
                itemBuilder: (ctx, index, realIdx) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.sw,
                        Dimens.space0.sh, Dimens.space0.sw, Dimens.space0.sh),
                    child: ClipRRect(
                        borderRadius:
                            BorderRadius.all(Radius.circular(Dimens.space0.r)),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            PlainAssetImageHolder(
                              height: MediaQuery.of(context).size.height.sh,
                              width: MediaQuery.of(context).size.width.sw,
                              outerCorner: Dimens.space0.r,
                              innerCorner: Dimens.space0.r,
                              assetWidth: MediaQuery.of(context).size.width.sw,
                              assetHeight:
                                  MediaQuery.of(context).size.height.sh,
                              boxFit: BoxFit.fitWidth,
                              iconUrl: Icons.check_circle,
                              iconColor: CustomColors.callAcceptColor,
                              iconSize: Dimens.space0.r,
                              boxDecorationColor: CustomColors.transparent,
                              assetUrl: imgList[index],
                            ),
                            Positioned(
                              bottom: Platform.isAndroid
                                  ? Dimens.space0.h
                                  : Dimens.space32.h,
                              left: Dimens.space38.w,
                              right: Dimens.space38.w,
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space230.h),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space14.h),
                                      padding: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.sh),
                                      child: RichText(
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                            text: Utils.getString('virtual') +
                                                " ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                    color: CustomColors.white,
                                                    fontFamily:
                                                        Config.manropeRegular,
                                                    fontSize: Dimens.space24.sp,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontStyle:
                                                        FontStyle.normal),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: Utils.getString(
                                                        'cloudPhoneSystem') +
                                                    " ",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                      fontSize:
                                                          Dimens.space24.sp,
                                                      color: CustomColors.white,
                                                      fontFamily: Config
                                                          .manropeExtraBold,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                              ),
                                              TextSpan(
                                                text: Utils.getString(
                                                    'forYourBusiness'),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        fontSize:
                                                            Dimens.space24.sp,
                                                        color:
                                                            CustomColors.white,
                                                        fontFamily: Config
                                                            .manropeRegular,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontStyle:
                                                            FontStyle.normal),
                                              )
                                            ]),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      child: Text(
                                        Utils.getString(
                                            'connectWithYourCustomers'),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(
                                                fontSize: Dimens.space14.sp,
                                                color: CustomColors.white,
                                                fontFamily: Config.heeboRegular,
                                                fontWeight: FontWeight.normal,
                                                fontStyle: FontStyle.normal),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),
                  );
                },
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space32.w,
                        Dimens.space100.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.centerLeft,
                    child: PlainAssetImageHolder(
                      assetUrl: "assets/images/logo.png",
                      width: Dimens.space120,
                      height: Dimens.space30,
                      assetWidth: Dimens.space120,
                      assetHeight: Dimens.space30,
                      boxFit: BoxFit.contain,
                      iconUrl: CustomIcon.icon_person,
                      iconSize: Dimens.space10,
                      iconColor: CustomColors.mainColor,
                      boxDecorationColor: CustomColors.transparent,
                      outerCorner: Dimens.space0,
                      innerCorner: Dimens.space0,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(
                            Dimens.space20.w,
                            Dimens.space28.h,
                            Dimens.space20.w,
                            Dimens.space40.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              child: Icon(
                                Icons.circle,
                                color: this.index == 0
                                    ? CustomColors.mainSecondaryColor
                                    : CustomColors.baseLightColor,
                                size: Dimens.space6,
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space10.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              child: Icon(
                                Icons.circle,
                                color: this.index == 1
                                    ? CustomColors.mainSecondaryColor
                                    : CustomColors.baseLightColor,
                                size: Dimens.space6,
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space10.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              child: Icon(
                                Icons.circle,
                                color: this.index == 2
                                    ? CustomColors.mainSecondaryColor
                                    : CustomColors.baseLightColor,
                                size: Dimens.space6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space16.w,
                                  Dimens.space0.h,
                                  Dimens.space16.w,
                                  Dimens.space16.h),
                              alignment: Alignment.center,
                              child: RoundedButtonWidget(
                                width: MediaQuery.of(context).size.width,
                                height: Dimens.space54,
                                titleTextAlign: TextAlign.center,
                                buttonBackgroundColor:
                                    CustomColors.mainSecondaryColor,
                                buttonBorderColor:
                                    CustomColors.mainSecondaryColor,
                                buttonTextColor: CustomColors.white,
                                corner: Dimens.space12,
                                buttonFontSize: Dimens.space16,
                                buttonFontFamily: Config.manropeSemiBold,
                                fontStyle: FontStyle.normal,
                                buttonFontWeight: FontWeight.normal,
                                buttonText: Utils.getString('getStarted'),
                                onPressed: () {
                                  onTapLogin();
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space16.w,
                                  Dimens.space0.h,
                                  Dimens.space16.w,
                                  Dimens.space16.h),
                              alignment: Alignment.center,
                              child: RoundedButtonWidget(
                                width: MediaQuery.of(context).size.width,
                                height: Dimens.space54,
                                titleTextAlign: TextAlign.center,
                                buttonBackgroundColor: CustomColors.transparent,
                                buttonTextColor: CustomColors.white,
                                buttonBorderColor: CustomColors.white,
                                corner: Dimens.space12,
                                buttonFontSize: Dimens.space16,
                                buttonFontFamily: Config.manropeSemiBold,
                                fontStyle: FontStyle.normal,
                                buttonFontWeight: FontWeight.normal,
                                buttonText: Utils.getString('login'),
                                onPressed: () {
                                  onTapLogin();
                                },
                              ),
                            ),
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
                              child: RoundedButtonWidget(
                                width: MediaQuery.of(context).size.width,
                                height: Dimens.space54,
                                buttonBackgroundColor: CustomColors.transparent,
                                buttonTextColor: CustomColors.white,
                                corner: Dimens.space0,
                                buttonBorderColor: CustomColors.transparent,
                                buttonFontFamily: Config.heeboRegular,
                                buttonFontSize: Dimens.space14,
                                buttonFontWeight: FontWeight.normal,
                                titleTextAlign: TextAlign.center,
                                buttonText: Config.appVersion,
                                onPressed: () {
                                  onTapLogin();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    return showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ConfirmDialogView(
                  description: Utils.getString('areYouSureToExit'),
                  leftButtonText: Utils.getString('cancel'),
                  rightButtonText: Utils.getString('ok').toUpperCase(),
                  onAgreeTap: () {
                    SystemNavigator.pop();
                  });
            }) ??
        false;
  }

  onTapLogin() {
    Navigator.of(context).pushNamed(RoutePaths.loginView);
  }
}
