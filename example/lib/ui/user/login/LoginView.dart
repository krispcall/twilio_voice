import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/constant/RoutePaths.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/country/CountryListProvider.dart';
import 'package:voice_example/provider/login_workspace/LoginWorkspaceProvider.dart';
import 'package:voice_example/provider/user/UserProvider.dart';
import 'package:voice_example/repository/CountryListRepository.dart';
import 'package:voice_example/repository/LoginWorkspaceRepository.dart';
import 'package:voice_example/repository/UserRepository.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/ui/common/CustomTextField.dart';
import 'package:voice_example/ui/common/dialog/ErrorDialog.dart';
import 'package:voice_example/ui/common/ButtonWidget.dart';
import 'package:voice_example/utils/PsProgressDialog.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/utils/Validation.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/UserLoginParameterHolder.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/viewobject/holder/request_holder/WorkSpaceRequestParamHolder.dart';
import 'package:voice_example/viewobject/model/checkDuplicateLogin/CheckDuplicateLogin.dart';
import 'package:voice_example/viewobject/model/country/CountryCode.dart';
import 'package:voice_example/viewobject/model/login/User.dart';
import 'package:voice_example/viewobject/model/memberLogin/Member.dart';
import 'package:voice_example/viewobject/model/workspace/workspace_detail/Workspace.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  UserRepository userRepository;
  UserProvider userProvider;
  AnimationController animationController;
  Animation<double> animation;

  LoginWorkspaceRepository loginWorkspaceRepository;
  LoginWorkspaceProvider loginWorkspaceProvider;

  CountryRepository countryRepository;
  CountryListProvider countryListProvider;

  ValueHolder valueHolder;

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);
    animationController.forward();
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    userRepository = Provider.of<UserRepository>(context, listen: false);
    valueHolder = Provider.of<ValueHolder>(context, listen: false);
    loginWorkspaceRepository =
        Provider.of<LoginWorkspaceRepository>(context, listen: false);
    countryRepository = Provider.of<CountryRepository>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.transparent,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          color: CustomColors.transparent,
          alignment: Alignment.center,
          child: MultiProvider(
            providers: <SingleChildWidget>[
              ChangeNotifierProvider<UserProvider>(
                  lazy: false,
                  create: (BuildContext context) {
                    this.userProvider = UserProvider(
                        userRepository: userRepository,
                        valueHolder: valueHolder);
                    return userProvider;
                  }),
              ChangeNotifierProvider<LoginWorkspaceProvider>(
                  lazy: false,
                  create: (BuildContext context) {
                    this.loginWorkspaceProvider = LoginWorkspaceProvider(
                        loginWorkspaceRepository: loginWorkspaceRepository,
                        valueHolder: valueHolder);
                    return loginWorkspaceProvider;
                  }),
              ChangeNotifierProvider<CountryListProvider>(
                  lazy: false,
                  create: (BuildContext context) {
                    this.countryListProvider = CountryListProvider(
                        countryListRepository: countryRepository);
                    return countryListProvider;
                  }),
            ],
            child: Consumer<UserProvider>(
              builder:
                  (BuildContext context, UserProvider provider, Widget child) {
                return AnimatedBuilder(
                  animation: animationController,
                  builder: (BuildContext context, Widget child) {
                    return FadeTransition(
                      opacity: animation,
                      child: Transform(
                        transform: Matrix4.translationValues(
                            0.0, 100 * (1 - animation.value), 0.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          alignment: Alignment.center,
                          color: CustomColors.transparent,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              PlainAssetImageHolder(
                                height: MediaQuery.of(context).size.height.sh,
                                width: MediaQuery.of(context).size.width.sw,
                                outerCorner: Dimens.space0.r,
                                innerCorner: Dimens.space0.r,
                                assetWidth:
                                    MediaQuery.of(context).size.width.sw,
                                assetHeight:
                                    MediaQuery.of(context).size.height.sh,
                                boxFit: BoxFit.fitWidth,
                                iconUrl: Icons.check_circle,
                                iconColor: CustomColors.callAcceptColor,
                                iconSize: Dimens.space0.r,
                                boxDecorationColor: CustomColors.transparent,
                                assetUrl: "assets/images/girl_background.png",
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        Dimens.space32.w,
                                        Dimens.space100.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
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
                                      boxDecorationColor:
                                          CustomColors.transparent,
                                      outerCorner: Dimens.space0,
                                      innerCorner: Dimens.space0,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    child: LoginFields(
                                      userProvider: userProvider,
                                      loginWorkspaceProvider:
                                          loginWorkspaceProvider,
                                      countryListProvider: countryListProvider,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class LoginFields extends StatefulWidget {
  const LoginFields({
    @required this.userProvider,
    @required this.loginWorkspaceProvider,
    @required this.countryListProvider,
  });

  final UserProvider userProvider;
  final LoginWorkspaceProvider loginWorkspaceProvider;
  final CountryListProvider countryListProvider;

  // final Function onProfileSelected;
  // final Function onLoginCancelTap;

  @override
  LoginFieldsState createState() => LoginFieldsState();
}

class LoginFieldsState extends State<LoginFields> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool error = false;
  String errorText = "";
  bool obscure = true;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String uniqueKey = "";

  @override
  void initState() {
    getUniQueKey();
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      showBottomLoginError(false);
    });
  }

  showBottomLoginError(bool isDuplicateLogin) async {
    if (UserProvider.boolIsTokenChanged) {
      await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.space16.r),
          ),
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.fromLTRB(Dimens.space21.w, Dimens.space0.h,
                  Dimens.space21.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              color: CustomColors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Dimens.space16.r)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space24.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: PlainAssetImageHolder(
                            assetUrl: "assets/images/smartphone.png",
                            height: Dimens.space64,
                            width: Dimens.space64,
                            assetWidth: Dimens.space64,
                            assetHeight: Dimens.space64,
                            boxFit: BoxFit.contain,
                            iconUrl: CustomIcon.icon_person,
                            iconSize: Dimens.space10,
                            iconColor: CustomColors.mainColor,
                            boxDecorationColor: CustomColors.transparent,
                            outerCorner: Dimens.space0,
                            innerCorner: Dimens.space0,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
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
                          child: Text(
                            Utils.getString('singleLogin'),
                            style:
                                Theme.of(context).textTheme.bodyText2.copyWith(
                                      color: CustomColors.textPrimaryColor,
                                      fontFamily: Config.manropeBold,
                                      fontSize: Dimens.space20.sp,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space21.w,
                              Dimens.space10.h,
                              Dimens.space21.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: Text(
                            Utils.getString('yourAccountLogin'),
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.bodyText2.copyWith(
                                      color: CustomColors.textTertiaryColor,
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space15.sp,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space10.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: RoundedButtonWidget(
                            width: double.maxFinite,
                            height: Dimens.space48,
                            buttonBackgroundColor: CustomColors.white,
                            buttonTextColor: CustomColors.loadingCircleColor,
                            corner: Dimens.space10,
                            buttonBorderColor: CustomColors.white,
                            buttonFontFamily: Config.manropeSemiBold,
                            buttonFontSize: Dimens.space15,
                            titleTextAlign: TextAlign.center,
                            buttonFontWeight: FontWeight.normal,
                            buttonText: Utils.getString('signInHere'),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              PsProgressDialog.showDialog(context);
                              login(true, isDuplicateLogin);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space16.h, Dimens.space0.w, Dimens.space30.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: RoundedButtonWidget(
                      width: double.maxFinite,
                      height: Dimens.space48,
                      buttonBackgroundColor: CustomColors.white,
                      buttonTextColor: CustomColors.textPrimaryColor,
                      corner: Dimens.space16,
                      buttonBorderColor: CustomColors.white,
                      buttonFontFamily: Config.manropeSemiBold,
                      buttonFontSize: Dimens.space15,
                      titleTextAlign: TextAlign.center,
                      buttonFontWeight: FontWeight.normal,
                      buttonText: Utils.getString('cancel'),
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            );
          });
    }
  }

  void getUniQueKey() async {
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      setState(() {
        uniqueKey = iosInfo.identifierForVendor;
      });
    } else {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        uniqueKey = androidInfo.androidId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      // emailController.text = "n.giri@krispcall.com";
      // passwordController.text = "diwakeR@123";
      // emailController.text = "shahithakurisundar@gmail.com";
      // passwordController.text = "Pa\$\$w0rd!";
      // emailController.text = "dristisushan@gmail.com";
      // emailController.text = "harriskunwar@icloud.com";
      // passwordController.text = "madan1123";

      // emailController.text = "a.acharya@krispcall.com";
      // passwordController.text = "diwaker123";

      // emailController.text = "a.acharya@krispcall.com";
      // passwordController.text = "diwaker123";
      // emailController.text = "salina.balami@ombryo.com";
      // passwordController.text = "voice_example@12345";
      // emailController.text = "tapish.adhikari5@gmail.com";
      // passwordController.text = "Test@12345";
      // emailController.text = "n.giri@krispcall.com";
      // passwordController.text = "diwakeR@123";
      // emailController.text = "salina.balami@ombryo.com";
      // passwordController.text = "voice_example@12345";
      // emailController.text = "salinabalami24+ii@gmail.com";
      // passwordController.text = "voice_example@12345";
      // emailController.text = "chapa4gainmanoj35@gmail.com";
      // passwordController.text = "password123";
      // emailController.text = "harriskunwar@icloud.com";
      // passwordController.text = "madan1123";
      // emailController.text = "dristisushan@gmail.com";
      // passwordController.text = "p@ssword";
      // emailController.text = "joshan.jt@gmail.com";
      // passwordController.text = "admin@123";
      // emailController.text = "k.shrestha1@codavatartech.tech";
      // passwordController.text = "madan1123";

      // emailController.text = "kedarjirel@gmail.com";
      // passwordController.text = "kedarcod@2021";

      // emailController.text = "joshan.jt@gmail.com";
      // passwordController.text = "Admin@123";

      // emailController.text = "bikrammhz@gmail.com";
      // passwordController.text = "bikram@123";
      // emailController.text = "callservice@krispcall.com";
      // passwordController.text = "Sujan@#1650";
      //   passwordController.text = "Ashi@#7865";
      // emailController.text = "r.lamichhane@codavatar.tech";
      // passwordController.text = "Rojita@#12345";
      // emailController.text = "Tnabina461@gmail.com";
      // passwordController.text = "Kathmandu@#2018";
      // emailController.text = "poonam.maharjan123@ombryo.com";
      // passwordController.text = "Everything@123";
      // emailController.text = "rojitalamichhane11+25@gmail.com";
      // passwordController.text = "Test@123";
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimens.space15.r),
          topRight: Radius.circular(Dimens.space15.r),
        ),
      ),
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      color: CustomColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(Dimens.space15.w, Dimens.space30.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: RoundedButtonWidget(
              height: Dimens.space20,
              width: Dimens.space50,
              buttonBackgroundColor: CustomColors.transparent,
              buttonTextColor: CustomColors.loadingCircleColor,
              corner: Dimens.space0,
              buttonBorderColor: CustomColors.transparent,
              buttonFontFamily: Config.manropeSemiBold,
              buttonFontSize: Dimens.space15,
              titleTextAlign: TextAlign.center,
              buttonFontWeight: FontWeight.normal,
              buttonText: Utils.getString('cancel'),
              // onPressed: widget.onLoginCancelTap,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width.sw,
            margin: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space40.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.centerLeft,
            child: Text(
              Utils.getString('welcomeBack'),
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontSize: Dimens.space24.sp,
                  color: CustomColors.textPrimaryColor,
                  fontFamily: Config.manropeExtraBold,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width.sw,
            margin: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space4.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: Text(
              Utils.getString('pleaseLoginToContinue'),
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: Dimens.space14.sp,
                    color: CustomColors.textTertiaryColor,
                    fontFamily: Config.heeboRegular,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                  ),
            ),
          ),
          Visibility(
            visible: error,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space10.h,
                  Dimens.space10.w, Dimens.space10.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space10.h,
                  Dimens.space0.w, Dimens.space10.h),
              color: CustomColors.errorBackgroundColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                // ignore: always_specify_types
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space10.w,
                        Dimens.space0.h, Dimens.space10.w, Dimens.space0.h),
                    child: Icon(
                      Icons.error_rounded,
                      color: CustomColors.textPrimaryErrorColor,
                      size: Dimens.space20,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space10.w,
                        Dimens.space0.h, Dimens.space10.w, Dimens.space0.h),
                    child: Text(
                      errorText,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: Dimens.space16.sp,
                          color: CustomColors.textPrimaryErrorColor,
                          fontFamily: Config.manropeRegular,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space16.h,
                Dimens.space16.w, Dimens.space20.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: CustomTextField(
              height: Dimens.space54,
              titleText: Utils.getString("emailAddress"),
              containerFillColor: CustomColors.baseLightColor,
              borderColor: CustomColors.secondaryColor,
              corner: Dimens.space10,
              titleFont: Config.manropeBold,
              titleTextColor: CustomColors.textSecondaryColor,
              titleFontSize: Dimens.space14,
              titleFontStyle: FontStyle.normal,
              titleFontWeight: FontWeight.normal,
              titleMarginLeft: Dimens.space0,
              titleMarginRight: Dimens.space0,
              titleMarginBottom: Dimens.space6,
              titleMarginTop: Dimens.space0,
              hintText: Utils.getString("donJohn"),
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
              textEditingController: emailController,
              showTitle: true,
              autoFocus: true,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onChanged: ()
              {

              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                Dimens.space16.w, Dimens.space24.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: CustomTextField(
              height: Dimens.space54,
              titleText: Utils.getString("password"),
              containerFillColor: CustomColors.baseLightColor,
              borderColor: CustomColors.secondaryColor,
              corner: Dimens.space10,
              titleFont: Config.manropeBold,
              titleTextColor: CustomColors.textSecondaryColor,
              titleFontSize: Dimens.space14,
              titleFontStyle: FontStyle.normal,
              titleFontWeight: FontWeight.normal,
              titleMarginLeft: Dimens.space0,
              titleMarginRight: Dimens.space0,
              titleMarginBottom: Dimens.space6,
              titleMarginTop: Dimens.space0,
              hintText: Utils.getString("loginPassword"),
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
              showTitle: true,
              autoFocus: false,
              obscure: obscure,
              textEditingController: passwordController,
              prefix: false,
              keyboardType: TextInputType.emailAddress,
              suffix: true,
              textInputAction: TextInputAction.done,
              onSuffixTap: () {
                setState(() {
                  obscure = !obscure;
                });
              },
              onChanged: ()
              {

              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space10.h,
                Dimens.space16.w, Dimens.space20.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
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
              buttonText: Utils.getString('login'),
              onPressed: () async {
                var checkLoginValidation =
                    LoginValidation.emailPasswordValidation(
                        emailController.text.trim(),
                        passwordController.text.trim());
                if (checkLoginValidation.isNotEmpty) {
                  setState(() {
                    error = true;
                    errorText = checkLoginValidation;
                  });
                } else {
                  UserLoginParameterHolder userLoginParameterHolder =
                      UserLoginParameterHolder(
                    client: "mobile",
                    details: UserLoginParamDetails(
                        userEmail: emailController.text,
                        userPassword: passwordController.text,
                        kind: "classic"),
                    deviceId: uniqueKey,
                  );
                  PsProgressDialog.showDialog(context);

                  final Resources<CheckDuplicateLogin> checkDuplicateLogin =
                      await widget.userProvider.doCheckDuplicateLogin(
                          userLoginParameterHolder.toMap());

                  if (checkDuplicateLogin != null &&
                      checkDuplicateLogin.data != null &&
                      !checkDuplicateLogin
                          .data.clientDndResponseData.data.success) {
                    login(false, false);
                  } else if (checkDuplicateLogin.status == Status.ERROR) {
                    PsProgressDialog.dismissDialog();
                    setState(() {
                      error = true;
                      errorText = checkDuplicateLogin.message;
                    });
                  } else {
                    PsProgressDialog.dismissDialog();
                    UserProvider.boolIsTokenChanged = true;
                    showBottomLoginError(true);
                  }
                }
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                Dimens.space16.w, Dimens.space60.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            child: RoundedButtonWidget(
              width: double.maxFinite,
              height: Dimens.space54,
              buttonBackgroundColor: CustomColors.transparent,
              buttonTextColor: CustomColors.loadingCircleColor,
              corner: Dimens.space0,
              buttonBorderColor: CustomColors.transparent,
              buttonFontFamily: Config.heeboRegular,
              buttonFontSize: Dimens.space14,
              buttonFontWeight: FontWeight.normal,
              titleTextAlign: TextAlign.center,
              buttonText: Utils.getString('forgotPassword'),
              onPressed: () async {
                // widget.onLoginCancelTap();
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  login(bool isFromBottomSheet, bool isDuplicateLogin) async {
    UserProvider.boolIsTokenChanged = false;
    UserProvider.boolIsTokenChangedLoop = false;
    UserProvider.checkLoop = false;
    // PsProgressDialog.showDialog(context);
    setState(() {
      error = false;
      errorText = "";
    });

    if (await Utils.checkInternetConnectivity()) {
      UserLoginParameterHolder userLoginParameterHolder;
      if (isFromBottomSheet && !isDuplicateLogin) {
        userLoginParameterHolder = UserLoginParameterHolder(
          client: "mobile",
          details: UserLoginParamDetails(
              userEmail: widget.userProvider.getUserEmail(),
              userPassword: widget.userProvider.getUserPassword(),
              kind: "classic"),
          deviceId: uniqueKey,
        );
      } else {
        userLoginParameterHolder = UserLoginParameterHolder(
          client: "mobile",
          details: UserLoginParamDetails(
              userEmail: emailController.text,
              userPassword: passwordController.text,
              kind: "classic"),
          deviceId: uniqueKey,
        );
      }

      //Do user login in the app
      final Resources<User> loginApiStatus = await widget.userProvider
          .doUserLoginApiCall(userLoginParameterHolder.toMap());

      if (loginApiStatus.data != null &&
          loginApiStatus.data.login.data != null) {
        widget.loginWorkspaceProvider.insertWorkspaceListIntoDb(
            loginApiStatus.data.login.data.details.workspaces);

        widget.loginWorkspaceProvider
            .replaceUserPassword(passwordController.text);
        //member login to default workspace
        final Resources<Member> workspaceLoginData =
            await widget.loginWorkspaceProvider.doWorkSpaceLogin(
          WorkSpaceRequestParamHolder(
            authToken: widget.loginWorkspaceProvider.getApiToken(),
            workspaceId: widget.loginWorkspaceProvider.getDefaultWorkspace(),
            memberId: widget.loginWorkspaceProvider.getMemberId(),
          ).toMap(),
        );

        if (workspaceLoginData.data != null) {
          Resources<List<CountryCode>> countryList =
              await widget.countryListProvider.doCountryListApiCall();

          if (countryList.data != null && countryList.data.length != 0) {
            final Resources<Workspace> workspaceDetail = await widget
                .loginWorkspaceProvider
                .doLoginWorkSpaceDetailApiCall();

            if (workspaceDetail != null &&
                workspaceDetail.data != null &&
                workspaceDetail.data.workspace.data.workspaceChannel != null) {
              if (workspaceDetail.data.workspace.data.workspaceChannel.length !=
                  0) {
                widget.countryListProvider.replaceDefaultCountryCode(
                    workspaceDetail
                        .data.workspace.data.workspaceChannel[0].countryCode);
              }
              PsProgressDialog.dismissDialog();
              // widget.onProfileSelected();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  RoutePaths.home, (Route<dynamic> route) => false);
            } else {
              PsProgressDialog.dismissDialog();
              setState(() {
                error = true;
                errorText = workspaceDetail.message;
              });
            }
          } else {
            PsProgressDialog.dismissDialog();
            widget.userProvider.onLogout();
            setState(() {
              error = true;
              errorText = countryList.message;
            });
          }
        } else {
          PsProgressDialog.dismissDialog();
          widget.userProvider.onLogout();
          setState(() {
            error = true;
            errorText = workspaceLoginData.message;
          });
        }
      } else {
        PsProgressDialog.dismissDialog();
        widget.userProvider.onLogout();
        setState(() {
          error = true;
          errorText = loginApiStatus.message;
        });
      }
    } else {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: Utils.getString('noInternet'),
            );
          });
    }
  }
}
