import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/utils/DeBouncer.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/RoutePaths.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/contacts/ContactsProvider.dart';
import 'package:voice_example/repository/ContactRepository.dart';
import 'package:voice_example/ui/common/base/CustomAppBar.dart';
import 'package:voice_example/ui/common/dialog/BlockContactDialog.dart';
import 'package:voice_example/ui/common/dialog/ChannelSelectionDialog.dart';
import 'package:voice_example/ui/common/dialog/CountryCodeSelectorDialog.dart';
import 'package:voice_example/ui/common/dialog/ErrorDialog.dart';
import 'package:voice_example/utils/utils.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/blockContactResponse/BlockContactResponse.dart';
import 'package:voice_example/viewobject/model/allContact/AllContactEdges.dart';
import 'package:voice_example/viewobject/model/allContact/Contact.dart';
import 'package:voice_example/viewobject/model/country/CountryCode.dart';
import 'package:voice_example/viewobject/holder/intent_holder/AddContactIntentHolder.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/viewobject/model/workspace/workspace_detail/WorkspaceChannel.dart';
import 'package:voice_example/viewobject/model/workspace/workspace_detail/WorkspaceDetail.dart';
import 'package:provider/provider.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialerView extends StatefulWidget {
  const DialerView({
    Key key,
    @required this.onLeadingTap,
    @required this.makeCallWithSid,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
    this.animationController,
    this.countryList,
    this.defaultCountryCode,
  }) : super(key: key);

  final AnimationController animationController;
  final List<CountryCode> countryList;
  final CountryCode defaultCountryCode;
  final Function(String, String, String, String, String, String, String, String, String, String, String, String) makeCallWithSid;
  final Function onLeadingTap;
  final Function onIncomingTap;
  final Function onOutgoingTap;

  @override
  _DialerViewState createState() => _DialerViewState();
}

class _DialerViewState extends State<DialerView> with TickerProviderStateMixin {
  ContactRepository contactRepository;
  ContactsProvider contactsProvider;

  ValueHolder valueHolder;

  bool isConnectedToInternet = false, outgoingValidation = false;

  final TextEditingController controllerNumber = TextEditingController();
  CountryCode selectedCountryCode;
  Contacts selectedContact;
  Animation<double> animation;
  final deBouncer = DeBouncer(milliseconds: 500);
  bool isLoading = false;
  bool isCountrySelected = false;


