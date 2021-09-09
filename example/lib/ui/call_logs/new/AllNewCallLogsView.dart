import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/constant/RoutePaths.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/call_log/CallLogProvider.dart';
import 'package:voice_example/repository/CallLogRepository.dart';
import 'package:voice_example/ui/call_logs/CallLogListItemView.dart';
import 'package:voice_example/ui/common/ButtonWidget.dart';
import 'package:voice_example/ui/common/EmptyViewUiWidget.dart';
import 'package:voice_example/ui/common/dialog/ChannelSelectionDialog.dart';
import 'package:voice_example/ui/common/dialog/DeleteDialog.dart';
import 'package:voice_example/ui/common/indicator/CustomLinearProgressIndicator.dart';
import 'package:voice_example/ui/dashboard/DashboardView.dart';
import 'package:voice_example/utils/PsProgressDialog.dart';
import 'package:voice_example/utils/utils.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:flutter/cupertino.dart';
import 'package:voice_example/viewobject/holder/intent_holder/MessageDetailIntentHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/contactPinUnpinRequestParamHolder/ContactPinUnpinRequestHolder.dart';
import 'package:voice_example/viewobject/model/workspace/workspace_detail/WorkspaceChannel.dart';
import 'package:voice_example/viewobject/model/workspace/workspace_detail/WorkspaceDetail.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllNewCallLogsView extends StatefulWidget {
  const AllNewCallLogsView({
    Key key,
    @required this.animationController,
    @required this.onSelectAllCheckBoxToggle,
    @required this.onCallTap,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
    @required this.makeCallWithSid,
    this.onStartConversationTap,
  }) : super(key: key);

  final AnimationController animationController;
  final Function(bool) onSelectAllCheckBoxToggle;
  final Function onCallTap;
  final Function onStartConversationTap;
  final Function onIncomingTap;
  final Function onOutgoingTap;
  final Function(String, String, String, String, String, String, String, String, String, String, String, String) makeCallWithSid;

  @override
  _AllNewCallLogsViewState createState() {
    return _AllNewCallLogsViewState();
  }
}

