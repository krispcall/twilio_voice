import 'package:flutter/material.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/constant/RoutePaths.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/contacts/ContactsProvider.dart';
import 'package:voice_example/provider/login_workspace/LoginWorkspaceProvider.dart';
import 'package:voice_example/provider/memberProvider/MemberProvider.dart';
import 'package:voice_example/repository/ContactRepository.dart';
import 'package:voice_example/repository/LoginWorkspaceRepository.dart';
import 'package:voice_example/repository/MemberRepository.dart';
import 'package:voice_example/ui/invite/dialog/InviteMemberDialog.dart';
import 'package:voice_example/ui/invite/dialog/RoleSelectionDialog.dart';
import 'package:voice_example/utils/PsProgressDialog.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/AddGlobalTagViewHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/AddWorkSpaceIntentHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/MemberListIntentHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/NumberListIntentHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/TeamListIntentHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/InviteMemberParamHolder.dart';
import 'package:provider/provider.dart';

import '../../common/CustomImageHolder.dart';
import '../../common/dialog/BalanceDialog.dart';
import '../../common/dialog/ErrorDialog.dart';

/*
 * *
 *  * Created by Kedar on 7/27/21 1:22 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/27/21 1:22 PM
 *
 */

class WorkSpaceDetailsDialog extends StatefulWidget
{
  final Function onCallback;
  WorkSpaceDetailsDialog({
    Key key,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
    this.onCallback
  }) : super(key: key);
  final Function onIncomingTap;
  final Function onOutgoingTap;

  @override
  _WorkSpaceDetailsDialogState createState() {
    return _WorkSpaceDetailsDialogState();
  }
}

class _WorkSpaceDetailsDialogState extends State<WorkSpaceDetailsDialog> {
  LoginWorkspaceProvider workspaceProvider;
  LoginWorkspaceRepository workspaceRepository;
  ValueHolder valueHolder;

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
    valueHolder = Provider.of<ValueHolder>(context);
    workspaceRepository = Provider.of<LoginWorkspaceRepository>(context);

    // TODO: implement build

