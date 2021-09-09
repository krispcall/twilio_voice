import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/constant/RoutePaths.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/main.dart';
import 'package:voice_example/provider/country/CountryListProvider.dart';
import 'package:voice_example/provider/login_workspace/LoginWorkspaceProvider.dart';
import 'package:voice_example/provider/user/UserProvider.dart';
import 'package:voice_example/repository/CountryListRepository.dart';
import 'package:voice_example/repository/LoginWorkspaceRepository.dart';
import 'package:voice_example/repository/UserRepository.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/ui/common/dialog/WorkSpaceDeleteDialog.dart';
import 'package:voice_example/ui/user/profile/UserProfile.dart';
import 'package:voice_example/ui/workspace/dialog/WorkSpaceDetailsDialog.dart';
import 'package:voice_example/ui/dashboard/DashboardView.dart';
import 'package:voice_example/ui/workspace/WorkspaceListItemView.dart';
import 'package:voice_example/ui/workspace/WorkspaceNumberListItemView.dart';
import 'package:voice_example/ui/workspace/WorkspaceTeamListItemView.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/utils/PsProgressDialog.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/AddWorkSpaceIntentHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/CreateNewTeamIntentHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/VoiceTokenPlatformParamHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/WorkSpaceRequestParamHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/WorkspaceSwitchParameterHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/createDeviceInfo/RegisterFcmParamHolder.dart';
import 'package:voice_example/viewobject/model/login/LoginWorkspace.dart';
import 'package:voice_example/viewobject/model/memberLogin/Member.dart';
import 'package:voice_example/viewobject/model/workspace/restore/RestoreWorkspaceResponse.dart';
import 'package:voice_example/viewobject/model/workspace/workspace_detail/Workspace.dart';
import 'package:voice_example/viewobject/model/workspace/workspace_detail/WorkspaceChannel.dart';
import 'package:voice_example/viewobject/model/workspace_switch/WorkspaceSwitch.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice/twiliovoice.dart';

class ZoomScaffold extends StatefulWidget {
  final Widget contentScreen;
  final AnimationController animationController;
  final Animation animation;

  final Function onIncomingTap;
  final Function onOutgoingTap;

  ZoomScaffold({
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
    this.contentScreen,
    this.animationController,
    this.animation,
  });

  @override
  _ZoomScaffoldState createState() => new _ZoomScaffoldState();
}

