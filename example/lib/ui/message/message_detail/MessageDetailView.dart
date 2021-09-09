import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/constant/RoutePaths.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/contacts/ContactsProvider.dart';
import 'package:voice_example/provider/messages/MessageDetailsProvider.dart';
import 'package:voice_example/repository/ContactRepository.dart';
import 'package:voice_example/repository/MessageDetailsRepository.dart';
import 'package:voice_example/ui/common/ButtonWidget.dart';
import 'package:voice_example/ui/common/ChatTextFiledWidgetWithIcon.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/ui/common/dialog/ChannelSelectionDialog.dart';
import 'package:voice_example/ui/common/dialog/ClientDndMuteDialog.dart';
import 'package:voice_example/ui/common/dialog/ClientDndUnMuteDialog.dart';
import 'package:voice_example/ui/common/dialog/ContactDetailDialog.dart';
import 'package:voice_example/ui/common/dialog/ErrorDialog.dart';
import 'package:voice_example/ui/common/indicator/CustomLinearProgressIndicator.dart';
import 'package:voice_example/ui/common/indicator/linear_percent_indicator.dart';
import 'package:voice_example/ui/message/message_detail/SideMenuWidget.dart';
import 'package:voice_example/utils/PsProgressDialog.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/AddContactIntentHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/AddNotesIntentHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/AddTagIntentHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/SearchConversationIntenHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/contactPinUnpinRequestParamHolder/ContactPinUnpinRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/updateClientDNDRequestParamHolder/UpdateClientDndHolder.dart';
import 'package:voice_example/viewobject/model/call/RecentConversationEdges.dart';
import 'package:voice_example/viewobject/model/call/RecentConversationNodes.dart';
import 'package:voice_example/viewobject/model/clientDndResponse/ClientDndResponse.dart';
import 'package:voice_example/viewobject/model/sendMessage/Messages.dart';
import 'package:voice_example/viewobject/model/workspace/workspace_detail/WorkspaceChannel.dart';
import 'package:voice_example/viewobject/model/workspace/workspace_detail/WorkspaceDetail.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

enum CallState {
  PENDING,
  SENT,
  FAILED,
  DELIVERED,
  NOANSWER,
  BUSY,
  COMPLETED,
  CANCELED,
  ATTEMPTED,
  INPROGRESS,
  RINGING,
  ONHOLD
}

String _convertCallTime(
    String callTime, String inputFormat, String outputFormat) {
  if (callTime != null) {
    String date = "";
    try {
      var dateFormat = DateFormat(outputFormat);
      String createdDate =
          dateFormat.format(DateTime.parse(callTime + 'Z').toLocal());
      date = createdDate;
    } on Exception catch (_) {}
    return date;
  } else {
    return "";
  }
}

String convertDateToTime(String dateTime) {
  String time = "";
  if (dateTime != null) {
    try {
      var strToDateTime = DateTime.parse(dateTime);
      final convertLocal = strToDateTime.toLocal();
      time = DateFormat.jm().format(convertLocal);
      // time = DateFormat.jm().format(DateTime.parse(convertLocal));
    } catch (e) {
    }
  }
  return time;
}

class MessageDetailView extends StatefulWidget {
  const MessageDetailView({
    Key key,
    @required this.clientId,
    @required this.clientPhoneNumber,
    @required this.clientName,
    @required this.clientProfilePicture,
    @required this.lastChatted,
    @required this.countryId,
    @required this.countryFlagUrl,
    @required this.isBlocked,
    @required this.dndMissed,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
    @required this.makeCallWithSid,
  }) : super(key: key);

  final String clientId;
  final String clientPhoneNumber;
  final String clientName;
  final String clientProfilePicture;
  final String countryId;
  final String countryFlagUrl;
  final String lastChatted;
  final bool isBlocked;
  final bool dndMissed;
  final Function onIncomingTap;
  final Function onOutgoingTap;
  final Function(String, String, String, String, String, String, String, String,
      String, String, String, String) makeCallWithSid;

  @override
  MessageDetailState createState() => MessageDetailState();
}

