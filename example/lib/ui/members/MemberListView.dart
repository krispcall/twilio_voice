import 'package:azlistview/azlistview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/memberProvider/MemberProvider.dart';
import 'package:voice_example/repository/MemberRepository.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/ui/common/EmptyViewUiWidget.dart';
import 'package:voice_example/ui/common/base/CustomAppBar.dart';
import 'package:voice_example/ui/common/dialog/ErrorDialog.dart';
import 'package:voice_example/ui/invite/dialog/InviteMemberDialog.dart';
import 'package:voice_example/ui/invite/dialog/RoleSelectionDialog.dart';
import 'package:voice_example/ui/members/MemberListItemView.dart';
import 'package:voice_example/utils/PsProgressDialog.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/InviteMemberParamHolder.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MemberListView extends StatefulWidget {
  const MemberListView({
    Key key,
    @required this.animationController,
    @required this.onLeadingTap,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
  }) : super(key: key);

  final AnimationController animationController;
  final Function onLeadingTap;
  final Function onIncomingTap;
  final Function onOutgoingTap;

  @override
  _MemberListView createState() => _MemberListView();
}

class _MemberListView extends State<MemberListView> with TickerProviderStateMixin
{
  MemberProvider memberProvider;
  MemberRepository memberRepository;

  ValueHolder valueHolder;

  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  final TextEditingController controllerSearchMember = TextEditingController();
  Animation<double> animation;
  @override
  void dispose()
  {
    super.dispose();
  }

