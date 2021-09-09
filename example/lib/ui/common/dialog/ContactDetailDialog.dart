import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/constant/RoutePaths.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/contacts/ContactsProvider.dart';
import 'package:voice_example/repository/ContactRepository.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/ui/common/EmptyViewUiWidget.dart';
import 'package:voice_example/ui/common/TagsItemWidget.dart';
import 'package:voice_example/ui/common/dialog/ChannelSelectionDialog.dart';
import 'package:voice_example/ui/common/dialog/ContactDeleteBlockDialog.dart';
import 'package:voice_example/ui/common/dialog/ClientDndMuteDialog.dart';
import 'package:voice_example/ui/common/dialog/ClientDndUnMuteDialog.dart';
import 'package:voice_example/ui/common/dialog/DeleteDialog.dart';
import 'package:voice_example/ui/common/dialog/ErrorDialog.dart';
import 'package:voice_example/utils/PsProgressDialog.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/holder/intent_holder/AddNotesIntentHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/EditContactIntentHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/AddTagIntentHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/MessageDetailIntentHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/blockContactResponse/BlockContactResponse.dart';
import 'package:voice_example/viewobject/holder/request_holder/contactPinUnpinRequestParamHolder/ContactPinUnpinRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/updateClientDNDRequestParamHolder/UpdateClientDndHolder.dart';
import 'package:voice_example/viewobject/model/allContact/Contact.dart';
import 'package:voice_example/viewobject/model/allNotes/Notes.dart';
import 'package:voice_example/viewobject/model/clientDndResponse/ClientDndResponse.dart';
import 'package:voice_example/viewobject/model/country/CountryCode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/viewobject/model/workspace/workspace_detail/WorkspaceChannel.dart';
import 'package:voice_example/viewobject/model/workspace/workspace_detail/WorkspaceDetail.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ContactDetailDialog extends StatefulWidget {
  const ContactDetailDialog({
    Key key,
    @required this.contactId,
    @required this.contactNumber,
    @required this.onContactUpdate,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
    @required this.makeCallWithSid,
  }) : super(key: key);

  final String contactId;
  final String contactNumber;
  final VoidCallback onContactUpdate;
  final Function onIncomingTap;
  final Function onOutgoingTap;
  final Function(String, String, String, String, String, String, String, String, String, String, String, String) makeCallWithSid;

  @override
  _ContactDetailDialogState createState() => _ContactDetailDialogState();
}

class _ContactDetailDialogState extends State<ContactDetailDialog> with SingleTickerProviderStateMixin
{
  AnimationController animationController;

  CountryCode selected;

  ContactsProvider contactsProvider;
  ContactRepository contactRepository;

  String contactId;
  String contactNumber;
  bool isLoading = false;