class MessageDetailState extends State<MessageDetailView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  final ScrollController _scrollController = ScrollController();

  MessageDetailsProvider messagesProvider;
  MessageDetailsRepository messagesRepository;

  ContactRepository contactRepository;
  ContactsProvider contactsProvider;

  ValueHolder valueHolder;

  bool isConnectedToInternet = false;
  bool isSendIconVisible = false;
  bool isLoading = false;
  final TextEditingController textEditingControllerMessage =
      TextEditingController();
  final FocusNode focusNode = FocusNode();
  GlobalKey<SliderMenuContainerState> _key =
      GlobalKey<SliderMenuContainerState>();
  String contactId;
  String contactNumber;

  @override
  void initState() {
    super.initState();
    contactId = widget.clientId;
    contactNumber = widget.clientPhoneNumber;
    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        messagesProvider.doPreviousConversationDetailByContactApiCall(
            widget.clientPhoneNumber);
      }
      // if (_scrollController.position.pixels ==
      //     _scrollController.position.minScrollExtent) {
      //   messagesProvider.doNextConversationDetailByContactApiCall(
      //       widget.clientPhoneNumber);
      // }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      if (_key.currentState.isDrawerOpen) {
        _key.currentState.closeDrawer();
      } else {
        animationController.reverse().then<dynamic>(
          (void data) {
            if (!mounted) {
              return Future<bool>.value(false);
            }
            Navigator.pop(context, true);
            return Future<bool>.value(true);
          },
        );
      }
      return Future<bool>.value(false);
    }

    valueHolder = Provider.of<ValueHolder>(context);
    messagesRepository = Provider.of<MessageDetailsRepository>(context);
    contactRepository = Provider.of<ContactRepository>(context);

    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
          backgroundColor: CustomColors.mainBackgroundColor,
          body: SafeArea(
            child: MultiProvider(
              providers: <SingleChildWidget>[
                ChangeNotifierProvider<ContactsProvider>(
                    lazy: false,
                    create: (BuildContext context) {
                      isLoading = true;
                      this.contactsProvider = ContactsProvider(
                          contactRepository: contactRepository);
                      contactsProvider
                          .doContactDetailApiCall(contactId)
                          .then((data) {
                        isLoading = false;
                        setState(() {});
                      });
                      ContactPinUnpinRequestHolder param =
                          ContactPinUnpinRequestHolder(
                        channel: contactsProvider.getDefaultChannel().id,
                        contact: widget.clientPhoneNumber,
                        pinned: false,
                      );
                      contactsProvider.doGetAllNotesApiCall(param);
                      return contactsProvider;
                    }),
                ChangeNotifierProvider<MessageDetailsProvider>(
                    lazy: false,
                    create: (BuildContext context) {
                      this.messagesProvider = MessageDetailsProvider(
                          messageDetailsRepository: messagesRepository);
                      messagesProvider
                          .doConversationDetailByContactApiCall(
                              (widget.clientPhoneNumber))
                          .then((value) {
                        messagesProvider.doSubscriptionUpdateConversationDetail(
                            widget.clientPhoneNumber);
                        // messagesProvider.doSubscriptionOnlineMemberStatusDetail(contactsProvider.getWorkspaceDetail().id);
                      });
                      return messagesProvider;
                    }),
              ],
              child: Consumer<MessageDetailsProvider>(
                builder: (BuildContext context, MessageDetailsProvider provider,
                    Widget child) {
                  return SliderMenuContainer(
                    key: _key,
                    isDraggable: true,
                    isTitleCenter: false,
                    hasAppBar: true,
                    trailing: Container(
                      alignment: Alignment.center,
                      width: kToolbarHeight,
                      height: kTextTabBarHeight,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              CustomColors.white,
                              CustomColors.white,
                              CustomColors.bottomAppBarColor,
                            ]),
                      ),
                      child: RoundedNetworkImageHolder(
                        width: kToolbarHeight,
                        height: kToolbarHeight,
                        boxFit: BoxFit.cover,
                        containerAlignment: Alignment.center,
                        iconUrl: CustomIcon.icon_arrow_left,
                        iconColor: CustomColors.loadingCircleColor,
                        iconSize: Dimens.space24,
                        boxDecorationColor: CustomColors.transparent,
                        outerCorner: Dimens.space0,
                        innerCorner: Dimens.space0,
                        imageUrl: "",
                        onTap: () {
                          _requestPop();
                        },
                      ),
                    ),
                    drawerIcon: Container(
                      alignment: Alignment.center,
                      width: kToolbarHeight,
                      height: kTextTabBarHeight,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              CustomColors.white,
                              CustomColors.white,
                              CustomColors.bottomAppBarColor,
                            ]),
                      ),
                      child: RoundedNetworkImageHolder(
                        width: kToolbarHeight,
                        height: kTextTabBarHeight,
                        boxFit: BoxFit.cover,
                        containerAlignment: Alignment.center,
                        iconUrl: CustomIcon.icon_more_vertical,
                        iconColor: CustomColors.mainColor,
                        iconSize: Dimens.space20,
                        boxDecorationColor: CustomColors.transparent,
                        outerCorner: Dimens.space0,
                        innerCorner: Dimens.space0,
                        imageUrl: "",
                        onTap: () {
                          if (_key.currentState.isDrawerOpen) {
                            _key.currentState.closeDrawer();
                          } else {
                            _key.currentState.openDrawer();
                          }
                        },
                      ),
                    ),
                    sliderMenuOpenSize: ScreenUtil().screenWidth * 0.90,
                    appBarHeight: kToolbarHeight.h,
                    appBarPadding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    title: Container(
                      alignment: Alignment.center,
                      width: kToolbarHeight,
                      height: kTextTabBarHeight,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              CustomColors.white,
                              CustomColors.white,
                              CustomColors.bottomAppBarColor,
                            ]),
                      ),
                      child: TextButton(
                        onPressed: () {
                          // Navigator.pushNamed(context,
                          //     RoutePaths.userDetails,
                          //     arguments: MessageDetailIntentHolder(
                          //         clientName: widget.clientName,
                          //         clientPhoneNumber: widget.clientPhoneNumber,
                          //         clientProfilePicture: widget.clientProfilePicture
                          //     )
                          // );
                        },
                        style: TextButton.styleFrom(
                          alignment: Alignment.center,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                        ),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: isLoading
                              ? Container()
                              : ImageAndTextWidget(
                                  listConversationEdge: messagesProvider
                                      ?.listConversationDetails?.data,
                                  isBlocked: contactsProvider
                                          ?.contactDetailResponse
                                          ?.data
                                          ?.contactDetailResponseData
                                          ?.contacts
                                          ?.blocked ??
                                      false,
                                  clientName: contactsProvider
                                                  .contactDetailResponse.data !=
                                              null &&
                                          contactsProvider.contactDetailResponse.data
                                                  .contactDetailResponseData.contacts !=
                                              null
                                      ? contactsProvider
                                          .contactDetailResponse
                                          .data
                                          .contactDetailResponseData
                                          .contacts
                                          .name
                                      : widget.clientName,
                                  clientNumber:
                                      contactsProvider.contactDetailResponse
                                                      .data !=
                                                  null &&
                                              contactsProvider
                                                      .contactDetailResponse
                                                      .data
                                                      .contactDetailResponseData
                                                      .contacts !=
                                                  null
                                          ? contactsProvider
                                              .contactDetailResponse
                                              .data
                                              .contactDetailResponseData
                                              .contacts
                                              .number
                                          : widget.clientPhoneNumber,
                                  clientProfilePicture:
                                      contactsProvider.contactDetailResponse
                                                      .data !=
                                                  null &&
                                              contactsProvider
                                                      .contactDetailResponse
                                                      .data
                                                      .contactDetailResponseData
                                                      .contacts !=
                                                  null
                                          ? contactsProvider
                                              .contactDetailResponse
                                              .data
                                              .contactDetailResponseData
                                              .contacts
                                              .profilePicture
                                          : widget.clientProfilePicture,
                                  flagUrl: contactsProvider
                                                  .contactDetailResponse.data !=
                                              null &&
                                          contactsProvider
                                                  .contactDetailResponse
                                                  .data
                                                  .contactDetailResponseData
                                                  .contacts !=
                                              null
                                      ? contactsProvider
                                          .contactDetailResponse
                                          .data
                                          .contactDetailResponseData
                                          .contacts
                                          .flagUrl
                                      : widget.countryFlagUrl,
                                  lastChatted: widget.lastChatted,
                                  onCallIconTap: () async {
                                    if (messagesProvider
                                            .getWorkspaceDetail()
                                            .workspaceChannel
                                            .length ==
                                        1) {
                                      widget.makeCallWithSid(
                                          messagesProvider
                                              .getDefaultChannel()
                                              .number,
                                          messagesProvider
                                              .getDefaultChannel()
                                              .name,
                                          messagesProvider
                                              .getDefaultChannel()
                                              .id,
                                          messagesProvider
                                              .getDefaultChannel()
                                              .countryLogo,
                                          widget.clientPhoneNumber,
                                          messagesProvider
                                              .getDefaultWorkspace(),
                                          messagesProvider.getMemberId(),
                                          messagesProvider.getVoiceToken(),
                                          widget.clientName,
                                          widget.clientId,
                                          widget.countryFlagUrl,
                                          widget.clientProfilePicture);
                                    } else {
                                      _channelSelectionDialog(
                                        context: context,
                                        workspaceDetails: messagesProvider
                                            .getWorkspaceDetail(),
                                      );
                                    }
                                  },
                                ),
                        ),
                      ),
                    ),
                    slideDirection: SlideDirection.RIGHT_TO_LEFT,
                    sliderMenu: SliderMenuWidget(
                      onIncomingTap: () {
                        widget.onIncomingTap();
                      },
                      onOutgoingTap: () {
                        widget.onOutgoingTap();
                      },
                      makeCallWithSid: (channelNumber,
                          channelName,
                          channelSid,
                          channelFlagUrl,
                          outgoingNumber,
                          workspaceSid,
                          memberId,
                          voiceToken,
                          outgoingName,
                          outgoingId,
                          outgoingFlagUrl,
                          outgoingProfilePicture) {
                        widget.makeCallWithSid(
                            channelNumber,
                            channelName,
                            channelSid,
                            channelFlagUrl,
                            outgoingNumber,
                            workspaceSid,
                            memberId,
                            voiceToken,
                            outgoingName,
                            outgoingId,
                            outgoingFlagUrl,
                            outgoingProfilePicture);
                      },
                      isBlocked: contactsProvider?.contactDetailResponse?.data
                              ?.contactDetailResponseData?.contacts?.blocked ??
                          false,
                      onContactDetailTap: () async {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(Dimens.space16.r),
                            ),
                            backgroundColor: Colors.white,
                            builder: (BuildContext context) {
                              return ContactDetailDialog(
                                contactId: contactId,
                                contactNumber: contactNumber,
                                onContactUpdate: () {
                                  contactsProvider
                                      .doContactDetailApiCall(contactId)
                                      .then((value) {
                                    setState(() {});
                                  });
                                },
                                onIncomingTap: () {
                                  widget.onIncomingTap();
                                },
                                onOutgoingTap: () {
                                  widget.onOutgoingTap();
                                },
                                makeCallWithSid: (channelNumber,
                                    channelName,
                                    channelSid,
                                    channelFlagUrl,
                                    outgoingNumber,
                                    workspaceSid,
                                    memberId,
                                    voiceToken,
                                    outgoingName,
                                    outgoingId,
                                    outgoingFlagUrl,
                                    outgoingProfilePicture) {
                                  widget.makeCallWithSid(
                                    channelNumber,
                                    channelName,
                                    channelSid,
                                    channelFlagUrl,
                                    outgoingNumber,
                                    workspaceSid,
                                    memberId,
                                    voiceToken,
                                    outgoingName,
                                    outgoingId,
                                    outgoingFlagUrl,
                                    outgoingProfilePicture,
                                  );
                                },
                              );
                            }).then((returnData) {
                          contactsProvider
                              .doContactDetailApiCall(contactId)
                              .then((value) {
                            setState(() {});
                          });
                          ContactPinUnpinRequestHolder param =
                              ContactPinUnpinRequestHolder(
                            channel: contactsProvider.getDefaultChannel().id,
                            contact: contactNumber,
                            pinned: false,
                          );
                          contactsProvider
                              .doGetAllNotesApiCall(param)
                              .then((value) {
                            setState(() {});
                          });
                        });
                      },
                      onAddContactTap: () async {
                        final dynamic returnData = await Navigator.pushNamed(
                          context,
                          RoutePaths.newContact,
                          arguments: AddContactIntentHolder(
                            phoneNumber:
                                contactsProvider.contactDetailResponse.data !=
                                            null &&
                                        contactsProvider
                                                .contactDetailResponse
                                                .data
                                                .contactDetailResponseData
                                                .contacts !=
                                            null
                                    ? contactsProvider
                                        .contactDetailResponse
                                        .data
                                        .contactDetailResponseData
                                        .contacts
                                        .number
                                    : widget.clientPhoneNumber,
                            //TODO replace Default Country code
                            defaultCountryCode: null,
                            onIncomingTap: () {
                              widget.onIncomingTap();
                            },
                            onOutgoingTap: () {
                              widget.onOutgoingTap();
                            },
                          ),
                        );
                        if (returnData != null &&
                            returnData["data"] is bool &&
                            returnData["data"]) {
                          contactsProvider
                              .doContactDetailApiCall(returnData["clientId"])
                              .then((value) {
                            setState(() {
                              contactId = returnData["clientId"];
                            });
                          });
                        }
                      },
                      onTapSearchConversation: () async {
                        final dynamic returnData = await Navigator.pushNamed(
                            context, RoutePaths.searchConversation,
                            arguments: SearchConversationIntentHolder(
                              contactsProvider.contactDetailResponse.data !=
                                          null &&
                                      contactsProvider
                                              .contactDetailResponse
                                              .data
                                              .contactDetailResponseData
                                              .contacts !=
                                          null
                                  ? contactsProvider.contactDetailResponse.data
                                      .contactDetailResponseData.contacts.number
                                  : widget.clientPhoneNumber,
                              contactsProvider.contactDetailResponse.data !=
                                          null &&
                                      contactsProvider.contactDetailResponse.data
                                              .contactDetailResponseData.contacts !=
                                          null
                                  ? contactsProvider.contactDetailResponse.data
                                      .contactDetailResponseData.contacts.name
                                  : widget.clientName,
                              animationController,
                            ));
                        if (returnData != null &&
                            returnData["data"] is bool &&
                            returnData["data"]) {
                          _key.currentState.closeDrawer();
                          if (returnData["afterWith"] !=
                              returnData['beforeWith']) {
                            messagesProvider
                                .doSearchConversationWithCursorApiCall(
                                    widget.clientPhoneNumber,
                                    returnData["afterWith"],
                                    returnData['beforeWith'])
                                .then((value) {
                              Future.delayed(Duration(seconds: 1), () {
                                if (_scrollController.hasClients) {
                                  _scrollController.jumpTo(_scrollController
                                      .position.maxScrollExtent);
                                  if (_scrollController.position.hasPixels) {
                                    messagesProvider
                                        .doPreviousConversationDetailByContactApiCall(
                                            widget.clientPhoneNumber);
                                  }
                                }
                              });
                            });
                          } else {
                            Future.delayed(Duration(seconds: 1), () {
                              if (_scrollController.hasClients) {
                                _scrollController.jumpTo(
                                    _scrollController.position.minScrollExtent);
                              }
                            });
                          }
                        }
                      },
                      clientId:
                          contactsProvider.contactDetailResponse.data != null &&
                                  contactsProvider.contactDetailResponse.data
                                          .contactDetailResponseData.contacts !=
                                      null
                              ? contactsProvider.contactDetailResponse.data
                                  .contactDetailResponseData.contacts.id
                              : contactId,
                      clientName: contactsProvider.contactDetailResponse.data !=
                                  null &&
                              contactsProvider.contactDetailResponse
                                      .data.contactDetailResponseData.contacts !=
                                  null
                          ? contactsProvider.contactDetailResponse.data
                              .contactDetailResponseData.contacts.name
                          : widget.clientName,
                      clientPhoneNumber: widget.clientPhoneNumber,
                      countryId: widget.countryId,
                      countryFlagUrl:
                          contactsProvider.contactDetailResponse.data != null &&
                                  contactsProvider.contactDetailResponse.data
                                          .contactDetailResponseData.contacts !=
                                      null
                              ? contactsProvider.contactDetailResponse.data
                                  .contactDetailResponseData.contacts.flagUrl
                              : widget.countryFlagUrl,
                      clientProfilePicture:
                          contactsProvider.contactDetailResponse.data != null &&
                                  contactsProvider.contactDetailResponse.data
                                          .contactDetailResponseData.contacts !=
                                      null
                              ? contactsProvider
                                  .contactDetailResponse
                                  .data
                                  .contactDetailResponseData
                                  .contacts
                                  .profilePicture
                              : widget.clientProfilePicture,
                      tags:
                          contactsProvider.contactDetailResponse.data != null &&
                                  contactsProvider.contactDetailResponse.data
                                          .contactDetailResponseData !=
                                      null
                              ? contactsProvider.contactDetailResponse.data
                                  .contactDetailResponseData.contacts.tags
                              : null,
                      dndMissed: widget.dndMissed,
                      lastChatted: widget.lastChatted,
                      dndEnabled:
                          contactsProvider.contactDetailResponse.data != null &&
                                  contactsProvider.contactDetailResponse.data
                                          .contactDetailResponseData !=
                                      null &&
                                  contactsProvider.contactDetailResponse.data
                                          .contactDetailResponseData.contacts !=
                                      null
                              ? contactsProvider.contactDetailResponse.data
                                  .contactDetailResponseData.contacts.dndEnabled
                              : false,
                      notes: contactsProvider.notes.data,
                      onNotesTap: () async {
                        final dynamic returnData = await Navigator.pushNamed(
                            context, RoutePaths.notesList,
                            arguments: AddNotesIntentHolder(
                              clientId: contactId,
                              number:
                                  contactsProvider.contactDetailResponse.data !=
                                              null &&
                                          contactsProvider
                                                  .contactDetailResponse
                                                  .data
                                                  .contactDetailResponseData
                                                  .contacts !=
                                              null
                                      ? contactsProvider
                                          .contactDetailResponse
                                          .data
                                          .contactDetailResponseData
                                          .contacts
                                          .number
                                      : widget.clientPhoneNumber,
                              onIncomingTap: () {
                                widget.onIncomingTap();
                              },
                              onOutgoingTap: () {
                                widget.onOutgoingTap();
                              },
                            ));
                        if (returnData != null &&
                            returnData['data'] != null &&
                            returnData['data']) {
                          ContactPinUnpinRequestHolder param =
                              ContactPinUnpinRequestHolder(
                            channel: contactsProvider.getDefaultChannel().id,
                            contact: contactNumber,
                            pinned: false,
                          );
                          return contactsProvider
                              .doGetAllNotesApiCall(param)
                              .then((value) {
                            setState(() {
                              contactId = returnData['clientId'];
                              contactsProvider
                                  .doContactDetailApiCall(contactId);
                            });
                          });
                        }
                      },
                      onAddTagsTap: () async {
                        final dynamic returnData = await Navigator.pushNamed(
                            context, RoutePaths.addNewTag,
                            arguments: AddTagIntentHolder(
                              clientId: contactId,
                              name: contactsProvider
                                              .contactDetailResponse.data !=
                                          null &&
                                      contactsProvider.contactDetailResponse.data
                                              .contactDetailResponseData.contacts !=
                                          null
                                  ? contactsProvider.contactDetailResponse.data
                                      .contactDetailResponseData.contacts.name
                                  : widget.clientName,
                              profilePicture:
                                  contactsProvider.contactDetailResponse.data !=
                                              null &&
                                          contactsProvider
                                                  .contactDetailResponse
                                                  .data
                                                  .contactDetailResponseData
                                                  .contacts !=
                                              null
                                      ? contactsProvider
                                          .contactDetailResponse
                                          .data
                                          .contactDetailResponseData
                                          .contacts
                                          .profilePicture
                                      : widget.clientProfilePicture,
                              number:
                                  contactsProvider.contactDetailResponse.data !=
                                              null &&
                                          contactsProvider
                                                  .contactDetailResponse
                                                  .data
                                                  .contactDetailResponseData
                                                  .contacts !=
                                              null
                                      ? contactsProvider
                                          .contactDetailResponse
                                          .data
                                          .contactDetailResponseData
                                          .contacts
                                          .number
                                      : widget.clientPhoneNumber,
                              countryId: widget.countryId,
                              company:
                                  contactsProvider.contactDetailResponse.data !=
                                              null &&
                                          contactsProvider
                                                  .contactDetailResponse
                                                  .data
                                                  .contactDetailResponseData
                                                  .contacts !=
                                              null
                                      ? contactsProvider
                                          .contactDetailResponse
                                          .data
                                          .contactDetailResponseData
                                          .contacts
                                          .company
                                      : "",
                              address:
                                  contactsProvider.contactDetailResponse.data !=
                                              null &&
                                          contactsProvider
                                                  .contactDetailResponse
                                                  .data
                                                  .contactDetailResponseData
                                                  .contacts !=
                                              null
                                      ? contactsProvider
                                          .contactDetailResponse
                                          .data
                                          .contactDetailResponseData
                                          .contacts
                                          .address
                                      : "",
                              email:
                                  contactsProvider.contactDetailResponse.data !=
                                              null &&
                                          contactsProvider
                                                  .contactDetailResponse
                                                  .data
                                                  .contactDetailResponseData
                                                  .contacts !=
                                              null
                                      ? contactsProvider
                                          .contactDetailResponse
                                          .data
                                          .contactDetailResponseData
                                          .contacts
                                          .email
                                      : null,
                              visibility:
                                  contactsProvider.contactDetailResponse.data !=
                                              null &&
                                          contactsProvider
                                                  .contactDetailResponse
                                                  .data
                                                  .contactDetailResponseData
                                                  .contacts !=
                                              null
                                      ? contactsProvider
                                          .contactDetailResponse
                                          .data
                                          .contactDetailResponseData
                                          .contacts
                                          .visibility
                                      : false,
                              countryFlag: contactsProvider
                                              .contactDetailResponse.data !=
                                          null &&
                                      contactsProvider
                                              .contactDetailResponse
                                              .data
                                              .contactDetailResponseData
                                              .contacts !=
                                          null
                                  ? contactsProvider
                                      .contactDetailResponse
                                      .data
                                      .contactDetailResponseData
                                      .contacts
                                      .flagUrl
                                  : widget.countryFlagUrl,
                              tags:
                                  contactsProvider.contactDetailResponse.data !=
                                              null &&
                                          contactsProvider
                                                  .contactDetailResponse
                                                  .data
                                                  .contactDetailResponseData !=
                                              null
                                      ? contactsProvider
                                          .contactDetailResponse
                                          .data
                                          .contactDetailResponseData
                                          .contacts
                                          .tags
                                      : null,
                              onIncomingTap: () {
                                widget.onIncomingTap();
                              },
                              onOutgoingTap: () {
                                widget.onOutgoingTap();
                              },
                            ));
                        if (returnData != null &&
                            returnData['data'] != null &&
                            returnData['data']) {
                          setState(() {
                            contactId = returnData['clientId'];
                            contactsProvider
                                .doContactDetailApiCall(contactId)
                                .then((value) {
                              setState(() {});
                            });
                          });
                        }
                      },
                      onCallTap: () async {
                        if (messagesProvider
                                .getWorkspaceDetail()
                                .workspaceChannel
                                .length ==
                            1) {
                          widget.makeCallWithSid(
                              messagesProvider.getDefaultChannel().number,
                              messagesProvider.getDefaultChannel().name,
                              messagesProvider.getDefaultChannel().id,
                              messagesProvider.getDefaultChannel().countryLogo,
                              widget.clientPhoneNumber,
                              messagesProvider.getDefaultWorkspace(),
                              messagesProvider.getMemberId(),
                              messagesProvider.getVoiceToken(),
                              widget.clientName,
                              widget.clientId,
                              widget.countryFlagUrl,
                              widget.clientProfilePicture);
                        } else {
                          _channelSelectionDialog(
                            context: context,
                            workspaceDetails:
                                messagesProvider.getWorkspaceDetail(),
                          );
                        }
                      },
                      onMuteTap: () async {
                        _showMuteDialog(
                            context: context,
                            clientName: widget.clientName,
                            onMuteTap: (int minutes, bool value) {
                              onMuteTap(minutes, value);
                            });
                      },
                      onUnMuteTap: () {
                        _showUnMuteDialog(
                          context: context,
                          clientName: widget.clientName,
                          dndEndTime: 0,
                          onUnMuteTap: (bool value) {
                            onMuteTap(0, value);
                          },
                        );
                      },
                    ),
                    sliderMain: Container(
                      alignment: Alignment.topCenter,
                      color: CustomColors.white,
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.fromLTRB(
                                      Dimens.space0.w,
                                      Dimens.space0.h,
                                      Dimens.space0.w,
                                      Dimens.space0.h),
                                  color: CustomColors.white,
                                  child: buildListMessage(messagesProvider
                                      .listConversationDetails.data),
                                ),
                              ),
                              // Input content
                              Container(
                                alignment: Alignment.bottomCenter,
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0,
                                    Dimens.space0,
                                    Dimens.space0,
                                    Dimens.space0),
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space0,
                                    Dimens.space0,
                                    Dimens.space0,
                                    Dimens.space0.h),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Divider(
                                      color: CustomColors.mainDividerColor,
                                      height: Dimens.space1.h,
                                      thickness: Dimens.space1.h,
                                    ),
                                    isLoading
                                        ? Container()
                                        : contactsProvider
                                                    ?.contactDetailResponse
                                                    ?.data
                                                    ?.contactDetailResponseData
                                                    ?.contacts
                                                    ?.blocked ??
                                                false
                                            ? Container(
                                                height: Dimens.space56.w,
                                                color: CustomColors
                                                    .bottomAppBarColor,
                                                child: Center(
                                                  child: Text(
                                                    Utils.getString(
                                                        'thisContactHasBeenBlocked'),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: CustomColors
                                                          .textTertiaryColor,
                                                      fontFamily:
                                                          Config.heeboRegular,
                                                      fontSize:
                                                          Dimens.space15.sp,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : ChatTextFieldWidgetWithIcon(
                                                listConversationEdge:
                                                    messagesProvider
                                                        .listConversationDetails
                                                        .data,
                                                animationController:
                                                    animationController,
                                                textEditingController:
                                                    textEditingControllerMessage,
                                                customIcon: CustomIcon
                                                    .icon_message_send,
                                                isSendIconVisible:
                                                    isSendIconVisible,
                                                onChanged: (value) {
                                                  if (value.isNotEmpty) {
                                                    setState(() {
                                                      isSendIconVisible = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      isSendIconVisible = false;
                                                    });
                                                  }
                                                },
                                                onSendTap: () async {
                                                  if (textEditingControllerMessage
                                                      .text.isNotEmpty) {
                                                    final Resources<Messages>
                                                        response =
                                                        await messagesProvider
                                                            .doSendMessageApiCall(
                                                                textEditingControllerMessage
                                                                    .text,
                                                                widget
                                                                    .clientPhoneNumber);
                                                    if (response != null &&
                                                        response.data != null) {
                                                      textEditingControllerMessage
                                                          .clear();
                                                      isSendIconVisible = false;
                                                    }
                                                  }
                                                },
                                              ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            child: CustomLinearProgressIndicator(
                                messagesProvider
                                    .listConversationDetails.status),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )),
    );
  }

  Widget buildListMessage(
      List<MessageDetailsObjectWithType> listConversationEdge) {
    if (listConversationEdge != null && listConversationEdge.isNotEmpty) {
      List<MessageDetailsObjectWithType> tempList =
          listConversationEdge.reversed.toList();
      return Container(
        alignment: Alignment.bottomCenter,
        color: CustomColors.white,
        margin: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
            Dimens.space16.w, Dimens.space10.h),
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        child: ListView.builder(
          reverse: true,
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          itemBuilder: (context, index) {
            if (tempList[index].type == "time") {
              if (index == 0) {
                return Container();
              } else {
                return Column(
                  children: [
                    messagesRepository.pageInfo != null &&
                            !messagesRepository.pageInfo.hasNextPage &&
                            index == tempList.length - 1
                        ? Container(
                            color: CustomColors.white,
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space36.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            child: EmptyConversationWidget(
                              title: contactsProvider
                                              .contactDetailResponse.data !=
                                          null &&
                                      contactsProvider.contactDetailResponse.data
                                              .contactDetailResponseData.contacts !=
                                          null
                                  ? contactsProvider.contactDetailResponse.data
                                      .contactDetailResponseData.contacts.name
                                  : widget.clientName,
                              message: Utils.getString("beginningMessage"),
                              imageUrl:
                                  contactsProvider.contactDetailResponse.data !=
                                              null &&
                                          contactsProvider
                                                  .contactDetailResponse
                                                  .data
                                                  .contactDetailResponseData
                                                  .contacts !=
                                              null
                                      ? contactsProvider
                                          .contactDetailResponse
                                          .data
                                          .contactDetailResponseData
                                          .contacts
                                          .profilePicture
                                      : widget.clientProfilePicture,
                              flagUrl:
                                  contactsProvider
                                                  .contactDetailResponse.data !=
                                              null &&
                                          contactsProvider
                                                  .contactDetailResponse
                                                  .data
                                                  .contactDetailResponseData
                                                  .contacts !=
                                              null
                                      ? contactsProvider
                                          .contactDetailResponse
                                          .data
                                          .contactDetailResponseData
                                          .contacts
                                          .flagUrl
                                      : widget.countryFlagUrl,
                              isContact:
                                  contactsProvider.contactDetailResponse.data !=
                                              null &&
                                          contactsProvider
                                                  .contactDetailResponse
                                                  .data
                                                  .contactDetailResponseData
                                                  .contacts !=
                                              null
                                      ? true
                                      : false,
                              onAddContactTap: () async {
                                final dynamic returnData =
                                    await Navigator.pushNamed(
                                  context,
                                  RoutePaths.newContact,
                                  arguments: AddContactIntentHolder(
                                    phoneNumber: contactsProvider
                                                    .contactDetailResponse.data !=
                                                null &&
                                            contactsProvider
                                                    .contactDetailResponse
                                                    .data
                                                    .contactDetailResponseData
                                                    .contacts !=
                                                null
                                        ? contactsProvider
                                            .contactDetailResponse
                                            .data
                                            .contactDetailResponseData
                                            .contacts
                                            .number
                                        : widget.clientPhoneNumber,
                                    //TODO replace Default Country code
                                    defaultCountryCode: null,
                                    onIncomingTap: () {
                                      widget.onIncomingTap();
                                    },
                                    onOutgoingTap: () {
                                      widget.onOutgoingTap();
                                    },
                                  ),
                                );
                                if (returnData != null &&
                                    returnData["data"] is bool &&
                                    returnData["data"]) {
                                  contactsProvider
                                      .doContactDetailApiCall(
                                          returnData["clientId"])
                                      .then((value) {
                                    setState(() {
                                      contactId = returnData["clientId"];
                                    });
                                  });
                                }
                              },
                            ),
                          )
                        : Container(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Dimens.space5.w),
                              topRight: Radius.circular(Dimens.space5.w),
                              bottomLeft: Radius.circular(Dimens.space5.w),
                              bottomRight: Radius.circular(Dimens.space5.w),
                            ),
                            color: CustomColors.bottomAppBarColor,
                          ),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space12.w,
                              Dimens.space6.h,
                              Dimens.space12.w,
                              Dimens.space6.h),
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space16.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: Text(
                            Utils.convertDateTime(
                                tempList[index].time.split("T")[0],
                                DateFormat("yyyy-MM-dd")),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: CustomColors.mainColor,
                              fontFamily: Config.heeboRegular,
                              fontSize: Dimens.space12.sp,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              }
            } else {
              if (tempList[index].edges.recentConversationNodes.direction ==
                  "Incoming")
                return InboundListHandlerView(
                    conversationEdge: tempList[index].edges,
                    boxDecorationType: tempList[index].messageBoxDecorationType,
                    onCallTap: () {
                      onCallTap(tempList[index].edges);
                    },
                    callbackVoice: (v) {
                      for (int i = 0; i < tempList.length; i++) {
                        if (i != index) {
                          try {
                            if (tempList[i].edges.advancedPlayer != null) {
                              setState(() {
                                tempList[i].edges.isPlay = false;
                                tempList[i].edges.advancedPlayer.stop();
                                tempList[i].edges.seekData = "0";
                              });
                            }
                          } catch (e) {
                          }
                        }
                      }
                    });
              else
                return OutBoundListHandlerView(
                    conversationEdge: tempList[index].edges,
                    onResendTap: () async {
                      if (textEditingControllerMessage.text.isNotEmpty) {
                        final Resources<Messages> response =
                            await messagesProvider.doSendMessageApiCall(
                                tempList[index]
                                    .edges
                                    .recentConversationNodes
                                    .content
                                    .body,
                                widget.clientPhoneNumber);
                        if (response != null && response.data != null) {
                          textEditingControllerMessage.clear();
                        }
                      }
                    },
                    boxDecorationType: tempList[index].messageBoxDecorationType,
                    onCallTap: () {
                      onCallTap(tempList[index].edges);
                    },
                    callbackVoice: (v) {
                      for (int i = 0; i < tempList.length; i++) {
                        if (i != index) {
                          try {
                            if (tempList[i].edges.advancedPlayer != null) {
                              setState(() {
                                tempList[i].edges.isPlay = false;
                                tempList[i].edges.advancedPlayer.stop();
                                tempList[i].edges.seekData = "0";
                              });
                            }
                          } catch (e) {
                          }
                        }
                      }
                    });
            }
          },
          itemCount: tempList.length,
          controller: _scrollController,
        ),
      );
    } else {
      animationController.forward();
      final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
          .animate(CurvedAnimation(
              parent: animationController,
              curve:
                  const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
      return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 100 * (1.0 - animation.value), 0.0),
              child: Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(
                    Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                child: SpinKitCircle(
                  color: CustomColors.mainColor,
                ),
              ),
            ),
          );
        },
      );
    }
  }

  void _channelSelectionDialog(
      {BuildContext context, WorkspaceDetail workspaceDetails}) {
    showModalBottomSheet(
      context: context,
      elevation: 0,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
          height: ScreenUtil().screenHeight * 0.48,
          child: ChannelSelectionDialog(
            channelList: workspaceDetails.workspaceChannel,
            onChannelTap: (WorkspaceChannel data) {
              widget.makeCallWithSid(
                data.number,
                data.name,
                data.id,
                data.countryLogo,
                widget.clientPhoneNumber,
                messagesProvider.getDefaultWorkspace(),
                messagesProvider.getMemberId(),
                messagesProvider.getVoiceToken(),
                widget.clientName,
                widget.clientId,
                widget.countryFlagUrl,
                widget.clientProfilePicture,
              );
            },
          )),
    );
  }

  void onCallTap(RecentConversationEdges conversationEdge) async {
    if (messagesProvider.getWorkspaceDetail().workspaceChannel.length == 1) {
      widget.makeCallWithSid(
          messagesProvider.getDefaultChannel().number,
          messagesProvider.getDefaultChannel().name,
          messagesProvider.getDefaultChannel().id,
          messagesProvider.getDefaultChannel().countryLogo,
          widget.clientPhoneNumber,
          messagesProvider.getDefaultWorkspace(),
          messagesProvider.getMemberId(),
          messagesProvider.getVoiceToken(),
          widget.clientName,
          widget.clientId,
          widget.countryFlagUrl,
          widget.clientProfilePicture);
    } else {
      _channelSelectionDialog(
        context: context,
        workspaceDetails: messagesProvider.getWorkspaceDetail(),
      );
    }
  }

  /*Note: need to uncomment this section and call this function frm call tap to
  * select the channel if required and need to connect wih workpace provider and repo to make
  * it functional*/

  // _onCallTap() async {
  //   bool connectivity = await Utils.checkInternetConnectivity();
  //
  //   if (connectivity) {
  //     PsProgressDialog.showDialog(context, message: "Loading...");
  //
  //     /*Fetch the channel from
  //     * collection or remote server*/
  //     Resources<List<WorkspaceChannel>> resources =
  //         await workspaceProvider.getChannelList();
  //
  //     if (resources.data != null) {
  //       PsProgressDialog.dismissDialog();
  //       /*
  //       * Check whether list has singvalue
  //       * if single:directly redicet to outging call
  //       * else multiple:show channel selection dialog*/
  //
  //       if (resources.data.isNotEmpty && resources.data.length > 1) {
  //         _showChannelSelectionDialog(
  //             list: resources.data,
  //             onChannelTap: (WorkspaceChannel channel) {
  //               initializeCall(channel.number, channel.id);
  //             });
  //       } else {
  //         initializeCall(messagesProvider.getDefaultChannel().number,
  //             messagesProvider.getDefaultChannel().id);
  //       }
  //     } else {
  //       PsProgressDialog.dismissDialog();
  //       initializeCall(messagesProvider.getDefaultChannel().number,
  //           messagesProvider.getDefaultChannel().id);
  //     }
  //   } else {
  //     initializeCall(messagesProvider.getDefaultChannel().number,
  //         messagesProvider.getDefaultChannel().id);
  //   }
  // }

  void _showUnMuteDialog(
      {BuildContext context,
      String clientName,
      int dndEndTime,
      Function onUnMuteTap}) {
    showModalBottomSheet(
      context: context,
      elevation: 0,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
          height: ScreenUtil().screenHeight * 0.3,
          child: ClientDndUnMuteDialog(
            clientName: clientName,
            onUmMuteTap: () {
              Navigator.of(context).pop();
              onUnMuteTap(true);
            },
            dndEndTime: dndEndTime,
          )),
    );
  }

  void _showMuteDialog(
      {BuildContext context, String clientName, Function onMuteTap}) {
    showModalBottomSheet(
      context: context,
      elevation: 0,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
          height: ScreenUtil().screenHeight * 0.57,
          child: ClientDndMuteDialog(
            clientName: clientName,
            onMuteTap: (int minutes, bool value) {
              Navigator.of(context).pop();
              onMuteTap(minutes, value);
            },
          )),
    );
  }

  void onMuteTap(int minutes, bool value) async {
    bool checkConnectivity = await Utils.checkInternetConnectivity();
    if (checkConnectivity) {
      PsProgressDialog.showDialog(context);
      UpdateClientDNDRequestParamHolder updateClientDNDRequestParamHolder =
          UpdateClientDNDRequestParamHolder(
        contact: widget.clientPhoneNumber,
        minutes: minutes,
        removeFromDND: value,
      );
      Resources<ClientDndResponse> _resource = await contactsProvider
          .doClientDndApiCall(updateClientDNDRequestParamHolder);
      if (_resource.status == Status.ERROR) {
        PsProgressDialog.dismissDialog();
        Utils.showToastMessage(_resource.message);
      } else {
        contactsProvider
            .doContactDetailApiCall(
                _resource.data.clientDndResponseData.contacts.id)
            .then((value) {
          setState(() {});
        });
        PsProgressDialog.dismissDialog();
      }
    } else {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: Utils.getString('noInternet'),
            );
          });
    }
  }
}