    return Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        child: ChangeNotifierProvider<LoginWorkspaceProvider>(
            lazy: false,
            create: (BuildContext context) {
              workspaceProvider = LoginWorkspaceProvider(
                  loginWorkspaceRepository: workspaceRepository,
                  valueHolder: valueHolder);
              workspaceProvider.doCallWorkSpaceDetailApi();
              workspaceProvider.getWorkspaceDetailFromDb();
              return workspaceProvider;
            },
            child: Consumer<LoginWorkspaceProvider>(builder:
                (BuildContext context, LoginWorkspaceProvider provider,
                    Widget child) {
              return Container(
                  height: ScreenUtil().screenHeight * 0.98,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(Dimens.space16.w),
                        topLeft: Radius.circular(Dimens.space16.w)),
                    color: CustomColors.backgroundColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            Dimens.space16.w,
                            Dimens.space28.h,
                            Dimens.space16.w,
                            Dimens.space24.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(Dimens.space16.w),
                              topLeft: Radius.circular(Dimens.space16.w)),
                          color: Colors.white,
                        ),
                        child: Container(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space0,
                                          Dimens.space2,
                                          Dimens.space0.h,
                                          Dimens.space2),
                                      padding: EdgeInsets.fromLTRB(
                                          Dimens.space16.w,
                                          Dimens.space0,
                                          Dimens.space16.w,
                                          Dimens.space0),
                                      child: RoundedNetworkImageHolder(
                                        width: Dimens.space80,
                                        height: Dimens.space80,
                                        boxFit: BoxFit.fill,
                                        iconUrl: CustomIcon.icon_gallery,
                                        iconColor:
                                            CustomColors.callInactiveColor,
                                        iconSize: Dimens.space40,
                                        outerCorner: Dimens.space20,
                                        innerCorner: Dimens.space12,
                                        imageUrl: (provider
                                                        .loginWorkspaceDetail !=
                                                    null &&
                                                provider.loginWorkspaceDetail.data !=
                                                    null &&
                                                provider.loginWorkspaceDetail.data
                                                        .workspace !=
                                                    null &&
                                                provider.loginWorkspaceDetail
                                                        .data.workspace.data !=
                                                    null &&
                                                provider
                                                        .loginWorkspaceDetail
                                                        .data
                                                        .workspace
                                                        .data
                                                        .photo !=
                                                    null)
                                            ? "${provider.loginWorkspaceDetail.data.workspace.data.photo}"
                                            : "",
                                      ),
                                    ),
                                    Flexible(
                                        flex: 1,
                                        child: Container(
                                          alignment: Alignment.topRight,
                                          width: double.infinity,
                                          child: BalanceDetailWidget(
                                              provider: workspaceProvider),
                                        ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space8.h,
                                    Dimens.space0,
                                    Dimens.space12.h),
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space16.w,
                                    Dimens.space0,
                                    Dimens.space16.w,
                                    Dimens.space0),
                                child: Container(
                                  child: Text(
                                    (provider.loginWorkspaceDetail != null &&
                                            provider.loginWorkspaceDetail
                                                    .data !=
                                                null)
                                        ? provider.loginWorkspaceDetail.data
                                            .workspace.data.title
                                        : "",
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(
                                            color:
                                                CustomColors.textPrimaryColor,
                                            fontFamily: Config.manropeExtraBold,
                                            fontSize: Dimens.space20.sp,
                                            fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space0,
                                    Dimens.space10.h,
                                    Dimens.space0.h,
                                    Dimens.space2),
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space16.w,
                                    Dimens.space0,
                                    Dimens.space16.w,
                                    Dimens.space0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    MemberCounterWidget(),
                                    ContactCounterCounterWidget()
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: CustomColors.mainDividerColor,
                        height: Dimens.space1,
                        thickness: Dimens.space1,
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space16.w,
                              Dimens.space20.h,
                              Dimens.space16.w,
                              Dimens.space20.h),
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
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        backgroundColor: CustomColors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              Dimens.space10.r),
                                        ),
                                      ),
                                      onPressed: () async {
                                        await showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimens.space16.r),
                                            ),
                                            backgroundColor: Colors.transparent,
                                            builder: (BuildContext context) {
                                              return AnimatedPadding(
                                                padding: MediaQuery.of(context)
                                                    .viewInsets,
                                                duration: const Duration(
                                                    milliseconds: 100),
                                                curve: Curves.decelerate,
                                                child: new Container(
                                                  height: ScreenUtil()
                                                          .screenHeight *
                                                      0.80,
                                                  child: InviteMemberDialog(
                                                    onCallBack: (String value) {
                                                      Navigator.of(context)
                                                          .pop();
                                                      _showInvitationTypeDialog(
                                                          value, context);
                                                    },
                                                  ),
                                                ),
                                              );
                                            });
                                      },
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                                  CustomIcon.icon_invite,
                                                  color: CustomColors
                                                      .loadingCircleColor,
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
                                                    Utils.getString("invite"),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                            fontFamily: Config
                                                                .heeboRegular,
                                                            fontSize: Dimens
                                                                .space12.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: CustomColors
                                                                .textTertiaryColor,
                                                            fontStyle: FontStyle
                                                                .normal),
                                                  )
                                              )
                                            ],
                                          )
                                      ),
                                    )
                                ),
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
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        backgroundColor: CustomColors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              Dimens.space10.r),
                                        ),
                                      ),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                                  // dndEnabled!=null && dndEnabled?CustomIcon.icon_muted:CustomIcon.icon_notification,
                                                  CustomIcon.icon_notification,
                                                  // color: dndEnabled!=null && dndEnabled?CustomColors.textPrimaryErrorColor:CustomColors.loadingCircleColor,
                                                  color: CustomColors
                                                      .loadingCircleColor,
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
                                                    // dndEnabled != null && dndEnabled
                                                    //     ? Utils.getString("muted")
                                                    //     : Utils.getString("alwaysOn")
                                                    //         .toLowerCase(),
                                                    Utils.getString("alwaysOn"),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                            fontFamily: Config
                                                                .heeboRegular,
                                                            fontSize: Dimens
                                                                .space12.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: CustomColors
                                                                .textTertiaryColor,
                                                            fontStyle: FontStyle
                                                                .normal),
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
                      WorkSpaceWidget(
                        onCallBack: ()
                        {
                          widget.onCallback();
                          workspaceProvider.doLoginWorkSpaceDetailApiCall();
                          workspaceProvider. getDefaultWorkSpace();
                        },
                        onIncomingTap: ()
                        {
                          widget.onIncomingTap();
                        },
                        onOutgoingTap: ()
                        {
                          widget.onOutgoingTap();
                        },
                      ),
                      UserManagementWidget(
                        provider: workspaceProvider,
                        onIncomingTap: ()
                        {
                          widget.onIncomingTap();
                        },
                        onOutgoingTap: ()
                        {
                          widget.onOutgoingTap();
                        },
                      ),
                      Expanded(
                        flex: 1,
                        child: MoreWidget(),
                      )
                      // WorkSpaceWidget(),
                    ],
                  ));
            })));
  }

  void _showInvitationTypeDialog(String email, BuildContext context) async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.space16.r),
        ),
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return new Container(
            height: ScreenUtil().screenHeight * 0.80,
            child: RoleSelectionDialog(
              email: email,
              onRoleSelected: (RoleType value) {
                Navigator.of(context).pop();
                _requestMemberInvitationApiCall(email, value);
              },
            ),
          );
        });
  }

  _requestMemberInvitationApiCall(String email, RoleType value) async {
    InviteMemberParamHolder requestParam = new InviteMemberParamHolder(
        email: email, role: value.roleName, inviteLink: value.inviteLink);
    bool connectivity = await Utils.checkInternetConnectivity();
    if (connectivity) {
      PsProgressDialog.showDialog(context);

      Resources _resource =
          await workspaceProvider.inviteUserToWorkSpace(requestParam.toMap());

      if (_resource.status == Status.SUCCESS) {
        PsProgressDialog.dismissDialog();
        Utils.showToastMessage(_resource.message);
      } else {
        PsProgressDialog.dismissDialog();
        Utils.showToastMessage(_resource.message);
      }
    } else {
      showDialog<dynamic>(builder: (BuildContext context) {
        return ErrorDialog(
          message: Utils.getString('noInternet'),
        );
      });
    }
  }
}