  @override
  void initState() {
    contactId = widget.contactId;
    contactNumber = widget.contactNumber;
    contactRepository = Provider.of<ContactRepository>(context, listen: false);
    animationController = AnimationController(duration: Config.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    return ChangeNotifierProvider<ContactsProvider>(
      lazy: false,
      create: (BuildContext context) {
        contactsProvider =
            ContactsProvider(contactRepository: contactRepository);
        contactsProvider.doContactDetailApiCall(contactId);
        ContactPinUnpinRequestHolder param = ContactPinUnpinRequestHolder(
          channel: contactsProvider.getDefaultChannel().id,
          contact: contactNumber,
          pinned: false,
        );
        contactsProvider.doGetAllNotesApiCall(param);
        return contactsProvider;
      },
      child: Consumer<ContactsProvider>(builder:
          (BuildContext context, ContactsProvider provider, Widget child) {
        if(!isLoading){
          if (contactsProvider.contactDetailResponse != null &&
              contactsProvider.contactDetailResponse.data != null) {
            if (contactsProvider.contactDetailResponse.data
                .contactDetailResponseData.contacts !=
                null) {
              return Container(
                height: MediaQuery.of(context).size.height.h,
                width: MediaQuery.of(context).size.width.w,
                alignment: Alignment.topCenter,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space28.h,
                    Dimens.space0.w, Dimens.space0.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimens.space16.r),
                    topRight: Radius.circular(Dimens.space16.r),
                  ),
                  color: CustomColors.white,
                  shape: BoxShape.rectangle,
                ),
                child: SingleChildScrollView(
                  child: ContactDetailWidget(
                    contactsProvider: contactsProvider,
                    animationController: animationController,
                    animation: animation,
                    clientId: contactId,
                    contact: contactsProvider.contactDetailResponse.data.contactDetailResponseData.contacts,
                    selectedCountryCode: selected,
                    notes: contactsProvider.notes.data,
                    onMuteTap: () async
                    {
                      _showMuteDialog(
                          context: context,
                          clientName: contactsProvider.contactDetailResponse
                              .data.contactDetailResponseData.contacts.name,
                          onMuteTap: (int minutes, bool value) {
                            onMuteTap(minutes, value);
                          });
                    },
                    onUnMuteTap: () {
                      _showUnMuteDialog(
                        context: context,
                        clientName: contactsProvider.contactDetailResponse.data
                            .contactDetailResponseData.contacts.name,
                        dndEndTime: 0,
                        onUnMuteTap: (bool value) {
                          onMuteTap(0, value);
                        },
                      );
                    },
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
                                : contactNumber,
                            onIncomingTap: ()
                            {
                              widget.onIncomingTap();
                            },
                            onOutgoingTap: ()
                            {
                              widget.onOutgoingTap();
                            },
                          )
                      );
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
                            contactsProvider.doContactDetailApiCall(contactId);
                          });
                        });
                      }
                    },
                    onAddTagsTap: () async {
                      final dynamic returnData = await Navigator.pushNamed(
                        context,
                        RoutePaths.addNewTag,
                        arguments: AddTagIntentHolder(
                          clientId: contactId,
                          name: contactsProvider.contactDetailResponse.data !=
                              null &&
                              contactsProvider.contactDetailResponse
                                  .data.contactDetailResponseData.contacts !=
                                  null
                              ? contactsProvider.contactDetailResponse.data
                              .contactDetailResponseData.contacts.name
                              : Utils.getString("unknown"),
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
                              : "",
                          number: contactsProvider.contactDetailResponse.data !=
                              null &&
                              contactsProvider.contactDetailResponse.data
                                  .contactDetailResponseData.contacts !=
                                  null
                              ? contactsProvider.contactDetailResponse.data
                              .contactDetailResponseData.contacts.number
                              : contactNumber,
                          countryId:
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
                              .country
                              : "",
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
                          email: contactsProvider.contactDetailResponse.data !=
                              null &&
                              contactsProvider.contactDetailResponse.data
                                  .contactDetailResponseData.contacts !=
                                  null
                              ? contactsProvider.contactDetailResponse.data
                              .contactDetailResponseData.contacts.email
                              : null,
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
                          countryFlag:
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
                              .flagUrl
                              : "",
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
                          tags: contactsProvider.contactDetailResponse.data !=
                              null &&
                              contactsProvider.contactDetailResponse.data
                                  .contactDetailResponseData !=
                                  null
                              ? contactsProvider.contactDetailResponse.data
                              .contactDetailResponseData.contacts.tags
                              : null,
                          onIncomingTap: ()
                          {
                            widget.onIncomingTap();
                          },
                          onOutgoingTap: ()
                          {
                            widget.onOutgoingTap();
                          },
                        ),
                      );
                      if (returnData != null &&
                          returnData['data'] != null &&
                          returnData['data']) {
                        setState(() {
                          contactId = returnData['clientId'];
                          contactsProvider.doContactDetailApiCall(contactId);
                        });
                      }
                    },
                    onMessageTap: () async
                    {
                      await Navigator.pushNamed(
                          context, RoutePaths.messageDetail,
                          arguments: MessageDetailIntentHolder(
                            clientName: contactsProvider
                                .contactDetailResponse
                                .data
                                .contactDetailResponseData
                                .contacts
                                .name !=
                                null
                                ? contactsProvider.contactDetailResponse.data
                                .contactDetailResponseData.contacts.name
                                : Utils.getString("unknown"),
                            clientPhoneNumber: contactsProvider
                                .contactDetailResponse
                                .data
                                .contactDetailResponseData
                                .contacts
                                .number,
                            clientProfilePicture: contactsProvider
                                .contactDetailResponse
                                .data
                                .contactDetailResponseData
                                .contacts
                                .profilePicture !=
                                null
                                ? contactsProvider
                                .contactDetailResponse
                                .data
                                .contactDetailResponseData
                                .contacts
                                .profilePicture
                                : "",
                            countryId: contactsProvider
                                .contactDetailResponse
                                .data
                                .contactDetailResponseData
                                .contacts
                                .country,
                            countryFlagUrl: contactsProvider
                                .contactDetailResponse
                                .data
                                .contactDetailResponseData
                                .contacts
                                .flagUrl,
                            isBlocked: contactsProvider
                                .contactDetailResponse
                                .data
                                .contactDetailResponseData
                                .contacts
                                .blocked,
                            lastChatted: contactsProvider
                                .contactDetailResponse
                                .data
                                .contactDetailResponseData
                                .contacts
                                .createdOn !=
                                null
                                ? contactsProvider
                                .contactDetailResponse
                                .data
                                .contactDetailResponseData
                                .contacts
                                .createdOn
                                : DateTime.now().toString(),
                            clientId: contactsProvider.contactDetailResponse
                                .data.contactDetailResponseData.contacts.id,
                            dndMissed: contactsProvider
                                .contactDetailResponse
                                .data
                                .contactDetailResponseData
                                .contacts
                                .dndMissed,
                            isContact: true,
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
                    },
                    onMakeCallTap: () async
                    {
                      Utils.checkInternetConnectivity().then((value) async
                      {
                        if (value)
                        {
                          if (contactsProvider.getWorkspaceDetail().workspaceChannel.length == 1)
                          {
                            widget.makeCallWithSid(
                              contactsProvider.getDefaultChannel().number,
                              contactsProvider.getDefaultChannel().name,
                              contactsProvider.getDefaultChannel().id,
                              contactsProvider.getDefaultChannel().countryLogo,
                              contactsProvider.contactDetailResponse.data.contactDetailResponseData.contacts.number,
                              contactsProvider.getDefaultWorkspace(),
                              contactsProvider.getMemberId(),
                              contactsProvider.getVoiceToken(),
                              contactsProvider.contactDetailResponse.data.contactDetailResponseData.contacts.name,
                              contactsProvider.contactDetailResponse.data.contactDetailResponseData.contacts.id,
                              contactsProvider.contactDetailResponse.data.contactDetailResponseData.contacts.flagUrl,
                              contactsProvider.contactDetailResponse.data.contactDetailResponseData.contacts.profilePicture,
                            );
                          }
                          else
                          {
                            _channelSelectionDialog(
                                context: context,
                                workspaceDetails: contactsProvider.getWorkspaceDetail()
                            );
                          }
                        }
                        else
                        {
                          Utils.showToastMessage(Utils.getString("noInternet"));
                        }
                      });
                    },
                    onDeleteBlockTap: () async {
                      final dynamic returnData = await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(Dimens.space16.r),
                          ),
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return ContactDeleteBlockDialog(
                                blocked: contactsProvider
                                    .contactDetailResponse
                                    .data
                                    .contactDetailResponseData
                                    .contacts
                                    .blocked);
                          });
                      if (returnData != null &&
                          returnData["data"] is bool &&
                          returnData["data"]) {
                        if (returnData["action"] == "delete") {
                          isLoading = true;
                          setState(() {});
                          if (await Utils.checkInternetConnectivity()) {
                            Resources<DeleteContactResponse>
                            deleteContactResponse =
                            await contactsProvider.deleteContact([
                              contactsProvider.contactDetailResponse.data
                                  .contactDetailResponseData.contacts.id
                            ]);
                            if (deleteContactResponse != null &&
                                deleteContactResponse.data != null) {
                              Utils.showToastMessage(
                                  Utils.getString("successfullyDeleted"));
                              Navigator.pop(context, {"data": true});
                            } else if (deleteContactResponse != null &&
                                deleteContactResponse.message != null) {
                              PsProgressDialog.dismissDialog();
                              isLoading = false;
                              setState(() {});
                              showDialog<dynamic>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ErrorDialog(
                                      message: deleteContactResponse.message,
                                    );
                                  });
                            }
                          } else {
                            isLoading = false;
                            setState(() {});
                            showDialog<dynamic>(
                              context: context,
                              builder: (BuildContext context) {
                                return ErrorDialog(
                                    message: Utils.getString('noInternet'));
                              },
                            );
                          }
                        }
                        else if (returnData["action"] == "block") {
                          isLoading = true;
                          setState(() {});
                          if (await Utils.checkInternetConnectivity()) {
                            Resources<BlockContactResponse>
                            deleteContactResponse = await contactsProvider
                                .blockContacts(
                                {
                                  "blocked": !contactsProvider
                                      .contactDetailResponse
                                      .data
                                      .contactDetailResponseData
                                      .contacts
                                      .blocked,
                                },
                                contactsProvider
                                    .contactDetailResponse
                                    .data
                                    .contactDetailResponseData
                                    .contacts
                                    .id);
                            if (deleteContactResponse != null &&
                                deleteContactResponse.data != null) {
                              Utils.showToastMessage(
                                !contactsProvider
                                    .contactDetailResponse
                                    .data
                                    .contactDetailResponseData
                                    .contacts
                                    .blocked
                                    ? Utils.getString("blockContact")
                                    : Utils.getString('unblockContact'),
                              );
                              Navigator.pop(context, {"data": true});
                            } else if (deleteContactResponse != null &&
                                deleteContactResponse.message != null) {
                              isLoading = false;
                              setState(() {});
                              PsProgressDialog.dismissDialog();
                              showDialog<dynamic>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ErrorDialog(
                                      message: deleteContactResponse.message,
                                    );
                                  });
                            }
                          } else {
                            showDialog<dynamic>(
                              context: context,
                              builder: (BuildContext context) {
                                isLoading = false;
                                setState(() {});
                                return ErrorDialog(
                                    message: Utils.getString('noInternet'));
                              },
                            );
                          }
                        }
                      }
                    },
                    onDeleteTap: () async
                    {
                      await showDialog<dynamic>(
                          barrierDismissible: false,
                          useRootNavigator: false,
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return DeleteDialog(
                              title: Utils.getString("deleteContact"),
                              description: Utils.getString(
                                  "areYouSureYouWantToDeleteThisContact"),
                              cancelText: Utils.getString('cancel'),
                              deleteText: Utils.getString('yesDelete'),
                              icon: CustomIcon.icon_users,
                              iconColor: CustomColors.mainColor,
                              deleteSize: 0,
                              deleteSizeTextColor:
                              CustomColors.callDeclineColor,
                              deleteSizeContainerColor:
                              CustomColors.callDeclineColorLight,
                              onDeleteTap: () async {
                                // PsProgressDialog.showDialog(dialogContext);
                                // List<String> list = List();
                                // list.add("${widget.contact.id}");
                                // final Resources<DeleteContactResponse>
                                // _apiStatus =
                                // await contactsProvider.deleteContact(list);
                                // if (_apiStatus.data.data.error != null) {
                                //   PsProgressDialog.dismissDialog();
                                //   showDialog<dynamic>(
                                //       context: context,
                                //       builder: (BuildContext context) {
                                //         return ErrorDialog(
                                //           message: _apiStatus
                                //               .data.data.error.message,
                                //         );
                                //       });
                                // } else {
                                //   PsProgressDialog.dismissDialog();
                                //   widget.onContactUpdate();
                                //   Navigator.of(context).pop();
                                // }
                              },
                            );
                          });
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
                ),
              );
            } else {
              animationController.forward();
              final Animation<double> animation =
              Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: animationController,
                  curve: const Interval(0.5 * 1, 1.0,
                      curve: Curves.fastOutSlowIn)));
              return AnimatedBuilder(
                animation: animationController,
                builder: (BuildContext context, Widget child) {
                  return FadeTransition(
                      opacity: animation,
                      child: Transform(
                        transform: Matrix4.translationValues(
                            0.0, 100 * (1.0 - animation.value), 0.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height.h,
                          width: MediaQuery.of(context).size.width.w,
                          alignment: Alignment.topCenter,
                          margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                              Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                              Dimens.space28.h, Dimens.space0.w, Dimens.space0.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Dimens.space16.r),
                              topRight: Radius.circular(Dimens.space16.r),
                            ),
                            color: CustomColors.white,
                            shape: BoxShape.rectangle,
                          ),
                          child: EmptyViewUiWidget(
                            assetUrl: "assets/images/empty_contact.png",
                            title: Utils.getString('noContacts'),
                            desc: Utils.getString('noContactsDescription'),
                            buttonTitle: Utils.getString('addANewContact'),
                            icon: Icons.add_circle_outline,
                            onPressed: () {},
                          ),
                        ),
                      ));
                },
              );
            }
          } else {
            animationController.forward();
            final Animation<double> animation =
            Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: animationController,
                curve: const Interval(0.5 * 1, 1.0,
                    curve: Curves.fastOutSlowIn)));
            return AnimatedBuilder(
              animation: animationController,
              builder: (BuildContext context, Widget child) {
                return FadeTransition(
                    opacity: animation,
                    child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 100 * (1.0 - animation.value), 0.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height.h,
                        width: MediaQuery.of(context).size.width.w,
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space28.h, Dimens.space0.w, Dimens.space0.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(Dimens.space16.r),
                            topRight: Radius.circular(Dimens.space16.r),
                          ),
                          color: CustomColors.white,
                          shape: BoxShape.rectangle,
                        ),
                        child: SpinKitCircle(
                          color: CustomColors.mainColor,
                        ),
                      ),
                    ));
              },
            );
          }
        }else {
          animationController.forward();
          final Animation<double> animation =
          Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve: const Interval(0.5 * 1, 1.0,
                  curve: Curves.fastOutSlowIn)));
          return AnimatedBuilder(
            animation: animationController,
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                  opacity: animation,
                  child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - animation.value), 0.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height.h,
                      width: MediaQuery.of(context).size.width.w,
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space28.h, Dimens.space0.w, Dimens.space0.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Dimens.space16.r),
                          topRight: Radius.circular(Dimens.space16.r),
                        ),
                        color: CustomColors.white,
                        shape: BoxShape.rectangle,
                      ),
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

  void _channelSelectionDialog({BuildContext context, WorkspaceDetail workspaceDetails})
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
                contactsProvider.contactDetailResponse.data.contactDetailResponseData.contacts.number,
                contactsProvider.getDefaultWorkspace(),
                contactsProvider.getMemberId(),
                contactsProvider.getVoiceToken(),
                contactsProvider.contactDetailResponse.data.contactDetailResponseData.contacts.name,
                contactsProvider.contactDetailResponse.data.contactDetailResponseData.contacts.id,
                contactsProvider.contactDetailResponse.data.contactDetailResponseData.contacts.flagUrl,
                contactsProvider.contactDetailResponse.data.contactDetailResponseData.contacts.profilePicture,
              );
            },
          )
      ),
    );
  }

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
        contact: contactsProvider.contactDetailResponse.data
            .contactDetailResponseData.contacts.number,
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