class _AllNewCallLogsViewState extends State<AllNewCallLogsView> {
  CallLogRepository callLogRepository;
  CallLogProvider callLogProvider;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;
  final TextEditingController controllerSearchCallLogs =
      TextEditingController();
  final SlidableController slidAbleController = SlidableController();
  bool isCheckBoxVisible = true, selectAllCheck = false;
  int selectedIndex = 0;
  List<String> toDeleteList = [];
  final ScrollController _scrollController = ScrollController();

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet) {
        setState(() {});
      }
    });
  }

  ValueHolder valueHolder;

  @override
  void initState() {
    checkConnection();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        callLogProvider.doNextCallLogsApiCall("new");
      }
    });

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      DashboardView.ebTransferData.on().listen((event) {
        callLogProvider.doCallLogsApiCall("new");
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    callLogRepository = Provider.of<CallLogRepository>(context);
    valueHolder = Provider.of<ValueHolder>(context);

    return ChangeNotifierProvider<CallLogProvider>(
      lazy: false,
      create: (BuildContext context) {
        this.callLogProvider =
            CallLogProvider(callLogRepository: callLogRepository);
        callLogProvider.doCallLogsApiCall("new");
        callLogProvider.doSubscriptionUpdateConversationDetail();
        return callLogProvider;
      },
      child: Consumer<CallLogProvider>(builder:
          (BuildContext context, CallLogProvider provider, Widget child) {
        widget.animationController.forward();
        final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(
                parent: widget.animationController,
                curve:
                    const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
        if (callLogProvider.callLogs != null &&
            callLogProvider.callLogs.data != null) {
          if (callLogProvider.callLogs.data.isNotEmpty) {
            return Container(
              color: CustomColors.white,
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(
                  Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
              padding: EdgeInsets.fromLTRB(
                  Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  RefreshIndicator(
                    color: CustomColors.mainColor,
                    backgroundColor: CustomColors.white,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: callLogProvider.callLogs.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final int count = callLogProvider.callLogs.data.length;
                        widget.animationController.forward();
                        return CallLogVerticalListItem(
                          slidAbleController: slidAbleController,
                          animationController: widget.animationController,
                          animation:
                              Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn),
                            ),
                          ),
                          callLog: callLogProvider.callLogs.data[index],
                          index: index,
                          isCheckBoxVisible: isCheckBoxVisible,
                          selectAllCheck: selectAllCheck,
                          onPressed: () async {
                            final dynamic returnData =
                                await Navigator.pushNamed(
                                    context, RoutePaths.messageDetail,
                                    arguments: MessageDetailIntentHolder(
                                      clientName: callLogProvider
                                                  .callLogs
                                                  .data[index]
                                                  .recentConversationNodes
                                                  .clientInfo !=
                                              null
                                          ? callLogProvider
                                              .callLogs
                                              .data[index]
                                              .recentConversationNodes
                                              .clientInfo
                                              .name
                                          : Utils.getString("unknown"),
                                      clientPhoneNumber: callLogProvider
                                          .callLogs
                                          .data[index]
                                          .recentConversationNodes
                                          .clientNumber,
                                      clientProfilePicture: callLogProvider
                                                  .callLogs
                                                  .data[index]
                                                  .recentConversationNodes
                                                  .clientInfo !=
                                              null
                                          ? callLogProvider
                                              .callLogs
                                              .data[index]
                                              .recentConversationNodes
                                              .clientInfo
                                              .profilePicture
                                          : "",
                                      countryId: callLogProvider
                                          .callLogs
                                          .data[index]
                                          .recentConversationNodes
                                          .clientCountry,
                                      countryFlagUrl: callLogProvider
                                          .callLogs
                                          .data[index]
                                          .recentConversationNodes
                                          .clientCountryFlag,
                                      isBlocked: callLogProvider
                                          .callLogs
                                          .data[index]
                                          .recentConversationNodes
                                          .blocked,
                                      lastChatted: callLogProvider
                                          .callLogs
                                          .data[index]
                                          .recentConversationNodes
                                          .createdAt,
                                      clientId: callLogProvider
                                                  .callLogs
                                                  .data[index]
                                                  .recentConversationNodes
                                                  .clientInfo !=
                                              null
                                          ? callLogProvider
                                              .callLogs
                                              .data[index]
                                              .recentConversationNodes
                                              .clientInfo
                                              .id
                                          : null,
                                      dndMissed: callLogProvider
                                          .callLogs
                                          .data[index]
                                          .recentConversationNodes
                                          .dndMissed,
                                      isContact: callLogProvider
                                                  .callLogs
                                                  .data[index]
                                                  .recentConversationNodes
                                                  .clientInfo !=
                                              null
                                          ? true
                                          : false,
                                      onIncomingTap: ()
                                      {
                                        widget.onIncomingTap();
                                      },
                                      onOutgoingTap: ()
                                      {
                                        widget.onOutgoingTap();
                                      },
                                      makeCallWithSid: (channelNumber, channelName, channelSid, channelFlagUrl, outgoingNumber, workspaceSid, memberId, voiceToken, outgoingName, outgoingId, outgoingFlagUrl, outgoingProfilePicture)
                                      {
                                        widget.makeCallWithSid(channelNumber, channelName, channelSid, channelFlagUrl, outgoingNumber, workspaceSid, memberId, voiceToken, outgoingName, outgoingId, outgoingFlagUrl, outgoingProfilePicture);
                                      },
                                    )
                                );
                            if (returnData != null &&
                                returnData is bool &&
                                returnData) {
                              callLogProvider.doCallLogsApiCall("all");
                            }
                          },
                          onLongPressed: () {
                            if (isCheckBoxVisible) {
                              setState(() {
                                isCheckBoxVisible = false;
                                widget.onSelectAllCheckBoxToggle(
                                    isCheckBoxVisible);
                              });
                            } else {
                              setState(() {
                                isCheckBoxVisible = true;
                                widget.onSelectAllCheckBoxToggle(
                                    isCheckBoxVisible);
                              });
                            }
                          },
                          onCallTap: (clientName, clientNumber, flagUrl)
                          {
                            Utils.checkInternetConnectivity().then((value)
                            {
                              if (value)
                              {
                                if (callLogProvider.callLogs.data[index].recentConversationNodes.blocked)
                                {
                                  Utils.showToastMessage(Utils.getString("thisContactHasBeenBlocked"));
                                }
                                else
                                {
                                  if (callLogProvider.getWorkspaceDetail().workspaceChannel.length == 1)
                                  {
                                    widget.makeCallWithSid(
                                      callLogProvider.getDefaultChannel().number,
                                      callLogProvider.getDefaultChannel().name,
                                      callLogProvider.getDefaultChannel().id,
                                      callLogProvider.getDefaultChannel().countryLogo,
                                      clientNumber,
                                      callLogProvider.getDefaultWorkspace(),
                                      callLogProvider.getMemberId(),
                                      callLogProvider.getVoiceToken(),
                                      clientName,
                                      callLogProvider.callLogs.data[index].recentConversationNodes.clientInfo != null ? callLogProvider.callLogs.data[index].recentConversationNodes.clientInfo.id : null,
                                      flagUrl,
                                      callLogProvider.callLogs.data[index].recentConversationNodes.clientInfo != null ? callLogProvider.callLogs.data[index].recentConversationNodes.clientInfo.profilePicture : "",
                                    );
                                  }
                                  else
                                  {
                                    _channelSelectionDialog(
                                      context: context,
                                      workspaceDetails: callLogProvider.getWorkspaceDetail(),
                                      clientId: callLogProvider.callLogs.data[index].recentConversationNodes.clientInfo != null ? callLogProvider.callLogs.data[index].recentConversationNodes.clientInfo.id : null,
                                      flagUrl: callLogProvider.callLogs.data[index].recentConversationNodes.clientInfo != null ? callLogProvider.callLogs.data[index].recentConversationNodes.clientInfo.profilePicture : "",
                                      clientName: clientName,
                                      clientNumber: clientNumber,
                                      clientProfilePicture: callLogProvider.callLogs.data[index].recentConversationNodes.clientInfo != null ? callLogProvider.callLogs.data[index].recentConversationNodes.clientInfo.profilePicture : "",
                                    );
                                  }
                                }
                              } else {
                                Utils.showToastMessage(
                                    Utils.getString("noInternet"));
                              }
                            });
                          },
                          onSelectAllTap: (value) {
                            if (value) {
                              for (int i = 0;
                                  i < callLogProvider.callLogs.data.length;
                                  i++) {
                                setState(() {
                                  callLogProvider.callLogs.data[i].check =
                                      false;
                                });
                              }
                              setState(() {
                                selectAllCheck = false;
                                toDeleteList.clear();
                              });
                            } else {
                              toDeleteList.clear();
                              for (int i = 0;
                                  i < callLogProvider.callLogs.data.length;
                                  i++) {
                                setState(() {
                                  callLogProvider.callLogs.data[i].check = true;
                                  toDeleteList
                                      .add(callLogProvider.callLogs.data[i].id);
                                });
                              }
                              setState(() {
                                selectAllCheck = true;
                              });
                            }
                          },
                          onCheckBoxTap: (value) {
                            if (value) {
                              setState(() {
                                callLogProvider.callLogs.data[index].check =
                                    false;
                                toDeleteList.remove(
                                    callLogProvider.callLogs.data[index].id);
                                selectAllCheck = false;
                              });
                            } else {
                              setState(() {
                                callLogProvider.callLogs.data[index].check =
                                    true;
                                toDeleteList
                                    .add(provider.callLogs.data[index].id);
                              });
                              if (toDeleteList.length ==
                                  callLogProvider.callLogs.data.length) {
                                setState(() {
                                  selectAllCheck = true;
                                });
                              }
                            }
                          },
                          onPinTap: (contactNumber, value) async {
                            PsProgressDialog.showDialog(context);
                            slidAbleController.activeState.close();
                            ContactPinUnpinRequestHolder params =
                                ContactPinUnpinRequestHolder(
                              channel: callLogProvider.getDefaultChannel().id,
                              contact: contactNumber,
                              pinned: value != null && value ? false : true,
                            );
                            Resources<bool> status = await callLogProvider
                                .doContactPinUnpinApiCall(params);
                            if (status != null && status.data != null) {
                              PsProgressDialog.dismissDialog();
                              callLogProvider.doCallLogsApiCall("new");
                            } else {
                              PsProgressDialog.dismissDialog();
                              Utils.showToastMessage(status.message);
                            }
                          },
                        );
                      },
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                          Dimens.space0,
                          Dimens.space0,
                          Dimens.space0,
                          (kBottomNavigationBarHeight + Dimens.space10).h),
                    ),
                    onRefresh: () {
                      return callLogProvider.doCallLogsApiCall("new");
                    },
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Offstage(
                        offstage: isCheckBoxVisible,
                        child: Container(
                          height: Dimens.space52,
                          decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: CustomColors.mainDividerColor,
                                ),
                              ),
                              color: CustomColors.white),
                          margin: EdgeInsets.fromLTRB(Dimens.space0,
                              Dimens.space0, Dimens.space0, Dimens.space0),
                          padding: EdgeInsets.fromLTRB(Dimens.space10,
                              Dimens.space0, Dimens.space10.h, Dimens.space0),
                          alignment: Alignment.centerRight,
                          child: RoundedButtonWidgetWithPrefix(
                            titleText: Utils.getString('delete'),
                            width: Dimens.space100,
                            height: Dimens.space40,
                            buttonColor: CustomColors.callDeclineColorLight,
                            textColor: CustomColors.callDeclineColor,
                            corner: Dimens.space8,
                            titleTextAlign: TextAlign.end,
                            icon: CustomIcon.icon_trash_outlined,
                            iconColor: CustomColors.callDeclineColor,
                            iconSize: Dimens.space16,
                            onPressed: () async {
                              if (toDeleteList.length != 0) {
                                await showDialog<dynamic>(
                                    barrierDismissible: false,
                                    useRootNavigator: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DeleteDialog(
                                        title: Utils.getString("deleteCallLog"),
                                        description: Utils.getString(
                                            "areYouSureYouWantToDeleteTheseCallLog"),
                                        cancelText: Utils.getString('cancel'),
                                        deleteText:
                                            Utils.getString('yesDelete'),
                                        icon: CustomIcon.icon_call_delete,
                                        iconColor:
                                            CustomColors.callDeclineColor,
                                        deleteSize: toDeleteList.length,
                                        deleteSizeTextColor:
                                            CustomColors.callDeclineColor,
                                        deleteSizeContainerColor:
                                            CustomColors.callDeclineColorLight,
                                        onDeleteTap: () async {
                                          // PsProgressDialog.showDialog(context);
                                          // String params = "";
                                          // for(int i=0;i<toDeleteList.length;i++)
                                          // {
                                          //   if(params.isEmpty)
                                          //   {
                                          //     if(toDeleteList.length==1)
                                          //     {
                                          //       params="[${toDeleteList[i]}]";
                                          //     }
                                          //     else
                                          //     {
                                          //       params="[${toDeleteList[i]},";
                                          //     }
                                          //   }
                                          //   else if(i==toDeleteList.length-1)
                                          //   {
                                          //     params=params+"${toDeleteList[i]}]";
                                          //   }
                                          //   else
                                          //   {
                                          //     params=params+"${toDeleteList[i]},";
                                          //   }
                                          // }
                                          // final Resources<Empty> _apiStatus = await provider.deleteCallLog(params);
                                          // if (_apiStatus.data != null)
                                          // {
                                          //   PsProgressDialog.dismissDialog();
                                          //   setState(()
                                          //   {
                                          //     selectAllCheck=false;
                                          //     isCheckBoxVisible=true;
                                          //     widget.onSelectAllCheckBoxToggle(isCheckBoxVisible);
                                          //   });
                                          //   callLogProvider.getAllCallLog("All");
                                          // }
                                          // else
                                          // {
                                          //   PsProgressDialog.dismissDialog();
                                          //   showDialog<dynamic>(
                                          //       context: context,
                                          //       builder: (BuildContext context)
                                          //       {
                                          //         return ErrorDialog(
                                          //           message: _apiStatus.message,
                                          //         );
                                          //       });
                                          // }
                                        },
                                      );
                                    });
                              } else {
                                Utils.showToastMessage(
                                    Utils.getString("noCallsSelected"));
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: Dimens.space70.h,
                    right: 0,
                    left: 0,
                    child: CustomLinearProgressIndicator(
                        callLogProvider.callLogs.status),
                  ),
                ],
              ),
            );
          } else {
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
                        padding: EdgeInsets.fromLTRB(Dimens.space0,
                            Dimens.space0, Dimens.space0, Dimens.space70.w),
                        child: EmptyViewUiWidget(
                          assetUrl: "assets/images/no_conversation.png",
                          title: Utils.getString('noCallLogs'),
                          desc: Utils.getString('noCallLogsDescription'),
                          buttonTitle: Utils.getString('startConversation'),
                          icon: Icons.add_circle_outline,
                          onPressed: widget.onStartConversationTap,
                        ),
                      ),
                    ));
              },
            );
          }
        } else {
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
                      margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0,
                          Dimens.space0, Dimens.space0),
                      child: SpinKitCircle(
                        color: CustomColors.mainColor,
                      )),
                ),
              );
            },
          );
        }
      }),
    );
  }

  void _channelSelectionDialog({BuildContext context, WorkspaceDetail workspaceDetails, String clientNumber, String clientName, String flagUrl, String clientId, String clientProfilePicture})
  {
    showModalBottomSheet(
      context: context,
      elevation: 0,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
          height: ScreenUtil().screenHeight * 0.48,
          child: ChannelSelectionDialog(
            channelList: workspaceDetails.workspaceChannel,
            onChannelTap: (WorkspaceChannel data)
            {
              widget.makeCallWithSid(
                data.number,
                data.name,
                data.id,
                data.countryLogo,
                clientNumber,
                callLogProvider.getDefaultWorkspace(),
                callLogProvider.getMemberId(),
                callLogProvider.getVoiceToken(),
                clientName,
                clientId,
                flagUrl,
                clientProfilePicture,
              );
            },
          )
      ),
    );
  }
}
