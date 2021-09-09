import 'package:flutter/cupertino.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/user/UserProvider.dart';
import 'package:voice_example/repository/UserRepository.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/utils/utils.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NumberSettingView extends StatefulWidget {
  NumberSettingView({
    Key key,
    this.animationController,
  }) : super(key: key);

  final AnimationController animationController;

  @override
  NumberSettingViewState createState() => NumberSettingViewState();
}

class NumberSettingViewState extends State<NumberSettingView> with SingleTickerProviderStateMixin {
  UserRepository userRepository;
  UserProvider userProvider;
  ValueHolder valueHolder;

  @override
  Widget build(BuildContext context)
  {
    userRepository = Provider.of<UserRepository>(context);
    valueHolder = Provider.of<ValueHolder>(context);
    widget.animationController.forward();

    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<UserProvider>(
            lazy: false,
            create: (BuildContext context) {
              this.userProvider = UserProvider(userRepository: userRepository, valueHolder: valueHolder);
              userProvider.getUserProfileDetails();
              return userProvider;
            }),
      ],
      child: Consumer<UserProvider>(
        builder: (BuildContext context, UserProvider provider, Widget child) {
          return Container(
            height: MediaQuery.of(context).size.height,
            color: CustomColors.mainBackgroundColor,
            padding: EdgeInsets.fromLTRB(
                Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
            child: CustomScrollView(
                scrollDirection: Axis.vertical,
                slivers: <Widget>[
                  NumberSettingDetailWidget(
                      animationController: widget.animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / 4) * 2, 1.0,
                              curve: Curves.fastOutSlowIn),
                        ),
                      ),
                      userProvider: userProvider,
                  ),
                ]),
          );
        },
      ),
    );
  }
}

class NumberSettingDetailWidget extends StatefulWidget
{
  NumberSettingDetailWidget({
    Key key,
    this.animationController,
    this.animation,
    @required this.userProvider,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final UserProvider userProvider;

  @override
  NumberSettingDetailWidgetState createState() => NumberSettingDetailWidgetState();
}

class NumberSettingDetailWidgetState extends State<NumberSettingDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: widget.userProvider.valueHolder.loginUserId != null
          ? AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
                opacity: widget.animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - widget.animation.value), 0.0),
                    child: Container(
                      color: CustomColors.backgroundColor,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          HeaderImageAndTextWidget(
                              userProvider: widget.userProvider,
                          ),
                          DetailWidget(userProvider: widget.userProvider),
                          Divider(
                            height: Dimens.space40,
                            thickness: Dimens.space40,
                            color: CustomColors.bottomAppBarColor,
                          ),
                        ],
                      ),
                    )
                )
            );
          })
          : Container(),
    );
  }
}

class HeaderImageAndTextWidget extends StatelessWidget
{
  HeaderImageAndTextWidget({this.userProvider});

  final UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(Dimens.space0,
          Utils.getStatusBarHeight(context), Dimens.space0, Dimens.space0),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0, Dimens.space20.w, Dimens.space0, Dimens.space20.w),
      alignment: Alignment.topLeft,
      color: CustomColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(
                Dimens.space0, Dimens.space2, Dimens.space0, Dimens.space2),
            padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0,
                Dimens.space16.w, Dimens.space0),
            child: RoundedNetworkSvgHolder(
              containerWidth: Dimens.space65,
              containerHeight: Dimens.space65,
              boxFit: BoxFit.contain,
              imageWidth: Dimens.space50,
              imageHeight: Dimens.space50,
              imageUrl: userProvider.getDefaultChannel() != null &&
                  userProvider.getDefaultChannel().countryLogo != null
                  ? Config.countryLogoUrl +
                  userProvider.getDefaultChannel().countryLogo
                  : "",
              outerCorner: Dimens.space20,
              innerCorner: Dimens.space20,
              iconUrl: CustomIcon.icon_person,
              iconColor: CustomColors.mainColor,
              iconSize: Dimens.space27,
              boxDecorationColor: CustomColors.mainBackgroundColor,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space12.h,
                Dimens.space0, Dimens.space12.h),
            padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0,
                Dimens.space16.w, Dimens.space0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text(
                    userProvider.getDefaultChannel().name,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline5.copyWith(
                        color: CustomColors.textPrimaryColor,
                        fontFamily: Config.manropeExtraBold,
                        fontSize: Dimens.space20.sp,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space8.h,
                      Dimens.space0, Dimens.space0.h),
                  child: Text(
                    userProvider.getDefaultChannel().number,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: CustomColors.textTertiaryColor,
                        fontSize: Dimens.space15.sp,
                        fontFamily: Config.heeboRegular,
                        fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailWidget extends StatelessWidget {
  final UserProvider userProvider;

  DetailWidget({
    @required this.userProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
              width: double.infinity,
              color: CustomColors.bottomAppBarColor,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space15.h,
                  Dimens.space16.w, Dimens.space15.h),
              child: Text(
                Utils.getString("generalSettings").toUpperCase(),
                style: Theme.of(context).textTheme.button.copyWith(
                    color: CustomColors.textPrimaryLightColor,
                    fontFamily: Config.manropeBold,
                    fontWeight: FontWeight.normal,
                    fontSize: Dimens.space14.sp,
                    fontStyle: FontStyle.normal),
              )),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            color: CustomColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                      Dimens.space16.h, Dimens.space16.w, Dimens.space16.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: CustomColors.mainDividerColor,
                      ),
                    ),
                  ),
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
                                Utils.getString("numberName"),
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal),
                              ))),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                alignment: Alignment.centerRight,
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
                                  userProvider.getDefaultChannel().name,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                    color: CustomColors.textTertiaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ))
                          ],
                        ),
                      ),
                      Icon(
                        CustomIcon.icon_arrow_right,
                        size: Dimens.space24.w,
                        color: CustomColors.textQuinaryColor,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                      Dimens.space16.h, Dimens.space16.w, Dimens.space16.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: CustomColors.mainDividerColor,
                      ),
                    ),
                  ),
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
                                Utils.getString("notifications"),
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal
                                ),
                              )
                          )
                      ),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              alignment: Alignment.centerRight,
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
                            ),
                            Container(
                              alignment: Alignment.centerRight,
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
                            )
                          ],
                        ),
                      ),
                      Icon(
                        CustomIcon.icon_arrow_right,
                        size: Dimens.space24.w,
                        color: CustomColors.textQuinaryColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