class ContactDetailWidget extends StatelessWidget
{
  ContactDetailWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
    @required this.contact,
    @required this.selectedCountryCode,
    @required this.onDeleteTap,
    @required this.onMakeCallTap,
    @required this.onMessageTap,
    @required this.onAddTagsTap,
    @required this.onNotesTap,
    @required this.onMuteTap,
    @required this.onUnMuteTap,
    @required this.clientId,
    @required this.notes,
    @required this.contactsProvider,
    @required this.onDeleteBlockTap,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final Contacts contact;
  final List<Notes> notes;
  final CountryCode selectedCountryCode;
  final Function onDeleteTap;
  final Function onMakeCallTap;
  final Function onMessageTap;
  final Function onAddTagsTap;
  final Function onNotesTap;
  final Function onMuteTap;
  final Function onUnMuteTap;
  final String clientId;
  final ContactsProvider contactsProvider;
  final Function onDeleteBlockTap;
  final Function onIncomingTap;
  final Function onOutgoingTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                Dimens.space16.w, Dimens.space24.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.center,
                  color: CustomColors.white,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        onTap: () {
                          // apiService.doSubscriptionOnlineMemberStatus(contactsProvider.getWorkspaceDetail().id);
                        },
                        child: Container(
                          width: Dimens.space54.w,
                          height: Dimens.space54.w,
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
                            width: Dimens.space54,
                            height: Dimens.space54,
                            boxFit: BoxFit.cover,
                            iconUrl: CustomIcon.icon_profile,
                            containerAlignment: Alignment.bottomCenter,
                            iconColor: CustomColors.callInactiveColor,
                            iconSize: Dimens.space46,
                            boxDecorationColor: CustomColors.mainDividerColor,
                            outerCorner: Dimens.space18,
                            innerCorner: Dimens.space18,
                            imageUrl: contact.profilePicture != null
                                ? contact.profilePicture
                                : "",
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                            alignment: Alignment.center,
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
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
                                    contact.name != null
                                        ? contact.name
                                        : Utils.getString("unknown"),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                            fontFamily: Config.manropeExtraBold,
                                            fontSize: Dimens.space20.sp,
                                            fontWeight: FontWeight.normal,
                                            color:
                                                CustomColors.textPrimaryColor,
                                            fontStyle: FontStyle.normal),
                                  ),
                                ),
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
                                    contact.createdOn != null
                                        ? "${Utils.getString("lastContacted")} ${timeago.format(DateTime.now().subtract(DateTime.now().difference(DateTime.parse(contact.createdOn))), locale: 'en')}"
                                        : "${Utils.getString("lastContacted")} ${timeago.format(DateTime.now(), locale: 'en')}",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                            fontFamily: Config.heeboRegular,
                                            fontSize: Dimens.space14.sp,
                                            fontWeight: FontWeight.normal,
                                            color:
                                                CustomColors.textPrimaryColor,
                                            fontStyle: FontStyle.normal),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          onDeleteBlockTap();
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
                          width: Dimens.space24.w,
                          height: Dimens.space24.w,
                          alignment: Alignment.center,
                          child: Icon(
                            CustomIcon.icon_more_vertical,
                            size: Dimens.space18.w,
                            color: CustomColors.textSecondaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                contact.tags.length != 0
                    ? Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space20.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        height: Dimens.space24.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: contact.tags.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space8.w,
                                  Dimens.space0.h),
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              height: Dimens.space24.h,
                              child: TagsItemWidget(tags: contact.tags[index]),
                            );
                          },
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          Divider(
            color: CustomColors.mainDividerColor,
            height: Dimens.space1,
            thickness: Dimens.space1,
          ),

          Divider(
            color: CustomColors.mainDividerColor,
            height: Dimens.space1,
            thickness: Dimens.space1,
          ),
          contactsProvider
              .contactDetailResponse
              .data
              .contactDetailResponseData
              .contacts
              .blocked?Container(): Container(
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space20.h,
                  Dimens.space16.w, Dimens.space20.h),
              alignment: Alignment.center,
              color: CustomColors.bottomAppBarColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space11.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.center,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space11.h,
                                Dimens.space0.w,
                                Dimens.space11.h),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor: CustomColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(Dimens.space10.r),
                            ),
                          ),
                          onPressed:
                              contact.dndEnabled != null && contact.dndEnabled
                                  ? onUnMuteTap
                                  : onMuteTap,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                      contact.dndEnabled != null &&
                                              contact.dndEnabled
                                          ? CustomIcon.icon_muted
                                          : CustomIcon.icon_notification,
                                      color: contact.dndEnabled != null &&
                                              contact.dndEnabled
                                          ? CustomColors.textPrimaryErrorColor
                                          : CustomColors.loadingCircleColor,
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
                                        contact.dndEnabled != null &&
                                                contact.dndEnabled
                                            ? Utils.getString("muted")
                                            : Utils.getString("alwaysOn")
                                                .toLowerCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontFamily: Config.heeboRegular,
                                                fontSize: Dimens.space12.sp,
                                                fontWeight: FontWeight.normal,
                                                color: CustomColors
                                                    .textTertiaryColor,
                                                fontStyle: FontStyle.normal),
                                      ))
                                ],
                              )),
                        )),
                  ),
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space11.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.center,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space11.h,
                                Dimens.space0.w,
                                Dimens.space11.h),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor: CustomColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(Dimens.space10.r),
                            ),
                          ),
                          onPressed: onMessageTap,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                      CustomIcon.icon_chat,
                                      color: CustomColors.loadingCircleColor,
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
                                        Utils.getString("message")
                                            .toLowerCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontFamily: Config.heeboRegular,
                                                fontSize: Dimens.space12.sp,
                                                fontWeight: FontWeight.normal,
                                                color: CustomColors
                                                    .textTertiaryColor,
                                                fontStyle: FontStyle.normal),
                                      ))
                                ],
                              )),
                        )),
                  ),
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.center,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space11.h,
                                Dimens.space0.w,
                                Dimens.space11.h),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor: CustomColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(Dimens.space10.r),
                            ),
                          ),
                          onPressed: onMakeCallTap,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                      CustomIcon.icon_call,
                                      color: CustomColors.loadingCircleColor,
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
                                        Utils.getString("call").toLowerCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontFamily: Config.heeboRegular,
                                                fontSize: Dimens.space12.sp,
                                                fontWeight: FontWeight.normal,
                                                color: CustomColors
                                                    .textTertiaryColor,
                                                fontStyle: FontStyle.normal),
                                      ))
                                ],
                              )),
                        )),
                  ),
                ],
              )
          ),
          Divider(
            color: CustomColors.mainDividerColor,
            height: Dimens.space1,
            thickness: Dimens.space1,
          ),
          //Add Tags
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            height: Dimens.space52.h,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                    Dimens.space16.w, Dimens.space0.h),
                backgroundColor: CustomColors.white,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: onAddTagsTap,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          CustomIcon.icon_tags_outlined,
                          size: Dimens.space16.w,
                          color: CustomColors.textTertiaryColor,
                        ),
                        Expanded(
                            child: Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space10.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                child: Text(
                                  Utils.getString("tags"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          color: CustomColors.textPrimaryColor,
                                          fontFamily: Config.manropeSemiBold,
                                          fontSize: Dimens.space15.sp,
                                          fontWeight: FontWeight.normal),
                                ))),
                      ],
                    ),
                  )),
                  Container(
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space10.w,
                          Dimens.space5.h, Dimens.space10.w, Dimens.space5.h),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.circular(Dimens.space16.r)),
                        border: Border.all(
                          color: CustomColors.textQuinaryColor,
                          width: Dimens.space1.h,
                        ),
                        color: CustomColors.white,
                        shape: BoxShape.rectangle,
                      ),
                      child: Text(
                        contact.tags != null && contact.tags.isNotEmpty
                            ? contact.tags.length.toString()
                            : Utils.getString("0"),
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: CustomColors.textTertiaryColor,
                            fontFamily: Config.heeboMedium,
                            fontSize: Dimens.space13.sp,
                            fontWeight: FontWeight.normal),
                      )),
                  Icon(
                    CustomIcon.icon_arrow_right,
                    size: Dimens.space24.w,
                    color: CustomColors.textQuinaryColor,
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: CustomColors.mainDividerColor,
            height: Dimens.space1,
            thickness: Dimens.space1,
          ),
          //Add Notes
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            height: Dimens.space52.h,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                    Dimens.space16.w, Dimens.space0.h),
                backgroundColor: CustomColors.white,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: onNotesTap,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          CustomIcon.icon_add_notes,
                          size: Dimens.space16.w,
                          color: CustomColors.textTertiaryColor,
                        ),
                        Expanded(
                            child: Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space10.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                child: Text(
                                  Utils.getString("notes"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          color: CustomColors.textPrimaryColor,
                                          fontFamily: Config.manropeSemiBold,
                                          fontSize: Dimens.space15.sp,
                                          fontWeight: FontWeight.normal),
                                ))),
                      ],
                    ),
                  )),
                  Container(
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space10.w,
                          Dimens.space5.h, Dimens.space10.w, Dimens.space5.h),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.circular(Dimens.space16.r)),
                        border: Border.all(
                          color: CustomColors.textQuinaryColor,
                          width: Dimens.space1.h,
                        ),
                        color: CustomColors.white,
                        shape: BoxShape.rectangle,
                      ),
                      child: Text(
                        notes != null && notes.isNotEmpty
                            ? notes.length.toString()
                            : Utils.getString("0"),
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: CustomColors.textTertiaryColor,
                            fontFamily: Config.heeboMedium,
                            fontSize: Dimens.space13.sp,
                            fontWeight: FontWeight.normal),
                      )),
                  Icon(
                    CustomIcon.icon_arrow_right,
                    size: Dimens.space24.w,
                    color: CustomColors.textQuinaryColor,
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: CustomColors.mainDividerColor,
            height: Dimens.space1,
            thickness: Dimens.space1,
          ),
          DetailWidget(
            clientId: clientId,
            contact: contact,
            onAddTagsTap: onAddTagsTap,
            contactsProvider: contactsProvider,
            onIncomingTap: ()
            {
              onIncomingTap();
            },
            onOutgoingTap: ()
            {
              onOutgoingTap();
            },
          ),
        ],
      ),
    );
  }
}

