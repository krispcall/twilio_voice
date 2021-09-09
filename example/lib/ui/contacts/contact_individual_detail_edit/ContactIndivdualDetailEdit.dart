import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/provider/contacts/ContactsProvider.dart';
import 'package:voice_example/provider/country/CountryListProvider.dart';
import 'package:voice_example/repository/ContactRepository.dart';
import 'package:voice_example/repository/CountryListRepository.dart';
import 'package:voice_example/ui/common/ButtonWidget.dart';
import 'package:voice_example/ui/common/CustomTextField.dart';
import 'package:voice_example/ui/common/base/CustomAppBar.dart';
import 'package:voice_example/ui/common/dialog/CountryCodeSelectorDialog.dart';
import 'package:voice_example/ui/common/dialog/ErrorDialog.dart';
import 'package:voice_example/utils/PsProgressDialog.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/utils/Validation.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/editContactRequestHolder/EditContactRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/editContactRequestParamHolder/EditContactRequestParamHolder.dart';
import 'package:voice_example/viewobject/model/allContact/Tags.dart';
import 'package:voice_example/viewobject/model/country/CountryCode.dart';
import 'package:voice_example/viewobject/model/editContact/EditContactResponse.dart';
import 'package:provider/provider.dart';

class ContactIndividualDetailEditView extends StatefulWidget {
  final String editName;
  final String contactName;
  final String contactNumber;
  final String email;
  final String company;
  final String address;
  final String photoUpload;
  final List<Tags> tags;
  final bool visibility;
  final String id;
  final Function onIncomingTap;
  final Function onOutgoingTap;

  const ContactIndividualDetailEditView(
      {Key key,
      @required this.onIncomingTap,
      @required this.onOutgoingTap,
      this.editName = "",
      this.contactName = "",
      this.contactNumber = "",
      this.email = "",
      this.company = "",
      this.address = "",
      this.photoUpload = "",
      this.tags,
      this.visibility,
      this.id})
      : super(key: key);

  @override
  _ContactIndividualDetailEditViewState createState() =>
      _ContactIndividualDetailEditViewState();
}