  @override
  void initState() {
    checkConnection();
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: widget.animationController,
        curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
    contactRepository = Provider.of<ContactRepository>(context, listen: false);

    valueHolder = Provider.of<ValueHolder>(context, listen: false);
    selectedCountryCode = widget.defaultCountryCode;
    for (int i = 0; i < widget.countryList.length; i++) {
      if (widget.countryList[i].dialCode == "+") {
        widget.countryList.remove(i);
      }
    }
    controllerNumber.addListener(() {
      if (controllerNumber.text.isNotEmpty) {
        for (int i = 0; i < widget.countryList.length; i++) {
          if(! isCountrySelected){
            if (controllerNumber.text.toLowerCase() ==
                widget.countryList[i].dialCode.toLowerCase()) {
              setState(() {
                selectedCountryCode = widget.countryList[i];
                controllerNumber.selection = TextSelection.fromPosition(
                    TextPosition(offset: controllerNumber.text.length));
              });
              break;
            }
          }
        }
      } else {
        setState(() {
          controllerNumber.text = selectedCountryCode.dialCode;
          controllerNumber.selection = TextSelection.fromPosition(
              TextPosition(offset: controllerNumber.text.length));
        });
      }
    });
    validate("");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      widget.animationController.reverse().then<dynamic>(
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

    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: CustomColors.white,
          body: CustomAppBar<ContactsProvider>(
            elevation: 0,
            centerTitle: false,
            titleWidget: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: RoundedNetworkSvgHolder(
                      containerWidth: Dimens.space40,
                      containerHeight: Dimens.space40,
                      boxFit: BoxFit.contain,
                      imageWidth: Dimens.space20,
                      imageHeight: Dimens.space20,
                      imageUrl: contactRepository.getDefaultChannel() != null &&
                              contactRepository
                                      .getDefaultChannel()
                                      .countryLogo !=
                                  null
                          ? Config.countryLogoUrl +
                              contactRepository.getDefaultChannel().countryLogo
                          : "",
                      outerCorner: Dimens.space300,
                      innerCorner: Dimens.space0,
                      iconUrl: CustomIcon.icon_person,
                      iconColor: CustomColors.mainColor,
                      iconSize: Dimens.space20,
                      boxDecorationColor: CustomColors.mainBackgroundColor,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space12.w,
                              Dimens.space0.h,
                              Dimens.space12.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: Text(
                            contactRepository.getDefaultChannel() != null &&
                                contactRepository.getDefaultChannel().name !=
                                    null
                                ? contactRepository.getDefaultChannel().name
                                : Utils.getString("appName"),
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: CustomColors.textPrimaryColor,
                                      fontFamily: Config.manropeBold,
                                      fontSize: Dimens.space16.sp,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space12.w,
                              Dimens.space0.h,
                              Dimens.space12.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: Text(
                              FlutterLibphonenumber().formatNumberSync(contactRepository.getDefaultChannel() != null &&
                                  contactRepository.getDefaultChannel().number !=
                                      null
                                  ? contactRepository.getDefaultChannel().number
                                  : Utils.getString("appName")),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
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
                ],
              ),
            ),
            leadingWidget: TextButton(
              onPressed: widget.onLeadingTap,
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.center,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
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
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
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
            // actions: [
            //   TextButton(
            //     onPressed: () {
            //       _channelSelectionDialog(
            //           context: context,
            //           workspaceDetails: contactsProvider.getWorkspaceDetail());
            //     },
            //     style: TextButton.styleFrom(
            //       alignment: Alignment.center,
            //       backgroundColor: CustomColors.transparent,
            //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //       padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0,
            //           Dimens.space0, Dimens.space0),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(Dimens.space0.r),
            //       ),
            //     ),
            //     child: RoundedNetworkImageHolder(
            //       width: Dimens.space20,
            //       height: Dimens.space20,
            //       boxFit: BoxFit.cover,
            //       iconUrl: CustomIcon.icon_arrow_down,
            //       iconColor: CustomColors.textTertiaryColor,
            //       iconSize: Dimens.space18,
            //       outerCorner: Dimens.space10,
            //       innerCorner: Dimens.space10,
            //       boxDecorationColor: CustomColors.transparent,
            //       imageUrl: "",
            //     ),
            //   ),
            // ],
            initProvider: () {
              contactsProvider =
                  ContactsProvider(contactRepository: contactRepository);
              return contactsProvider;
            },
            onProviderReady: (ContactsProvider provider) {
              contactsProvider.doAllContactApiCall();
            },
            builder: (BuildContext context, ContactsProvider provider,
                Widget child) {
              return AnimatedBuilder(
                animation: widget.animationController,
                builder: (BuildContext context, Widget child) {
                  return FadeTransition(
                      opacity: animation,
                      child: Transform(
                        transform: Matrix4.translationValues(
                            0.0, 100 * (1 - animation.value), 0.0),
                        child: Container(
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space40.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          color: CustomColors.white,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              SizedBox(height: Dimens.space60.h),
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space60.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                        alignment: Alignment.center,
                                        width: Dimens.space43.w,
                                        margin: EdgeInsets.fromLTRB(
                                            Dimens.space0.w,
                                            Dimens.space0.h,
                                            Dimens.space0.w,
                                            Dimens.space0.h),
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                            padding: EdgeInsets.fromLTRB(
                                                Dimens.space0.w,
                                                Dimens.space0.h,
                                                Dimens.space0.w,
                                                Dimens.space0.h),
                                          ),
                                          onPressed: () {
                                            showCountryCodeSelectorDialog();
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    Dimens.space0.w,
                                                    Dimens.space0.h,
                                                    Dimens.space0.w,
                                                    Dimens.space0.h),
                                                alignment: Alignment.center,
                                                child: RoundedNetworkSvgHolder(
                                                  containerWidth:
                                                      Dimens.space24,
                                                  containerHeight:
                                                      Dimens.space24,
                                                  boxFit: BoxFit.contain,
                                                  imageWidth: Dimens.space24,
                                                  imageHeight: Dimens.space24,
                                                  imageUrl:
                                                      Config.countryLogoUrl +
                                                          selectedCountryCode
                                                              .flagUri,
                                                  outerCorner: Dimens.space0,
                                                  innerCorner: Dimens.space0,
                                                  iconUrl:
                                                      CustomIcon.icon_person,
                                                  iconColor:
                                                      CustomColors.mainColor,
                                                  iconSize: Dimens.space20,
                                                  boxDecorationColor:
                                                      CustomColors.transparent,
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    Dimens.space9.w,
                                                    Dimens.space0.h,
                                                    Dimens.space0.w,
                                                    Dimens.space0.h),
                                                alignment: Alignment.center,
                                                child: Icon(
                                                  CustomIcon.icon_drop_down,
                                                  color: CustomColors
                                                      .textQuinaryColor,
                                                  size: Dimens.space5.w,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                    Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space13.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      padding: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      child: Text(
                                        controllerNumber.text.length >=
                                                selectedCountryCode
                                                    .dialCode.length
                                            ? controllerNumber.text.substring(
                                                0,
                                                selectedCountryCode
                                                    .dialCode.length)
                                            : controllerNumber.text.substring(0,
                                                controllerNumber.text.length),
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        softWrap: false,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                color: CustomColors
                                                    .textQuinaryColor,
                                                fontFamily:
                                                    Config.manropeSemiBold,
                                                fontSize: Dimens.space24.sp,
                                                fontWeight: FontWeight.normal,
                                                fontStyle: FontStyle.normal),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space8.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      padding: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      child: Text(
                                        controllerNumber.text.length >
                                                selectedCountryCode
                                                    .dialCode.length
                                            ? controllerNumber.text
                                                    .substring(
                                                        selectedCountryCode
                                                            .dialCode.length)
                                                    .isNotEmpty
                                                ? controllerNumber.text
                                                    .substring(
                                                        selectedCountryCode
                                                            .dialCode.length)
                                                : Utils.getString("enterNumber")
                                            : Utils.getString("enterNumber"),
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                color: controllerNumber
                                                            .text.length >
                                                        selectedCountryCode
                                                            .dialCode.length
                                                    ? controllerNumber.text
                                                            .substring(
                                                                selectedCountryCode
                                                                    .dialCode
                                                                    .length)
                                                            .isNotEmpty
                                                        ? CustomColors
                                                            .textPrimaryColor
                                                        : CustomColors
                                                            .textQuinaryColor
                                                    : CustomColors
                                                        .textQuinaryColor,
                                                fontFamily:
                                                    Config.manropeSemiBold,
                                                fontSize: Dimens.space24.sp,
                                                fontWeight: FontWeight.normal,
                                                fontStyle: FontStyle.normal),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space14.h,
                                    Dimens.space0.w,
                                    Dimens.space20.h),
                                alignment: Alignment.center,
                                child: selectedContact != null
                                    ? InkWell(
                                        onTap: () async {
                                          setState(() {
                                            controllerNumber.text =
                                                selectedContact.number;
                                          });
                                          validate("");
                                        },
                                        child: Text(
                                          selectedContact.name != null
                                              ? selectedContact.name
                                              : Utils.getString("unknown"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .button
                                              .copyWith(
                                                  color: CustomColors
                                                      .textPrimaryColor,
                                                  fontFamily:
                                                      Config.manropeSemiBold,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: Dimens.space15.sp,
                                                  fontWeight:
                                                      FontWeight.normal),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () async {
                                          // Navigator.pushNamed(
                                          //     context, RoutePaths.newContact,arguments: AddContactIntentHolder(
                                          //   countryList: countryListProvider.countryList.data,
                                          //   defaultCountryCode: countryListProvider.getDefaultCountryCode(),
                                          // ))

                                          final dynamic returnData =
                                              await Navigator.pushNamed(
                                            context,
                                            RoutePaths.newContact,
                                            arguments: AddContactIntentHolder(
                                              phoneNumber: controllerNumber.text
                                                  .substring(selectedCountryCode
                                                      .dialCode.length),
                                              defaultCountryCode:
                                                  selectedCountryCode,
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
                                            validate("");
                                          }
                                        },
                                        child: Text(
                                          Utils.getString("addContacts"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .button
                                              .copyWith(
                                                  color: CustomColors
                                                      .loadingCircleColor,
                                                  fontFamily:
                                                      Config.manropeSemiBold,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: Dimens.space15.sp,
                                                  fontWeight:
                                                      FontWeight.normal),
                                        ),
                                      ),
                              ),
                              SizedBox(height: Dimens.space10.h),
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space10.w,
                                    Dimens.space0.h,
                                    Dimens.space10.w,
                                    Dimens.space16.h),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      alignment: Alignment.center,
                                      width: Dimens.space76.w,
                                      height: Dimens.space76.w,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          backgroundColor:
                                              CustomColors.bottomAppBarColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Dimens.space100.r),
                                          ),
                                        ),
                                        onPressed: () {
                                          validate("1");
                                        },
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          alignment: Alignment.center,
                                          width: Dimens.space76.w,
                                          height: Dimens.space76.w,
                                          child: Text(
                                            Utils.getString("1"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                    color: CustomColors
                                                        .textSenaryColor,
                                                    fontFamily:
                                                        Config.manropeSemiBold,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: Dimens.space32.sp,
                                                    fontStyle: FontStyle.normal,
                                                    height:
                                                        Dimens.space1andHalf.h),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      alignment: Alignment.center,
                                      width: Dimens.space76.w,
                                      height: Dimens.space76.w,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          backgroundColor:
                                              CustomColors.bottomAppBarColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Dimens.space100.r),
                                          ),
                                        ),
                                        onPressed: () {
                                          validate("2");
                                        },
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          alignment: Alignment.center,
                                          width: Dimens.space76.w,
                                          height: Dimens.space76.w,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                Utils.getString("2"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: CustomColors
                                                            .textSenaryColor,
                                                        fontFamily: Config
                                                            .manropeSemiBold,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize:
                                                            Dimens.space32.sp,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        height: Dimens
                                                            .space1andHalf.h),
                                              ),
                                              Text(
                                                Utils.getString("abc"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: CustomColors
                                                            .textSenaryColor,
                                                        fontFamily:
                                                            Config.heeboMedium,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize:
                                                            Dimens.space12.sp,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        height:
                                                            Dimens.space1.h),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      alignment: Alignment.center,
                                      width: Dimens.space76.w,
                                      height: Dimens.space76.w,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          backgroundColor:
                                              CustomColors.bottomAppBarColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Dimens.space100.r),
                                          ),
                                        ),
                                        onPressed: () {
                                          validate("3");
                                        },
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          alignment: Alignment.center,
                                          width: Dimens.space76.w,
                                          height: Dimens.space76.w,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                Utils.getString("3"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: CustomColors
                                                            .textSenaryColor,
                                                        fontFamily: Config
                                                            .manropeSemiBold,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize:
                                                            Dimens.space32.sp,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        height: Dimens
                                                            .space1andHalf.h),
                                              ),
                                              Text(
                                                Utils.getString("def"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: CustomColors
                                                            .textSenaryColor,
                                                        fontFamily:
                                                            Config.heeboMedium,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize:
                                                            Dimens.space12.sp,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        height:
                                                            Dimens.space1.h),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space10.w,
                                    Dimens.space0.h,
                                    Dimens.space10.w,
                                    Dimens.space16.h),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      alignment: Alignment.center,
                                      width: Dimens.space76.w,
                                      height: Dimens.space76.w,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          backgroundColor:
                                              CustomColors.bottomAppBarColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Dimens.space100.r),
                                          ),
                                        ),
                                        onPressed: () {
                                          validate("4");
                                        },
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          alignment: Alignment.center,
                                          width: Dimens.space76.w,
                                          height: Dimens.space76.w,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                Utils.getString("4"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: CustomColors
                                                            .textSenaryColor,
                                                        fontFamily: Config
                                                            .manropeSemiBold,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize:
                                                            Dimens.space32.sp,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        height: Dimens
                                                            .space1andHalf.h),
                                              ),
                                              Text(
                                                Utils.getString("ghi"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: CustomColors
                                                            .textSenaryColor,
                                                        fontFamily:
                                                            Config.heeboMedium,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize:
                                                            Dimens.space12.sp,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        height:
                                                            Dimens.space1.h),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      alignment: Alignment.center,
                                      width: Dimens.space76.w,
                                      height: Dimens.space76.w,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          backgroundColor:
                                              CustomColors.bottomAppBarColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Dimens.space100.r),
                                          ),
                                        ),
                                        onPressed: () {
                                          validate("5");
                                        },
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          alignment: Alignment.center,
                                          width: Dimens.space76.w,
                                          height: Dimens.space76.w,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                Utils.getString("5"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: CustomColors
                                                            .textSenaryColor,
                                                        fontFamily: Config
                                                            .manropeSemiBold,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize:
                                                            Dimens.space32.sp,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        height: Dimens
                                                            .space1andHalf.h),
                                              ),
                                              Text(
                                                Utils.getString("jkl"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: CustomColors
                                                            .textSenaryColor,
                                                        fontFamily:
                                                            Config.heeboMedium,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize:
                                                            Dimens.space12.sp,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        height:
                                                            Dimens.space1.h),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      alignment: Alignment.center,
                                      width: Dimens.space76.w,
                                      height: Dimens.space76.w,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          backgroundColor:
                                              CustomColors.bottomAppBarColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Dimens.space100.r),
                                          ),
                                        ),
                                        onPressed: () {
                                          validate("6");
                                        },
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          alignment: Alignment.center,
                                          width: Dimens.space76.w,
                                          height: Dimens.space76.w,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                Utils.getString("6"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: CustomColors
                                                            .textSenaryColor,
                                                        fontFamily: Config
                                                            .manropeSemiBold,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize:
                                                            Dimens.space32.sp,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        height: Dimens
                                                            .space1andHalf.h),
                                              ),
                                              Text(
                                                Utils.getString("mno"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: CustomColors
                                                            .textSenaryColor,
                                                        fontFamily:
                                                            Config.heeboMedium,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize:
                                                            Dimens.space12.sp,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        height:
                                                            Dimens.space1.h),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space10.w,
                                    Dimens.space0.h,
                                    Dimens.space10.w,
                                    Dimens.space16.h),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      alignment: Alignment.center,
                                      width: Dimens.space76.w,
                                      height: Dimens.space76.w,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          backgroundColor:
                                              CustomColors.bottomAppBarColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Dimens.space100.r),
                                          ),
                                        ),
                                        onPressed: () {
                                          validate("7");
                                        },
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          alignment: Alignment.center,
                                          width: Dimens.space76.w,
                                          height: Dimens.space76.w,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                Utils.getString("7"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: CustomColors
                                                            .textSenaryColor,
                                                        fontFamily: Config
                                                            .manropeSemiBold,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize:
                                                            Dimens.space32.sp,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        height: Dimens
                                                            .space1andHalf.h),
                                              ),
                                              Text(
                                                Utils.getString("pqr"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: CustomColors
                                                            .textSenaryColor,
                                                        fontFamily:
                                                            Config.heeboMedium,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize:
                                                            Dimens.space12.sp,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        height:
                                                            Dimens.space1.h),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      alignment: Alignment.center,
                                      width: Dimens.space76.w,
                                      height: Dimens.space76.w,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          backgroundColor:
                                              CustomColors.bottomAppBarColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Dimens.space100.r),
                                          ),
                                        ),
                                        onPressed: () {
                                          validate("8");
                                        },
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          alignment: Alignment.center,
                                          width: Dimens.space76.w,
                                          height: Dimens.space76.w,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                Utils.getString("8"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: CustomColors
                                                            .textSenaryColor,
                                                        fontFamily: Config
                                                            .manropeSemiBold,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize:
                                                            Dimens.space32.sp,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        height: Dimens
                                                            .space1andHalf.h),
                                              ),
                                              Text(
                                                Utils.getString("stuv"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: CustomColors
                                                            .textSenaryColor,
                                                        fontFamily:
                                                            Config.heeboMedium,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize:
                                                            Dimens.space12.sp,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        height: Dimens.space1),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      alignment: Alignment.center,
                                      width: Dimens.space76.w,
                                      height: Dimens.space76.w,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          backgroundColor:
                                              CustomColors.bottomAppBarColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Dimens.space100.r),
                                          ),
                                        ),
                                        onPressed: () {
                                          validate("9");
                                        },
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          alignment: Alignment.center,
                                          width: Dimens.space76.w,
                                          height: Dimens.space76.w,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                Utils.getString("9"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: CustomColors
                                                            .textSenaryColor,
                                                        fontFamily: Config
                                                            .manropeSemiBold,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize:
                                                            Dimens.space32.sp,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        height: Dimens
                                                            .space1andHalf.h),
                                              ),
                                              Text(
                                                Utils.getString("wxyz"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                      color: CustomColors
                                                          .textSenaryColor,
                                                      fontFamily:
                                                          Config.heeboMedium,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize:
                                                          Dimens.space12.sp,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      height: Dimens.space1,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space10.w,
                                    Dimens.space0.h,
                                    Dimens.space10.w,
                                    Dimens.space16.h),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      alignment: Alignment.center,
                                      width: Dimens.space76.w,
                                      height: Dimens.space76.w,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          backgroundColor:
                                              CustomColors.bottomAppBarColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Dimens.space70.r),
                                          ),
                                          alignment: Alignment.center,
                                        ),
                                        onPressed: () {
                                          validate("*");
                                        },
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          alignment: Alignment.center,
                                          width: Dimens.space76.w,
                                          height: Dimens.space76.w,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                                child: Text(
                                                  Utils.getString("*"),
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                        color: CustomColors
                                                            .textSenaryColor,
                                                        fontFamily: Config
                                                            .manropeSemiBold,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize:
                                                            Dimens.space32.sp,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        height: Dimens
                                                            .space1andHalf.h,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      alignment: Alignment.center,
                                      width: Dimens.space76.w,
                                      height: Dimens.space76.w,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          backgroundColor:
                                              CustomColors.bottomAppBarColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Dimens.space70.r),
                                          ),
                                          alignment: Alignment.center,
                                        ),
                                        onPressed: () {
                                          validate("0");
                                        },
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          alignment: Alignment.center,
                                          width: Dimens.space76.w,
                                          height: Dimens.space76.w,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                                child: Text(
                                                  Utils.getString("0"),
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                        color: CustomColors
                                                            .textSenaryColor,
                                                        fontFamily: Config
                                                            .manropeSemiBold,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize:
                                                            Dimens.space32.sp,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        height: Dimens
                                                            .space1andHalf.h,
                                                      ),
                                                ),
                                              ),
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
                                                child: Text(
                                                  Utils.getString("+"),
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                        color: CustomColors
                                                            .textSenaryColor,
                                                        fontFamily:
                                                            Config.heeboMedium,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize:
                                                            Dimens.space16.sp,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        height: Dimens.space1.h,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      alignment: Alignment.center,
                                      width: Dimens.space76.w,
                                      height: Dimens.space76.w,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          backgroundColor:
                                              CustomColors.bottomAppBarColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Dimens.space70.r),
                                          ),
                                          alignment: Alignment.center,
                                        ),
                                        onPressed: () {
                                          validate("#");
                                        },
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          alignment: Alignment.center,
                                          width: Dimens.space76.w,
                                          height: Dimens.space76.w,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                                child: Text(
                                                  Utils.getString("#"),
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                        color: CustomColors
                                                            .textSenaryColor,
                                                        fontFamily: Config
                                                            .manropeSemiBold,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize:
                                                            Dimens.space32.sp,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        height: Dimens
                                                            .space1andHalf.h,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space10.w,
                                    Dimens.space0.h,
                                    Dimens.space10.w,
                                    Dimens.space16.h),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      alignment: Alignment.center,
                                      width: Dimens.space76.w,
                                      height: Dimens.space76.w,
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      alignment: Alignment.center,
                                      width: Dimens.space76.w,
                                      height: Dimens.space76.w,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          backgroundColor: outgoingValidation && isLoading == false
                                              ? CustomColors.callAcceptColor
                                              : CustomColors.bottomAppBarColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Dimens.space100.r),
                                          ),
                                        ),
                                        onPressed: () async
                                        {
                                          List<WorkspaceChannel>listWorkspaceChannel = contactsProvider.getChannelList();
                                          if (listWorkspaceChannel != null && listWorkspaceChannel.length != 0)
                                          {
                                            for (int i = 0; i < listWorkspaceChannel.length; i++)
                                            {
                                              if (listWorkspaceChannel[i].number == controllerNumber.text)
                                              {
                                                Utils.showToastMessage(Utils.getString("cannotCallThisNumber"));
                                                return;
                                              }
                                            }
                                          }

                                          Utils.checkInternetConnectivity().then((value) async
                                          {
                                            if (outgoingValidation && value && isLoading == false)
                                            {
                                              if (contactsProvider.getWorkspaceDetail().workspaceChannel.length == 1)
                                              {
                                                if (selectedContact != null && selectedContact.name != null && selectedContact.blocked)
                                                {
                                                  blockedContact();
                                                }
                                                else
                                                {
                                                  widget.makeCallWithSid(
                                                    contactsProvider.getDefaultChannel().number,
                                                    contactsProvider.getDefaultChannel().name,
                                                    contactsProvider.getDefaultChannel().id,
                                                    contactsProvider.getDefaultChannel().countryLogo,
                                                    controllerNumber.text,
                                                    contactsProvider.getDefaultWorkspace(),
                                                    contactsProvider.getMemberId(),
                                                    contactsProvider.getVoiceToken(),
                                                    selectedContact!=null?selectedContact.name:Utils.getString("unknown"),
                                                    selectedContact!=null?selectedContact.id:"",
                                                    selectedCountryCode.flagUri,
                                                    selectedContact!=null?selectedContact.profilePicture:"",
                                                  );
                                                }
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
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          alignment: Alignment.center,
                                          width: Dimens.space76.w,
                                          height: Dimens.space76.w,
                                          child: Icon(
                                            CustomIcon.icon_call,
                                            size: Dimens.space32.w,
                                            color: CustomColors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      alignment: Alignment.center,
                                      width: Dimens.space76.w,
                                      height: Dimens.space76.w,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          backgroundColor:
                                              CustomColors.bottomAppBarColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Dimens.space100.r),
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            controllerNumber.text =
                                                controllerNumber.text.substring(
                                                    0,
                                                    controllerNumber
                                                            .text.length -
                                                        1);
                                            validate("");
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          alignment: Alignment.center,
                                          width: Dimens.space76.w,
                                          height: Dimens.space76.w,
                                          child: Icon(
                                            CustomIcon.icon_back_space,
                                            color: CustomColors.textQuaternaryColor,
                                            size: Dimens.space26.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  );
                },
              );
            },
          ),
        )
    );
  }

  void showCountryCodeSelectorDialog() async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.space10.r),
        ),
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height.h,
            width: MediaQuery.of(context).size.width.w,
            padding: EdgeInsets.fromLTRB(
                Dimens.space0.w,
                Utils.getStatusBarHeight(context) + 30,
                Dimens.space0.w,
                Dimens.space0.h),
            child: CountryCodeSelectorDialog(
              countryCodeList: widget.countryList,
              selectedCountryCode: selectedCountryCode,
              onSelectCountryCode: (CountryCode countryCode) {
                setState(() {
                  isCountrySelected = true;
                  selectedCountryCode = countryCode;
                  controllerNumber.text = selectedCountryCode.dialCode;
                  validate("");
                });
              },
            ),
          );
        });
  }

  void blockedContact() async
  {
    final dynamic returnData = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.space16.r),
        ),
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return BlockContactDialog(
            block: true,
          );
        });
    if (returnData != null && returnData["data"] is bool && returnData["data"])
    {
      if (returnData["action"] == "block")
      {
        if (await Utils.checkInternetConnectivity())
        {
          Resources<BlockContactResponse> blockContactResponse = await contactsProvider.blockContacts({
            "blocked": false,},
              selectedContact.id
          );

          if (blockContactResponse != null && blockContactResponse.data != null)
          {
            Utils.showToastMessage(Utils.getString('unblockContact'));
            widget.makeCallWithSid(
              contactsProvider.getDefaultChannel().number,
              contactsProvider.getDefaultChannel().name,
              contactsProvider.getDefaultChannel().id,
              contactsProvider.getDefaultChannel().countryLogo,
              controllerNumber.text,
              contactsProvider.getDefaultWorkspace(),
              contactsProvider.getMemberId(),
              contactsProvider.getVoiceToken(),
              selectedContact.name,
              selectedContact.id,
              selectedCountryCode.flagUri,
              selectedContact.profilePicture,
            );
          }
          else if (blockContactResponse != null && blockContactResponse.message != null)
          {
            // PsProgressDialog.dismissDialog();
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  return ErrorDialog(
                    message: blockContactResponse.message,
                  );
                });
          }
        }
        else
        {
          showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(message: Utils.getString('noInternet'));
            },
          );
        }
      }
    }
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
              if (selectedContact != null && selectedContact.name != null && selectedContact.blocked)
              {
                blockedContact();
              }
              else
              {
                widget.makeCallWithSid(
                  data.number,
                  data.name,
                  data.id,
                  data.countryLogo,
                  controllerNumber.text,
                  contactsProvider.getDefaultWorkspace(),
                  contactsProvider.getMemberId(),
                  contactsProvider.getVoiceToken(),
                  selectedContact!=null?selectedContact.name:Utils.getString("unknown"),
                  selectedContact!=null?selectedContact.id:null,
                  selectedCountryCode.flagUri,
                  selectedContact!=null?selectedContact.profilePicture:"",
                );
              }
            },
          )
      ),
    );
  }

  void validate(String number) async
  {

    if (contactsProvider != null) {
      isLoading = true;
      isCountrySelected = false;
      deBouncer.run(() async{
        List<AllContactEdges> result =
            await contactsProvider.doSearchContactFromDb(controllerNumber.text);

        if (result != null && result.length != 0)
        {
            selectedContact = result[0].contactNode;
            isLoading = false;
            setState(() {});
        } else {
          selectedContact = null;
          isLoading = false;
          setState(() {});
        }
      });

    }

    if (controllerNumber.text.isEmpty) {
      setState(() {
        controllerNumber.text =
            selectedCountryCode.dialCode + "" + controllerNumber.text + number;
      });
    } else {
      setState(() {
        controllerNumber.text = controllerNumber.text + number;
      });
    }
    if ((controllerNumber.text.length - selectedCountryCode.dialCode.length) == 10) {
      setState(() {
        this.outgoingValidation = true;
      });
    } else {
      setState(() {
        this.outgoingValidation = false;
      });
    }
  }
}


