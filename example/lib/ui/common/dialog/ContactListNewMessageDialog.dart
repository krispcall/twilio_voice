import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/contacts/ContactsProvider.dart';
import 'package:voice_example/provider/messages/MessageDetailsProvider.dart';
import 'package:voice_example/repository/ContactRepository.dart';
import 'package:voice_example/repository/MessageDetailsRepository.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/ui/common/EmptyViewUiWidget.dart';
import 'package:voice_example/ui/common/dialog/BlockContactDialog.dart';
import 'package:voice_example/ui/common/dialog/ErrorDialog.dart';
import 'package:voice_example/ui/contacts/contact_view/ContactListItemView.dart';
import 'package:voice_example/utils/PsProgressDialog.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/blockContactResponse/BlockContactResponse.dart';
import 'package:voice_example/viewobject/model/allContact/AllContactEdges.dart';
import 'package:voice_example/viewobject/model/sendMessage/Messages.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactListNewMessageDialog extends StatefulWidget {
  const ContactListNewMessageDialog({
    Key key,
    @required this.animationController,
    @required this.onMessageSent,
    @required this.statusBarHeight,
  }) : super(key: key);

  final AnimationController animationController;
  final double statusBarHeight;
  final Function(AllContactEdges) onMessageSent;

  @override
  ContactListNewMessageDialogState createState() =>
      ContactListNewMessageDialogState();
}

