/*
 * *
 *  * Created by Kedar on 7/12/21 12:51 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/12/21 12:51 PM
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/constant/RoutePaths.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/team/TeamProvider.dart';
import 'package:voice_example/repository/TeamsRepository.dart';
import 'package:voice_example/ui/common/CustomTextField.dart';
import 'package:voice_example/ui/common/EmptyViewUiWidget.dart';
import 'package:voice_example/ui/common/base/CustomAppBar.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/viewobject/holder/intent_holder/CreateNewTeamIntentHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/ColorHolder.dart';
import 'package:provider/provider.dart';
import 'TeamVerticalListItem.dart';

class TeamListWidget extends StatefulWidget {
  TeamListWidget({
    Key key,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
  }) : super(key: key);

  final Function onIncomingTap;
  final Function onOutgoingTap;

  @override
  AddTagViewWidgetState createState() => AddTagViewWidgetState();
}

class AddTagViewWidgetState extends State<TeamListWidget>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  TextEditingController controllerSearchTeams = TextEditingController();
  TeamRepository teamRepository;
  TeamProvider teamProvider;
  ColorHolder selectedColor;
  List<String> selectedTags = [];
  String clientId = "";

  @override
  void initState() {
    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    teamRepository = Provider.of<TeamRepository>(context, listen: false);

    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, clientId);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomAppBar<TeamProvider>(
            titleWidget: PreferredSize(
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
                      margin: EdgeInsets.fromLTRB(Dimens.space16.w,
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
                                textAlign: TextAlign.center,
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
                      Utils.getString("teams"),
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
            leadingWidget: null,
            centerTitle: false,
            elevation: 1,
            onIncomingTap: ()
            {
              widget.onIncomingTap();
            },
            onOutgoingTap: ()
            {
              widget.onOutgoingTap();
            },
            initProvider: () {
              return TeamProvider(teamRepository: teamRepository);
            },
            onProviderReady: (TeamProvider provider) async {
              teamProvider = provider;
              teamProvider.doGetTeamsListApiCall();
              controllerSearchTeams.addListener(() {
                if (controllerSearchTeams.text != null &&
                    controllerSearchTeams.text.isNotEmpty) {
                  teamProvider.doDbTeamsSearch(controllerSearchTeams.text);
                } else {
                  teamProvider.doGetTeamsListApiCall();
                }
              });
            },
            builder: (BuildContext context, TeamProvider provider, Widget child) {
              animationController.forward();

              return Container(
                width: ScreenUtil().screenHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space16.w,
                            Dimens.space20.h, Dimens.space16.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: CustomSearchFieldWidgetWithIcon(
                            animationController: animationController,
                            textEditingController: controllerSearchTeams,
                            customIcon: CustomIcon.icon_search,
                            hint: Utils.getString("searchTeams"))),
                    Expanded(
                      flex: 1,
                      child: RefreshIndicator(
                        color: CustomColors.mainColor,
                        backgroundColor: CustomColors.white,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            if (provider.teams != null &&
                                provider.teams.data != null) {
                              if (teamProvider.teams.data.length > 0) {
                                return MediaQuery.removePadding(
                                    context: context,
                                    removeTop: true,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: provider.teams.data.length + 1,
                                      padding: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space20.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        if (index == provider.teams.data.length) {
                                          return Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                  Dimens.space0.w,
                                                  Dimens.space0.h),
                                              child: Column(
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pushNamed(context,
                                                          RoutePaths.addTeams,
                                                          arguments: CreateNewTeamIntentHolder(
                                                              onNewTeamCreated:
                                                              _onNewTeamCreated,
                                                            onIncomingTap: ()
                                                            {
                                                              widget.onIncomingTap();
                                                            },
                                                            onOutgoingTap: ()
                                                            {
                                                              widget.onOutgoingTap();
                                                            },
                                                          ));
                                                    },
                                                    style: TextButton.styleFrom(
                                                      padding:
                                                      EdgeInsets.fromLTRB(
                                                          Dimens.space0.w,
                                                          Dimens.space8.h,
                                                          Dimens.space0.w,
                                                          Dimens.space8.h),
                                                      tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                    ),
                                                    child: Container(
                                                        alignment:
                                                        Alignment.centerLeft,
                                                        margin:
                                                        EdgeInsets.fromLTRB(
                                                            Dimens.space20.w,
                                                            Dimens.space0.h,
                                                            Dimens.space20.w,
                                                            Dimens.space0.h),
                                                        padding:
                                                        EdgeInsets.fromLTRB(
                                                            Dimens.space0.w,
                                                            Dimens.space0.h,
                                                            Dimens.space0.w,
                                                            Dimens.space0.h),
                                                        height: Dimens.space52.h,
                                                        child: Row(
                                                          mainAxisSize:
                                                          MainAxisSize.min,
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                          children: <Widget>[
                                                            Container(
                                                              margin: EdgeInsets
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
                                                              alignment: Alignment
                                                                  .center,
                                                              child: Icon(
                                                                Icons
                                                                    .add_circle_outline,
                                                                color: CustomColors
                                                                    .loadingCircleColor,
                                                                size: Dimens
                                                                    .space20.w,
                                                              ),
                                                            ),
                                                            Expanded(
                                                                child: Container(
                                                                  width:
                                                                  double.infinity,
                                                                  height: Dimens
                                                                      .space50.h,
                                                                  margin: EdgeInsets
                                                                      .fromLTRB(
                                                                      Dimens
                                                                          .space10
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
                                                                  alignment: Alignment
                                                                      .centerLeft,
                                                                  child: Text(
                                                                      '${Utils.getString('createNewTeam')}',
                                                                      overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                      style: Theme.of(
                                                                          context)
                                                                          .textTheme
                                                                          .bodyText1
                                                                          .copyWith(
                                                                        fontFamily:
                                                                        Config
                                                                            .heeboMedium,
                                                                        color: CustomColors
                                                                            .loadingCircleColor,
                                                                        fontSize: Dimens
                                                                            .space16
                                                                            .sp,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                        fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                      )),
                                                                )),
                                                          ],
                                                        )),
                                                  ),
                                                  Divider(
                                                    color: CustomColors
                                                        .mainDividerColor,
                                                    height: Dimens.space1,
                                                    thickness: Dimens.space1,
                                                  ),
                                                ],
                                              ));
                                        } else {
                                          return TeamVerticalListItem(
                                            animationController:
                                            animationController,
                                            animation: Tween<double>(
                                                begin: 0.0, end: 1.0)
                                                .animate(
                                              CurvedAnimation(
                                                parent: animationController,
                                                curve: Interval(
                                                    (1 / 10) * index, 1.0,
                                                    curve: Curves.fastOutSlowIn),
                                              ),
                                            ),
                                            team: provider.teams.data[index],
                                            onPressed: () async {

                                            },
                                            onLongPressed: () {

                                            },
                                          );
                                        }
                                      },
                                      physics: AlwaysScrollableScrollPhysics(),
                                    ));
                              } else {
                                return AnimatedBuilder(
                                    animation: animationController,
                                    builder:
                                        (BuildContext context, Widget child) {
                                      return FadeTransition(
                                        opacity:
                                        Tween<double>(begin: 0.0, end: 1.0)
                                            .animate(CurvedAnimation(
                                            parent: animationController,
                                            curve: const Interval(
                                                0.5 * 1, 1.0,
                                                curve: Curves
                                                    .fastOutSlowIn))),
                                        child: Transform(
                                          transform: Matrix4.translationValues(
                                              0.0,
                                              100 *
                                                  (1.0 -
                                                      Tween<double>(
                                                          begin: 0.0,
                                                          end: 1.0)
                                                          .animate(CurvedAnimation(
                                                          parent:
                                                          animationController,
                                                          curve: const Interval(
                                                              0.5 * 1, 1.0,
                                                              curve: Curves
                                                                  .fastOutSlowIn)))
                                                          .value),
                                              0.0),
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
                                              child: SingleChildScrollView(
                                                child: Center(
                                                  child: AnimatedBuilder(
                                                    animation:
                                                    animationController,
                                                    builder:
                                                        (BuildContext context,
                                                        Widget child) {
                                                      return FadeTransition(
                                                          opacity: animation,
                                                          child: Transform(
                                                            transform: Matrix4
                                                                .translationValues(
                                                                0.0,
                                                                100 *
                                                                    (1.0 -
                                                                        animation
                                                                            .value),
                                                                0.0),
                                                            child: Container(
                                                              color: Colors.white,
                                                              margin: EdgeInsets
                                                                  .fromLTRB(
                                                                  Dimens
                                                                      .space0,
                                                                  Dimens
                                                                      .space0,
                                                                  Dimens
                                                                      .space0,
                                                                  Dimens
                                                                      .space0),
                                                              padding: EdgeInsets
                                                                  .fromLTRB(
                                                                  Dimens
                                                                      .space0,
                                                                  Dimens
                                                                      .space0,
                                                                  Dimens
                                                                      .space0,
                                                                  Dimens
                                                                      .space70
                                                                      .sp),
                                                              child:
                                                              EmptyViewUiWidget(
                                                                assetUrl:
                                                                "assets/images/empty_teams.png",
                                                                title: Utils
                                                                    .getString(
                                                                    'noTeams'),
                                                                desc: Utils.getString(
                                                                    'noTeamsDescription'),
                                                                buttonTitle: Utils
                                                                    .getString(
                                                                    'createNewTeam'),
                                                                icon: Icons
                                                                    .add_circle_outline,
                                                                onPressed: () {
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      RoutePaths
                                                                          .addTeams,
                                                                      arguments: CreateNewTeamIntentHolder(
                                                                          onNewTeamCreated:_onNewTeamCreated,
                                                                        onIncomingTap: ()
                                                                        {
                                                                          widget.onIncomingTap();
                                                                        },
                                                                        onOutgoingTap: ()
                                                                        {
                                                                          widget.onOutgoingTap();
                                                                        },
                                                                      ));
                                                                },
                                                              ),
                                                            ),
                                                          ));
                                                    },
                                                  ),
                                                ),
                                              )),
                                        ),
                                      );
                                    });
                              }
                            } else {
                              return AnimatedBuilder(
                                animation: animationController,
                                builder: (BuildContext context, Widget child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: Transform(
                                      transform: Matrix4.translationValues(0.0,
                                          100 * (1.0 - animation.value), 0.0),
                                      child: Container(
                                        color: Colors.white,
                                        margin: EdgeInsets.fromLTRB(
                                            Dimens.space0,
                                            Dimens.space0,
                                            Dimens.space0,
                                            Dimens.space0),
                                        child: SpinKitCircle(
                                          color: CustomColors.mainColor,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                        onRefresh: () {
                          return teamProvider.doGetTeamsListApiCall();
                        },
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }

  _onNewTeamCreated() async {
    teamProvider.doGetTeamsListApiCall();
    setState(() {

    });
  }
}
