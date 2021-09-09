import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/call_transfer/CallTransferProvider.dart';
import 'package:voice_example/provider/memberProvider/MemberProvider.dart';
import 'package:voice_example/repository/MemberRepository.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/ui/common/EmptyViewUiWidget.dart';
import 'package:voice_example/ui/common/dialog/ConfirmTransferCall.dart';
import 'package:voice_example/ui/members/MemberListItemView.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

/*
 * *
 *  * Created by Kedar on 7/23/21 12:55 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/23/21 12:55 PM
 *
 */

class TransferCallDialog extends StatefulWidget
{
  final Function onCancelTap;
  final AnimationController animationController;
  final CallTransferProvider callTransferProvider;
  final String callerId;
  final String conversationId;
  final String direction;

  TransferCallDialog({
    Key key,
    this.callTransferProvider,
    this.onCancelTap,
    this.animationController,
    this.callerId,
    this.conversationId,
    this.direction,
  }) : super(key: key);

  @override
  _TransferCallDialogState createState() => _TransferCallDialogState();
}

class _TransferCallDialogState extends State<TransferCallDialog>
{
  MemberProvider memberProvider;
  MemberRepository memberRepository;
  Animation<double> animation;
  @override
  void initState() {
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
    return Container(
        height: MediaQuery.of(context).size.height.h,
        width: MediaQuery.of(context).size.width.w,
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimens.space16.r),
            topRight: Radius.circular(Dimens.space16.r),
          ),
          color: CustomColors.white,
          shape: BoxShape.rectangle,
        ),
        child: Scaffold(
          backgroundColor: CustomColors.transparent,
          resizeToAvoidBottomInset: true,
          body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space18.h, Dimens.space20.w, Dimens.space18.h),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child:  Text(
                          Utils.getString("transferCall"),
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: CustomColors.textPrimaryColor,
                              fontFamily: Config.manropeBold,
                              fontWeight: FontWeight.normal,
                              fontSize: Dimens.space16.sp,
                              fontStyle: FontStyle.normal
                          ),
                        ),
                      ),
                      Positioned(
                        left: Dimens.space0.w,
                        child: RoundedNetworkImageHolder(
                          width: Dimens.space24,
                          height: Dimens.space24,
                          boxFit: BoxFit.cover,
                          iconUrl: CustomIcon.icon_arrow_left,
                          iconColor: CustomColors.loadingCircleColor,
                          iconSize: Dimens.space24,
                          outerCorner: Dimens.space0,
                          innerCorner: Dimens.space0,
                          boxDecorationColor: CustomColors.transparent,
                          imageUrl: "",
                          onTap:()
                          {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  )
              ),
              Divider(
                color: CustomColors.mainDividerColor,
                height: Dimens.space1.h,
                thickness: Dimens.space1.h,
              ),
              Expanded(
                child: ChangeNotifierProvider<MemberProvider>(
                  lazy: false,
                  create: (BuildContext context)
                  {
                    memberProvider = MemberProvider(memberRepository: memberRepository);
                    memberProvider.doGetAllWorkspaceMembersApiCall();
                    return memberProvider;
                  },
                  child: Consumer<MemberProvider>(builder: (BuildContext context, MemberProvider provider, Widget child)
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
                      return Container(
                        color: CustomColors.white,
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
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
                                          memberProvider.memberEdges.data[i].getSuspensionTag(),
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
                                      return TextButton(
                                          onPressed:() async
                                          {
                                            if(memberProvider?.memberEdges?.data[index]?.members?.onCall?? false) {
                                                Utils.showToastMessage("cannotCallThisNumberRightNow");
                                            }else{
                                              final returnData = await showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(
                                                        Dimens.space16.r),
                                                  ),
                                                  backgroundColor: Colors
                                                      .transparent,
                                                  builder: (
                                                      BuildContext context) {
                                                    return ConfirmTransferCallDialog(
                                                      userName: memberProvider
                                                          .memberEdges
                                                          .data[index].members
                                                          .firstName + " " +
                                                          memberProvider
                                                              .memberEdges
                                                              .data[index]
                                                              .members.lastName,
                                                      onTap: () {
                                                        // if(memberProvider?.memberEdges?.data[index]?.members?.onCall?? false){
                                                        //   Utils.showToastMessage("cannotCallThisNumberRightNow");
                                                        // }else
                                                        //   {
                                                          widget
                                                              .callTransferProvider
                                                              .callTransfer(
                                                            direction: widget
                                                                .direction,
                                                            destination: memberProvider
                                                                .memberEdges
                                                                .data[index]
                                                                .members.id,
                                                            callerId: widget
                                                                .callerId,
                                                            conversationId: widget
                                                                .conversationId,
                                                          );
                                                        // }
                                                      },
                                                    );
                                                  });
                                              if (returnData != null &&
                                                  returnData["data"] is bool &&
                                                  returnData["data"]) {
                                                Navigator.of(context).pop();
                                                Utils.showToastMessage(
                                                    Utils.getString(
                                                        "transferCall"));
                                              }
                                            }
                                          },
                                          style: TextButton.styleFrom(
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                          ),
                                          child: MemberListItemView(
                                            memberEdges: memberProvider.memberEdges.data[index],
                                            animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                                              CurvedAnimation(
                                                parent: widget.animationController,
                                                curve: Interval((1 / memberProvider.memberEdges.data.length) * index, 1.0,
                                                    curve: Curves.fastOutSlowIn),
                                              ),
                                            ),
                                            animationController: widget.animationController,
                                          )
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
                ),
              ),
            ],
          ),
        )
    );
  }
}