class _ZoomScaffoldState extends State<ZoomScaffold>
    with TickerProviderStateMixin {
  Curve scaleDownCurve = Interval(0.0, 0.3, curve: Curves.easeOut);
  Curve scaleUpCurve = Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideOutCurve = Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideInCurve = Interval(0.0, 1.0, curve: Curves.easeOut);

  ValueHolder valueHolder;

  LoginWorkspaceRepository workspaceRepository;
  LoginWorkspaceProvider loginWorkspaceProvider;

  CountryRepository countryRepository;
  CountryListProvider countryListProvider;

  UserRepository userRepository;
  UserProvider userProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    valueHolder = Provider.of<ValueHolder>(context);
    countryRepository = Provider.of<CountryRepository>(context);
    workspaceRepository = Provider.of<LoginWorkspaceRepository>(context);
    userRepository = Provider.of<UserRepository>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CountryListProvider>(
          lazy: false,
          create: (BuildContext context) {
            countryListProvider =
                CountryListProvider(countryListRepository: countryRepository);
            return countryListProvider;
          },
        ),
        ChangeNotifierProvider<LoginWorkspaceProvider>(
          lazy: false,
          create: (BuildContext context) {
            this.loginWorkspaceProvider = LoginWorkspaceProvider(
              loginWorkspaceRepository: workspaceRepository,
              valueHolder: valueHolder,
            );
            return loginWorkspaceProvider;
          },
        ),
        ChangeNotifierProvider<UserProvider>(
          lazy: false,
          create: (BuildContext context) {
            this.userProvider = UserProvider(
              userRepository: userRepository,
              valueHolder: valueHolder,
            );
            return userProvider;
          },
        ),
      ],
      child: Consumer<LoginWorkspaceProvider>(
        builder: (BuildContext context, LoginWorkspaceProvider provider,
            Widget child) {
          if (Provider.of<MenuController>(context, listen: false).state ==
              MenuState.opening) {
            loginWorkspaceProvider.refreshWorkSpaceList();
            // loginWorkspaceProvider.getWorkspaceListFromDb();
            loginWorkspaceProvider.getWorkspaceDetailFromDb();
          }
          return Stack(
            alignment: Alignment.center,
            children: [
              loginWorkspaceProvider.getLoginUserId() != null &&
                      loginWorkspaceProvider.getLoginUserId().isNotEmpty
                  ? Container(
                      child: Scaffold(
                        backgroundColor: CustomColors.mainColor,
                        body: GestureDetector(
                          onPanUpdate: (details) {
                            //on swiping left
                            if (details.delta.dx < -6) {
                              Provider.of<MenuController>(context,
                                      listen: false)
                                  .toggle();
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space40.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Container(
                                  width: Dimens.space80.w,
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      loginWorkspaceProvider.loginWorkspace !=
                                                  null &&
                                              loginWorkspaceProvider
                                                      .loginWorkspace.data !=
                                                  null &&
                                              loginWorkspaceProvider
                                                      .loginWorkspace
                                                      .data
                                                      .length !=
                                                  0
                                          ? Expanded(
                                              child: Container(
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
                                                child: ListView.builder(
                                                  itemCount:
                                                      loginWorkspaceProvider
                                                          .loginWorkspace
                                                          .data
                                                          .length,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return WorkspaceListItemView(
                                                      workspace:
                                                          loginWorkspaceProvider
                                                              .loginWorkspace
                                                              .data[index],
                                                      animationController: widget
                                                          .animationController,
                                                      animation:
                                                          widget.animation,
                                                      index: index,
                                                      count:
                                                          loginWorkspaceProvider
                                                              .loginWorkspace
                                                              .data
                                                              .length,
                                                      defaultWorkspace:
                                                          loginWorkspaceProvider
                                                              .getDefaultWorkspace(),
                                                      onWorkspaceTap: () async {
                                                        if (index != 0 &&
                                                            index ==
                                                                loginWorkspaceProvider
                                                                        .loginWorkspace
                                                                        .data
                                                                        .length -
                                                                    1) {
                                                          // Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CreateNewWorkSpaceView(
                                                          //   onCallBack:(LoginWorkspace
                                                          //   value){
                                                          //     _switchWorkSpace(
                                                          //         value);
                                                          //   }
                                                          //   ,
                                                          // )));

                                                          Navigator.pushNamed(
                                                            context,
                                                            RoutePaths
                                                                .createWorkSpace,
                                                            arguments:
                                                                AddWorkSpaceIntentHolder(
                                                              onAddWorkSpaceCallBack:
                                                                  (LoginWorkspace
                                                                      value) {
                                                                _switchWorkSpace(
                                                                    value);
                                                              },
                                                              onIncomingTap:
                                                                  () {
                                                                widget
                                                                    .onIncomingTap();
                                                              },
                                                              onOutgoingTap:
                                                                  () {
                                                                widget
                                                                    .onOutgoingTap();
                                                              },
                                                            ),
                                                          );
                                                        } else {
                                                          if (loginWorkspaceProvider
                                                                      .loginWorkspace
                                                                      .data[
                                                                          index]
                                                                      .status !=
                                                                  null &&
                                                              loginWorkspaceProvider
                                                                      .loginWorkspace
                                                                      .data[
                                                                          index]
                                                                      .status ==
                                                                  "Active") {
                                                            _switchWorkSpace(
                                                                loginWorkspaceProvider
                                                                    .loginWorkspace
                                                                    .data[index]);
                                                          } else {
                                                            await showModalBottomSheet(
                                                              context: context,
                                                              elevation: 0,
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              builder: (dialogContext) =>
                                                                  Container(
                                                                      height: ScreenUtil()
                                                                              .screenHeight *
                                                                          0.45,
                                                                      child:
                                                                          WorkspaceDeleteDialog(
                                                                        onRestoreTap:
                                                                            () {
                                                                          Navigator.pop(
                                                                              dialogContext);
                                                                          _onRestoreTap(loginWorkspaceProvider
                                                                              .loginWorkspace
                                                                              .data[index]);
                                                                        },
                                                                        planOverviewData: loginWorkspaceProvider
                                                                            .loginWorkspace
                                                                            .data[index]
                                                                            .plan,
                                                                      )),
                                                            );
                                                          }
                                                        }
                                                      },
                                                    );
                                                  },
                                                  physics:
                                                      AlwaysScrollableScrollPhysics(),
                                                  padding: EdgeInsets.fromLTRB(
                                                      Dimens.space0.w,
                                                      Dimens.space0.h,
                                                      Dimens.space0.w,
                                                      Dimens.space0.h),
                                                ),
                                              ),
                                            )
                                          : Expanded(child: Container()),
                                      TextButton(
                                        onPressed: () {
                                          showProfileWidget();
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space14.h,
                                              Dimens.space0.w,
                                              Dimens.space16.h),
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.fromLTRB(
                                                    Dimens.space0.w,
                                                    Dimens.space0.h,
                                                    Dimens.space0.w,
                                                    Dimens.space2.h),
                                                padding: EdgeInsets.fromLTRB(
                                                    Dimens.space0.w,
                                                    Dimens.space0.h,
                                                    Dimens.space0.w,
                                                    Dimens.space0.h),
                                                child:
                                                    RoundedNetworkImageHolder(
                                                  width: Dimens.space48,
                                                  height: Dimens.space48,
                                                  boxFit: BoxFit.cover,
                                                  iconUrl:
                                                      CustomIcon.icon_profile,
                                                  iconColor: CustomColors
                                                      .callInactiveColor,
                                                  iconSize: Dimens.space41,
                                                  boxDecorationColor:
                                                      CustomColors
                                                          .mainDividerColor,
                                                  outerCorner: Dimens.space16,
                                                  innerCorner: Dimens.space16,
                                                  containerAlignment:
                                                      Alignment.bottomCenter,
                                                  imageUrl: loginWorkspaceProvider
                                                      .getUserProfilePicture(),
                                                ),
                                              ),
                                              Positioned(
                                                right: Dimens.space14.w,
                                                bottom: Dimens.space0.w,
                                                child: Container(
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
                                                  child:
                                                      RoundedNetworkImageHolder(
                                                    width: Dimens.space15,
                                                    height: Dimens.space15,
                                                    boxFit: BoxFit.cover,
                                                    iconUrl: Icons.circle,
                                                    iconColor: CustomColors
                                                        .callAcceptColor,
                                                    iconSize: Dimens.space12,
                                                    boxDecorationColor:
                                                        CustomColors.mainColor,
                                                    outerCorner:
                                                        Dimens.space300,
                                                    innerCorner:
                                                        Dimens.space300,
                                                    imageUrl: "",
                                                    onTap: () {
                                                      showProfileWidget();
                                                    },
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
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.topCenter,
                                    margin: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space10.h,
                                        Dimens.space32.w,
                                        Dimens.space0.h),
                                    padding: EdgeInsets.fromLTRB(
                                        Dimens.space18.w,
                                        Dimens.space24.h,
                                        Dimens.space18.w,
                                        Dimens.space24.h),
                                    decoration: BoxDecoration(
                                      color: CustomColors.baseLightColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft:
                                            Radius.circular(Dimens.space16.r),
                                        topRight:
                                            Radius.circular(Dimens.space16.r),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        GestureDetector(
                                            onTap: () {
                                              _showButtonSheetWidget(
                                                  callBack: () {
                                                loginWorkspaceProvider
                                                    .refreshWorkSpaceList();
                                              });
                                            },
                                            child: Container(
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
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      constraints: BoxConstraints(
                                                          maxWidth: ScreenUtil()
                                                                  .screenWidth *
                                                              0.5),
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              Dimens.space0.w,
                                                              Dimens.space0.h,
                                                              Dimens.space0.w,
                                                              Dimens.space0.h),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              Dimens.space0.w,
                                                              Dimens.space0.h,
                                                              Dimens.space0.w,
                                                              Dimens.space0.h),
                                                      child: Text(
                                                        loginWorkspaceProvider
                                                                        .loginWorkspaceDetail !=
                                                                    null &&
                                                                loginWorkspaceProvider
                                                                        .loginWorkspaceDetail
                                                                        .data !=
                                                                    null &&
                                                                loginWorkspaceProvider
                                                                        .loginWorkspaceDetail
                                                                        .data
                                                                        .workspace
                                                                        .data
                                                                        .title !=
                                                                    null
                                                            ? loginWorkspaceProvider
                                                                .loginWorkspaceDetail
                                                                .data
                                                                .workspace
                                                                .data
                                                                .title
                                                            : Utils.getString(
                                                                "appName"),
                                                        maxLines: 1,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline5
                                                            .copyWith(
                                                                color: CustomColors
                                                                    .textPrimaryColor,
                                                                fontFamily: Config
                                                                    .manropeExtraBold,
                                                                fontSize: Dimens
                                                                    .space18.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal),
                                                      ),
                                                    ),
                                                    Container(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        margin: EdgeInsets
                                                            .fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        padding: EdgeInsets.fromLTRB(
                                                            Dimens.space0.w,
                                                            Dimens.space0.h,
                                                            Dimens.space0.w,
                                                            Dimens.space0.h),
                                                        child:
                                                            RoundedNetworkImageHolder(
                                                                width: Dimens
                                                                    .space18,
                                                                height: Dimens
                                                                    .space18,
                                                                boxFit: BoxFit
                                                                    .cover,
                                                                iconUrl: CustomIcon
                                                                    .icon_more,
                                                                iconColor:
                                                                    CustomColors
                                                                        .textQuaternaryColor,
                                                                iconSize: Dimens
                                                                    .space18,
                                                                boxDecorationColor:
                                                                    CustomColors
                                                                        .transparent,
                                                                outerCorner:
                                                                    Dimens
                                                                        .space0,
                                                                innerCorner:
                                                                    Dimens
                                                                        .space0,
                                                                imageUrl: "",
                                                                onTap: () {
                                                                  _showButtonSheetWidget(
                                                                      callBack:
                                                                          () {
                                                                    loginWorkspaceProvider
                                                                        .refreshWorkSpaceList();
                                                                  });
                                                                })),
                                                  ],
                                                ))),
                                        Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.fromLTRB(
                                                Dimens.space0.w,
                                                Dimens.space21.h,
                                                Dimens.space0.w,
                                                Dimens.space0.h),
                                            padding: EdgeInsets.fromLTRB(
                                                Dimens.space0.w,
                                                Dimens.space0.h,
                                                Dimens.space0.w,
                                                Dimens.space0.h),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
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
                                                  child:
                                                      RoundedNetworkImageHolder(
                                                    width: Dimens.space14,
                                                    height: Dimens.space14,
                                                    boxFit: BoxFit.fitWidth,
                                                    iconUrl: CustomIcon
                                                        .icon_arrow_down,
                                                    iconColor: CustomColors
                                                        .textTertiaryColor,
                                                    iconSize: Dimens.space12,
                                                    boxDecorationColor:
                                                        CustomColors
                                                            .transparent,
                                                    outerCorner: Dimens.space0,
                                                    innerCorner: Dimens.space0,
                                                    imageUrl: "",
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    margin: EdgeInsets.fromLTRB(
                                                        Dimens.space0.w,
                                                        Dimens.space0.h,
                                                        Dimens.space0.w,
                                                        Dimens.space0.h),
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            Dimens.space0.w,
                                                            Dimens.space0.h,
                                                            Dimens.space0.w,
                                                            Dimens.space0.h),
                                                    child: Text(
                                                      Utils.getString("numbers")
                                                          .toUpperCase(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline5
                                                          .copyWith(
                                                              color: CustomColors
                                                                  .textTertiaryColor,
                                                              fontFamily: Config
                                                                  .manropeSemiBold,
                                                              fontSize: Dimens
                                                                  .space14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal),
                                                    ),
                                                  ),
                                                ),
                                                Container(
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
                                                  child: Material(
                                                      color: Colors.transparent,
                                                      child: Container(
                                                          width: Dimens.space30,
                                                          height:
                                                              Dimens.space30,
                                                          child: InkWell(
                                                            child:
                                                                RoundedNetworkImageHolder(
                                                              width: Dimens
                                                                  .space14,
                                                              height: Dimens
                                                                  .space14,
                                                              boxFit: BoxFit
                                                                  .fitWidth,
                                                              iconUrl: CustomIcon
                                                                  .icon_plus,
                                                              iconColor:
                                                                  CustomColors
                                                                      .textTertiaryColor,
                                                              iconSize: Dimens
                                                                  .space12,
                                                              boxDecorationColor:
                                                                  CustomColors
                                                                      .transparent,
                                                              outerCorner:
                                                                  Dimens.space0,
                                                              innerCorner:
                                                                  Dimens.space0,
                                                              imageUrl: "",
                                                            ),
                                                            onTap: () {},
                                                          ))),
                                                )
                                              ],
                                            )),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              loginWorkspaceProvider
                                                              .loginWorkspaceDetail !=
                                                          null &&
                                                      loginWorkspaceProvider
                                                              .loginWorkspaceDetail.data !=
                                                          null &&
                                                      loginWorkspaceProvider
                                                              .loginWorkspaceDetail
                                                              .data
                                                              .workspace
                                                              .data
                                                              .workspaceChannel !=
                                                          null &&
                                                      loginWorkspaceProvider
                                                              .loginWorkspaceDetail
                                                              .data
                                                              .workspace
                                                              .data
                                                              .workspaceChannel
                                                              .length !=
                                                          0
                                                  ? Expanded(
                                                      child: Container(
                                                        alignment:
                                                            Alignment.topCenter,
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space15.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        child: ListView.builder(
                                                          itemCount: loginWorkspaceProvider
                                                              .loginWorkspaceDetail
                                                              .data
                                                              .workspace
                                                              .data
                                                              .workspaceChannel
                                                              .length,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            WorkspaceChannel
                                                                workspaceChannel =
                                                                loginWorkspaceProvider
                                                                    .getDefaultChannel();
                                                            if (workspaceChannel !=
                                                                null) {
                                                              return WorkspaceNumberListItemView(
                                                                workspaceChannel:
                                                                    loginWorkspaceProvider
                                                                        .loginWorkspaceDetail
                                                                        .data
                                                                        .workspace
                                                                        .data
                                                                        .workspaceChannel[index],
                                                                animationController:
                                                                    widget
                                                                        .animationController,
                                                                animation: widget
                                                                    .animation,
                                                                selectedChannel:
                                                                    workspaceChannel,
                                                                count: loginWorkspaceProvider
                                                                    .loginWorkspaceDetail
                                                                    .data
                                                                    .workspace
                                                                    .data
                                                                    .workspaceChannel
                                                                    .length,
                                                                onChannelTap:
                                                                    () {
                                                                  loginWorkspaceProvider.replaceDefaultChannel(json.encode(loginWorkspaceProvider
                                                                      .loginWorkspaceDetail
                                                                      .data
                                                                      .workspace
                                                                      .data
                                                                      .workspaceChannel[
                                                                          index]
                                                                      .toJson()));
                                                                  DashboardView.ebTransferData.fire(json.encode(loginWorkspaceProvider
                                                                      .loginWorkspaceDetail
                                                                      .data
                                                                      .workspace
                                                                      .data
                                                                      .workspaceChannel[
                                                                          index]
                                                                      .toJson()));
                                                                  Provider.of<MenuController>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .toggle();
                                                                },
                                                              );
                                                            } else {
                                                              return Container();
                                                            }
                                                          },
                                                          physics:
                                                              AlwaysScrollableScrollPhysics(),
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  Dimens
                                                                      .space0.w,
                                                                  Dimens
                                                                      .space0.h,
                                                                  Dimens
                                                                      .space0.w,
                                                                  Dimens.space0
                                                                      .h),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      alignment:
                                                          Alignment.center,
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              Dimens.space0.w,
                                                              Dimens.space17.h,
                                                              Dimens.space0.w,
                                                              Dimens.space0.h),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              Dimens.space0.w,
                                                              Dimens.space0.h,
                                                              Dimens.space0.w,
                                                              Dimens.space0.h),
                                                      decoration: BoxDecoration(
                                                          color: CustomColors
                                                              .mainDividerColor,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      Dimens
                                                                          .space8
                                                                          .r))),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Container(
                                                            alignment: Alignment
                                                                .center,
                                                            margin: EdgeInsets
                                                                .fromLTRB(
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space24
                                                                        .h,
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space14
                                                                        .h),
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h,
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h),
                                                            child: Icon(
                                                              CustomIcon
                                                                  .icon_empty_number,
                                                              size: Dimens
                                                                  .space48.w,
                                                              color: CustomColors
                                                                  .textQuaternaryColor,
                                                            ),
                                                          ),
                                                          Container(
                                                            alignment: Alignment
                                                                .center,
                                                            margin: EdgeInsets
                                                                .fromLTRB(
                                                                    Dimens
                                                                        .space20
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h,
                                                                    Dimens
                                                                        .space20
                                                                        .w,
                                                                    Dimens
                                                                        .space25
                                                                        .h),
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h,
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h),
                                                            child: RichText(
                                                              maxLines: 2,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              text: TextSpan(
                                                                  text: Utils
                                                                      .getString(
                                                                          "youHaveNotBeenAssigned"),
                                                                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                                                                      color: CustomColors
                                                                          .textTertiaryColor,
                                                                      fontFamily:
                                                                          Config
                                                                              .heeboRegular,
                                                                      fontSize:
                                                                          Dimens
                                                                              .space14
                                                                              .sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .normal),
                                                                  children: <
                                                                      TextSpan>[
                                                                    TextSpan(
                                                                      text: Utils
                                                                          .getString(
                                                                              "purchaseNumber"),
                                                                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                                                                          color: CustomColors
                                                                              .loadingCircleColor,
                                                                          fontFamily: Config
                                                                              .heeboRegular,
                                                                          fontSize: Dimens
                                                                              .space14
                                                                              .sp,
                                                                          fontWeight: FontWeight
                                                                              .normal,
                                                                          fontStyle:
                                                                              FontStyle.normal),
                                                                    )
                                                                  ]),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                              Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.fromLTRB(
                                                    Dimens.space0.w,
                                                    Dimens.space21.h,
                                                    Dimens.space0.w,
                                                    Dimens.space0.h),
                                                padding: EdgeInsets.fromLTRB(
                                                    Dimens.space0.w,
                                                    Dimens.space0.h,
                                                    Dimens.space0.w,
                                                    Dimens.space0.h),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              Dimens.space0.w,
                                                              Dimens.space0.h,
                                                              Dimens.space0.w,
                                                              Dimens.space0.h),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              Dimens.space0.w,
                                                              Dimens.space0.h,
                                                              Dimens.space0.w,
                                                              Dimens.space0.h),
                                                      child:
                                                          RoundedNetworkImageHolder(
                                                        width: Dimens.space14,
                                                        height: Dimens.space14,
                                                        boxFit: BoxFit.fitWidth,
                                                        iconUrl: CustomIcon
                                                            .icon_arrow_down,
                                                        iconColor: CustomColors
                                                            .textTertiaryColor,
                                                        iconSize:
                                                            Dimens.space12,
                                                        boxDecorationColor:
                                                            CustomColors
                                                                .transparent,
                                                        outerCorner:
                                                            Dimens.space0,
                                                        innerCorner:
                                                            Dimens.space0,
                                                        imageUrl: "",
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        child: Text(
                                                          Utils.getString(
                                                                  "teamMembers")
                                                              .toUpperCase(),
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headline5
                                                              .copyWith(
                                                                  color: CustomColors
                                                                      .textTertiaryColor,
                                                                  fontFamily:
                                                                      Config
                                                                          .manropeSemiBold,
                                                                  fontSize:
                                                                      Dimens
                                                                          .space14
                                                                          .sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              Dimens.space0.w,
                                                              Dimens.space0.h,
                                                              Dimens.space0.w,
                                                              Dimens.space0.h),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              Dimens.space0.w,
                                                              Dimens.space0.h,
                                                              Dimens.space0.w,
                                                              Dimens.space0.h),
                                                      child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: Container(
                                                          width: Dimens.space30,
                                                          height:
                                                              Dimens.space30,
                                                          child: InkWell(
                                                            child:
                                                                RoundedNetworkImageHolder(
                                                              width: Dimens
                                                                  .space14,
                                                              height: Dimens
                                                                  .space14,
                                                              boxFit: BoxFit
                                                                  .fitWidth,
                                                              iconUrl: CustomIcon
                                                                  .icon_plus,
                                                              iconColor:
                                                                  CustomColors
                                                                      .textTertiaryColor,
                                                              iconSize: Dimens
                                                                  .space12,
                                                              boxDecorationColor:
                                                                  CustomColors
                                                                      .transparent,
                                                              outerCorner:
                                                                  Dimens.space0,
                                                              innerCorner:
                                                                  Dimens.space0,
                                                              imageUrl: "",
                                                            ),
                                                            onTap: () {
                                                              Navigator
                                                                  .pushNamed(
                                                                context,
                                                                RoutePaths
                                                                    .addTeams,
                                                                arguments:
                                                                    CreateNewTeamIntentHolder(
                                                                  onNewTeamCreated:
                                                                      () {
                                                                    loginWorkspaceProvider
                                                                        .doLoginWorkSpaceDetailApiCall();
                                                                  },
                                                                  onIncomingTap:
                                                                      () {
                                                                    widget
                                                                        .onIncomingTap();
                                                                  },
                                                                  onOutgoingTap:
                                                                      () {
                                                                    widget
                                                                        .onOutgoingTap();
                                                                  },
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              loginWorkspaceProvider
                                                              .loginWorkspaceDetail !=
                                                          null &&
                                                      loginWorkspaceProvider
                                                              .loginWorkspaceDetail.data !=
                                                          null &&
                                                      loginWorkspaceProvider
                                                              .loginWorkspaceDetail
                                                              .data
                                                              .workspace
                                                              .data
                                                              .workspaceTeam !=
                                                          null &&
                                                      loginWorkspaceProvider
                                                              .loginWorkspaceDetail
                                                              .data
                                                              .workspace
                                                              .data
                                                              .workspaceTeam
                                                              .length !=
                                                          0
                                                  ? Expanded(
                                                      child: Container(
                                                        alignment:
                                                            Alignment.topCenter,
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space17.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        child: ListView.builder(
                                                          itemCount:
                                                              loginWorkspaceProvider
                                                                  .loginWorkspaceDetail
                                                                  .data
                                                                  .workspace
                                                                  .data
                                                                  .workspaceTeam
                                                                  .length,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          shrinkWrap: true,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            return WorkspaceTeamListItemView(
                                                              workspaceTeam:
                                                                  loginWorkspaceProvider
                                                                      .loginWorkspaceDetail
                                                                      .data
                                                                      .workspace
                                                                      .data
                                                                      .workspaceTeam[index],
                                                              animationController:
                                                                  widget
                                                                      .animationController,
                                                              animation: widget
                                                                  .animation,
                                                              index: index,
                                                              selectedIndex: 0,
                                                              count: loginWorkspaceProvider
                                                                  .loginWorkspaceDetail
                                                                  .data
                                                                  .workspace
                                                                  .data
                                                                  .workspaceChannel
                                                                  .length,
                                                            );
                                                          },
                                                          physics:
                                                              AlwaysScrollableScrollPhysics(),
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  Dimens
                                                                      .space0.w,
                                                                  Dimens
                                                                      .space0.h,
                                                                  Dimens
                                                                      .space0.w,
                                                                  Dimens.space0
                                                                      .h),
                                                        ),
                                                      ),
                                                    )
                                                  : Expanded(
                                                      child:
                                                          SingleChildScrollView(
                                                              child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Container(
                                                            alignment: Alignment
                                                                .center,
                                                            margin: EdgeInsets
                                                                .fromLTRB(
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space17
                                                                        .h,
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h),
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h,
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h),
                                                            decoration: BoxDecoration(
                                                                color: CustomColors
                                                                    .mainDividerColor,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(Dimens
                                                                            .space8
                                                                            .r))),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  margin: EdgeInsets.fromLTRB(
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space24
                                                                          .h,
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space14
                                                                          .h),
                                                                  padding: EdgeInsets.fromLTRB(
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h,
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h),
                                                                  child: Icon(
                                                                    CustomIcon
                                                                        .icon_empty_team,
                                                                    size: Dimens
                                                                        .space48
                                                                        .w,
                                                                    color: CustomColors
                                                                        .textQuaternaryColor,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  margin: EdgeInsets.fromLTRB(
                                                                      Dimens
                                                                          .space20
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h,
                                                                      Dimens
                                                                          .space20
                                                                          .w,
                                                                      Dimens
                                                                          .space25
                                                                          .h),
                                                                  padding: EdgeInsets.fromLTRB(
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h,
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h),
                                                                  child: TextButton(
                                                                      onPressed: () {
                                                                        Navigator
                                                                            .pushNamed(
                                                                          context,
                                                                          RoutePaths
                                                                              .addTeams,
                                                                          arguments:
                                                                              CreateNewTeamIntentHolder(
                                                                            onNewTeamCreated:
                                                                                () {
                                                                              loginWorkspaceProvider.doLoginWorkSpaceDetailApiCall();
                                                                            },
                                                                            onIncomingTap:
                                                                                () {
                                                                              widget.onIncomingTap();
                                                                            },
                                                                            onOutgoingTap:
                                                                                () {
                                                                              widget.onOutgoingTap();
                                                                            },
                                                                          ),
                                                                        );
                                                                      },
                                                                      style: TextButton.styleFrom(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            Dimens.space0.w,
                                                                            Dimens.space0.h,
                                                                            Dimens.space0.w,
                                                                            Dimens.space0.h),
                                                                        tapTargetSize:
                                                                            MaterialTapTargetSize.shrinkWrap,
                                                                        backgroundColor:
                                                                            CustomColors.transparent,
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                      ),
                                                                      child: RichText(
                                                                        maxLines:
                                                                            2,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        text: TextSpan(
                                                                            text: Utils.getString(
                                                                                "noTeams"),
                                                                            style: Theme.of(context).textTheme.bodyText1.copyWith(
                                                                                color: CustomColors.textTertiaryColor,
                                                                                fontFamily: Config.heeboRegular,
                                                                                fontSize: Dimens.space14.sp,
                                                                                fontWeight: FontWeight.normal,
                                                                                fontStyle: FontStyle.normal),
                                                                            children: <TextSpan>[
                                                                              TextSpan(
                                                                                text: Utils.getString("createThem"),
                                                                                style: Theme.of(context).textTheme.bodyText1.copyWith(color: CustomColors.loadingCircleColor, fontFamily: Config.heeboRegular, fontSize: Dimens.space14.sp, fontWeight: FontWeight.normal, fontStyle: FontStyle.normal),
                                                                              )
                                                                            ]),
                                                                      )),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      color: CustomColors.white,
                    ),
              createContentDisplay(),
            ],
          );
        },
      ),
    );
  }

  createContentDisplay() {
    return zoomAndSlideContent(Container(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: widget.contentScreen,
      ),
    ));
  }

  zoomAndSlideContent(Widget content) {
    var slidePercent, scalePercent;

    switch (Provider.of<MenuController>(context, listen: false).state) {
      case MenuState.closed:
        slidePercent = 0.0;
        scalePercent = 0.0;
        break;
      case MenuState.open:
        slidePercent = 1.0;
        scalePercent = 1.0;
        break;
      case MenuState.opening:
        slidePercent = slideOutCurve.transform(
            Provider.of<MenuController>(context, listen: false).percentOpen);
        scalePercent = scaleDownCurve.transform(
            Provider.of<MenuController>(context, listen: false).percentOpen);
        break;
      case MenuState.closing:
        slidePercent = slideInCurve.transform(
            Provider.of<MenuController>(context, listen: false).percentOpen);
        scalePercent = scaleUpCurve.transform(
            Provider.of<MenuController>(context, listen: false).percentOpen);
        break;
    }

    final slideAmount = (MediaQuery.of(context).size.width - 20) * slidePercent;
    final contentScale = 1.0 - (0.1 * scalePercent);
    final cornerRadius =
        16.0 * Provider.of<MenuController>(context, listen: false).percentOpen;

    return Transform(
      transform: Matrix4.translationValues(slideAmount, 0.0, 0.0)
        ..scale(contentScale, contentScale),
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: const Offset(0.0, 5.0),
              blurRadius: 15.0,
              spreadRadius: 10.0,
            ),
          ],
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(cornerRadius), child: content),
      ),
    );
  }

  _showButtonSheetWidget({callBack}) async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.space16.r),
        ),
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.9,
            maxChildSize: 1.0,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  color: Colors.transparent,
                  height: ScreenUtil().screenHeight,
                  child: WorkSpaceDetailsDialog(
                    onCallback: callBack,
                    onIncomingTap: () {
                      widget.onIncomingTap();
                    },
                    onOutgoingTap: () {
                      widget.onOutgoingTap();
                    },
                  ),
                ),
              );
            },
          );
        });
  }

  showProfileWidget() async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.space16.r),
        ),
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            height: ScreenUtil().screenHeight * 0.9,
            child: UserProfile(
                animationController: widget.animationController,
                onLogOut: () {
                  userProvider.onLogout(isTokenError: false);
                }),
          );
        });
  }

  void _switchWorkSpace(LoginWorkspace loginWorkspace) async {
    bool connectivity = await Utils.checkInternetConnectivity();
    if (connectivity) {
      PsProgressDialog.showDialog(context);

      Resources<WorkspaceSwitch> workspaceSwitch = await loginWorkspaceProvider
          .doChangeWorkspaceApiCall(WorkspaceSwitchParameterHolder(
                  defaultWorkspace: loginWorkspace.id)
              .toMap());

      if (workspaceSwitch.data != null &&
          workspaceSwitch.data.workspaceSwitch.data != null) {
        final Resources<Member> workspaceLoginData =
            await loginWorkspaceProvider.doWorkSpaceLogin(
          WorkSpaceRequestParamHolder(
            authToken: loginWorkspaceProvider.getApiToken(),
            workspaceId: loginWorkspace.id,
            memberId: loginWorkspace.memberId,
          ).toMap(),
        );

        if (workspaceLoginData.data != null &&
            workspaceLoginData.data.data.data != null) {
          final Resources<Workspace> workspaceDetail =
              await loginWorkspaceProvider.doLoginWorkSpaceDetailApiCall();

          if (workspaceDetail != null &&
              workspaceDetail.data != null &&
              workspaceDetail.data.workspace.data != null) {
            if (workspaceDetail != null && workspaceDetail.data != null) {
              loginWorkspaceProvider.replaceDefaultWorkspace(
                  workspaceSwitch.data.workspaceSwitch.data.defaultWorkspace);
              loginWorkspaceProvider.refreshWorkSpaceList();
              if (workspaceDetail.data.workspace != null &&
                  workspaceDetail.data.workspace.data.workspaceChannel.length !=
                      0) {
                loginWorkspaceProvider.replaceDefaultChannel(json.encode(
                    workspaceDetail.data.workspace.data.workspaceChannel[0]
                        .toJson()));
                DashboardView.ebTransferData.fire(json.encode(workspaceDetail
                    .data.workspace.data.workspaceChannel[0]
                    .toJson()));
                countryListProvider.replaceDefaultCountryCode(workspaceDetail
                    .data.workspace.data.workspaceChannel[0].countryCode);
              } else {
                loginWorkspaceProvider.replaceDefaultChannel(null);
                DashboardView.ebTransferData.fire(null);
                countryListProvider.replaceDefaultCountryCode("+61");
              }
              VoiceTokenPlatformParamHolder voiceTokenPlatformParamHolder =
                  VoiceTokenPlatformParamHolder(
                      platform: Platform.isIOS ? "IPHONE" : "ANDROID");
              Resources<String> voiceToken = await loginWorkspaceProvider
                  .doVoiceTokenApiCall(voiceTokenPlatformParamHolder.toMap());
              if (voiceToken != null && voiceToken.data != null) {
                if (voiceClient == null) {
                  voiceClient = VoiceClient(voiceToken.data);
                }

                voiceClient
                    .registerForNotification(
                        voiceToken.data,
                        Platform.isIOS
                            ? await FirebaseMessaging.instance.getAPNSToken()
                            : await FirebaseMessaging.instance.getToken())
                    .then((value) async {
                  if (value) {
                    loginWorkspaceProvider.replaceVoiceToken(voiceToken.data);
                    PsProgressDialog.dismissDialog();
                  } else {
                    loginWorkspaceProvider.replaceVoiceToken("");
                    PsProgressDialog.dismissDialog();
                  }
                });
              } else {
                PsProgressDialog.dismissDialog();
              }
              RegisterFcmParamHolder registerFcmParamHolder =
                  RegisterFcmParamHolder(
                      fcmRegistrationId:
                          await FirebaseMessaging.instance.getToken(),
                      version: Config.appVersion,
                      platform: Platform.isIOS
                          ? Utils.getString("ios")
                          : Utils.getString("android"));
              loginWorkspaceProvider
                  .doDeviceRegisterApiCall(registerFcmParamHolder.toMap());
            } else {
              PsProgressDialog.dismissDialog();
            }
          } else {
            PsProgressDialog.dismissDialog();
          }
        }
      }
    } else {
      Utils.showToastMessage(Utils.getString("noInternet"));
    }
  }

  void _onRestoreTap(LoginWorkspace data) async {
    bool connectivity = await Utils.checkInternetConnectivity();
    if (connectivity) {
      PsProgressDialog.showDialog(context);
      Resources<RestoreWorkspaceResponse> response =
          await loginWorkspaceProvider.doRestoreWorkSpaceApiCall(data.id);
      if (response.data != null && response.data.data != null) {
        PsProgressDialog.dismissDialog();
        loginWorkspaceProvider.refreshWorkSpaceList();
      } else {
        PsProgressDialog.dismissDialog();
        Utils.showToastMessage(response.message);
      }
    } else {
      Utils.showToastMessage(Utils.getString("noInternet"));
    }
  }
}

class Layout {
  final WidgetBuilder contentBuilder;

  Layout({
    this.contentBuilder,
  });
}

class MenuController extends ChangeNotifier {
  final TickerProvider vSync;
  final AnimationController _animationController;
  MenuState state = MenuState.closed;

  MenuController({
    @required this.vSync,
  }) : _animationController = new AnimationController(vsync: vSync) {
    _animationController
      ..duration = const Duration(milliseconds: 250)
      ..addListener(() {
        notifyListeners();
      })
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            state = MenuState.opening;
            break;
          case AnimationStatus.reverse:
            state = MenuState.closing;
            break;
          case AnimationStatus.completed:
            state = MenuState.open;
            break;
          case AnimationStatus.dismissed:
            state = MenuState.closed;
            break;
        }
        notifyListeners();
      });
  }

  @override
  dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  get percentOpen {
    return _animationController.value;
  }

  open() {
    _animationController.forward();
  }

  close() {
    _animationController.reverse();
  }

  toggle() {
    if (state == MenuState.open) {
      close();
    } else if (state == MenuState.closed) {
      open();
    }
  }
}

enum MenuState {
  closed,
  opening,
  open,
  closing,
}