// Outgoing List Handler

class OutBoundListHandlerView extends StatelessWidget {
  OutBoundListHandlerView({
    @required this.conversationEdge,
    Key key,
    this.onResendTap,
    this.onCallTap,
    this.boxDecorationType,
    this.callbackVoice,
  }) : super(key: key);

  final RecentConversationEdges conversationEdge;
  final Function onResendTap;
  final Function onCallTap;
  final String boxDecorationType;
  final Function(RecentConversationEdges) callbackVoice;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (conversationEdge.recentConversationNodes.conversationType ==
            "Message") {
          if (conversationEdge.recentConversationNodes.conversationStatus ==
                  "DELIVERED" ||
              conversationEdge.recentConversationNodes.conversationStatus ==
                  "SENT") {
            return OutGoingMessageView(
              conversationEdge: conversationEdge,
              boxDecorationType: boxDecorationType,
            );
          } else if (conversationEdge
                  .recentConversationNodes.conversationStatus ==
              "PENDING") {
            return PendingMessageView(
              conversationEdge: conversationEdge,
              boxDecorationType: boxDecorationType,
            );
          } else {
            return NotSendMessageView(
              conversationEdge: conversationEdge,
              onReSendTap: onResendTap,
              boxDecorationType: boxDecorationType,
            );
          }
        } else if (conversationEdge.recentConversationNodes.conversationType ==
            "Call") {
          if (conversationEdge.recentConversationNodes.conversationStatus ==
              "NOANSWER") {
            if (conversationEdge.recentConversationNodes.reject != null &&
                conversationEdge.recentConversationNodes.reject) {
              return CallRejectedView(
                conversationEdge: conversationEdge,
                onCallTap: onCallTap,
              );
            } else {
              return OutgoingCallNoAnswerView(
                conversationEdge: conversationEdge,
              );
            }
          } else if (conversationEdge
                  .recentConversationNodes.conversationStatus ==
              "BUSY") {
            return OutgoingCallBusyView(conversationEdge: conversationEdge);
          } else if (conversationEdge
                  .recentConversationNodes.conversationStatus ==
              "ATTEMPTED") {
            return OutgoingCallAttemptedView(
                conversationEdge: conversationEdge);
          }else if (conversationEdge
                  .recentConversationNodes.conversationStatus ==
              "FAILED") {
            return CallFailedView(
                conversationEdge: conversationEdge);
          } else if (conversationEdge
                  .recentConversationNodes.conversationStatus ==
              "CANCELLED") {
            return OutgoingCallCanceledView(
              conversationEdge: conversationEdge,
            );
          } else if (conversationEdge
                  .recentConversationNodes.conversationStatus ==
              "COMPLETED") {
            //todo recording
            return OutGoingCallView(
              conversationEdge: conversationEdge,
            );
          } else if (conversationEdge
                      .recentConversationNodes.conversationStatus ==
                  "PENDING" ||
              conversationEdge.recentConversationNodes.conversationStatus ==
                  "CALLING") {
            return OutGoingCallingView(
              conversationEdge: conversationEdge,
            );
          } else if (conversationEdge
                  .recentConversationNodes.conversationStatus ==
              "RINGING") {
            return OutGoingRingingView(
              conversationEdge: conversationEdge,
            );
          } else if (conversationEdge
                  .recentConversationNodes.conversationStatus ==
              "INPROGRESS") {

            return OutGoingInProgressView(
              conversationEdge: conversationEdge,
            );
          } else if (conversationEdge
                  .recentConversationNodes.conversationStatus ==
              "ATTEMPTED") {
            return OutgoingCallAttemptedView(
                conversationEdge: conversationEdge);
          } else {
            return OutgoingCallBusyView(conversationEdge: conversationEdge);
          }
        } else {
          return Container();
        }
      },
    );
  }
}