class ContactListNewMessageDialogState
    extends State<ContactListNewMessageDialog> {
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;
  TextEditingController textEditingControllerMessage = TextEditingController();
  TextEditingController textEditingControllerSearchContacts =
      TextEditingController();

  AllContactEdges selectedContact;

  ContactRepository contactRepository;
  ContactsProvider contactsProvider;

  MessageDetailsRepository messagesRepository;
  MessageDetailsProvider messagesProvider;

  bool isLoading = false;

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
    if (!isConnectedToInternet) {
      checkConnection();
    }
    super.initState();
  }

  @override
  void dispose() {
    textEditingControllerSearchContacts.dispose();
    textEditingControllerMessage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    contactRepository = Provider.of<ContactRepository>(context);
    messagesRepository = Provider.of<MessageDetailsRepository>(context);
    valueHolder = Provider.of<ValueHolder>(context);

    return Container(
        height: MediaQuery.of(context).size.height.h,
        width: MediaQuery.of(context).size.width.w,
        color: CustomColors.transparent,
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
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
                  margin: EdgeInsets.fromLTRB(Dimens.space20.w,
                      Dimens.space18.h, Dimens.space20.w, Dimens.space18.h),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Text(
                          Utils.getString("newMessage"),
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: CustomColors.textPrimaryColor,
                              fontFamily: Config.manropeBold,
                              fontWeight: FontWeight.normal,
                              fontSize: Dimens.space18.sp,
                              fontStyle: FontStyle.normal),
                        ),
                      ),
                      Positioned(
                        left: Dimens.space0.w,
                        child: RoundedNetworkImageHolder(
                          width: Dimens.space24,
                          height: Dimens.space24,
                          boxFit: BoxFit.cover,
                          iconUrl: CustomIcon.icon_close,
                          iconColor: CustomColors.iconColorBlack,
                          iconSize: Dimens.space10,
                          outerCorner: Dimens.space0,
                          innerCorner: Dimens.space0,
                          boxDecorationColor: CustomColors.transparent,
                          imageUrl: "",
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  )),
              Divider(
                color: CustomColors.mainDividerColor,
                height: Dimens.space1.h,
                thickness: Dimens.space1.h,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(Dimens.space15.w, Dimens.space20.h,
                    Dimens.space15.w, Dimens.space20.h),
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(Dimens.space8.r),
                  ),
                  color: CustomColors.baseLightColor,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space14.w,
                          Dimens.space0.h, Dimens.space8.w, Dimens.space0.h),
                      child: Text(
                        Utils.getString("to") + " : ",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: CustomColors.textSenaryColor,
                            fontFamily: Config.manropeBold,
                            fontWeight: FontWeight.normal,
                            fontSize: Dimens.space14.sp,
                            fontStyle: FontStyle.normal),
                      ),
                    ),
                    selectedContact == null
                        ? Expanded(
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
                            alignment: Alignment.center,
                            child: TextField(
                              controller: textEditingControllerSearchContacts,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
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
                                hintText: Utils.getString('searchContacts'),
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
                          ))
                        : Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space7.h,
                                Dimens.space0.w,
                                Dimens.space7.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space6.w,
                                Dimens.space4.h,
                                Dimens.space6.w,
                                Dimens.space4.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.space5.r),
                              ),
                              color: CustomColors.secondaryColor,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                  child: Text(
                                    selectedContact.contactNode.name != null
                                        ? selectedContact.contactNode.name
                                        : Utils.getString("unknown"),
                                    style: Theme.of(context)
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
                                RoundedNetworkImageHolder(
                                  width: Dimens.space24,
                                  height: Dimens.space24,
                                  boxFit: BoxFit.cover,
                                  iconUrl: CustomIcon.icon_close,
                                  iconColor: CustomColors.iconColorBlack,
                                  iconSize: Dimens.space10,
                                  outerCorner: Dimens.space0,
                                  innerCorner: Dimens.space0,
                                  boxDecorationColor: CustomColors.transparent,
                                  imageUrl: "",
                                  onTap: () {
                                    setState(() {
                                      selectedContact = null;
                                      textEditingControllerSearchContacts.text =
                                          "";
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
              Expanded(
                  child: MultiProvider(
                providers: [
                  ChangeNotifierProvider<MessageDetailsProvider>(
                    lazy: false,
                    create: (BuildContext context) {
                      messagesProvider = MessageDetailsProvider(
                          messageDetailsRepository: messagesRepository);
                      return messagesProvider;
                    },
                  ),
                ],
                child: ChangeNotifierProvider<ContactsProvider>(
                  lazy: false,
                  create: (BuildContext context) {
                    contactsProvider =
                        ContactsProvider(contactRepository: contactRepository);
                    contactsProvider.doAllContactApiCall();
                    textEditingControllerSearchContacts.addListener(() {
                      if (textEditingControllerSearchContacts.text.isNotEmpty) {
                        contactsProvider.doSearchContactFromDb(
                            textEditingControllerSearchContacts.text);
                      } else {
                        contactsProvider.doAllContactApiCall();
                      }
                    });
                    return contactsProvider;
                  },
                  child: Consumer<ContactsProvider>(builder:
                      (BuildContext context, ContactsProvider provider,
                          Widget child) {
                    if (contactsProvider.contactResponse != null &&
                        contactsProvider.contactResponse.data != null) {
                      if (contactsProvider.contactResponse.data.contactResponse
                          .contactResponseData.contactEdges.isNotEmpty) {
                        return Container(
                          color: CustomColors.white,
                          alignment: Alignment.topCenter,
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
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: provider
                                .contactResponse
                                .data
                                .contactResponse
                                .contactResponseData
                                .contactEdges
                                .length,
                            itemBuilder: (BuildContext context, int index) {
                              final int count = provider
                                  .contactResponse
                                  .data
                                  .contactResponse
                                  .contactResponseData
                                  .contactEdges
                                  .length;
                              widget.animationController.forward();
                              return ContactListItemView(
                                animationController: widget.animationController,
                                animation:
                                    Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: widget.animationController,
                                    curve: Interval((1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn),
                                  ),
                                ),
                                offStage: false,
                                contactEdges: provider
                                    .contactResponse
                                    .data
                                    .contactResponse
                                    .contactResponseData
                                    .contactEdges[index],
                                onTap: () async {
                                  if (provider
                                          .contactResponse
                                          .data
                                          .contactResponse
                                          .contactResponseData
                                          .contactEdges[index]
                                          .contactNode
                                          .blocked ==
                                      true) {
                                    final dynamic returnData =
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
                                              return BlockContactDialog(
                                                block: true,
                                              );
                                            });
                                    if (returnData != null &&
                                        returnData["data"] is bool &&
                                        returnData["data"]) {
                                      if (returnData["action"] == "block") {
                                        isLoading = true;
                                        setState(() {});
                                        if (await Utils
                                            .checkInternetConnectivity()) {
                                          Resources<BlockContactResponse>
                                              deleteContactResponse =
                                              await contactsProvider
                                                  .blockContacts(
                                                      {
                                                "blocked": false,
                                              },
                                                      provider
                                                          .contactResponse
                                                          .data
                                                          .contactResponse
                                                          .contactResponseData
                                                          .contactEdges[index]
                                                          .contactNode
                                                          .id);
                                          if (deleteContactResponse != null &&
                                              deleteContactResponse.data !=
                                                  null) {
                                            Utils.showToastMessage(
                                              Utils.getString('unblockContact'),
                                            );

                                            contactsProvider.doAllContactApiCall();
                                            selectedContact = contactsProvider
                                                .contactResponse
                                                .data
                                                .contactResponse
                                                .contactResponseData
                                                .contactEdges[index];
                                            setState(() {});

                                            // Navigator.pop(
                                            //     context, {"data": true});
                                          } else if (deleteContactResponse !=
                                                  null &&
                                              deleteContactResponse.message !=
                                                  null) {
                                            isLoading = false;
                                            setState(() {});
                                            PsProgressDialog.dismissDialog();
                                            showDialog<dynamic>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return ErrorDialog(
                                                    message:
                                                        deleteContactResponse
                                                            .message,
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
                                                  message: Utils.getString(
                                                      'noInternet'));
                                            },
                                          );
                                        }
                                      }
                                    }
                                  }else{
                                    selectedContact = contactsProvider
                                        .contactResponse
                                        .data
                                        .contactResponse
                                        .contactResponseData
                                        .contactEdges[index];
                                    setState(() {});
                                  }

                                },
                              );
                            },
                            physics: AlwaysScrollableScrollPhysics(),
                          ),
                        );
                      } else {
                        widget.animationController.forward();
                        final Animation<double> animation =
                            Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
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
                                    color: CustomColors.white,
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
                                    child: EmptyViewUiWidget(
                                      assetUrl:
                                          "assets/images/empty_contact.png",
                                      title: Utils.getString('noContacts'),
                                      desc: Utils.getString(
                                          'noContactsDescription'),
                                      buttonTitle:
                                          Utils.getString('addANewContact'),
                                      icon: Icons.add_circle_outline,
                                      onPressed: () {},
                                    ),
                                  ),
                                ));
                          },
                        );
                      }
                    } else {
                      widget.animationController.forward();
                      final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
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
                                  margin: EdgeInsets.fromLTRB(
                                      Dimens.space0,
                                      Dimens.space0,
                                      Dimens.space0,
                                      Dimens.space0),
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
              )),
              Container(
                margin: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space10.h,
                    Dimens.space16.w, Dimens.space10.h),
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                alignment: Alignment.center,
                child: TextField(
                  controller: textEditingControllerMessage,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: CustomColors.textSenaryColor,
                      fontFamily: Config.manropeMedium,
                      fontWeight: FontWeight.normal,
                      fontSize: Dimens.space14.sp,
                      fontStyle: FontStyle.normal),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(Dimens.space16.w,
                        Dimens.space13.h, Dimens.space0.w, Dimens.space13.h),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: Dimens.space0.w,
                      ),
                      borderRadius:
                          BorderRadius.all(Radius.circular(Dimens.space10.r)),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: Dimens.space0.w,
                      ),
                      borderRadius:
                          BorderRadius.all(Radius.circular(Dimens.space10.r)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: Dimens.space0.w,
                      ),
                      borderRadius:
                          BorderRadius.all(Radius.circular(Dimens.space10.r)),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: Dimens.space0.w,
                      ),
                      borderRadius:
                          BorderRadius.all(Radius.circular(Dimens.space10.r)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: Dimens.space0.w,
                      ),
                      borderRadius:
                          BorderRadius.all(Radius.circular(Dimens.space10.r)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: Dimens.space0.w,
                      ),
                      borderRadius:
                          BorderRadius.all(Radius.circular(Dimens.space10.r)),
                    ),
                    filled: true,
                    fillColor: CustomColors.baseLightColor,
                    hintText: Utils.getString('typeYourMessageHere'),
                    prefixIcon: Container(
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: RoundedNetworkImageHolder(
                        width: Dimens.space24,
                        height: Dimens.space24,
                        boxFit: BoxFit.cover,
                        iconUrl: CustomIcon.icon_attachment,
                        iconColor: CustomColors.textPrimaryLightColor,
                        iconSize: Dimens.space20,
                        outerCorner: Dimens.space0,
                        innerCorner: Dimens.space0,
                        boxDecorationColor: CustomColors.transparent,
                        imageUrl: "",
                        onTap: () {
                          Utils.showToastMessage(Utils.getString("comingSoon"));
                        },
                      ),
                    ),
                    suffixIcon: Container(
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: RoundedNetworkImageHolder(
                        width: Dimens.space24,
                        height: Dimens.space24,
                        boxFit: BoxFit.cover,
                        iconUrl: CustomIcon.icon_message_send,
                        iconColor: textEditingControllerMessage.text.isNotEmpty
                            ? CustomColors.mainColor
                            : CustomColors.transparent,
                        iconSize: Dimens.space20,
                        outerCorner: Dimens.space0,
                        innerCorner: Dimens.space0,
                        boxDecorationColor: CustomColors.transparent,
                        imageUrl: "",
                        onTap: () async {
                          if (textEditingControllerMessage.text.isNotEmpty) {
                            if (selectedContact != null) {
                              PsProgressDialog.showDialog(context);
                              Resources<Messages> sendMessageResponse =
                                  await messagesProvider.doSendMessageApiCall(
                                      textEditingControllerMessage.text,
                                      selectedContact.contactNode.number);
                              if (sendMessageResponse.data != null) {
                                Navigator.of(context).pop();
                                PsProgressDialog.dismissDialog();
                                widget.onMessageSent(selectedContact);
                              } else {
                                PsProgressDialog.dismissDialog();
                                Utils.showToastMessage(
                                    sendMessageResponse.message);
                              }
                            } else {
                              Utils.showToastMessage(
                                  Utils.getString("pleaseSelectAContact"));
                            }
                          }
                        },
                      ),
                    ),
                    hintStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: CustomColors.textSenaryColor,
                        fontFamily: Config.manropeMedium,
                        fontWeight: FontWeight.normal,
                        fontSize: Dimens.space14.sp,
                        fontStyle: FontStyle.normal),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