class WorkSpaceWidget extends StatelessWidget {

  final Function  onCallBack;
  final Function onIncomingTap;
  final Function onOutgoingTap;

  const WorkSpaceWidget({
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
    this.onCallBack
  });


  // final Contacts contact;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      decoration: BoxDecoration(
        color: CustomColors.white,
        shape: BoxShape.rectangle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  child: Container(
                      color: CustomColors.bottomAppBarColor,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                          Dimens.space15.h, Dimens.space0.w, Dimens.space15.h),
                      child: Text(
                        Utils.getString("workspace").toUpperCase(),
                        style: Theme.of(context).textTheme.button.copyWith(
                            color: CustomColors.textPrimaryLightColor,
                            fontFamily: Config.manropeBold,
                            fontWeight: FontWeight.normal,
                            fontSize: Dimens.space14.sp,
                            fontStyle: FontStyle.normal),
                      ))),
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RoutePaths.overview,
                        arguments: AddWorkSpaceIntentHolder(
                          onAddWorkSpaceCallBack: onCallBack,
                          onIncomingTap: ()
                          {
                            onIncomingTap();
                          },
                          onOutgoingTap: ()
                          {
                            onOutgoingTap();
                          },
                        )
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
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
                                    Utils.getString("overview"),
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                            color:
                                                CustomColors.textPrimaryColor,
                                            fontFamily: Config.manropeSemiBold,
                                            fontSize: Dimens.space15.sp,
                                            fontWeight: FontWeight.normal),
                                  ))),
                          Expanded(
                            child: Container(
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
                                  // contact.number,
                                  "",
                                  maxLines: 1,
                                  softWrap: false,
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
                                )),
                          ),
                          Icon(
                            CustomIcon.icon_arrow_right,
                            size: Dimens.space24.w,
                            color: CustomColors.textQuinaryColor,
                          ),
                        ],
                      ),
                    )),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RoutePaths.myNumbers,
                        arguments : NumberListIntentHolder(
                          onIncomingTap: ()
                          {
                            onIncomingTap();
                          },
                          onOutgoingTap: ()
                          {
                            onOutgoingTap();
                          },
                        )
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
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
                                  Utils.getString("numbers"),
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
                          child: Container(
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
                                // contact.number,
                                "",
                                maxLines: 1,
                                softWrap: false,
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
                              )),
                        ),
                        Icon(
                          CustomIcon.icon_arrow_right,
                          size: Dimens.space24.w,
                          color: CustomColors.textQuinaryColor,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class UserManagementWidget extends StatelessWidget
{
  final LoginWorkspaceProvider provider;
  final Function onIncomingTap;
  final Function onOutgoingTap;

  const UserManagementWidget({
    Key key,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
    this.provider
  });


  // final Contacts contact;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      decoration: BoxDecoration(
        color: CustomColors.white,
        shape: BoxShape.rectangle,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  child: Container(
                      color: CustomColors.bottomAppBarColor,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                          Dimens.space15.h, Dimens.space0.w, Dimens.space15.h),
                      child: Text(
                        Utils.getString("usermanagement").toUpperCase(),
                        style: Theme.of(context).textTheme.button.copyWith(
                            color: CustomColors.textPrimaryLightColor,
                            fontFamily: Config.manropeBold,
                            fontWeight: FontWeight.normal,
                            fontSize: Dimens.space14.sp,
                            fontStyle: FontStyle.normal),
                      ))),
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                InkWell(
                  onTap: ()
                  {
                    Navigator.pushNamed(
                      context,
                      RoutePaths.teamsList,
                      arguments : TeamListIntentHolder(
                          onIncomingTap: ()
                          {
                            onIncomingTap();
                          },
                          onOutgoingTap: ()
                          {
                            onOutgoingTap();
                          },
                        )
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
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
                                  Utils.getString("teams"),
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
                          child: Container(
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
                                // contact.number,
                                "",
                                maxLines: 1,
                                softWrap: false,
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
                              )),
                        ),
                        Icon(
                          CustomIcon.icon_arrow_right,
                          size: Dimens.space24.w,
                          color: CustomColors.textQuinaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RoutePaths.memberList,
                        arguments : MemberListIntentHolder(
                          onIncomingTap: ()
                          {
                            onIncomingTap();
                          },
                          onOutgoingTap: ()
                          {
                            onOutgoingTap();
                          },
                        )
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
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
                                  Utils.getString("members"),
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
                          child: Container(
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
                                // contact.number,
                                "",
                                maxLines: 1,
                                softWrap: false,
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
                              )),
                        ),
                        Icon(
                          CustomIcon.icon_arrow_right,
                          size: Dimens.space24.w,
                          color: CustomColors.textQuinaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    /*Todo Need to provide the clientId and Client Name*/
                    Navigator.pushNamed(context, RoutePaths.tagsList,
                        arguments: AddGlobalTagViewHolder(
                          workspaceName: provider
                              .loginWorkspaceDetail.data.workspace.data.title,
                          workspaceImage: provider
                              .loginWorkspaceDetail.data.workspace.data.photo,
                          onIncomingTap: ()
                          {
                            onIncomingTap();
                          },
                          onOutgoingTap: ()
                          {
                            onOutgoingTap();
                          },
                        )
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                        Dimens.space16.h, Dimens.space16.w, Dimens.space0.h),
                    alignment: Alignment.center,
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
                                  Utils.getString("tags"),
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
                          child: Container(
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
                                // contact.number,
                                "",
                                maxLines: 1,
                                softWrap: false,
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
                              )),
                        ),
                        Icon(
                          CustomIcon.icon_arrow_right,
                          size: Dimens.space24.w,
                          color: CustomColors.textQuinaryColor,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MoreWidget extends StatelessWidget {
  const MoreWidget();

  // final Contacts contact;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      color: CustomColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  child: Container(
                      color: CustomColors.bottomAppBarColor,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                          Dimens.space15.h, Dimens.space0.w, Dimens.space15.h),
                      child: Text(
                        Utils.getString("more").toUpperCase(),
                        style: Theme.of(context).textTheme.button.copyWith(
                            color: CustomColors.textPrimaryLightColor,
                            fontFamily: Config.manropeBold,
                            fontWeight: FontWeight.normal,
                            fontSize: Dimens.space14.sp,
                            fontStyle: FontStyle.normal),
                      ))),
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                        Dimens.space16.h, Dimens.space16.w, Dimens.space16.h),
                    alignment: Alignment.center,
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
                                  Utils.getString("advanceSettings"),
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
                          child: Container(
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
                                // contact.number,
                                "",
                                maxLines: 1,
                                softWrap: false,
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
                              )),
                        ),
                        Icon(
                          CustomIcon.icon_arrow_right,
                          size: Dimens.space24.w,
                          color: CustomColors.textQuinaryColor,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BalanceDetailWidget extends StatelessWidget {
  LoginWorkspaceProvider provider;

  BalanceDetailWidget({this.provider});

  @override
  Widget build(BuildContext context) {
    if (provider.overviewData != null &&
        provider.overviewData.data != null &&
        provider.overviewData.data.credit != null &&
        provider.overviewData.data.credit.amount != null) {
      return TextButton(
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            elevation: 0,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => Container(
                height: ScreenUtil().screenHeight * 0.42,
                child: BalanceDialog(
                  onTap: () {
                    /*Todo website link here*/
                  },
                  amount: provider.overviewData.data.credit.amount,
                )),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(Dimens.space5.r),
            ),
            color: CustomColors.callAcceptColor,
          ),
          padding: EdgeInsets.fromLTRB(Dimens.space8.w, Dimens.space8.h,
              Dimens.space8.w, Dimens.space8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '\$${provider.overviewData.data.credit.amount} Remaining',
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: CustomColors.white,
                    fontFamily: Config.heeboMedium,
                    fontSize: Dimens.space13.sp,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1.07),
              ),
            ],
          ),
        ),
      );
    } else {
      return TextButton(
          onPressed: () async {
            await showModalBottomSheet(
              context: context,
              elevation: 0,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => Container(
                  height: ScreenUtil().screenHeight * 0.42,
                  child: BalanceDialog(
                    onTap: () {
                      /*Todo website link here*/
                    },
                    amount: 0,
                  )),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(Dimens.space5.r),
              ),
              color: CustomColors.callAcceptColor,
            ),
            padding: EdgeInsets.fromLTRB(Dimens.space8.w, Dimens.space8.h,
                Dimens.space8.w, Dimens.space8.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '\$0.00 Remaining',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: CustomColors.white,
                      fontFamily: Config.heeboMedium,
                      fontSize: Dimens.space13.sp,
                      letterSpacing:
                          0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.normal,
                      height: 1.07),
                ),
              ],
            ),
          ));
    }
  }
}

