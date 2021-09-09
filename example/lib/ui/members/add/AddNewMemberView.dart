/*
 * *
 *  * Created by Kedar on 8/11/21 8:34 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 8/11/21 7:58 AM
 *
 */


import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/memberProvider/MemberProvider.dart';
import 'package:voice_example/repository/MemberRepository.dart';
import 'package:voice_example/ui/common/ButtonWidget.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/ui/common/base/CustomAppBar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/ui/members/add/AddMemberItemWidget.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:provider/provider.dart';

/*
 * *
 *  * Created by Kedar on 8/10/21 7:41 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 8/10/21 7:41 AM
 *
 */
class AddNewMemberView extends StatefulWidget {
  final Function onAddToTeamTap;

  AddNewMemberView({
    Key key,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
    this.onAddToTeamTap
  }) : super(key: key);

  final Function onIncomingTap;
  final Function onOutgoingTap;

  @override
  _AddNewMemberViewState createState() {
    return _AddNewMemberViewState();
  }
}

class _AddNewMemberViewState extends State<AddNewMemberView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  MemberProvider memberProvider;
  MemberRepository memberRepository;
  Map<String, String> selectedMember = new Map();

  @override
  void initState() {
    super.initState();
    this.animationController = new AnimationController(
        vsync: this, duration: Config.animation_duration);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    memberRepository = Provider.of<MemberRepository>(context, listen: false);

    // TODO: implement build
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

    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: CustomColors.white,
            automaticallyImplyLeading: false,
            toolbarHeight: Dimens.space30,
            elevation: 0.0,
            title: Container(),
          ),
          body: SafeArea(
            child: CustomAppBar<MemberProvider>(
                titleWidget: PreferredSize(
                  preferredSize:
                  Size(MediaQuery.of(context).size.width.w, kToolbarHeight.h),
                  child: Container(),
                ),
                leadingWidget: null,
                onIncomingTap: ()
                {
                  widget.onIncomingTap();
                },
                onOutgoingTap: ()
                {
                  widget.onOutgoingTap();
                },
                actions: [
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                        Dimens.space16.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                        Dimens.space0.w, Dimens.space0.h),
                    child: TextButton(
                      onPressed: () async {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: CustomColors.transparent,
                        alignment: Alignment.centerRight,
                      ),
                      child: Text(
                        Utils.getString('skip'),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: CustomColors.loadingCircleColor,
                          fontFamily: Config.manropeBold,
                          fontSize: Dimens.space15.sp,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  )
                ],
                centerTitle: false,
                elevation: 0.0,
                initProvider: () {
                  return MemberProvider(memberRepository: memberRepository);
                },
                onProviderReady: (MemberProvider provider) async {
                  memberProvider = provider;
                  memberProvider.doGetAllWorkspaceMembersApiCall();
                },
                builder:
                    (BuildContext context, MemberProvider provider, Widget child) {
                  animationController.forward();
                  return AnimatedBuilder(
                      animation: animationController,
                      builder: (BuildContext context, Widget child) {
                        return FadeTransition(
                          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                  parent: animationController,
                                  curve: const Interval(0.5 * 1, 1.0,
                                      curve: Curves.fastOutSlowIn))),
                          child: Transform(
                            transform: Matrix4.translationValues(
                                0.0,
                                100 *
                                    (1.0 -
                                        Tween<double>(begin: 0.0, end: 1.0)
                                            .animate(CurvedAnimation(
                                            parent: animationController,
                                            curve: const Interval(0.5 * 1, 1.0,
                                                curve: Curves.fastOutSlowIn)))
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
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ImageAndTextWidget(),
                                    memberProvider.memberEdges.data != null
                                        ? memberProvider.memberEdges.data.isNotEmpty
                                        ? Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: double.infinity,
                                                color: CustomColors
                                                    .bottomAppBarColor,
                                                margin: EdgeInsets.fromLTRB(
                                                    Dimens.space0.w,
                                                    Dimens.space26.h,
                                                    Dimens.space0.w,
                                                    Dimens.space0.h),
                                                padding: EdgeInsets.fromLTRB(
                                                    Dimens.space16.w,
                                                    Dimens.space15.h,
                                                    Dimens.space0.w,
                                                    Dimens.space16.h),
                                                child: Text(
                                                  "${Utils.getString("members").toUpperCase()} - ${memberProvider.memberEdges.data.length}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .button
                                                      .copyWith(
                                                      color: CustomColors
                                                          .textPrimaryLightColor,
                                                      fontFamily: Config
                                                          .manropeBold,
                                                      fontWeight:
                                                      FontWeight
                                                          .normal,
                                                      fontSize: Dimens
                                                          .space14.sp,
                                                      fontStyle: FontStyle
                                                          .normal),
                                                )),
                                            Expanded(
                                              flex: 1,
                                              child: MediaQuery.removePadding(
                                                  removeTop: true,
                                                  context: context,
                                                  child: ListView.builder(
                                                    shrinkWrap: false,
                                                    scrollDirection:
                                                    Axis.vertical,
                                                    itemCount: provider
                                                        .memberEdges
                                                        .data
                                                        .length,
                                                    padding:
                                                    EdgeInsets.fromLTRB(
                                                        Dimens.space0.w,
                                                        Dimens.space0.h,
                                                        Dimens.space0.w,
                                                        Dimens.space0.h),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                        int index) {
                                                      return Container(
                                                        color: Colors
                                                            .transparent,
                                                        alignment:
                                                        Alignment.center,
                                                        margin: EdgeInsets
                                                            .fromLTRB(
                                                            Dimens
                                                                .space0.w,
                                                            Dimens
                                                                .space0.h,
                                                            Dimens
                                                                .space0.w,
                                                            Dimens.space0
                                                                .h),
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
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          mainAxisSize:
                                                          MainAxisSize
                                                              .max,
                                                          children: [
                                                            Divider(
                                                              color: CustomColors
                                                                  .mainDividerColor,
                                                              height: Dimens
                                                                  .space1.h,
                                                              thickness:
                                                              Dimens
                                                                  .space1
                                                                  .h,
                                                            ),
                                                            TextButton(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                alignment:
                                                                Alignment
                                                                    .center,
                                                                backgroundColor: memberProvider
                                                                    .memberEdges
                                                                    .data[
                                                                index]
                                                                    .isChecked
                                                                    ? CustomColors
                                                                    .loadingCircleColor
                                                                    .withOpacity(
                                                                    0.1)
                                                                    : Colors
                                                                    .white,
                                                                tapTargetSize:
                                                                MaterialTapTargetSize
                                                                    .shrinkWrap,
                                                                padding: EdgeInsets.fromLTRB(
                                                                    Dimens
                                                                        .space0,
                                                                    Dimens
                                                                        .space0,
                                                                    Dimens
                                                                        .space0,
                                                                    Dimens
                                                                        .space0),
                                                              ),
                                                              onPressed: () {
                                                                if (!memberProvider
                                                                    .memberEdges
                                                                    .data[
                                                                index]
                                                                    .isChecked) {
                                                                  selectedMember.remove(memberProvider
                                                                      .memberEdges
                                                                      .data[
                                                                  index]
                                                                      .members
                                                                      .id);
                                                                  memberProvider
                                                                      .memberEdges
                                                                      .data[
                                                                  index]
                                                                      .isChecked = true;
                                                                } else {
                                                                  selectedMember.putIfAbsent(
                                                                      memberProvider
                                                                          .memberEdges
                                                                          .data[
                                                                      index]
                                                                          .members
                                                                          .id,
                                                                          () => memberProvider
                                                                          .memberEdges
                                                                          .data[index]
                                                                          .members
                                                                          .id);
                                                                  memberProvider
                                                                      .memberEdges
                                                                      .data[
                                                                  index]
                                                                      .isChecked = false;
                                                                }
                                                                setState(
                                                                        () {});
                                                              },
                                                              child:
                                                              Container(
                                                                color: Colors
                                                                    .transparent,
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
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
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
                                                                height: Dimens
                                                                    .space52
                                                                    .h,
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                                  mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                                  children: [
                                                                    Container(
                                                                      color: Colors
                                                                          .transparent,
                                                                      alignment:
                                                                      Alignment.center,
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
                                                                      CustomCheckBox(
                                                                        width:
                                                                        Dimens.space20,
                                                                        height:
                                                                        Dimens.space20,
                                                                        boxFit:
                                                                        BoxFit.contain,
                                                                        iconUrl:
                                                                        Icons.check,
                                                                        iconColor:
                                                                        CustomColors.white,
                                                                        selectedColor:
                                                                        CustomColors.loadingCircleColor,
                                                                        unSelectedColor:
                                                                        CustomColors.textQuinaryColor,
                                                                        iconSize:
                                                                        Dimens.space16,
                                                                        outerCorner:
                                                                        Dimens.space6,
                                                                        innerCorner:
                                                                        Dimens.space6,
                                                                        assetHeight:
                                                                        Dimens.space20,
                                                                        assetWidth:
                                                                        Dimens.space20,
                                                                        isChecked: memberProvider
                                                                            .memberEdges
                                                                            .data[index]
                                                                            .isChecked,
                                                                        onCheckBoxTap:
                                                                            (value) {
                                                                          if (value) {
                                                                            selectedMember.putIfAbsent(memberProvider.memberEdges.data[index].members.id, () => memberProvider.memberEdges.data[index].members.id);
                                                                            memberProvider.memberEdges.data[index].isChecked = true;
                                                                          } else {
                                                                            selectedMember.remove(memberProvider.memberEdges.data[index].members.id);
                                                                            memberProvider.memberEdges.data[index].isChecked = false;
                                                                          }
                                                                          setState(() {});
                                                                        },
                                                                      ),
                                                                    ),
                                                                    Flexible(
                                                                        flex:
                                                                        1,
                                                                        child:
                                                                        Container(
                                                                          color:
                                                                          Colors.transparent,
                                                                          alignment:
                                                                          Alignment.center,
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
                                                                          child:
                                                                          AddMemberItemWidget(
                                                                            item: memberProvider.memberEdges.data[index],
                                                                          ),
                                                                        )),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                    physics:
                                                    AlwaysScrollableScrollPhysics(),
                                                  )),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.space24.w,
                                                  Dimens.space24.h,
                                                  Dimens.space24.w,
                                                  Dimens.space24.h),
                                              padding: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                  Dimens.space0.w,
                                                  Dimens.space0.h),
                                              child: RoundedButtonWidget(
                                                width: double.maxFinite,
                                                height: Dimens.space54,
                                                buttonBackgroundColor:
                                                CustomColors
                                                    .callAcceptColor,
                                                buttonTextColor:
                                                CustomColors.white,
                                                corner: Dimens.space10,
                                                buttonBorderColor:
                                                CustomColors.mainColor,
                                                buttonFontFamily:
                                                Config.manropeSemiBold,
                                                buttonFontSize:
                                                Dimens.space16,
                                                titleTextAlign:
                                                TextAlign.center,
                                                buttonFontWeight:
                                                FontWeight.normal,
                                                buttonText: Utils.getString(
                                                    'addToTeam'),
                                                onPressed: () async {
                                                  widget.onAddToTeamTap(
                                                      selectedMember.values
                                                          .toList());
                                                },
                                              ),
                                            ),
                                          ],
                                        ))
                                        : Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.fromLTRB(
                                              Dimens.space24.w,
                                              Dimens.space24.h,
                                              Dimens.space24.w,
                                              Dimens.space24.h),
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          child: RoundedButtonWidget(
                                            width: double.maxFinite,
                                            height: Dimens.space54,
                                            buttonBackgroundColor:
                                            CustomColors.callAcceptColor,
                                            buttonTextColor:
                                            CustomColors.white,
                                            corner: Dimens.space10,
                                            buttonBorderColor:
                                            CustomColors.mainColor,
                                            buttonFontFamily:
                                            Config.manropeSemiBold,
                                            buttonFontSize: Dimens.space16,
                                            titleTextAlign: TextAlign.center,
                                            buttonFontWeight:
                                            FontWeight.normal,
                                            buttonText:
                                            Utils.getString('addToTeam'),
                                            onPressed: () async {
                                              widget.onAddToTeamTap(
                                                  selectedMember.values
                                                      .toList());
                                            },
                                          ),
                                        ))
                                        : Expanded(
                                      child: SpinKitCircle(
                                        color: CustomColors.mainColor,
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                        );
                      });
                }),
          ),
        )
       );
  }
}

class ImageAndTextWidget extends StatelessWidget {
  ImageAndTextWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: Dimens.space120.w,
              height: Dimens.space120.w,
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              child: PlainAssetImageHolder(
                assetUrl: "assets/images/add_member.png",
                width: Dimens.space120,
                height: Dimens.space120,
                assetWidth: Dimens.space80,
                assetHeight: Dimens.space80,
                boxFit: BoxFit.contain,
                outerCorner: Dimens.space0,
                innerCorner: Dimens.space0,
                iconSize: Dimens.space120,
                iconUrl: CustomIcon.icon_gallery,
                iconColor: CustomColors.white,
                boxDecorationColor: CustomColors.white,
              )),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space20.h,
                Dimens.space0.w, Dimens.space10),
            child: Text(
              Utils.getString("addMembers"),
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
            margin: EdgeInsets.fromLTRB(Dimens.space37.w, Dimens.space0.h,
                Dimens.space37.w, Dimens.space0.h),
            child: Text(Utils.getString("addMemberDesc"),
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
    );
  }
}