class OutGoingMessageView extends StatefulWidget {
  final RecentConversationEdges conversationEdge;
  final String boxDecorationType;

  const OutGoingMessageView(
      {Key key, this.conversationEdge, this.boxDecorationType})
      : super(key: key);

  @override
  _OutGoingMessageViewState createState() => _OutGoingMessageViewState();
}

class _OutGoingMessageViewState extends State<OutGoingMessageView> {
  bool timeStamp = true;

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
    return Container(
        margin: Utils.setMessageViewMarginByMessageDecorationType(
            widget.boxDecorationType),
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        alignment: Alignment.centerRight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space14.w,
                        Dimens.space10.h, Dimens.space14.w, Dimens.space10.h),
                    decoration: Utils.setOutBoundMessageBoxDecoration(
                        widget.boxDecorationType),
                    child: GestureDetector(
                      onLongPress: () {
                        timeStamp = !timeStamp;
                        setState(() {});
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            constraints: BoxConstraints(
                              maxWidth: Dimens.space200.w,
                            ),
                            child: Text(
                              "${widget.conversationEdge.recentConversationNodes.content.body}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: CustomColors.white,
                                    fontFamily: Config.heeboRegular,
                                    fontSize: Dimens.space16.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Offstage(
                      offstage: timeStamp,
                      child: Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              alignment: Alignment.center,
                              child: Text(
                                "${_convertCallTime(widget.conversationEdge.recentConversationNodes.createdAt.split("+")[0], 'yyyy-MM-ddThh:mm:ss.SSSSSS', "hh:mm a")}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space13.sp,
                                      color: CustomColors.textTertiaryColor,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                              ),
                            ),
                            Icon(
                              Icons.check_circle_outline,
                              size: 16,
                              color: CustomColors.callAcceptColor,
                            ),
                          ],
                        ),
                      ))
                ]),
          ],
        ));
  }
}

class PendingMessageView extends StatelessWidget {
  final RecentConversationEdges conversationEdge;
  final String boxDecorationType;