  @override
  void initState()
  {
    memberRepository = Provider.of<MemberRepository>(context, listen: false);
    widget.animationController.forward();
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    memberRepository = Provider.of<MemberRepository>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: CustomColors.white,
      body: CustomAppBar<MemberProvider>(
          elevation: 0,
          centerTitle: true,
          titleWidget: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width.w,kToolbarHeight.h),
            child:Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              child: Text(
                Utils.getString("members"),
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
          ),
          leadingWidget: TextButton(
            onPressed: widget.onLeadingTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Icon(
                    Icons.menu,
                    color: CustomColors.textSecondaryColor,
                    size: Dimens.space24.w,
                  ),
                ),
                Positioned(
                  right: Dimens.space22.w,
                  bottom: Dimens.space22.w,
                  child: Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                        Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                        Dimens.space0.w, Dimens.space0.h),
                    child: RoundedNetworkImageHolder(
                      imageUrl: "",
                      width: Dimens.space10,
                      height: Dimens.space10,
                      boxFit: BoxFit.cover,
                      outerCorner: Dimens.space300,
                      innerCorner: Dimens.space300,
                      iconSize: Dimens.space0,
                      iconColor: CustomColors.callDeclineColor,
                      boxDecorationColor: CustomColors.callDeclineColor,
                      iconUrl: CustomIcon.icon_search,
                    ),
                  ),
                ),
              ],
            ),
          ),
          onIncomingTap: ()
          {
            widget.onIncomingTap();
          },
          onOutgoingTap: ()
          {
            widget.onOutgoingTap();
          },
          actions: [
            TextButton(
              onPressed: () async
              {
                _onInviteClick();
              },
              style: TextButton.styleFrom(
                alignment: Alignment.center,
                backgroundColor: CustomColors.transparent,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.fromLTRB(
                    Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.space0.r),
                ),
              ),
              child: RoundedNetworkImageHolder(
                width: Dimens.space20,
                height: Dimens.space20,
                boxFit: BoxFit.cover,
                iconUrl: CustomIcon.icon_plus_rounded,
                iconColor: CustomColors.loadingCircleColor,
                iconSize: Dimens.space18,
                outerCorner: Dimens.space10,
                innerCorner: Dimens.space10,
                boxDecorationColor: CustomColors.transparent,
                imageUrl: "",
              ),
            ),
          ],
          initProvider: ()
          {
            memberProvider = MemberProvider(memberRepository: memberRepository);
            return memberProvider;
          },
          onProviderReady: (MemberProvider provider)
          {
            controllerSearchMember.addListener(()
            {
              if (controllerSearchMember.text != null && controllerSearchMember.text.isNotEmpty && controllerSearchMember.text!="")
              {
                memberProvider.doSearchMemberFromDb(controllerSearchMember.text);
              }
              else
              {
                memberProvider.getAllMembersFromDb();
              }
            });
            memberProvider.doGetAllWorkspaceMembersApiCall();
            memberProvider.doSubscriptionOnlineMemberStatusDetail(memberProvider.getWorkspaceDetail().id);

          },
          builder: (BuildContext context, MemberProvider provider, Widget child)
          {
            if (memberProvider.memberEdges != null && memberProvider.memberEdges.data != null)
            {
              if(memberProvider.memberEdges != null && memberProvider.memberEdges.data != null)
              {
                int onlineLength = 0;
                int offlineLength = 0;
                for(int i = 0, length = memberProvider.memberEdges.data.length; i < length; i++)
                {
                  if(memberProvider.memberEdges.data!=null && memberProvider.memberEdges.data.isNotEmpty && memberProvider.memberEdges.data[i].members.online!=null && memberProvider.memberEdges.data[i].members.online==true)
                  {
                    onlineLength++;
                  }
                  else
                  {
                    offlineLength++;
                  }
                }
                for (int i = 0, length = memberProvider.memberEdges.data.length; i < length; i++)
                {
                  String pinyin="";
                  if(memberProvider.memberEdges.data!=null && memberProvider.memberEdges.data.isNotEmpty && memberProvider.memberEdges.data[i].members.online!=null && memberProvider.memberEdges.data[i].members.online==true)
                  {
                    pinyin = Utils.getString("online").toUpperCase()+"-"+onlineLength.toString();
                  }
                  else
                  {
                    pinyin = Utils.getString("offline").toUpperCase()+"-"+offlineLength.toString();
                  }
                  memberProvider.memberEdges.data[i].namePinyin = pinyin;
                  if (RegExp("[A-Z]").hasMatch(pinyin))
                  {
                    memberProvider.memberEdges.data[i].tagIndex = pinyin;
                  }
                  else
                  {
                    memberProvider.memberEdges.data[i].tagIndex = Utils.getString("offline");
                  }
                }
                // A-Z sort.
                // SuspensionUtil.sortListBySuspensionTag(memberProvider.memberEdges.data);
                memberProvider.memberEdges.data.sort((b, a) {
                  if (a.getSuspensionTag() == "@" || b.getSuspensionTag() == "#") {
                    return -1;
                  } else if (a.getSuspensionTag() == "#" || b.getSuspensionTag() == "@") {
                    return 1;
                  } else {
                    return a.getSuspensionTag().compareTo(b.getSuspensionTag());
                  }
                });
                // show sus tag.
                SuspensionUtil.setShowSuspensionStatus(memberProvider.memberEdges.data);
              }
              return RefreshIndicator(
                color: CustomColors.mainColor,
                backgroundColor: CustomColors.white,
                child: Container(
                  color: CustomColors.white,
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w,  (kBottomNavigationBarHeight + Dimens.space10).h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            Dimens.space16.w,
                            Dimens.space20.h,
                            Dimens.space16.w,
                            Dimens.space20.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.center,
                        child: TextField(
                          controller: controllerSearchMember,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: CustomColors.textSenaryColor,
                              fontFamily: Config.manropeMedium,
                              fontWeight: FontWeight.normal,
                              fontSize: Dimens.space14.sp,
                              fontStyle: FontStyle.normal),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space13.h,
                                Dimens.space0.w,
                                Dimens.space13.h),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: Dimens.space0.w,
                              ),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.space10.r)),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: Dimens.space0.w,
                              ),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.space10.r)),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: Dimens.space0.w,
                              ),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.space10.r)),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: Dimens.space0.w,
                              ),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.space10.r)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: Dimens.space0.w,
                              ),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.space10.r)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: Dimens.space0.w,
                              ),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.space10.r)),
                            ),
                            filled: true,
                            fillColor: CustomColors.baseLightColor,
                            prefixIcon: Icon(
                              CustomIcon.icon_search,
                              size: Dimens.space16.w,
                              color: CustomColors.textTertiaryColor,
                            ),
                            hintText: Utils.getString('searchMembers'),
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                color: CustomColors.textSenaryColor,
                                fontFamily: Config.manropeMedium,
                                fontWeight: FontWeight.normal,
                                fontSize: Dimens.space14.sp,
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                      ),
                      memberProvider.memberEdges.data.isNotEmpty?
                      Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            alignment: Alignment.center,
                            child: AzListView(
                              data: memberProvider.memberEdges.data,
                              itemCount: memberProvider.memberEdges.data.length,
                              susItemBuilder: (context, i)
                              {
                                return Container(
                                  width: MediaQuery.of(context).size.width.w,
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                  padding: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space9.h, Dimens.space20.w, Dimens.space9.h),
                                  decoration: BoxDecoration(
                                    color: CustomColors.bottomAppBarColor,
                                  ),
                                  child: Text(
                                    memberProvider?.memberEdges?.data[i]?.getSuspensionTag() ?? "",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: CustomColors.textTertiaryColor,
                                        fontFamily: Config.manropeBold,
                                        fontSize: Dimens.space14.sp,
                                        fontWeight: FontWeight.normal,
                                        letterSpacing: Dimens.space0.w,
                                        wordSpacing: Dimens.space0.w,
                                        fontStyle: FontStyle.normal
                                    ),
                                  ),
                                );
                              },
                              itemBuilder: (BuildContext context, int index)
                              {
                                widget.animationController.forward();
                                return MemberListItemView(
                                  memberEdges: memberProvider.memberEdges.data[index],
                                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                      parent: widget.animationController,
                                      curve: Interval((1 / memberProvider.memberEdges.data.length) * index, 1.0,
                                          curve: Curves.fastOutSlowIn),
                                    ),
                                  ),
                                  animationController: widget.animationController,
                                );
                              },
                              physics: AlwaysScrollableScrollPhysics(),
                              indexBarData: SuspensionUtil.getTagIndexList(null),
                              indexBarMargin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              indexBarOptions: IndexBarOptions(
                                needRebuild: true,
                                indexHintAlignment: Alignment.centerRight,
                              ),
                            ),
                          )
                      ):
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            alignment: Alignment.center,
                            child: SingleChildScrollView(
                              child: EmptyViewUiWidget(
                                assetUrl: "assets/images/empty_member.png",
                                title: Utils.getString('noMembers'),
                                desc: Utils.getString('makeAConversation'),
                                buttonTitle: Utils.getString('inviteMembers'),
                                icon: Icons.add_circle_outline,
                                onPressed: () {},
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                ),
                onRefresh: ()
                {
                  return memberProvider.doGetAllWorkspaceMembersApiCall();
                },
              );
            }
            else
            {
              widget.animationController.forward();
              final Animation<double> animation =
              Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: widget.animationController,
                  curve: const Interval(0.5 * 1, 1.0,
                      curve: Curves.fastOutSlowIn)));
              return AnimatedBuilder(
                animation: widget.animationController,
                builder: (BuildContext context, Widget child) {
                  return FadeTransition(
                      opacity: animation,
                      child: Transform(
                        transform: Matrix4.translationValues(
                            0.0, 100 * (1.0 - animation.value), 0.0),
                        child: Container(
                          color: Colors.white,
                          margin: EdgeInsets.fromLTRB(Dimens.space0,
                              Dimens.space0, Dimens.space0, Dimens.space0),
                          child: SpinKitCircle(
                            color: CustomColors.mainColor,
                          ),
                        ),
                      ));
                },
              );
            }
          }),
    );
  }

  void _onInviteClick() async{
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.space16.r),
        ),
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: new Container(
              height: ScreenUtil().screenHeight * 0.80,
              child: InviteMemberDialog(
                onCallBack: (String value) {
                  Navigator.of(context).pop();
                  _showInvitationTypeDialog(value, context);
                },
              ),
            ),
          );
        });
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
      await memberProvider.inviteUserToWorkSpace(requestParam.toMap());

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
