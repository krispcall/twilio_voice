import 'package:azlistview/azlistview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/memberProvider/MemberProvider.dart';
import 'package:voice_example/repository/MemberRepository.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/ui/common/EmptyViewUiWidget.dart';
import 'package:voice_example/ui/members/MemberListItemView.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavigationSearchMemberDialog extends StatefulWidget {
  const NavigationSearchMemberDialog({
    Key key,
    @required this.animationController,
  }) : super(key: key);

  final AnimationController animationController;

  @override
  NavigationSearchMemberDialogState createState() => NavigationSearchMemberDialogState();
}

class NavigationSearchMemberDialogState extends State<NavigationSearchMemberDialog>
{
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  MemberProvider memberProvider;
  MemberRepository memberRepository;

  final TextEditingController controllerSearchMember = TextEditingController();
  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue)
    {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet) {
        setState(() {});
      }
    });
  }

  ValueHolder valueHolder;

  @override
  void initState()
  {
    if (!isConnectedToInternet)
    {
      checkConnection();
    }
    memberRepository = Provider.of<MemberRepository>(context,listen: false);
    valueHolder = Provider.of<ValueHolder>(context, listen: false);

    super.initState();
  }

  @override
  void dispose()
  {
    super.dispose();
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
                          Utils.getString("browseMembers"),
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
                        return RefreshIndicator(
                          color: CustomColors.mainColor,
                          backgroundColor: CustomColors.white,
                          child: Container(
                            color: CustomColors.white,
                            alignment: Alignment.topCenter,
                            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
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
                  ),
              ),
            ],
          ),
        )
    );
  }
}
