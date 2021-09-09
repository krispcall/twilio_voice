import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/call_log/CallLogProvider.dart';
import 'package:voice_example/repository/CallLogRepository.dart';
import 'package:voice_example/ui/common/CustomTabWidget.dart';
import 'package:voice_example/ui/common/base/CustomAppBar.dart';
import 'package:voice_example/ui/tag/edit/EditTagWidget.dart';
import 'package:voice_example/utils/utils.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:voice_example/viewobject/model/allContact/Tags.dart';
import 'package:provider/provider.dart';

import 'UserViewWidget.dart';

class EditTagContainerView extends StatefulWidget {
  final Tags tag;
  final Function callBack;

  const EditTagContainerView({
    Key key,
    this.tag,
    this.callBack,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
  }) : super(key: key);

  final Function onIncomingTap;
  final Function onOutgoingTap;

  @override
  EditTagContainerViewState createState() => EditTagContainerViewState();
}

class EditTagContainerViewState extends State<EditTagContainerView>
    with TickerProviderStateMixin {
  CallLogRepository callLogRepository;
  CallLogProvider callLogProvider;
  double screenHeight;
  ValueHolder valueHolder;
  AnimationController animationController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: Config.animation_duration);
  }

  @override
  void didChangeDependencies() {
    screenHeight = Utils.getStatusBarHeight(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    callLogRepository = Provider.of<CallLogRepository>(context);
    valueHolder = Provider.of<ValueHolder>(context);

    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    animationController.forward();

    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: CustomColors.mainBackgroundColor,
          body: CustomAppBar<CallLogProvider>(
            elevation: 0,
            centerTitle: false,
            titleWidget: Container(
              color: CustomColors.white,
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
                      Utils.getString("${widget.tag.title}"),
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
            onIncomingTap: () {
              widget.onIncomingTap();
            },
            onOutgoingTap: () {
              widget.onOutgoingTap();
            },
            actions: [],
            initProvider: () {
              callLogProvider =
                  CallLogProvider(callLogRepository: callLogRepository);
              return callLogProvider;
            },
            onProviderReady: (CallLogProvider provider) {},
            builder:
                (BuildContext context, CallLogProvider provider, Widget child) {
              return DefaultTabController(
                length: 2,
                initialIndex: 0,
                child: Scaffold(
                  appBar: PreferredSize(
                    preferredSize: Size(
                      MediaQuery.of(context).size.width,
                      Dimens.space40.h,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.white,
                      child: TabBar(
                        isScrollable: false,
                        indicatorColor: CustomColors.mainColor,
                        labelColor: CustomColors.mainColor,
                        unselectedLabelColor: CustomColors.textTertiaryColor,
                        indicatorWeight: Dimens.space2.w,
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(
                              width: Dimens.space2.h,
                              color: CustomColors.mainColor),
                          insets: EdgeInsets.fromLTRB(
                              Dimens.space16.w,
                              Dimens.space0.h,
                              Dimens.space16.w,
                              Dimens.space0.h),
                        ),
                        labelStyle:
                            Theme.of(context).textTheme.bodyText1.copyWith(
                                  fontSize: Dimens.space14.sp,
                                  fontWeight: FontWeight.normal,
                                  color: CustomColors.mainColor,
                                  fontFamily: Config.manropeSemiBold,
                                  fontStyle: FontStyle.normal,
                                ),
                        unselectedLabelStyle:
                            Theme.of(context).textTheme.bodyText1.copyWith(
                                  fontSize: Dimens.space14.sp,
                                  fontWeight: FontWeight.normal,
                                  color: CustomColors.textTertiaryColor,
                                  fontFamily: Config.manropeSemiBold,
                                  fontStyle: FontStyle.normal,
                                ),
                        onTap: (index) {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        tabs: <Widget>[
                          Tab(
                              child: Container(
                            alignment: Alignment.center,
                            height: Dimens.space40.h,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            child: CustomTagTabWidget(
                              offstage: true,
                              selected: selectedIndex == 0 ? true : false,
                              title: Utils.getString('overview'),
                            ),
                          )),
                          Tab(
                              child: Container(
                            alignment: Alignment.center,
                            height: Dimens.space40.h,
                            child: CustomTagTabWidget(
                              offstage: true,
                              selected: selectedIndex == 1 ? true : false,
                              title: Utils.getString('users'),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  backgroundColor: CustomColors.white,
                  body: TabBarView(
                    children: [
                      EditTagViewWidget(
                        tag: widget.tag,
                        callBack: (String title) {
                          widget.callBack();
                          widget.tag.title = title;
                          setState(() {});
                        },
                      ),
                      UserListViewWidget(tag: widget.tag),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        onWillPop: _requestPop);
  }
}