class MemberCounterWidget extends StatefulWidget {
  MemberCounterWidget({Key key}) : super(key: key);

  @override
  _MemberCounterWidgetState createState() {
    return _MemberCounterWidgetState();
  }
}

class _MemberCounterWidgetState extends State<MemberCounterWidget> {
  MemberProvider memberProvider;
  MemberRepository memberRepository;

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
    memberRepository = Provider.of<MemberRepository>(context);

    return ChangeNotifierProvider<MemberProvider>(
        lazy: false,
        create: (BuildContext context) {
          memberProvider = MemberProvider(memberRepository: memberRepository);
          memberProvider.doGetAllWorkspaceMembersApiCall();
          return memberProvider;
        },
        child: Consumer<MemberProvider>(builder:
            (BuildContext context, MemberProvider provider, Widget child) {
          return Container(
            margin: EdgeInsets.fromLTRB(
                Dimens.space0, Dimens.space0, Dimens.space6.w, Dimens.space0),
            padding: EdgeInsets.fromLTRB(
                Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
            constraints: BoxConstraints(minWidth: Dimens.space100),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    width: Dimens.space10.w,
                    height: Dimens.space10.w,
                    decoration: BoxDecoration(
                      color: CustomColors.callAcceptColor,
                      borderRadius:
                          BorderRadius.all(Radius.circular(Dimens.space10.r)),
                    )),
                SizedBox(width: Dimens.space5.h),
                Text(
                  memberProvider.memberEdges != null &&
                          memberProvider.memberEdges.data != null &&
                          memberProvider.memberEdges.data.isNotEmpty
                      ? '${memberProvider.memberEdges.data.where((element) => element.members.online).toList().length}/${provider.memberEdges.data.length} ' +
                          Utils.getString("members")
                      : "0/0 " + Utils.getString("members"),
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: CustomColors.textPrimaryColor,
                      fontFamily: Config.heeboRegular,
                      fontSize: Dimens.space13.sp,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.normal),
                ),
              ],
            ),
          );
        }));
  }
}