class DetailWidget extends StatelessWidget
{
  const DetailWidget({
    @required this.clientId,
    @required this.contact,
    @required this.onAddTagsTap,
    @required this.contactsProvider,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
  });

  final Contacts contact;
  final Function onAddTagsTap;
  final String clientId;
  final ContactsProvider contactsProvider;
  final Function onIncomingTap;
  final Function onOutgoingTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width.w,
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
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
                        Utils.getString("moreDetails").toUpperCase(),
                        style: Theme.of(context).textTheme.button.copyWith(
                            color: CustomColors.textPrimaryLightColor,
                            fontFamily: Config.manropeBold,
                            fontWeight: FontWeight.normal,
                            fontSize: Dimens.space14.sp,
                            fontStyle: FontStyle.normal),
                      ))),
            ],
          ),
          Divider(
            color: CustomColors.mainDividerColor,
            height: Dimens.space1,
            thickness: Dimens.space1,
          ),
          //Name
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                Dimens.space16.w, Dimens.space0.h),
            alignment: Alignment.center,
            height: Dimens.space52.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Text(
                          Utils.getString("name"),
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: CustomColors.textPrimaryColor,
                              fontFamily: Config.manropeSemiBold,
                              fontSize: Dimens.space15.sp,
                              fontWeight: FontWeight.normal),
                        ))),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final dynamic returnData = await Navigator.pushNamed(
                          context, RoutePaths.editContact,
                          arguments: EditContactIntentHolder(
                              editName: "contactName",
                              contactName: contact.name != null ? contact.name : "",
                              contactNumber: contact.number != null ? contact.number : "",
                              email: contact.email != null ? contact.email : "",
                              company: contact.company != null ? contact.company : "",
                              address: contact.address != null ? contact.address : "",
                              photoUpload: contact.profilePicture != null ? contact.profilePicture : '',
                              tags: contact.tags != null ? contact.tags : [],
                              visibility: contact.visibility != null ? contact.visibility : "",
                              id: contact.id != null ? contact.id : "",
                              onIncomingTap: ()
                              {
                                onIncomingTap();
                              },
                              onOutgoingTap: ()
                              {
                                onOutgoingTap();
                              }
                          )
                      );
                      if (returnData != null &&
                          returnData["data"] is bool &&
                          returnData["data"]) {
                        contactsProvider.doContactDetailApiCall(contact.id);
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
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
                              contact.name != null
                                  ? contact.name
                                  : Utils.getString("unknown"),
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
                            ))
                      ],
                    ),
                  ),
                ),
                Icon(
                  CustomIcon.icon_arrow_right,
                  size: Dimens.space24.w,
                  color: CustomColors.textQuinaryColor,
                ),
              ],
            ),
          ),
          Divider(
            color: CustomColors.mainDividerColor,
            height: Dimens.space1,
            thickness: Dimens.space1,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                Dimens.space16.w, Dimens.space0.h),
            alignment: Alignment.center,
            height: Dimens.space52.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Text(
                          Utils.getString("phoneNumber"),
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: CustomColors.textPrimaryColor,
                              fontFamily: Config.manropeSemiBold,
                              fontSize: Dimens.space15.sp,
                              fontWeight: FontWeight.normal),
                        ))),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final dynamic returnData = await Navigator.pushNamed(
                          context, RoutePaths.editContact,
                          arguments: EditContactIntentHolder(
                              editName: "phoneNumber",
                              contactName: contact.name != null ? contact.name : "",
                              contactNumber: contact.number != null ? contact.number : "",
                              email: contact.email != null ? contact.email : "",
                              company: contact.company != null ? contact.company : "",
                              address: contact.address != null ? contact.address : "",
                              photoUpload: contact.profilePicture != null ? contact.profilePicture : '',
                              tags: contact.tags != null ? contact.tags : [],
                              visibility: contact.visibility != null ? contact.visibility : "",
                              id: contact.id != null ? contact.id : "",
                              onIncomingTap: ()
                              {
                                onIncomingTap();
                              },
                              onOutgoingTap: ()
                              {
                                onOutgoingTap();
                              }
                          )
                      );
                      if (returnData != null &&
                          returnData["data"] is bool &&
                          returnData["data"]) {
                        contactsProvider.doContactDetailApiCall(contact.id);
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
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
                          child: RoundedNetworkSvgHolder(
                            containerWidth: Dimens.space20,
                            containerHeight: Dimens.space20,
                            boxFit: BoxFit.contain,
                            imageWidth: Dimens.space20,
                            imageHeight: Dimens.space20,
                            imageUrl: contact.flagUrl != null
                                ? Config.countryLogoUrl + contact.flagUrl
                                : "",
                            outerCorner: Dimens.space300.r,
                            innerCorner: Dimens.space0.r,
                            iconUrl: CustomIcon.icon_person,
                            iconColor: CustomColors.mainColor,
                            iconSize: Dimens.space20.w,
                            boxDecorationColor:
                                CustomColors.mainBackgroundColor,
                          ),
                        ),
                        Container(
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
                              contact.number,
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
                            ))
                      ],
                    ),
                  ),
                ),
                Icon(
                  CustomIcon.icon_arrow_right,
                  size: Dimens.space24.w,
                  color: CustomColors.textQuinaryColor,
                ),
              ],
            ),
          ),
          Divider(
            color: CustomColors.mainDividerColor,
            height: Dimens.space1,
            thickness: Dimens.space1,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                Dimens.space16.w, Dimens.space0.h),
            alignment: Alignment.center,
            height: Dimens.space52.h,
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
                    flex: 2,
                    child: Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Text(
                          Utils.getString("email"),
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: CustomColors.textPrimaryColor,
                              fontFamily: Config.manropeSemiBold,
                              fontSize: Dimens.space15.sp,
                              fontWeight: FontWeight.normal),
                        ))),
                Expanded(
                    flex: 3,
                    child: InkWell(
                      onTap: () async {
                        final dynamic returnData = await Navigator.pushNamed(
                            context, RoutePaths.editContact,
                            arguments: EditContactIntentHolder(
                                editName: "email",
                                contactName:
                                contact.name != null ? contact.name : "",
                                contactNumber:
                                contact.number != null ? contact.number : "",
                                email: contact.email != null ? contact.email : "",
                                company: contact.company != null
                                    ? contact.company
                                    : "",
                                address: contact.address != null
                                    ? contact.address
                                    : "",
                                photoUpload: contact.profilePicture != null
                                    ? contact.profilePicture
                                    : '',
                                tags: contact.tags != null ? contact.tags : [],
                                visibility: contact.visibility != null
                                    ? contact.visibility
                                    : "",
                                id: contact.id != null ? contact.id : "",
                                onIncomingTap: ()
                                {
                                  onIncomingTap();
                                },
                                onOutgoingTap: ()
                                {
                                  onOutgoingTap();
                                }
                            )
                        );

                        if (returnData != null &&
                            returnData["data"] is bool &&
                            returnData["data"]) {
                          contactsProvider.doContactDetailApiCall(contact.id);
                        }
                      },
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
                            contact.email != null ? contact.email : "",
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    color: CustomColors.textTertiaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal),
                          )),
                    )),
                Icon(
                  CustomIcon.icon_arrow_right,
                  size: Dimens.space24.w,
                  color: CustomColors.textQuinaryColor,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                Dimens.space16.w, Dimens.space0.h),
            alignment: Alignment.center,
            height: Dimens.space52.h,
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
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Text(
                          Utils.getString("company"),
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: CustomColors.textPrimaryColor,
                              fontFamily: Config.manropeSemiBold,
                              fontSize: Dimens.space15.sp,
                              fontWeight: FontWeight.normal),
                        ))),
                Expanded(
                    child: InkWell(
                  onTap: () async {
                    final dynamic returnData = await Navigator.pushNamed(
                        context, RoutePaths.editContact,
                        arguments: EditContactIntentHolder(
                          editName: "company",
                          contactName: contact.name != null ? contact.name : "",
                          contactNumber:
                              contact.number != null ? contact.number : "",
                          email: contact.email != null ? contact.email : "",
                          company:
                              contact.company != null ? contact.company : "",
                          address:
                              contact.address != null ? contact.address : "",
                          photoUpload: contact.profilePicture != null
                              ? contact.profilePicture
                              : '',
                          tags: contact.tags != null ? contact.tags : [],
                          visibility: contact.visibility != null
                              ? contact.visibility
                              : "",
                          id: contact.id != null ? contact.id : "",
                            onIncomingTap: ()
                            {
                              onIncomingTap();
                            },
                            onOutgoingTap: ()
                            {
                              onOutgoingTap();
                            }
                        ));
                    if (returnData != null &&
                        returnData["data"] is bool &&
                        returnData["data"]) {
                      contactsProvider.doContactDetailApiCall(contact.id);
                    }
                  },
                  child: Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(
                        contact.company != null ? contact.company : "",
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: CustomColors.textTertiaryColor,
                            fontFamily: Config.manropeSemiBold,
                            fontSize: Dimens.space15.sp,
                            fontWeight: FontWeight.normal),
                      )),
                )),
                Icon(
                  CustomIcon.icon_arrow_right,
                  size: Dimens.space24.w,
                  color: CustomColors.textQuinaryColor,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                Dimens.space16.w, Dimens.space0.h),
            alignment: Alignment.center,
            height: Dimens.space52.h,
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
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Text(
                          Utils.getString("address"),
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: CustomColors.textPrimaryColor,
                              fontFamily: Config.manropeSemiBold,
                              fontSize: Dimens.space15.sp,
                              fontWeight: FontWeight.normal),
                        ))),
                Expanded(
                    child: InkWell(
                  onTap: () async {
                    final dynamic returnData = await Navigator.pushNamed(
                        context, RoutePaths.editContact,
                        arguments: EditContactIntentHolder(
                          editName: "address",
                          contactName: contact.name != null ? contact.name : "",
                          contactNumber:
                              contact.number != null ? contact.number : "",
                          email: contact.email != null ? contact.email : "",
                          company:
                              contact.company != null ? contact.company : "",
                          address:
                              contact.address != null ? contact.address : "",
                          photoUpload: contact.profilePicture != null
                              ? contact.profilePicture
                              : '',
                          tags: contact.tags != null ? contact.tags : [],
                          visibility: contact.visibility != null
                              ? contact.visibility
                              : "",
                          id: contact.id != null ? contact.id : "",
                            onIncomingTap: ()
                            {
                              onIncomingTap();
                            },
                            onOutgoingTap: ()
                            {
                              onOutgoingTap();
                            }
                        ));
                    if (returnData != null &&
                        returnData["data"] is bool &&
                        returnData["data"]) {
                      contactsProvider.doContactDetailApiCall(contact.id);
                    }
                  },
                  child: Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(
                        contact.address != null ? contact.address : "",
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: CustomColors.textTertiaryColor,
                            fontFamily: Config.manropeSemiBold,
                            fontSize: Dimens.space15.sp,
                            fontWeight: FontWeight.normal),
                      )),
                )),
                Icon(
                  CustomIcon.icon_arrow_right,
                  size: Dimens.space24.w,
                  color: CustomColors.textQuinaryColor,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                Dimens.space16.w, Dimens.space0.h),
            alignment: Alignment.center,
            height: Dimens.space52.h,
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
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Text(
                          Utils.getString("clientId"),
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: CustomColors.textPrimaryColor,
                              fontFamily: Config.manropeSemiBold,
                              fontSize: Dimens.space15.sp,
                              fontWeight: FontWeight.normal),
                        ))),
                Expanded(
                    child: Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Text(
                          contact.id != null ? contact.id : "",
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: CustomColors.textTertiaryColor,
                              fontFamily: Config.manropeSemiBold,
                              fontSize: Dimens.space15.sp,
                              fontWeight: FontWeight.normal),
                        ))),
                Icon(
                  CustomIcon.icon_arrow_right,
                  size: Dimens.space24.w,
                  color: CustomColors.textQuinaryColor,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                Dimens.space16.w, Dimens.space0.h),
            alignment: Alignment.center,
            height: Dimens.space52.h,
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
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Text(
                          Utils.getString("visibility"),
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: CustomColors.textPrimaryColor,
                              fontFamily: Config.manropeSemiBold,
                              fontSize: Dimens.space15.sp,
                              fontWeight: FontWeight.normal),
                        ))),
                Expanded(
                    child: Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Text(
                          contact.visibility
                              ? Utils.getString("public")
                              : Utils.getString("private"),
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: CustomColors.textTertiaryColor,
                              fontFamily: Config.manropeSemiBold,
                              fontSize: Dimens.space15.sp,
                              fontWeight: FontWeight.normal),
                        ))),
                Icon(
                  CustomIcon.icon_arrow_right,
                  size: Dimens.space24.w,
                  color: CustomColors.textQuinaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
