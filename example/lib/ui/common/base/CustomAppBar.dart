import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/ui/dashboard/DashboardView.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar<T extends ChangeNotifier> extends StatefulWidget
{
  const CustomAppBar({
    Key key,
    @required this.builder,
    @required this.initProvider,
    @required this.elevation,
    @required this.titleWidget,
    @required this.leadingWidget,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
    this.child,
    this.centerTitle=false,
    this.onProviderReady,
    this.actions = const <Widget>[]
  }) : super(key: key);

  final Widget Function(BuildContext context, T provider, Widget child) builder;
  final Function initProvider;
  final Widget child;
  final Widget leadingWidget;
  final Widget titleWidget;
  final Function(T) onProviderReady;
  final List<Widget> actions;
  final double elevation;
  final bool centerTitle;
  final Function onIncomingTap;
  final Function onOutgoingTap;

  @override
  CustomAppBarState<T> createState() => CustomAppBarState<T>();
}

class CustomAppBarState<T extends ChangeNotifier> extends State<CustomAppBar<T>>
{
  bool callInProgressOutgoing = false;
  bool callInProgressIncoming = false;
  int secondsOutgoing=0, minutesOutgoing=0, secondsIncoming=0, minutesIncoming=0;

  @override
  void initState()
  {
    WidgetsBinding.instance?.addPostFrameCallback((_) async
    {
      DashboardView.outgoingEvent.on().listen((event)
      {
        if(event!=null && event["outgoingEvent"]=="outGoingCallRinging")
        {
          if(mounted)
          {
            setState(()
            {
              callInProgressOutgoing=true;
            });
          }
        }
        else if(event!=null && event["outgoingEvent"]=="outGoingCallDisconnected")
        {
          if(mounted)
          {
            setState(()
            {
              callInProgressOutgoing=false;
            });
          }
        }
        else if(event!=null && event["outgoingEvent"]=="outGoingCallConnected")
        {
          if(mounted)
          {
            setState(()
            {
              callInProgressOutgoing=true;
              minutesOutgoing = event["minutes"];
              secondsOutgoing =event["seconds"];
            });
          }
        }
        else if(event!=null && event["outgoingEvent"]=="outGoingCallConnectFailure")
        {
          if(mounted)
          {
            setState(()
            {
              callInProgressOutgoing=false;
            });
          }
        }
        else if(event!=null && event["outgoingEvent"]=="outGoingCallReconnecting")
        {
          if(mounted)
          {
            setState(()
            {
              callInProgressOutgoing=true;
            });
          }
        }
        else if(event!=null && event["outgoingEvent"]=="outGoingCallReconnected")
        {
          if(mounted)
          {
            setState(()
            {
              callInProgressOutgoing=true;
            });
          }
        }
        else if(event!=null && event["outgoingEvent"]=="outGoingCallCallQualityWarningsChanged")
        {
          if(mounted)
          {
            setState(()
            {
              callInProgressOutgoing=true;
            });
          }
        }
      });


      DashboardView.incomingEvent.on().listen((event)
      {
        if(event!=null && event["incomingEvent"]=="incomingRinging")
        {
          if(mounted)
          {
            setState(()
            {
              callInProgressIncoming=true;
            });
          }
        }
        else if(event!=null && event["incomingEvent"]=="incomingDisconnected")
        {
          if(mounted)
          {
            setState(()
            {
              callInProgressIncoming=false;
            });
          }
        }
        else if(event!=null && event["incomingEvent"]=="incomingConnected")
        {
          if(mounted)
          {
            setState(()
            {
              callInProgressIncoming=true;
              minutesIncoming= event["minutes"];
              secondsIncoming =event["seconds"];
            });
          }
        }
        else if(event!=null && event["incomingEvent"]=="incomingConnectFailure")
        {
          if(mounted)
          {
            setState(()
            {
              callInProgressIncoming=false;
            });
          }
        }
        else if(event!=null && event["incomingEvent"]=="incomingReconnecting")
        {
          if(mounted)
          {
            setState(()
            {
              callInProgressIncoming=true;
            });
          }
        }
        else if(event!=null && event["incomingEvent"]=="incomingReconnected")
        {
          if(mounted)
          {
            setState(()
            {
              callInProgressIncoming=true;
            });
          }
        }
        else if(event!=null && event["incomingEvent"]=="incomingCallQualityWarningsChanged")
        {
          if(mounted)
          {
            setState(()
            {
              callInProgressIncoming=true;
            });
          }
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return SafeArea(
        child: widget.leadingWidget!=null?
        Scaffold(
            backgroundColor : CustomColors.white,
            resizeToAvoidBottomInset: true,
            appBar: PreferredSize(
              preferredSize: Size(
                MediaQuery.of(context).size.width.w,
                callInProgressOutgoing || callInProgressIncoming?(kToolbarHeight.h)*2:kToolbarHeight.h,
              ),
              child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width.w,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Offstage(
                        offstage: !callInProgressOutgoing,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor: CustomColors.callOnProgressColor,
                            alignment: Alignment.center
                          ),
                          onPressed: ()
                          {
                            widget.onOutgoingTap();
                          },
                          child: Container(
                            height:kToolbarHeight.h,
                            alignment: Alignment.center,
                            child: Text(
                              Utils.getString("touchToReturnCall")+" "+minutesOutgoing.toString().padLeft(2, '0')+":"+secondsOutgoing.toString().padLeft(2, '0'),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyText1
                                  .copyWith(
                                color: CustomColors.white,
                                fontWeight: FontWeight.normal,
                                fontFamily: Config.heeboMedium,
                                fontSize: Dimens.space14.sp,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Offstage(
                        offstage: !callInProgressIncoming,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor: CustomColors.callOnProgressColor,
                              alignment: Alignment.center
                          ),
                          onPressed: ()
                          {
                            widget.onIncomingTap();
                          },
                          child: Container(
                            height:kToolbarHeight.h,
                            alignment: Alignment.center,
                            child: Text(
                              Utils.getString("touchToReturnCall")+" "+minutesIncoming.toString().padLeft(2, '0')+":"+secondsIncoming.toString().padLeft(2, '0'),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyText1
                                  .copyWith(
                                color: CustomColors.white,
                                fontWeight: FontWeight.normal,
                                fontFamily: Config.heeboMedium,
                                fontSize: Dimens.space14.sp,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                      AppBar(
                          toolbarHeight:kToolbarHeight.h,
                          automaticallyImplyLeading: false,
                          brightness: Utils.getBrightnessForAppBar(context),
                          backgroundColor : CustomColors.white,
                          iconTheme: IconThemeData(color: CustomColors.mainIconColor),
                          titleSpacing: 0,
                          title: widget.titleWidget,
                          actions: widget.actions,
                          centerTitle: widget.centerTitle,
                          elevation: widget.elevation,
                          leading: widget.leadingWidget
                      ),
                    ],
                  )
              ),
            ),
            body: ChangeNotifierProvider<T>(
              lazy: false,
              create: (BuildContext context)
              {
                final T providerObj = widget.initProvider();
                if (widget.onProviderReady != null)
                {
                  widget.onProviderReady(providerObj);
                }
                return providerObj;
              },
              child: Consumer<T>(
                  builder: widget.builder,
                  child: widget.child
              ),
            )
        ):
        Scaffold(
            backgroundColor : CustomColors.white,
            resizeToAvoidBottomInset: true,
            appBar: PreferredSize(
              preferredSize: Size(
                MediaQuery.of(context).size.width.w,
                callInProgressOutgoing || callInProgressIncoming?(kToolbarHeight.h)*2:kToolbarHeight.h,
              ),
              child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width.w,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Offstage(
                        offstage: !callInProgressOutgoing,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor: CustomColors.callOnProgressColor,
                              alignment: Alignment.center
                          ),
                          onPressed: ()
                          {
                            widget.onOutgoingTap();
                          },
                          child: Container(
                            height:kToolbarHeight.h,
                            alignment: Alignment.center,
                            child: Text(
                              Utils.getString("touchToReturnCall")+" "+minutesOutgoing.toString().padLeft(2, '0')+":"+secondsOutgoing.toString().padLeft(2, '0'),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyText1
                                  .copyWith(
                                color: CustomColors.white,
                                fontWeight: FontWeight.normal,
                                fontFamily: Config.heeboMedium,
                                fontSize: Dimens.space14.sp,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Offstage(
                        offstage: !callInProgressIncoming,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor: CustomColors.callOnProgressColor,
                              alignment: Alignment.center
                          ),
                          onPressed: ()
                          {
                            widget.onIncomingTap();
                          },
                          child: Container(
                            height:kToolbarHeight.h,
                            alignment: Alignment.center,
                            child: Text(
                              Utils.getString("touchToReturnCall")+" "+minutesIncoming.toString().padLeft(2, '0')+":"+secondsIncoming.toString().padLeft(2, '0'),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyText1
                                  .copyWith(
                                color: CustomColors.white,
                                fontWeight: FontWeight.normal,
                                fontFamily: Config.heeboMedium,
                                fontSize: Dimens.space14.sp,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                      AppBar(
                          toolbarHeight:kToolbarHeight.h,
                          automaticallyImplyLeading: false,
                          brightness: Utils.getBrightnessForAppBar(context),
                          backgroundColor : CustomColors.white,
                          iconTheme: IconThemeData(color: CustomColors.mainIconColor),
                          titleSpacing: 0,
                          title: widget.titleWidget,
                          actions: widget.actions,
                          centerTitle: widget.centerTitle,
                          elevation: widget.elevation,
                          leading: widget.leadingWidget
                      ),
                    ],
                  )
              ),
            ),
            body: ChangeNotifierProvider<T>(
              lazy: false,
              create: (BuildContext context)
              {
                final T providerObj = widget.initProvider();
                if (widget.onProviderReady != null)
                {
                  widget.onProviderReady(providerObj);
                }
                return providerObj;
              },
              child: Consumer<T>(
                  builder: widget.builder,
                  child: widget.child
              ),
            )
        )
    );
  }
}