class ContactCounterCounterWidget extends StatefulWidget {
  ContactCounterCounterWidget({Key key}) : super(key: key);

  @override
  _ContactCounterCounterWidgetState createState() {
    return _ContactCounterCounterWidgetState();
  }
}

class _ContactCounterCounterWidgetState
    extends State<ContactCounterCounterWidget> {
  ContactsProvider contactsProvider;
  ContactRepository contactRepository;

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
    // Figma Flutter Generator CounterWidget - FRAME - HORIZONTAL
    contactRepository = Provider.of<ContactRepository>(context);

    return ChangeNotifierProvider<ContactsProvider>(
        lazy: false,
        create: (BuildContext context) {
          contactsProvider =
              ContactsProvider(contactRepository: contactRepository);
          // contactsProvider.getAllContactsFromDB();
          return contactsProvider;
        },
        child: Consumer<ContactsProvider>(builder:
            (BuildContext context, ContactsProvider provider, Widget child) {
          return Container(
            margin: EdgeInsets.fromLTRB(
                Dimens.space0, Dimens.space0, Dimens.space6.w, Dimens.space0),
            padding: EdgeInsets.fromLTRB(
                Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
            constraints: BoxConstraints(minWidth: Dimens.space100),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    width: Dimens.space10.w,
                    height: Dimens.space10.w,
                    decoration: BoxDecoration(
                      color: CustomColors.loadingCircleColor,
                      borderRadius:
                          BorderRadius.all(Radius.circular(Dimens.space10.r)),
                    )),
                SizedBox(width: Dimens.space5.h),

                /*Todo need to show the list length  after refactor in in contact provider and repository*/

                Text(
                  '${0} Contacts',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: CustomColors.textPrimaryColor,
                      fontFamily: Config.heeboRegular,
                      fontSize: Dimens.space13.sp,
                      letterSpacing:
                          0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.w400,
                      height: 1.0769230769230769),
                ),
              ],
            ),
          );
        }));
  }
}
