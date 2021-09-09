import 'package:azlistview/azlistview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/constant/RoutePaths.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/contacts/ContactsProvider.dart';
import 'package:voice_example/provider/country/CountryListProvider.dart';
import 'package:voice_example/repository/ContactRepository.dart';
import 'package:voice_example/repository/CountryListRepository.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/ui/common/EmptyViewUiWidget.dart';
import 'package:voice_example/ui/common/base/CustomAppBar.dart';
import 'package:voice_example/ui/common/dialog/BlockContactDialog.dart';
import 'package:voice_example/ui/common/dialog/ContactDetailDialog.dart';
import 'package:voice_example/ui/common/dialog/ErrorDialog.dart';
import 'package:voice_example/ui/contacts/contact_view/ContactListItemView.dart';
import 'package:voice_example/ui/dashboard/DashboardView.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/AddContactIntentHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/blockContactResponse/BlockContactResponse.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactListView extends StatefulWidget
{
  const ContactListView({
    Key key,
    @required this.animationController,
    @required this.onLeadingTap,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
    @required this.makeCallWithSid,
  }) : super(key: key);

  final AnimationController animationController;
  final Function onLeadingTap;
  final Function onIncomingTap;
  final Function onOutgoingTap;
  final Function(String, String, String, String, String, String, String, String, String, String, String, String) makeCallWithSid;


  @override
  _ContactListViewState createState() => _ContactListViewState();
}

class _ContactListViewState extends State<ContactListView> with SingleTickerProviderStateMixin
{
  ContactRepository contactRepository;
  ContactsProvider contactsProvider;
  CountryRepository countryRepository;
  CountryListProvider countryListProvider;

  ValueHolder valueHolder;

  bool isConnectedToInternet = false;
  bool isLoading = false;