  const PendingMessageView(
      {Key key, this.conversationEdge, this.boxDecorationType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: Utils.setMessageViewMarginByMessageDecorationType(
            boxDecorationType),
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        alignment: Alignment.centerRight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space14.w, Dimens.space10.h,
                  Dimens.space14.w, Dimens.space10.h),
              decoration:
                  Utils.setOutBoundMessageBoxDecoration(boxDecorationType),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    constraints: BoxConstraints(
                      maxWidth: Dimens.space200.w,
                    ),
                    child: Text(
                      "${conversationEdge.recentConversationNodes.content.body}",
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: CustomColors.white,
                            fontFamily: Config.heeboRegular,
                            fontSize: Dimens.space16.sp,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class NotSendMessageView extends StatefulWidget {
  final RecentConversationEdges conversationEdge;
  final String boxDecorationType;
  final Function onReSendTap;

  NotSendMessageView(
      {Key key,
      this.conversationEdge,
      this.onReSendTap,
      this.boxDecorationType})
      : super(key: key);

  @override
  _NotSendMessageViewState createState() {
    return _NotSendMessageViewState();
  }
}

class _NotSendMessageViewState extends State<NotSendMessageView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: Utils.setMessageViewMarginByMessageDecorationType(
          widget.boxDecorationType),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      alignment: Alignment.centerRight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: RoundedNetworkImageHolder(
                        width: Dimens.space36,
                        height: Dimens.space36,
                        boxFit: BoxFit.cover,
                        containerAlignment: Alignment.center,
                        iconUrl: Icons.refresh_outlined,
                        iconColor: CustomColors.textPrimaryErrorColor,
                        iconSize: Dimens.space20,
                        boxDecorationColor: CustomColors.bottomAppBarColor,
                        outerCorner: Dimens.space300,
                        innerCorner: Dimens.space300,
                        imageUrl: "",
                        onTap: () {
                          widget.onReSendTap(widget.conversationEdge
                              .recentConversationNodes.content.body);
                        }),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.fromLTRB(Dimens.space11.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space14.w,
                        Dimens.space10.h, Dimens.space14.w, Dimens.space10.h),
                    decoration: Utils.setFailedMessageBoxDecoration(
                        widget.boxDecorationType),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          constraints: BoxConstraints(
                            maxWidth: Dimens.space200.w,
                          ),
                          child: Text(
                            "${widget.conversationEdge.recentConversationNodes.content.body}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                                    color: CustomColors.redButtonColor,
                                    fontFamily: Config.heeboRegular,
                                    fontSize: Dimens.space16.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.info,
                      size: Dimens.space20.w,
                      color: CustomColors.textPrimaryErrorColor,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(Dimens.space3.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      alignment: Alignment.center,
                      child: Text(
                        Utils.getString("failedToSend"),
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontFamily: Config.heeboMedium,
                            fontSize: Dimens.space12.sp,
                            color: CustomColors.textPrimaryErrorColor,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class OutGoingCallView extends StatelessWidget {
  final RecentConversationEdges conversationEdge;

  OutGoingCallView({Key key, this.conversationEdge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space16.h,
            Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space14.w, Dimens.space10.h,
                  Dimens.space14.w, Dimens.space10.h),
              decoration: BoxDecoration(
                color: CustomColors.bottomAppBarColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.space15.w),
                  topRight: Radius.circular(Dimens.space15.w),
                  bottomLeft: Radius.circular(Dimens.space15.w),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: RoundedNetworkImageHolder(
                      width: Dimens.space40,
                      height: Dimens.space40,
                      boxFit: BoxFit.cover,
                      containerAlignment: Alignment.center,
                      iconUrl: CustomIcon.icon_call_outgoing,
                      iconColor: CustomColors.callAcceptColor,
                      iconSize: Dimens.space21,
                      boxDecorationColor: CustomColors.mainDividerColor,
                      outerCorner: Dimens.space300,
                      innerCorner: Dimens.space0,
                      imageUrl: "",
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space10.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
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
                              Utils.getString("callEnded"),
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                      color: CustomColors.textPrimaryColor,
                                      fontFamily: Config.manropeBold,
                                      fontSize: Dimens.space16.sp,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal),
                            )),
                        Container(
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
                            _printCallTimeDuration(
                                conversationEdge.recentConversationNodes),
                            // "${_convertCallTime(conversationEdge.recentConversationNodes.createdAt.split("+")[0], 'yyyy-MM-ddThh:mm:ss.SSSSSS', "hh:mm a")}",
                            // "${conversationEdge.recentConversationNodes.content.duration} - ${_convertCallTime(conversationEdge.recentConversationNodes.content.callTime, "EEE, dd MMM yyyy hh:mm:ss +0000", "hh:mm a")}",
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      fontFamily: Config.heeboRegular,
                                      color: CustomColors.textTertiaryColor,
                                      fontSize: Dimens.space13.sp,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class OutGoingCallingView extends StatelessWidget {
  final RecentConversationEdges conversationEdge;

  OutGoingCallingView({Key key, this.conversationEdge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space16.h,
            Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space14.w, Dimens.space10.h,
                  Dimens.space14.w, Dimens.space10.h),
              decoration: BoxDecoration(
                color: CustomColors.bottomAppBarColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.space15.w),
                  topRight: Radius.circular(Dimens.space15.w),
                  bottomLeft: Radius.circular(Dimens.space15.w),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: RoundedNetworkImageHolder(
                      width: Dimens.space40,
                      height: Dimens.space40,
                      boxFit: BoxFit.cover,
                      containerAlignment: Alignment.center,
                      iconUrl: CustomIcon.icon_call_outgoing,
                      iconColor: CustomColors.callAcceptColor,
                      iconSize: Dimens.space21,
                      boxDecorationColor: CustomColors.mainDividerColor,
                      outerCorner: Dimens.space300,
                      innerCorner: Dimens.space0,
                      imageUrl: "",
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space10.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
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
                              Utils.getString("calling1"),
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.manropeBold,
                                    fontSize: Dimens.space16.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                            )),
                        Container(
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
                            Utils.getString("callingDesc"),
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space13.sp,
                                      color: CustomColors.textTertiaryColor,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class OutGoingRingingView extends StatelessWidget {
  final RecentConversationEdges conversationEdge;

  OutGoingRingingView({Key key, this.conversationEdge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space16.h,
            Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space14.w, Dimens.space10.h,
                  Dimens.space14.w, Dimens.space10.h),
              decoration: BoxDecoration(
                color: CustomColors.bottomAppBarColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.space15.w),
                  topRight: Radius.circular(Dimens.space15.w),
                  bottomLeft: Radius.circular(Dimens.space15.w),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: RoundedNetworkImageHolder(
                      width: Dimens.space40,
                      height: Dimens.space40,
                      boxFit: BoxFit.cover,
                      containerAlignment: Alignment.center,
                      iconUrl: CustomIcon.icon_call_outgoing,
                      iconColor: CustomColors.callAcceptColor,
                      iconSize: Dimens.space21,
                      boxDecorationColor: CustomColors.mainDividerColor,
                      outerCorner: Dimens.space300,
                      innerCorner: Dimens.space0,
                      imageUrl: "",
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space10.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
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
                              Utils.getString("ringing"),
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.manropeBold,
                                    fontSize: Dimens.space16.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                            )),
                        Container(
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
                            Utils.getString("ringingDesc"),
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space13.sp,
                                      color: CustomColors.textTertiaryColor,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class OutGoingInProgressView extends StatelessWidget {
  final RecentConversationEdges conversationEdge;

  OutGoingInProgressView({Key key, this.conversationEdge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space16.h,
            Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space14.w, Dimens.space10.h,
                  Dimens.space14.w, Dimens.space10.h),
              decoration: BoxDecoration(
                color: CustomColors.bottomAppBarColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.space15.w),
                  topRight: Radius.circular(Dimens.space15.w),
                  bottomLeft: Radius.circular(Dimens.space15.w),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: RoundedNetworkImageHolder(
                      width: Dimens.space40,
                      height: Dimens.space40,
                      boxFit: BoxFit.cover,
                      containerAlignment: Alignment.center,
                      iconUrl: CustomIcon.icon_call_outgoing,
                      iconColor: CustomColors.callAcceptColor,
                      iconSize: Dimens.space21,
                      boxDecorationColor: CustomColors.mainDividerColor,
                      outerCorner: Dimens.space300,
                      innerCorner: Dimens.space0,
                      imageUrl: "",
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space10.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
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
                              Utils.getString("inProgress"),
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.manropeBold,
                                    fontSize: Dimens.space16.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                            )),
                        Container(
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
                            Utils.getString("inProgress"),
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space13.sp,
                                      color: CustomColors.textTertiaryColor,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class OutgoingCallBusyView extends StatelessWidget {
  final RecentConversationEdges conversationEdge;

  OutgoingCallBusyView({Key key, this.conversationEdge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space16.h,
            Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space14.w, Dimens.space10.h,
                  Dimens.space14.w, Dimens.space10.h),
              decoration: BoxDecoration(
                color: CustomColors.bottomAppBarColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.space15.w),
                  topRight: Radius.circular(Dimens.space15.w),
                  bottomLeft: Radius.circular(Dimens.space15.w),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: RoundedNetworkImageHolder(
                      width: Dimens.space40,
                      height: Dimens.space40,
                      boxFit: BoxFit.cover,
                      containerAlignment: Alignment.center,
                      iconUrl: CustomIcon.icon_call_busy,
                      iconColor: CustomColors.textPrimaryErrorColor,
                      iconSize: Dimens.space21,
                      boxDecorationColor: CustomColors.mainDividerColor,
                      outerCorner: Dimens.space300,
                      innerCorner: Dimens.space0,
                      imageUrl: "",
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space10.w,
                        Dimens.space0.w, Dimens.space0.w, Dimens.space0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
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
                              Utils.getString("busy"),
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                      color: CustomColors.textPrimaryColor,
                                      fontFamily: Config.manropeBold,
                                      fontSize: Dimens.space16.sp,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal),
                            )),
                        Container(
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
                            "${_convertCallTime(conversationEdge.recentConversationNodes.createdAt.split("+")[0], 'yyyy-MM-ddThh:mm:ss.SSSSSS', "hh:mm a")}",
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      fontFamily: Config.heeboRegular,
                                      color: CustomColors.textTertiaryColor,
                                      fontSize: Dimens.space13.sp,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class OutgoingCallAttemptedView extends StatelessWidget {
  final RecentConversationEdges conversationEdge;

  OutgoingCallAttemptedView({Key key, this.conversationEdge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space16.h,
            Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space14.w, Dimens.space10.h,
                  Dimens.space14.w, Dimens.space10.h),
              decoration: BoxDecoration(
                color: CustomColors.bottomAppBarColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.space15.w),
                  topRight: Radius.circular(Dimens.space15.w),
                  bottomLeft: Radius.circular(Dimens.space15.w),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: RoundedNetworkImageHolder(
                      width: Dimens.space40,
                      height: Dimens.space40,
                      boxFit: BoxFit.cover,
                      containerAlignment: Alignment.center,
                      iconUrl: CustomIcon.icon_call_cancelled,
                      iconColor: CustomColors.textPrimaryErrorColor,
                      iconSize: Dimens.space21,
                      boxDecorationColor: CustomColors.mainDividerColor,
                      outerCorner: Dimens.space300,
                      innerCorner: Dimens.space0,
                      imageUrl: "",
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space10.w,
                        Dimens.space0.w, Dimens.space0.w, Dimens.space0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
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
                              Utils.getString("callAttempted"),
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                      color: CustomColors.textPrimaryColor,
                                      fontFamily: Config.manropeBold,
                                      fontSize: Dimens.space16.sp,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal),
                            )),
                        Container(
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
                            "${_convertCallTime(conversationEdge.recentConversationNodes.createdAt.split("+")[0], 'yyyy-MM-ddThh:mm:ss.SSSSSS', "hh:mm a")}",
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      fontFamily: Config.heeboRegular,
                                      color: CustomColors.textTertiaryColor,
                                      fontSize: Dimens.space13.sp,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class OutgoingCallNoAnswerView extends StatelessWidget {
  final RecentConversationEdges conversationEdge;

  OutgoingCallNoAnswerView({Key key, this.conversationEdge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: EdgeInsets.fromLTRB(
            Dimens.space0, Dimens.space6.h, Dimens.space0, Dimens.space6.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space8.h,
                  Dimens.space0, Dimens.space8.h),
              padding: EdgeInsets.fromLTRB(Dimens.space14.w, Dimens.space12.h,
                  Dimens.space14.w, Dimens.space12.h),
              decoration: BoxDecoration(
                color: CustomColors.bottomAppBarColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.space15.w),
                  topRight: Radius.circular(Dimens.space15.w),
                  bottomLeft: Radius.circular(Dimens.space15.w),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: Dimens.space40.w,
                    height: Dimens.space40.w,
                    decoration: BoxDecoration(
                      color: CustomColors.mainDividerColor,
                      borderRadius: BorderRadius.all(Radius.elliptical(
                          Dimens.space40.w, Dimens.space40.w)),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      CustomIcon.icon_call_no_answer,
                      size: Dimens.space24.w,
                      color: CustomColors.redButtonColor,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space10.w,
                        Dimens.space0.w, Dimens.space0.w, Dimens.space0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space4.h,
                                Dimens.space0.w,
                                Dimens.space4.h),
                            child: Text(
                              Utils.getString("noAnswer"),
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.bodyText2.copyWith(
                                  color: CustomColors.textPrimaryColor,
                                  fontFamily: Config.manropeBold,
                                  fontSize: Dimens.space14.sp,
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.w700,
                                  height: 1),
                            )),
                        Container(
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
                            "${_convertCallTime(conversationEdge.recentConversationNodes.createdAt.split("+")[0], 'yyyy-MM-ddThh:mm:ss.SSSSSS', "hh:mm a")}",
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      fontFamily: Config.heeboRegular,
                                      color: CustomColors.textTertiaryColor,
                                      fontSize: Dimens.space13.sp,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class OutgoingCallCanceledView extends StatelessWidget {
  final RecentConversationEdges conversationEdge;

  OutgoingCallCanceledView({Key key, this.conversationEdge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space16.h,
            Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space14.w, Dimens.space10.h,
                  Dimens.space14.w, Dimens.space10.h),
              decoration: BoxDecoration(
                color: CustomColors.bottomAppBarColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.space15.w),
                  topRight: Radius.circular(Dimens.space15.w),
                  bottomLeft: Radius.circular(Dimens.space15.w),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: RoundedNetworkImageHolder(
                      width: Dimens.space40,
                      height: Dimens.space40,
                      boxFit: BoxFit.cover,
                      containerAlignment: Alignment.center,
                      iconUrl: CustomIcon.icon_call_cancelled,
                      iconColor: CustomColors.textPrimaryLightColor,
                      iconSize: Dimens.space21,
                      boxDecorationColor: CustomColors.mainDividerColor,
                      outerCorner: Dimens.space300,
                      innerCorner: Dimens.space0,
                      imageUrl: "",
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space10.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
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
                              Utils.getString("callCancelled"),
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.manropeBold,
                                    fontSize: Dimens.space16.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                            )),
                        Container(
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
                            "${_convertCallTime(conversationEdge.recentConversationNodes.createdAt.split("+")[0], 'yyyy-MM-ddThh:mm:ss.SSSSSS', "hh:mm a")}",
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      fontFamily: Config.heeboRegular,
                                      color: CustomColors.textTertiaryColor,
                                      fontSize: Dimens.space13.sp,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class CallFailedView extends StatelessWidget {
  final RecentConversationEdges conversationEdge;
  final MessageDetailsProvider messageDetailsProvider;
  final ValueHolder valueHolder;
  final AnimationController animationController;
  final String clientPhoneNumber;
  final String clientName;
  final String clientProfilePicture;
  final String clientId;
  final String flagUrl;
  final Function makeCallWithSid;

  const CallFailedView(
      {Key key,
      this.conversationEdge,
      this.messageDetailsProvider,
      @required this.clientId,
      @required this.clientPhoneNumber,
      @required this.clientName,
      @required this.clientProfilePicture,
      @required this.flagUrl,
      @required this.makeCallWithSid,
      this.valueHolder,
      this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(
            Dimens.space0, Dimens.space6.h, Dimens.space0, Dimens.space6.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space8.h,
                  Dimens.space0, Dimens.space8.h),
              padding: EdgeInsets.fromLTRB(Dimens.space14.w, Dimens.space12.h,
                  Dimens.space14.w, Dimens.space12.h),
              decoration: BoxDecoration(
                color: CustomColors.redButtonColor.withOpacity(0.2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.space15.w),
                  topRight: Radius.circular(Dimens.space15.w),
                  bottomLeft: Radius.circular(Dimens.space15.w),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: Dimens.space40.w,
                        height: Dimens.space40.w,
                        decoration: BoxDecoration(
                          color: CustomColors.redButtonColor.withOpacity(0.3),
                          borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.space20.w)),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.call,
                          size: Dimens.space24.w,
                          color: CustomColors.redButtonColor,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(Dimens.space10.w,
                            Dimens.space0.w, Dimens.space0.w, Dimens.space0.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space4.h,
                                    Dimens.space0.w,
                                    Dimens.space4.h),
                                child: Text(
                                  Utils.getString("callFailed"),
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                          color: CustomColors.textPrimaryColor,
                                          fontFamily: Config.manropeBold,
                                          fontSize: Dimens.space14.sp,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.w700,
                                          height: 1),
                                )),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space2.h,
                                  Dimens.space0.w,
                                  Dimens.space2.h),
                              child: Text(
                                  _printCallTimeDuration(conversationEdge.recentConversationNodes),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        fontFamily: Config.heeboRegular,
                                        fontSize: Dimens.space13.sp,
                                        color: CustomColors.textTertiaryColor,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.w400,
                                        height: 1),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Visibility(
                    visible: false,
                    child: Container(
                      width: Dimens.space178.w,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space10.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      alignment: Alignment.center,
                      child: RoundedButtonWidget(
                        width: Dimens.space178.w,
                        height: Dimens.space34.w,
                        corner: Dimens.space10,
                        buttonBackgroundColor: CustomColors.redButtonColor,
                        buttonTextColor: CustomColors.white,
                        buttonText: Utils.getString('redial'),
                        buttonBorderColor: CustomColors.redButtonColor,
                        fontStyle: FontStyle.normal,
                        buttonFontFamily: Config.heeboRegular,
                        buttonFontSize: Dimens.space16,
                        buttonFontWeight: FontWeight.normal,
                        onPressed: () async {
                          makeCallWithSid();
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class CallRejectedView extends StatelessWidget {
  final RecentConversationEdges conversationEdge;
  final Function onCallTap;

  CallRejectedView({Key key, this.conversationEdge, this.onCallTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space16.h,
            Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space14.w, Dimens.space10.h,
                  Dimens.space14.w, Dimens.space10.h),
              decoration: BoxDecoration(
                color: CustomColors.errorBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.space15.w),
                  topRight: Radius.circular(Dimens.space15.w),
                  bottomLeft: Radius.circular(Dimens.space15.w),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: RoundedNetworkImageHolder(
                          width: Dimens.space40,
                          height: Dimens.space40,
                          boxFit: BoxFit.cover,
                          containerAlignment: Alignment.center,
                          iconUrl: CustomIcon.icon_call_cancelled,
                          iconColor: CustomColors.redButtonColor,
                          iconSize: Dimens.space21,
                          boxDecorationColor:
                              CustomColors.redButtonColor.withOpacity(0.12),
                          outerCorner: Dimens.space300,
                          innerCorner: Dimens.space0,
                          imageUrl: "",
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(Dimens.space10.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
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
                                  Utils.getString("callRejected"),
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                          color: CustomColors.textPrimaryColor,
                                          fontFamily: Config.manropeBold,
                                          fontSize: Dimens.space16.sp,
                                          fontWeight: FontWeight.normal,
                                          fontStyle: FontStyle.normal),
                                )),
                            Container(
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
                                "${conversationEdge.recentConversationNodes.content.duration} - ${_convertCallTime(conversationEdge.recentConversationNodes.content.callTime, "EEE, dd MMM yyyy hh:mm:ss +0000", "hh:mm a")}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        fontFamily: Config.heeboRegular,
                                        fontSize: Dimens.space13.sp,
                                        color: CustomColors.textTertiaryColor,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.normal),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space8.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.center,
                    child: RoundedButtonWidget(
                        width: Dimens.space178.w,
                        height: Dimens.space34.w,
                        corner: Dimens.space10,
                        buttonBackgroundColor: CustomColors.redButtonColor,
                        buttonTextColor: CustomColors.white,
                        buttonText: Utils.getString('redial'),
                        buttonBorderColor: CustomColors.redButtonColor,
                        fontStyle: FontStyle.normal,
                        buttonFontFamily: Config.manropeSemiBold,
                        buttonFontSize: Dimens.space14,
                        buttonFontWeight: FontWeight.normal,
                        onPressed: onCallTap),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

// Incoming List Handler

class InboundListHandlerView extends StatelessWidget {
  const InboundListHandlerView({
    this.conversationEdge,
    Key key,
    this.onResendTap,
    this.onCallTap,
    this.boxDecorationType,
    this.callbackVoice,
  }) : super(key: key);
  final String boxDecorationType;
  final RecentConversationEdges conversationEdge;
  final Function onResendTap;
  final Function onCallTap;
  final Function(RecentConversationEdges) callbackVoice;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (conversationEdge.recentConversationNodes.conversationType ==
          "Message") {
        return IncomingMessageView(
          conversationEdge: conversationEdge,
          boxDecorationType: boxDecorationType,
        );
      } else if (conversationEdge.recentConversationNodes.conversationType ==
          "Call") {
        if (conversationEdge.recentConversationNodes.content.body != null) {
          return VoiceMailView(
              conversationEdge: conversationEdge,
              callback: (v) {
                callbackVoice(v);
              });
        } else if (conversationEdge
                .recentConversationNodes.conversationStatus ==
            "NOANSWER") {
          return IncomingCallMissedView(
            conversationEdge: conversationEdge,
            onCallTap: onCallTap,
          );
        } else if (conversationEdge
                .recentConversationNodes.conversationStatus ==
            "BUSY") {
          return IncomingCallRejectedView(
            conversationEdge: conversationEdge,
            onCallTap: onCallTap,
          );
        } else if (conversationEdge
                .recentConversationNodes.conversationStatus ==
            "COMPLETED") {
          return IncomingCallView(
            conversationEdge: conversationEdge,
          );
        } else if (conversationEdge
                .recentConversationNodes.conversationStatus ==
            "CANCELLED") {
          return IncomingCallCanceledView(conversationEdge: conversationEdge);
        } else if (conversationEdge
                .recentConversationNodes.conversationStatus ==
            "INPROGRESS") {
          return IncomingCallInProgress(
            conversationEdge: conversationEdge,
          );
        } else {
          return IncomingRingingView(
            conversationEdge: conversationEdge,
          );
        }
      } else {
        return VoiceMailView(
            conversationEdge: conversationEdge,
            callback: (v) {
              callbackVoice(v);
            });
      }
    });
  }
}

class IncomingMessageView extends StatefulWidget {
  final RecentConversationEdges conversationEdge;
  final MessageDetailsProvider messageDetailsProvider;
  final ValueHolder valueHolder;
  final String boxDecorationType;

  const IncomingMessageView(
      {Key key,
      this.conversationEdge,
      this.messageDetailsProvider,
      this.valueHolder,
      this.boxDecorationType})
      : super(key: key);

  @override
  _IncomingMessageViewState createState() {
    return _IncomingMessageViewState();
  }
}

class _IncomingMessageViewState extends State<IncomingMessageView> {
  bool timeStamp = true;

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
    return Container(
        alignment: Alignment.centerLeft,
        margin: Utils.setMessageViewMarginByMessageDecorationType(
            widget.boxDecorationType),
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space14.w,
                        Dimens.space10.h, Dimens.space14.w, Dimens.space10.h),
                    decoration: Utils.setInboundMessageBoxDecoration(
                        widget.boxDecorationType),
                    child: GestureDetector(
                      onLongPress: () {
                        timeStamp = !timeStamp;
                        setState(() {});
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                            constraints: BoxConstraints(
                              maxWidth: Dimens.space200.w,
                            ),
                            child: Text(
                              "${widget.conversationEdge.recentConversationNodes.content.body}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.heeboRegular,
                                    fontSize: Dimens.space16.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Offstage(
                    offstage: timeStamp,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${_convertCallTime(widget.conversationEdge.recentConversationNodes.createdAt.split("+")[0], 'yyyy-MM-ddThh:mm:ss.SSSSSS', "hh:mm a")}",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontFamily: Config.heeboRegular,
                              fontSize: Dimens.space13.sp,
                              color: CustomColors.textTertiaryColor,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                            ),
                      ),
                    ),
                  )
                ])
          ],
        ));
  }
}

class IncomingCallView extends StatelessWidget {
  final RecentConversationEdges conversationEdge;

  IncomingCallView({Key key, this.conversationEdge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space16.h,
            Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space14.w, Dimens.space10.h,
                  Dimens.space14.w, Dimens.space10.h),
              decoration: BoxDecoration(
                color: CustomColors.bottomAppBarColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.space15.w),
                  topRight: Radius.circular(Dimens.space15.w),
                  bottomRight: Radius.circular(Dimens.space15.w),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: RoundedNetworkImageHolder(
                      width: Dimens.space40,
                      height: Dimens.space40,
                      boxFit: BoxFit.cover,
                      containerAlignment: Alignment.center,
                      iconUrl: CustomIcon.icon_call_incoming,
                      iconColor: CustomColors.callAcceptColor,
                      iconSize: Dimens.space21,
                      boxDecorationColor: CustomColors.mainDividerColor,
                      outerCorner: Dimens.space300,
                      innerCorner: Dimens.space0,
                      imageUrl: "",
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space10.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
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
                              Utils.getString("callEnded"),
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.manropeBold,
                                    fontSize: Dimens.space16.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                            )),
                        Container(
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
                            "${_convertCallTime(conversationEdge.recentConversationNodes.createdAt.split("+")[0], 'yyyy-MM-ddThh:mm:ss.SSSSSS', "hh:mm a")}",
                            // "${conversationEdge.recentConversationNodes.content.duration} - ${_convertCallTime(conversationEdge.recentConversationNodes.content.callTime, "EEE, dd MMM yyyy hh:mm:ss +0000", "hh:mm a")}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    fontFamily: Config.heeboRegular,
                                    fontSize: Dimens.space13.sp,
                                    color: CustomColors.textTertiaryColor,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class IncomingCallCanceledView extends StatelessWidget {
  final RecentConversationEdges conversationEdge;

  IncomingCallCanceledView({Key key, this.conversationEdge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space16.h,
            Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space14.w, Dimens.space10.h,
                  Dimens.space14.w, Dimens.space10.h),
              decoration: BoxDecoration(
                color: CustomColors.bottomAppBarColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.space15.w),
                  topRight: Radius.circular(Dimens.space15.w),
                  bottomRight: Radius.circular(Dimens.space15.w),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: RoundedNetworkImageHolder(
                      width: Dimens.space40,
                      height: Dimens.space40,
                      boxFit: BoxFit.cover,
                      containerAlignment: Alignment.center,
                      iconUrl: CustomIcon.icon_call_cancelled,
                      iconColor: CustomColors.textPrimaryLightColor,
                      iconSize: Dimens.space21,
                      boxDecorationColor: CustomColors.mainDividerColor,
                      outerCorner: Dimens.space300,
                      innerCorner: Dimens.space0,
                      imageUrl: "",
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space10.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
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
                              Utils.getString("callCancelled"),
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.manropeBold,
                                    fontSize: Dimens.space16.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                            )),
                        Container(
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
                            "${conversationEdge.recentConversationNodes.content.duration} - ${_convertCallTime(conversationEdge.recentConversationNodes.content.callTime, "EEE, dd MMM yyyy hh:mm:ss +0000", "hh:mm a")}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    fontFamily: Config.heeboRegular,
                                    fontSize: Dimens.space13.sp,
                                    color: CustomColors.textTertiaryColor,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class IncomingCallMissedView extends StatelessWidget {
  final RecentConversationEdges conversationEdge;
  final Function onCallTap;

  IncomingCallMissedView({Key key, this.conversationEdge, this.onCallTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space16.h,
            Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space14.w, Dimens.space10.h,
                  Dimens.space14.w, Dimens.space10.h),
              decoration: BoxDecoration(
                color: CustomColors.bottomAppBarColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.space15.w),
                  topRight: Radius.circular(Dimens.space15.w),
                  bottomRight: Radius.circular(Dimens.space15.w),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: RoundedNetworkImageHolder(
                          width: Dimens.space40,
                          height: Dimens.space40,
                          boxFit: BoxFit.cover,
                          containerAlignment: Alignment.center,
                          iconUrl: CustomIcon.icon_call_missed,
                          iconColor: CustomColors.textPrimaryErrorColor,
                          iconSize: Dimens.space21,
                          boxDecorationColor: CustomColors.mainDividerColor,
                          outerCorner: Dimens.space300,
                          innerCorner: Dimens.space0,
                          imageUrl: "",
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(Dimens.space10.w,
                            Dimens.space0.w, Dimens.space0.w, Dimens.space0.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.w,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                child: Text(
                                  Utils.getString("missedCall"),
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                        color: CustomColors.textPrimaryColor,
                                        fontFamily: Config.manropeBold,
                                        fontSize: Dimens.space16.sp,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.normal,
                                      ),
                                )),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.w,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              child: conversationEdge
                                          .recentConversationNodes.content !=
                                      null
                                  ? Text(
                                      "${_convertCallTime(conversationEdge.recentConversationNodes.createdAt.split("+")[0], 'yyyy-MM-ddThh:mm:ss.SSSSSS', "hh:mm a")}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontFamily: Config.heeboRegular,
                                              color: CustomColors
                                                  .textTertiaryColor,
                                              fontSize: Dimens.space13.sp,
                                              fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.normal),
                                    )
                                  : Text(
                                      "${convertDateToTime(conversationEdge.recentConversationNodes.createdAt)}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontFamily: Config.heeboRegular,
                                              fontSize: Dimens.space13.sp,
                                              color: CustomColors
                                                  .textTertiaryColor,
                                              fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.normal),
                                    ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space8.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.center,
                    child: RoundedButtonWidget(
                        width: Dimens.space178.w,
                        height: Dimens.space34.w,
                        corner: Dimens.space10,
                        buttonBackgroundColor: CustomColors.loadingCircleColor,
                        buttonTextColor: CustomColors.white,
                        buttonText: Utils.getString('callBack'),
                        buttonBorderColor: CustomColors.loadingCircleColor,
                        fontStyle: FontStyle.normal,
                        buttonFontFamily: Config.manropeSemiBold,
                        buttonFontSize: Dimens.space14,
                        buttonFontWeight: FontWeight.normal,
                        onPressed: onCallTap),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class IncomingCallInProgress extends StatelessWidget {
  final RecentConversationEdges conversationEdge;

  IncomingCallInProgress({Key key, this.conversationEdge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space16.h,
            Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space14.w, Dimens.space10.h,
                  Dimens.space14.w, Dimens.space10.h),
              decoration: BoxDecoration(
                color: CustomColors.bottomAppBarColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.space15.w),
                  topRight: Radius.circular(Dimens.space15.w),
                  bottomLeft: Radius.circular(Dimens.space15.w),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: RoundedNetworkImageHolder(
                      width: Dimens.space40,
                      height: Dimens.space40,
                      boxFit: BoxFit.cover,
                      containerAlignment: Alignment.center,
                      iconUrl: CustomIcon.icon_call_incoming,
                      iconColor: CustomColors.callAcceptColor,
                      iconSize: Dimens.space21,
                      boxDecorationColor: CustomColors.mainDividerColor,
                      outerCorner: Dimens.space300,
                      innerCorner: Dimens.space0,
                      imageUrl: "",
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space10.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
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
                              Utils.getString("inProgress"),
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.manropeBold,
                                    fontSize: Dimens.space16.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                            )),
                        Container(
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
                            Utils.getString("inProgress"),
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space13.sp,
                                      color: CustomColors.textTertiaryColor,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class IncomingRingingView extends StatelessWidget {
  final RecentConversationEdges conversationEdge;

  IncomingRingingView({Key key, this.conversationEdge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space16.h,
            Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space14.w, Dimens.space10.h,
                  Dimens.space14.w, Dimens.space10.h),
              decoration: BoxDecoration(
                color: CustomColors.bottomAppBarColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.space15.w),
                  topRight: Radius.circular(Dimens.space15.w),
                  bottomLeft: Radius.circular(Dimens.space15.w),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: RoundedNetworkImageHolder(
                      width: Dimens.space40,
                      height: Dimens.space40,
                      boxFit: BoxFit.cover,
                      containerAlignment: Alignment.center,
                      iconUrl: CustomIcon.icon_call_incoming,
                      iconColor: CustomColors.callAcceptColor,
                      iconSize: Dimens.space21,
                      boxDecorationColor: CustomColors.mainDividerColor,
                      outerCorner: Dimens.space300,
                      innerCorner: Dimens.space0,
                      imageUrl: "",
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space10.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
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
                              Utils.getString("ringing"),
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.manropeBold,
                                    fontSize: Dimens.space16.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                            )),
                        Container(
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
                            Utils.getString("ringingDesc"),
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space13.sp,
                                      color: CustomColors.textTertiaryColor,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class IncomingCallRejectedView extends StatelessWidget {
  final RecentConversationEdges conversationEdge;
  final Function onCallTap;

  IncomingCallRejectedView({Key key, this.conversationEdge, this.onCallTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space16.h,
            Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space14.w, Dimens.space10.h,
                  Dimens.space14.w, Dimens.space10.h),
              decoration: BoxDecoration(
                color: CustomColors.bottomAppBarColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.space15.w),
                  topRight: Radius.circular(Dimens.space15.w),
                  bottomRight: Radius.circular(Dimens.space15.w),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: RoundedNetworkImageHolder(
                          width: Dimens.space40,
                          height: Dimens.space40,
                          boxFit: BoxFit.cover,
                          containerAlignment: Alignment.center,
                          iconUrl: CustomIcon.icon_call_missed,
                          iconColor: CustomColors.textPrimaryErrorColor,
                          iconSize: Dimens.space21,
                          boxDecorationColor: CustomColors.mainDividerColor,
                          outerCorner: Dimens.space300,
                          innerCorner: Dimens.space0,
                          imageUrl: "",
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(Dimens.space10.w,
                            Dimens.space0.w, Dimens.space0.w, Dimens.space0.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.w,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                child: Text(
                                  Utils.getString("rejectedCall"),
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                        color: CustomColors.textPrimaryColor,
                                        fontFamily: Config.manropeBold,
                                        fontSize: Dimens.space16.sp,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.normal,
                                      ),
                                )),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.w,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              child: conversationEdge
                                          .recentConversationNodes.content !=
                                      null
                                  ? Text(
                                      "${_convertCallTime(conversationEdge.recentConversationNodes.createdAt.split("+")[0], 'yyyy-MM-ddThh:mm:ss.SSSSSS', "hh:mm a")}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontFamily: Config.heeboRegular,
                                              color: CustomColors
                                                  .textTertiaryColor,
                                              fontSize: Dimens.space13.sp,
                                              fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.normal),
                                    )
                                  : Text(
                                      "${convertDateToTime(conversationEdge.recentConversationNodes.createdAt)}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontFamily: Config.heeboRegular,
                                              fontSize: Dimens.space13.sp,
                                              color: CustomColors
                                                  .textTertiaryColor,
                                              fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.normal),
                                    ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space8.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.center,
                    child: RoundedButtonWidget(
                        width: Dimens.space178.w,
                        height: Dimens.space34.w,
                        corner: Dimens.space10,
                        buttonBackgroundColor: CustomColors.loadingCircleColor,
                        buttonTextColor: CustomColors.white,
                        buttonText: Utils.getString('callBack'),
                        buttonBorderColor: CustomColors.loadingCircleColor,
                        fontStyle: FontStyle.normal,
                        buttonFontFamily: Config.manropeSemiBold,
                        buttonFontSize: Dimens.space14,
                        buttonFontWeight: FontWeight.normal,
                        onPressed: onCallTap),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

/*----------------------------------------------------------------------------------------------------------------*/

//Voice mail

class VoiceMailView extends StatefulWidget {
  final RecentConversationEdges conversationEdge;
  final Function(RecentConversationEdges) callback;

  const VoiceMailView({Key key, this.conversationEdge, this.callback})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VoiceMailViewState();
  }
}

class _VoiceMailViewState extends State<VoiceMailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {
        widget.conversationEdge.advancedPlayer = AudioPlayer();
      });

      widget.conversationEdge.advancedPlayer
          .setUrl(widget.conversationEdge.recentConversationNodes.content.body);
      widget.conversationEdge.advancedPlayer.onDurationChanged.listen((event) {
        setState(() {
          widget.conversationEdge.seekDataTotal = event.inSeconds.toString();
        });
      });
    });
  }

  @override
  void dispose() {
    widget.conversationEdge.advancedPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space16.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: Dimens.space260.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimens.space18.w),
                topRight: Radius.circular(Dimens.space18.w),
                bottomLeft: Radius.circular(Dimens.space2.w),
                bottomRight: Radius.circular(Dimens.space18.w),
              ),
              color: CustomColors.bottomAppBarColor,
            ),
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space14.w, Dimens.space10.h,
                Dimens.space14.w, Dimens.space10.h),
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: RoundedNetworkImageHolder(
                    width: Dimens.space40,
                    height: Dimens.space40,
                    boxFit: BoxFit.cover,
                    containerAlignment: Alignment.center,
                    iconUrl: widget.conversationEdge.isPlay
                        ? CustomIcon.icon_hold
                        : CustomIcon.icon_voice_mail_play,
                    iconColor: widget.conversationEdge.isPlay
                        ? CustomColors.warningColor
                        : CustomColors.mainColor,
                    iconSize: widget.conversationEdge.isPlay
                        ? Dimens.space21
                        : Dimens.space26,
                    boxDecorationColor: CustomColors.mainDividerColor,
                    outerCorner: Dimens.space300,
                    innerCorner: Dimens.space0,
                    imageUrl: "",
                    onTap: () async {
                      var voiceUrl = widget.conversationEdge
                          .recentConversationNodes.content.body;
                      if (widget.conversationEdge.isPlay) {
                        setState(() {
                          widget.conversationEdge.isPlay = false;
                        });
                        await widget.conversationEdge.advancedPlayer.pause();
                      } else {
                        await widget.conversationEdge.advancedPlayer
                            .play(voiceUrl);

                        widget.conversationEdge.advancedPlayer.onDurationChanged
                            .listen((event) {
                          setState(() {
                            widget.conversationEdge.seekDataTotal =
                                event.inSeconds.toString();
                          });
                        });
                        widget.conversationEdge.advancedPlayer
                            .onAudioPositionChanged
                            .listen((event) {
                          setState(() {
                            widget.conversationEdge.seekData =
                                event.inSeconds.toString();
                          });
                        });
                        setState(() {
                          widget.conversationEdge.isPlay = true;
                          widget.conversationEdge.advancedPlayer
                              .onPlayerCompletion
                              .listen((event) {
                            setState(() {
                              widget.conversationEdge.isPlay = false;
                              widget.conversationEdge.seekData = "0";
                            });
                          });
                        });
                        widget.callback(widget.conversationEdge);
                      }
                    },
                  ),
                ),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          Utils.getString('voiceMail'),
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: CustomColors.textPrimaryColor,
                              fontFamily: Config.manropeBold,
                              fontSize: Dimens.space16.sp,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space6.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space2.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.centerLeft,
                        child: LinearPercentIndicator(
                          lineHeight: Dimens.space10.h,
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          percent: widget.conversationEdge.seekData != "0"
                              ? (double.parse(
                                      widget.conversationEdge.seekData) /
                                  (double.parse(
                                      widget.conversationEdge.seekDataTotal)))
                              : 0,
                          // percent:double.parse(widget.conversationEdge.seekData)/60,
                          backgroundColor:
                              CustomColors.callInactiveColor.withOpacity(0.6),
                          progressColor: CustomColors.mainColor,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space6.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
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
                              child: RoundedNetworkImageHolder(
                                width: Dimens.space21,
                                height: Dimens.space21,
                                boxFit: BoxFit.cover,
                                containerAlignment: Alignment.center,
                                iconUrl: CustomIcon.icon_voice_mail,
                                iconColor: CustomColors.warningColor,
                                iconSize: Dimens.space21,
                                boxDecorationColor: CustomColors.transparent,
                                outerCorner: Dimens.space300,
                                innerCorner: Dimens.space0,
                                imageUrl: "",
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space4.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              child: Text(
                                '${_printDuration(Duration(seconds: int.parse(widget.conversationEdge.seekData)))}/${_printDuration(Duration(seconds: int.parse(widget.conversationEdge.seekDataTotal)))}',
                                textAlign: TextAlign.left,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      color: CustomColors.textTertiaryColor,
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space13.sp,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ToolBar Widget

class ImageAndTextWidget extends StatelessWidget {
  const ImageAndTextWidget({
    Key key,
    @required this.clientNumber,
    @required this.clientName,
    @required this.clientProfilePicture,
    @required this.onCallIconTap,
    @required this.flagUrl,
    @required this.lastChatted,
    @required this.isBlocked,
    @required this.listConversationEdge,
  }) : super(key: key);

  final String clientNumber;
  final String clientName;
  final String flagUrl;
  final String clientProfilePicture;
  final Function onCallIconTap;
  final String lastChatted;
  final bool isBlocked;
  final List<MessageDetailsObjectWithType> listConversationEdge;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(
            Dimens.space0, Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: Dimens.space40.w,
              height: Dimens.space40.w,
              margin: EdgeInsets.fromLTRB(Dimens.space12.w, Dimens.space0,
                  Dimens.space0, Dimens.space0),
              padding: EdgeInsets.fromLTRB(
                  Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
              child: RoundedNetworkImageHolder(
                width: Dimens.space40,
                height: Dimens.space40,
                boxFit: BoxFit.cover,
                containerAlignment: Alignment.bottomCenter,
                iconUrl: CustomIcon.icon_profile,
                iconColor: CustomColors.callInactiveColor,
                iconSize: Dimens.space34,
                boxDecorationColor: CustomColors.mainDividerColor,
                outerCorner: Dimens.space14,
                innerCorner: Dimens.space14,
                imageUrl:
                    clientProfilePicture != null ? clientProfilePicture : "",
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0,
                    Dimens.space0, Dimens.space0),
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(Dimens.space0,
                              Dimens.space0, Dimens.space0, Dimens.space0),
                          child: Text(
                            clientName != null
                                ? clientName
                                : Utils.getString("unknown"),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodyText2.copyWith(
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
                            margin: EdgeInsets.fromLTRB(Dimens.space6.w,
                                Dimens.space0, Dimens.space0, Dimens.space0),
                            child: RoundedNetworkSvgHolder(
                              containerWidth: Dimens.space16.w,
                              containerHeight: Dimens.space16.w,
                              boxFit: BoxFit.contain,
                              imageWidth: Dimens.space16.w,
                              imageHeight: Dimens.space16.w,
                              imageUrl: flagUrl != null
                                  ? Config.countryLogoUrl + flagUrl
                                  : "",
                              outerCorner: Dimens.space0.w,
                              innerCorner: Dimens.space0.w,
                              iconUrl: CustomIcon.icon_person,
                              iconColor: CustomColors.white,
                              iconSize: Dimens.space16.w,
                              boxDecorationColor: Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(
                        "${Utils.getString("lastContacted")} ${timeago.format(DateTime.now().subtract(DateTime.now().difference(DateTime.parse(lastChatted))), locale: 'en')}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: CustomColors.textTertiaryColor,
                            fontFamily: Config.heeboMedium,
                            fontSize: Dimens.space13.sp,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            listConversationEdge != null &&
                    listConversationEdge.isNotEmpty &&
                    !isBlocked
                ? Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: RoundedAssetSvgHolder(
                      containerWidth: Dimens.space40,
                      containerHeight: Dimens.space40,
                      boxFit: BoxFit.cover,
                      imageWidth: Dimens.space40,
                      imageHeight: Dimens.space40,
                      outerCorner: Dimens.space0,
                      innerCorner: Dimens.space0,
                      iconUrl: CustomIcon.icon_call,
                      iconColor: CustomColors.mainColor,
                      iconSize: Dimens.space16,
                      boxDecorationColor: Colors.transparent,
                      assetUrl: "assets/images/icon_call.svg",
                      onTap: onCallIconTap,
                    ),
                  )
                : Container(),
          ],
        ));
  }
}

/*----------------------------------------------------------------------------------------------------------------*/

//Empty Call View

class EmptyConversationWidget extends StatelessWidget {
  final String title;
  final String message;
  final String imageUrl;
  final String flagUrl;
  final Function onAddContactTap;
  final bool isContact;

  EmptyConversationWidget({
    Key key,
    @required this.title,
    @required this.message,
    @required this.imageUrl,
    @required this.flagUrl,
    @required this.onAddContactTap,
    this.isContact = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          width: Dimens.space100.w,
          height: Dimens.space100.w,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          child: Stack(
            alignment: Alignment.center,
            children: [
              RoundedNetworkImageHolder(
                width: Dimens.space100,
                height: Dimens.space100,
                boxFit: BoxFit.cover,
                containerAlignment: Alignment.bottomCenter,
                iconUrl: CustomIcon.icon_profile,
                iconColor: CustomColors.callInactiveColor,
                iconSize: Dimens.space85,
                boxDecorationColor: CustomColors.mainDividerColor,
                outerCorner: Dimens.space32,
                innerCorner: Dimens.space32,
                imageUrl: imageUrl,
              ),
              Positioned(
                bottom: Dimens.space0.h,
                right: Dimens.space0.w,
                child: Offstage(
                  offstage: isContact,
                  child: RoundedNetworkImageHolder(
                    width: Dimens.space32,
                    height: Dimens.space32,
                    boxFit: BoxFit.cover,
                    containerAlignment: Alignment.center,
                    iconUrl: CustomIcon.icon_add_person,
                    iconColor: CustomColors.white,
                    iconSize: Dimens.space0,
                    boxDecorationColor: CustomColors.white,
                    outerCorner: Dimens.space32,
                    innerCorner: Dimens.space32,
                    imageUrl: "",
                    onTap: () {},
                  ),
                ),
              ),
              Positioned(
                bottom: Dimens.space2.h,
                right: Dimens.space2.w,
                child: Offstage(
                  offstage: isContact,
                  child: RoundedNetworkImageHolder(
                    width: Dimens.space28,
                    height: Dimens.space28,
                    boxFit: BoxFit.cover,
                    containerAlignment: Alignment.center,
                    iconUrl: CustomIcon.icon_add_person,
                    iconColor: CustomColors.white,
                    iconSize: Dimens.space15,
                    boxDecorationColor: CustomColors.loadingCircleColor,
                    outerCorner: Dimens.space32,
                    innerCorner: Dimens.space32,
                    imageUrl: "",
                    onTap: onAddContactTap,
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space20.h,
                  Dimens.space0.w, Dimens.space10),
              child: Text(
                title != null ? title : Utils.getString("unknown"),
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
              margin: EdgeInsets.fromLTRB(Dimens.space8.w, Dimens.space20.h,
                  Dimens.space8.w, Dimens.space10),
              alignment: Alignment.center,
              child: RoundedNetworkSvgHolder(
                containerWidth: Dimens.space20.w,
                containerHeight: Dimens.space20.w,
                boxFit: BoxFit.contain,
                imageWidth: Dimens.space16.w,
                imageHeight: Dimens.space16.w,
                imageUrl:
                    flagUrl != null ? Config.countryLogoUrl + flagUrl : "",
                outerCorner: Dimens.space0.w,
                innerCorner: Dimens.space0.w,
                iconUrl: CustomIcon.icon_person,
                iconColor: CustomColors.white,
                iconSize: Dimens.space20.w,
                boxDecorationColor: Colors.transparent,
              ),
            ),
          ],
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space37.w, Dimens.space0.h,
              Dimens.space37.w, Dimens.space0.h),
          child: Text(
              title != null
                  ? message + " " + title
                  : message + " " + Utils.getString("unknown"),
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
    );
  }
}

//Voice Mail Duration Trim
String _printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  // return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  return "$twoDigitMinutes:$twoDigitSeconds";
}

//Voice Call Duration Trim
String _printCallTimeDuration(
  RecentConversationNodes data,
) {
  String msg = "";
  try {
    Duration duration = Duration(seconds: int.parse(data.content.duration));
    if (duration.inSeconds > 0) {
      if (duration.inSeconds < 60) {
        msg = "a few seconds";
      } else if (duration.inSeconds > 60) {
        msg = duration.inMinutes.toString() + " minutes";
      }
    }
  } catch (e) {}

  if (msg.isNotEmpty) {
    msg = msg + " - ";
  }
  return msg +
      "${_convertCallTime(data.createdAt.split("+")[0], 'yyyy-MM-ddThh:mm:ss.SSSSSS', "hh:mm a")}";
}