class _ContactIndividualDetailEditViewState
    extends State<ContactIndividualDetailEditView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  TextEditingController contactName = TextEditingController();
  TextEditingController contactNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController company = TextEditingController();
  TextEditingController address = TextEditingController();
  CountryCode selectedCountryCode;
  bool isConnectedToInternet = false;
  bool isSelected = true;
  bool showAdditionalDetail = false;
  ContactsProvider contactsProvider;
  ContactRepository contactRepository;
  CountryRepository countryRepository;
  CountryListProvider countryListProvider;
  List<CountryCode> countryCodeList;
  Animation<double> animation;
  ValueHolder valueHolder;

  @override
  void initState() {
    contactNumber.text = widget.contactNumber;
    contactName.text = widget.contactName;
    email.text = widget.email;
    company.text = widget.company;
    address.text = widget.address;

    checkConnection();
    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);
    animationController.forward();
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
    valueHolder = Provider.of<ValueHolder>(context, listen: false);
    countryRepository = Provider.of<CountryRepository>(context, listen: false);
    contactRepository = Provider.of<ContactRepository>(context, listen: false);
    countryListProvider =
        CountryListProvider(countryListRepository: countryRepository);

    countryListProvider.getCountryListFromDb().then((data) {
      countryCodeList = data;
      selectedCountryCode = countryCodeList[13];

      contactNumber.addListener(() {
        if (contactNumber.text.isNotEmpty) {
          for (int i = 0; i < countryCodeList.length; i++) {
            if (contactNumber.text.toLowerCase() ==
                countryCodeList[i].dialCode.toLowerCase()) {
              setState(() {
                selectedCountryCode = countryCodeList[i];
                contactNumber.selection = TextSelection.fromPosition(
                    TextPosition(offset: contactNumber.text.length));
              });
              break;
            }
          }
        } else {
          setState(() {
            contactNumber.text = selectedCountryCode.dialCode;
            contactNumber.selection = TextSelection.fromPosition(
                TextPosition(offset: contactNumber.text.length));
          });
        }
      });
      validate("");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        backgroundColor: CustomColors.white,
        body: CustomAppBar<ContactsProvider>(
            titleWidget: PreferredSize(
              preferredSize:
                  Size(MediaQuery.of(context).size.width.w, kToolbarHeight.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: CustomColors.white,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(Dimens.space8.w,
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
                              backgroundColor: CustomColors.transparent),
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
                                Utils.getString('cancel'),
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
                    flex: 2,
                    child: Text(
                      "Edit ${widget.editName == "contactName" ? "Contact Name" :widget.editName == "phoneNumber" ? "Phone Number" : widget.editName == "email" ? "Email Address" : widget.editName == "company" ? "Company Name" : "Address"}",
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
                  Expanded(flex: 1, child: Container()),
                ],
              ),
            ),
            leadingWidget: null,
            centerTitle: false,
            elevation: 1,
            onIncomingTap: () {
              widget.onIncomingTap();
            },
            onOutgoingTap: () {
              widget.onOutgoingTap();
            },
            initProvider: () {
              return ContactsProvider(
                  contactRepository: contactRepository,
                  valueHolder: valueHolder);
            },
            onProviderReady: (ContactsProvider provider) async {
              contactsProvider = provider;
            },
            builder: (BuildContext context, ContactsProvider provider,
                Widget child) {
              animationController.forward();
              final Animation<double> animation =
                  Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                      parent: animationController,
                      curve: const Interval(0.5 * 1, 1.0,
                          curve: Curves.fastOutSlowIn)));
              return countryCodeList != null
                  ? Container(
                      color: CustomColors.white,
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                          Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            widget.editName == "contactName"
                                ? Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space30.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    padding: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    child: CustomTextField(
                                      height: Dimens.space48,
                                      titleText: Utils.getString("contactName"),
                                      containerFillColor:
                                          CustomColors.baseLightColor,
                                      borderColor: CustomColors.secondaryColor,
                                      corner: Dimens.space10,
                                      titleFont: Config.manropeBold,
                                      titleTextColor:
                                          CustomColors.textSecondaryColor,
                                      titleFontSize: Dimens.space14,
                                      titleFontStyle: FontStyle.normal,
                                      titleFontWeight: FontWeight.w700,
                                      titleMarginLeft: Dimens.space0,
                                      titleMarginRight: Dimens.space0,
                                      titleMarginBottom: Dimens.space6,
                                      titleMarginTop: Dimens.space0,
                                      hintText: Utils.getString('contactName'),
                                      hintFontColor:
                                          CustomColors.textQuaternaryColor,
                                      hintFontFamily: Config.heeboRegular,
                                      hintFontSize: Dimens.space16,
                                      hintFontStyle: FontStyle.normal,
                                      hintFontWeight: FontWeight.normal,
                                      inputFontColor:
                                          CustomColors.textQuaternaryColor,
                                      inputFontFamily: Config.heeboRegular,
                                      inputFontSize: Dimens.space16,
                                      inputFontStyle: FontStyle.normal,
                                      inputFontWeight: FontWeight.normal,
                                      textEditingController: contactName,
                                      showTitle: true,
                                      autoFocus: false,
                                      keyboardType: TextInputType.name,
                                      textInputAction: TextInputAction.next,
                                    ),
                                  )
                                : Container(),
                            widget.editName == "phoneNumber"
                                ? Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space30.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    padding: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    child: CustomTextField(
                                        codes: countryCodeList,
                                        selectedCountryCode:
                                            selectedCountryCode,
                                        // widget.defaultCountryCode,
                                        prefix: true,
                                        height: Dimens.space48,
                                        titleText:
                                            Utils.getString("phoneNumber"),
                                        containerFillColor:
                                            CustomColors.baseLightColor,
                                        borderColor:
                                            CustomColors.secondaryColor,
                                        corner: Dimens.space10,
                                        titleFont: Config.manropeBold,
                                        titleTextColor:
                                            CustomColors.textSecondaryColor,
                                        titleFontSize: Dimens.space14,
                                        titleFontStyle: FontStyle.normal,
                                        titleFontWeight: FontWeight.w700,
                                        titleMarginLeft: Dimens.space0,
                                        titleMarginRight: Dimens.space0,
                                        titleMarginBottom: Dimens.space6,
                                        titleMarginTop: Dimens.space0,
                                        hintText: "",
                                        hintFontColor:
                                            CustomColors.textQuaternaryColor,
                                        hintFontFamily: Config.heeboRegular,
                                        hintFontSize: Dimens.space16,
                                        hintFontStyle: FontStyle.normal,
                                        hintFontWeight: FontWeight.normal,
                                        inputFontColor:
                                            CustomColors.textQuaternaryColor,
                                        inputFontFamily: Config.heeboRegular,
                                        inputFontSize: Dimens.space16,
                                        inputFontStyle: FontStyle.normal,
                                        inputFontWeight: FontWeight.normal,
                                        textEditingController: contactNumber,
                                        showTitle: true,
                                        autoFocus: false,
                                        keyboardType: TextInputType.phone,
                                        textInputAction: TextInputAction.done,
                                        onPrefixTap: () {
                                          showCountryCodeSelectorDialog();
                                        }),
                                  )
                                : Container(),
                            widget.editName == "email"
                                ? Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space18.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    padding: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    child: CustomTextField(
                                      autoFocus: true,
                                      height: Dimens.space48,
                                      titleText: Utils.getString("emailId"),
                                      containerFillColor:
                                          CustomColors.baseLightColor,
                                      borderColor: CustomColors.secondaryColor,
                                      corner: Dimens.space10,
                                      titleFont: Config.manropeBold,
                                      titleTextColor:
                                          CustomColors.textSecondaryColor,
                                      titleFontSize: Dimens.space14,
                                      titleFontStyle: FontStyle.normal,
                                      titleFontWeight: FontWeight.w700,
                                      titleMarginLeft: Dimens.space0,
                                      titleMarginRight: Dimens.space0,
                                      titleMarginBottom: Dimens.space6,
                                      titleMarginTop: Dimens.space0,
                                      hintText: Utils.getString('emailAddress'),
                                      hintFontColor:
                                          CustomColors.textQuaternaryColor,
                                      hintFontFamily: Config.heeboRegular,
                                      hintFontSize: Dimens.space16,
                                      hintFontStyle: FontStyle.normal,
                                      hintFontWeight: FontWeight.normal,
                                      inputFontColor:
                                          CustomColors.textQuaternaryColor,
                                      inputFontFamily: Config.heeboRegular,
                                      inputFontSize: Dimens.space16,
                                      inputFontStyle: FontStyle.normal,
                                      inputFontWeight: FontWeight.normal,
                                      textEditingController: email,
                                      showTitle: true,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                    ),
                                  )
                                : Container(),
                            widget.editName == "company"
                                ? Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space18.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    padding: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    child: CustomTextField(
                                      height: Dimens.space48,
                                      titleText: Utils.getString("company"),
                                      containerFillColor:
                                          CustomColors.baseLightColor,
                                      borderColor: CustomColors.secondaryColor,
                                      corner: Dimens.space10,
                                      titleFont: Config.manropeBold,
                                      titleTextColor:
                                          CustomColors.textSecondaryColor,
                                      titleFontSize: Dimens.space14,
                                      titleFontStyle: FontStyle.normal,
                                      titleFontWeight: FontWeight.w700,
                                      titleMarginLeft: Dimens.space0,
                                      titleMarginRight: Dimens.space0,
                                      titleMarginBottom: Dimens.space6,
                                      titleMarginTop: Dimens.space0,
                                      hintText: Utils.getString('companyName'),
                                      hintFontColor:
                                          CustomColors.textQuaternaryColor,
                                      hintFontFamily: Config.heeboRegular,
                                      hintFontSize: Dimens.space16,
                                      hintFontStyle: FontStyle.normal,
                                      hintFontWeight: FontWeight.normal,
                                      inputFontColor:
                                          CustomColors.textQuaternaryColor,
                                      inputFontFamily: Config.heeboRegular,
                                      inputFontSize: Dimens.space16,
                                      inputFontStyle: FontStyle.normal,
                                      inputFontWeight: FontWeight.normal,
                                      textEditingController: company,
                                      showTitle: true,
                                      autoFocus: true,
                                      keyboardType: TextInputType.name,
                                      textInputAction: TextInputAction.next,
                                    ),
                                  )
                                : Container(),
                            widget.editName == "address"
                                ? Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space18.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    padding: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    child: CustomTextField(
                                      height: Dimens.space48,
                                      titleText: Utils.getString("address"),
                                      containerFillColor:
                                          CustomColors.baseLightColor,
                                      borderColor: CustomColors.secondaryColor,
                                      corner: Dimens.space10,
                                      titleFont: Config.manropeBold,
                                      titleTextColor:
                                          CustomColors.textSecondaryColor,
                                      titleFontSize: Dimens.space14,
                                      titleFontStyle: FontStyle.normal,
                                      titleFontWeight: FontWeight.w700,
                                      titleMarginLeft: Dimens.space0,
                                      titleMarginRight: Dimens.space0,
                                      titleMarginBottom: Dimens.space6,
                                      titleMarginTop: Dimens.space0,
                                      hintText: Utils.getString('address'),
                                      hintFontColor:
                                          CustomColors.textQuaternaryColor,
                                      hintFontFamily: Config.heeboRegular,
                                      hintFontSize: Dimens.space16,
                                      hintFontStyle: FontStyle.normal,
                                      hintFontWeight: FontWeight.normal,
                                      inputFontColor:
                                          CustomColors.textQuaternaryColor,
                                      inputFontFamily: Config.heeboRegular,
                                      inputFontSize: Dimens.space16,
                                      inputFontStyle: FontStyle.normal,
                                      inputFontWeight: FontWeight.normal,
                                      textEditingController: address,
                                      showTitle: true,
                                      autoFocus: true,
                                      keyboardType: TextInputType.name,
                                      textInputAction: TextInputAction.done,
                                    ),
                                  )
                                : Container(),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space28.h,
                                  Dimens.space0.w,
                                  Dimens.space34.h),
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              child: RoundedButtonWidget(
                                width: double.maxFinite,
                                height: Dimens.space54,
                                buttonBackgroundColor: CustomColors.mainColor,
                                buttonTextColor: CustomColors.white,
                                corner: Dimens.space10,
                                buttonBorderColor: CustomColors.mainColor,
                                buttonFontFamily: Config.manropeSemiBold,
                                buttonFontSize: Dimens.space16,
                                titleTextAlign: TextAlign.center,
                                buttonFontWeight: FontWeight.normal,
                                buttonText: Utils.getString('saveChanges'),
                                onPressed: () async {
                                  if (widget.editName == "contactName" &&
                                      ContactValidation.isValidName(
                                              contactName.text)
                                          .isNotEmpty) {
                                    showDialog<dynamic>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ErrorDialog(
                                              message:
                                                  ContactValidation.isValidName(
                                                      contactName.text));
                                        });
                                  } else if (widget.editName == "phoneNumber" &&
                                      !Utils.validatePhoneNumbers(
                                          contactNumber.text)) {
                                    showDialog<dynamic>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ErrorDialog(
                                            message: Utils.getString(
                                                'invalidPhoneNumber'),
                                          );
                                        });
                                  } else if (widget.editName == "phoneNumber" &&
                                      ContactValidation.isValidPhoneNumber(
                                              contactNumber.text)
                                          .isNotEmpty) {
                                    showDialog<dynamic>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ErrorDialog(
                                            message: ContactValidation
                                                .isValidPhoneNumber(
                                                    contactNumber.text),
                                          );
                                        });
                                  } else if (widget.editName == "phoneNumber" &&
                                      !await ContactValidation
                                          .checkValidPhoneNumber(
                                              selectedCountryCode,
                                              contactNumber.text)) {

                                    showDialog<dynamic>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ErrorDialog(
                                            message:
                                                Utils.getString("invalidPhone"),
                                          );
                                        });
                                  } else if (widget.editName == "email" &&
                                      ContactValidation.isValidEmail(email.text)
                                          .isNotEmpty) {
                                    showDialog<dynamic>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ErrorDialog(
                                            message:
                                                ContactValidation.isValidEmail(
                                                    email.text),
                                          );
                                        });
                                  } else if (widget.editName == "company" &&
                                      ContactValidation.isValidCompany(
                                              company.text)
                                          .isNotEmpty) {
                                    showDialog<dynamic>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ErrorDialog(
                                            message: ContactValidation
                                                .isValidCompany(company.text),
                                          );
                                        });
                                  } else if (widget.editName == "address" &&
                                      ContactValidation.isValidAddress(
                                              address.text)
                                          .isNotEmpty) {
                                    showDialog<dynamic>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ErrorDialog(
                                            message: ContactValidation
                                                .isValidAddress(address.text),
                                          );
                                        });
                                  } else {
                                    if (await Utils
                                        .checkInternetConnectivity()) {
                                      /*TODO: need tor replace the company name*/
                                      final EditContactRequestParamHolder
                                          editContactRequestParamHolder =
                                          EditContactRequestParamHolder(
                                        name: widget.editName != "contactName"
                                            ? null
                                            : contactName.text,
                                        company: widget.editName != "company"
                                            ? null
                                            : company?.text ?? "",
                                        visibility: null,
                                        phoneNumber:
                                            widget.editName != "phoneNumber"
                                                ? null
                                                : widget.contactNumber ==
                                                        contactNumber.text
                                                    ? null
                                                    : contactNumber.text,
                                        email: widget.editName != "email"
                                            ? null
                                            : email.text.isEmpty
                                                ? null
                                                : email.text,
                                        address: widget.editName != "address"
                                            ? null
                                            : address?.text ?? "",
                                        tags: null,
                                        profileImageUrl: null,
                                      );
                                      PsProgressDialog.showDialog(context);
                                      final Resources<EditContactResponse>
                                          editContactResponse =
                                          await contactsProvider.editContactApiCall(
                                              EditContactRequestHolder(
                                                  data:
                                                      editContactRequestParamHolder,
                                                  id: widget.id));

                                      if (editContactResponse != null &&
                                          editContactResponse.data != null) {
                                        PsProgressDialog.dismissDialog();
                                        Navigator.pop(context, {
                                          "data": true,
                                          "id": editContactResponse
                                              .data
                                              .editContactResponseData
                                              .contacts
                                              .id
                                        });
                                      } else if (editContactResponse != null &&
                                          editContactResponse.message != null) {
                                        PsProgressDialog.dismissDialog();
                                        showDialog<dynamic>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ErrorDialog(
                                                message:
                                                    editContactResponse.message,
                                              );
                                            });
                                      }
                                    } else {
                                      showDialog<dynamic>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ErrorDialog(
                                              message: Utils.getString(
                                                  'noInternet'));
                                        },
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : AnimatedBuilder(
                      animation: animationController,
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
                              child: SpinKitCircle(
                                color: CustomColors.mainColor,
                              ),
                            ),
                          ),
                        );
                      },
                    );
            }),
      ),
    );
  }

  Future<bool> _requestPop() {
    animationController.reverse().then<dynamic>(
      (void data) {
        if (!mounted) {
          return Future<bool>.value(false);
        }
        Navigator.pop(context, {"data": false, "clientId": null});
        return Future<bool>.value(true);
      },
    );
    return Future<bool>.value(false);
  }

  alertModel() async {
    await showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.space10.r),
        ),
        backgroundColor: Colors.black.withOpacity(0.01),
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                Dimens.space16.w, Dimens.space0.h),
            child: Container(
              height: Dimens.space328.h,
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: Dimens.space220.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Dimens.space16.r)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/private_number.png",
                          fit: BoxFit.fill,
                        ),
                        SizedBox(height: Dimens.space10.h),
                        Text(
                          Utils.getString('saveNumberPrivately'),
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                // color: CustomColors.loadingCircleColor,
                                fontFamily: Config.manropeRegular,
                                fontSize: Dimens.space20.sp,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        SizedBox(height: Dimens.space10.h),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space21.w,
                              Dimens.space0.h,
                              Dimens.space21.w,
                              Dimens.space0.h),
                          child: Text(
                            Utils.getString(
                                'numbersSavedPrivatelyCannotBeAccessed'),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: Dimens.space16.h),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: Dimens.space48.h,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(Dimens.space16.r)),
                      child: Center(
                        child: Text("Close"),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimens.space32.h),
                ],
              ),
            ),
          );
        });
  }

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet) {
        setState(() {});
      }
    });
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
              countryCodeList: countryCodeList,
              selectedCountryCode: selectedCountryCode,
              onSelectCountryCode: (CountryCode countryCode) {
                setState(() {
                  selectedCountryCode = countryCode;
                  contactNumber.text = selectedCountryCode.dialCode;
                  validate("");
                });
              },
            ),
          );
        });
  }

  void validate(String number) {
    if (contactNumber.text.isEmpty) {
      setState(() {
        contactNumber.text =
            selectedCountryCode.dialCode + "" + contactNumber.text + number;
      });
    } else {
      setState(() {
        contactNumber.text = contactNumber.text + number;
      });
    }
  }
}