  final TextEditingController controllerSearchContacts =
      TextEditingController();

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet) {}
    });
  }

  @override
  void initState() {
    countryRepository = Provider.of<CountryRepository>(context, listen: false);
    countryListProvider =
        CountryListProvider(countryListRepository: countryRepository);
    if (!isConnectedToInternet) {
      checkConnection();
    }
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      DashboardView.ebTransferData.on().listen((event) {
        contactsProvider.doAllContactApiCall();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    contactRepository = Provider.of<ContactRepository>(context);
    valueHolder = Provider.of<ValueHolder>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: CustomColors.white,
      body: CustomAppBar<ContactsProvider>(
        elevation: 0,
        centerTitle: true,
        onIncomingTap: ()
        {
          widget.onIncomingTap();
        },
        onOutgoingTap: ()
        {
          widget.onOutgoingTap();
        },
        titleWidget: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          child: Text(
            Utils.getString("contacts"),
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
        actions: [
          TextButton(
            onPressed: () async
            {
              final dynamic returnData = await Navigator.pushNamed(
                context,
                RoutePaths.newContact,
                arguments: AddContactIntentHolder(
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
                  returnData["data"] is bool &&
                  returnData["data"]) {
                contactsProvider.doAllContactApiCall();
              }
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
        initProvider: () {
          contactsProvider = ContactsProvider(
              contactRepository: contactRepository, valueHolder: valueHolder);
          return contactsProvider;
        },
        onProviderReady: (ContactsProvider provider) {
          contactsProvider.doAllContactApiCall();
          controllerSearchContacts.addListener(() {
            if (controllerSearchContacts.text.isEmpty) {
              contactsProvider.getAllContactsFromDB();
            } else if (controllerSearchContacts.text != null &&
                controllerSearchContacts.text.isNotEmpty &&
                controllerSearchContacts.text != "") {
              contactsProvider
                  .doSearchContactFromDb(controllerSearchContacts.text);
            } else {
              contactsProvider.getAllContactsFromDB();
            }
          });
        },
        builder:
            (BuildContext context, ContactsProvider provider, Widget child) {
          if (!isLoading) {
            if (contactsProvider.contactResponse != null &&
                contactsProvider.contactResponse.data != null) {
              if (contactsProvider.contactResponse.data.contactResponse
                  .contactResponseData.contactEdges.isNotEmpty) {
                for (int i = 0,
                        length = contactsProvider
                            .contactResponse
                            .data
                            .contactResponse
                            .contactResponseData
                            .contactEdges
                            .length;
                    i < length;
                    i++) {
                  String pinyin = PinyinHelper.getPinyinE(contactsProvider
                                  .contactResponse
                                  .data
                                  .contactResponse
                                  .contactResponseData
                                  .contactEdges[i]
                                  .contactNode
                                  .name !=
                              null &&
                          contactsProvider
                              .contactResponse
                              .data
                              .contactResponse
                              .contactResponseData
                              .contactEdges[i]
                              .contactNode
                              .name
                              .isNotEmpty
                      ? contactsProvider.contactResponse.data.contactResponse
                          .contactResponseData.contactEdges[i].contactNode.name
                      : Utils.getString("unknown"));
                  String tag = pinyin.substring(0, 1).toUpperCase();
                  provider.contactResponse.data.contactResponse
                      .contactResponseData.contactEdges[i].namePinyin = pinyin;
                  if (RegExp("[A-Z]").hasMatch(tag)) {
                    provider.contactResponse.data.contactResponse
                        .contactResponseData.contactEdges[i].tagIndex = tag;
                  } else {
                    provider.contactResponse.data.contactResponse
                        .contactResponseData.contactEdges[i].tagIndex = "#";
                  }
                }
                // A-Z sort.
                SuspensionUtil.sortListBySuspensionTag(provider.contactResponse
                    .data.contactResponse.contactResponseData.contactEdges);

                // show sus tag.
                SuspensionUtil.setShowSuspensionStatus(provider.contactResponse
                    .data.contactResponse.contactResponseData.contactEdges);
              }
              return RefreshIndicator(
                color: CustomColors.mainColor,
                backgroundColor: CustomColors.white,
                child: Container(
                  color: CustomColors.white,
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(
                      Dimens.space0.w,
                      Dimens.space0.h,
                      Dimens.space0.w,
                      (kBottomNavigationBarHeight + Dimens.space10).h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          controller: controllerSearchContacts,
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
                      ),
                      contactsProvider.contactResponse.data.contactResponse
                              .contactResponseData.contactEdges.isNotEmpty
                          ? Expanded(
                              child: AzListView(
                                data: provider
                                    .contactResponse
                                    .data
                                    .contactResponse
                                    .contactResponseData
                                    .contactEdges,
                                itemCount: provider
                                    .contactResponse
                                    .data
                                    .contactResponse
                                    .contactResponseData
                                    .contactEdges
                                    .length,
                                susItemBuilder: (context, i) {
                                  return Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      decoration: BoxDecoration(
                                        color: CustomColors.bottomAppBarColor,
                                      ),
                                      alignment: Alignment.center,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width.w,
                                        padding: EdgeInsets.fromLTRB(
                                            Dimens.space20.w,
                                            Dimens.space5.h,
                                            Dimens.space20.w,
                                            Dimens.space5.h),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${provider.contactResponse.data.contactResponse.contactResponseData.contactEdges[i].getSuspensionTag()}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: CustomColors
                                                  .textTertiaryColor,
                                              fontFamily: Config.manropeBold,
                                              fontSize: Dimens.space14.sp,
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.normal),
                                        ),
                                      ));
                                },
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
                                    animationController:
                                        widget.animationController,
                                    animation:
                                        Tween<double>(begin: 0.0, end: 1.0)
                                            .animate(
                                      CurvedAnimation(
                                        parent: widget.animationController,
                                        curve: Interval(
                                            (1 / count) * index, 1.0,
                                            curve: Curves.fastOutSlowIn),
                                      ),
                                    ),
                                    offStage: true,
                                    contactEdges: provider
                                        .contactResponse
                                        .data
                                        .contactResponse
                                        .contactResponseData
                                        .contactEdges[index],
                                    onTap: () async
                                    {
                                      // final dynamic returnData = await
                                      if (provider
                                          .contactResponse
                                          .data
                                          .contactResponse
                                          .contactResponseData
                                          .contactEdges[index]
                                          .contactNode
                                          .blocked!=null && provider
                                          .contactResponse
                                          .data
                                          .contactResponse
                                          .contactResponseData
                                          .contactEdges[index]
                                          .contactNode
                                          .blocked)
                                      {
                                        final dynamic returnData =
                                            await showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimens.space16.r),
                                                ),
                                                backgroundColor:
                                                    Colors.transparent,
                                                builder:
                                                    (BuildContext context) {
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
                                                              .contactEdges[
                                                                  index]
                                                              .contactNode
                                                              .id);
                                              if (deleteContactResponse !=
                                                      null &&
                                                  deleteContactResponse.data !=
                                                      null) {
                                                isLoading = false;
                                                setState(() {});
                                                Utils.showToastMessage(
                                                    Utils.getString(
                                                        'unblockContact'));
                                                contactsProvider
                                                    .doAllContactApiCall();
                                              } else if (deleteContactResponse !=
                                                      null &&
                                                  deleteContactResponse
                                                          .message !=
                                                      null) {
                                                // PsProgressDialog.dismissDialog();
                                                isLoading = false;
                                                setState(() {});
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
                                              isLoading = false;
                                              setState(() {});
                                              showDialog<dynamic>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return ErrorDialog(
                                                      message: Utils.getString(
                                                          'noInternet'));
                                                },
                                              );
                                            }
                                          }
                                        }
                                      }
                                      else
                                      {
                                        showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimens.space16.r),
                                            ),
                                            backgroundColor: Colors.white,
                                            builder: (BuildContext context) {
                                              return ContactDetailDialog(
                                                  contactId: contactsProvider
                                                      .contactResponse
                                                      .data
                                                      .contactResponse
                                                      .contactResponseData
                                                      .contactEdges[index]
                                                      .contactNode
                                                      .id,
                                                  contactNumber:
                                                      contactsProvider
                                                          .contactResponse
                                                          .data
                                                          .contactResponse
                                                          .contactResponseData
                                                          .contactEdges[index]
                                                          .contactNode
                                                          .number,
                                                  onContactUpdate: ()
                                                  {
                                                    provider.doAllContactApiCall();
                                                  },
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
                                          if (returnData != null &&
                                              returnData["data"] is bool &&
                                              returnData["data"]) {
                                            contactsProvider
                                                .doAllContactApiCall();
                                          }
                                        });
                                      }
                                    },
                                  );
                                },
                                physics: AlwaysScrollableScrollPhysics(),
                                indexBarData:
                                    SuspensionUtil.getTagIndexList(null),
                                indexBarMargin: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                indexBarOptions: IndexBarOptions(
                                  needRebuild: true,
                                  indexHintAlignment: Alignment.centerRight,
                                ),
                              ),
                            )
                          : Expanded(
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
                                  child: SingleChildScrollView(
                                    child: EmptyViewUiWidget(
                                      assetUrl:
                                          "assets/images/empty_contact.png",
                                      title: Utils.getString('noContacts'),
                                      desc: Utils.getString(
                                          'noContactsDescription'),
                                      buttonTitle:
                                          Utils.getString('addANewContact'),
                                      icon: Icons.add_circle_outline,
                                      onPressed: () async {
                                        final dynamic returnData =
                                            await Navigator.pushNamed(
                                          context,
                                          RoutePaths.newContact,
                                          arguments: AddContactIntentHolder(
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
                                            returnData["data"] is bool &&
                                            returnData["data"]) {
                                          contactsProvider
                                              .doAllContactApiCall();
                                        }
                                      },
                                    ),
                                  )),
                            ),
                    ],
                  ),
                ),
                onRefresh: () {
                  return contactsProvider.doAllContactApiCall();
                },
              );
            } else {
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
          } else {
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
        },
      ),
    );
  }
}
