import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
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
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/ui/common/CustomTextField.dart';
import 'package:voice_example/ui/common/base/CustomAppBar.dart';
import 'package:voice_example/ui/common/dialog/SaveNumberPrivatelyDialog.dart';
import 'package:voice_example/ui/common/dialog/CountryCodeSelectorDialog.dart';
import 'package:voice_example/ui/common/dialog/ErrorDialog.dart';
import 'package:voice_example/utils/PsProgressDialog.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/utils/Validation.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/addContactRequestParamHolder/AddContactRequestParamHolder.dart';
import 'package:voice_example/viewobject/model/addContact/AddContactResponse.dart';
import 'package:voice_example/viewobject/model/country/CountryCode.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ContactAddView extends StatefulWidget {
  final CountryCode defaultCountryCode;
  final String phoneNumber;
  final Function onIncomingTap;
  final Function onOutgoingTap;

  const ContactAddView(
      {Key key,
      @required this.onIncomingTap,
      @required this.onOutgoingTap,
      this.defaultCountryCode,
      this.phoneNumber})
      : super(key: key);

  @override
  _ContactAddViewState createState() => _ContactAddViewState();
}

class _ContactAddViewState extends State<ContactAddView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  final TextEditingController contactName = TextEditingController();
  final TextEditingController contactNumber = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController company = TextEditingController();
  final TextEditingController address = TextEditingController();
  CountryCode selectedCountryCode;
  bool isConnectedToInternet = false;
  bool isSelected = true;
  bool showAdditionalDetail = false;
  ContactsProvider contactsProvider;
  ContactRepository contactRepository;
  File _image;
  final _picker = ImagePicker();
  File _selectedFile;
  String selectedFilePath;
  CountryRepository countryRepository;
  CountryListProvider countryListProvider;
  List<CountryCode> countryCodeList;
  Animation<double> animation;
  bool isCountrySelected = false;

  ValueHolder valueHolder;

  void _askPermissionCamera() async {
    await [Permission.camera].request().then(_onStatusRequestedCamera);
  }

  void _askPermissionStorage() async {
    await [Permission.storage].request().then(_onStatusRequested);
  }

  void _askPermissionPhotos() async {
    await [Permission.photos].request().then(_onStatusRequested);
  }

  void _onStatusRequested(Map<Permission, PermissionStatus> status) {
    Permission perm;
    if (Platform.isIOS) {
      perm = Permission.photos;
    } else {
      perm = Permission.storage;
    }
    if (status[perm] != PermissionStatus.granted) {
      if (Platform.isIOS) {
        openAppSettings();
      }
    } else {
      _getImage(ImageSource.gallery);
    }
  }

  void _onStatusRequestedCamera(Map<Permission, PermissionStatus> status) {
    if (status[Permission.camera] != PermissionStatus.granted) {
      openAppSettings();
    } else {
      _getImage(ImageSource.camera);
    }
  }

  void _getImage(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
      }
    });

    if (_image != null) {
      File cropped = await ImageCropper.cropImage(
          sourcePath: _image.path,
          compressQuality: 100,
          maxWidth: 700,
          maxHeight: 700,
          cropStyle: CropStyle.rectangle,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            initAspectRatio: CropAspectRatioPreset.original,
            toolbarColor: Colors.white,
            toolbarTitle: 'Edit Images',
            statusBarColor: Colors.red,
            activeControlsWidgetColor: Colors.blue,
            cropFrameColor: Colors.white,
            cropGridColor: Colors.white,
            toolbarWidgetColor: Colors.black,
            backgroundColor: Colors.white,
          ));

      this.setState(() {
        if (cropped != null) {
          if (_selectedFile != null && _selectedFile.existsSync()) {
            _selectedFile.deleteSync();
          }
          _selectedFile = cropped;
          selectedFilePath = _selectedFile.path;
        }

        // delete image camera
        if (source.toString() == 'ImageSource.camera' && _image.existsSync()) {
          _image.deleteSync();
        }
      });
    }
  }

  Future<void> showOptionsDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(Utils.getString('PleaseSelectOptionToPickImage')),
            actions: [
              InkWell(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(Dimens.space8.w, Dimens.space8.h,
                      Dimens.space8.w, Dimens.space8.h),
                  child: Text(Utils.getString('camera')),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  if (Platform.isIOS) {
                    _askPermissionCamera();
                  } else {
                    _getImage(ImageSource.camera);
                  }
                },
              ),
              InkWell(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(Dimens.space8.w, Dimens.space8.h,
                      Dimens.space8.w, Dimens.space8.h),
                  child: Text(Utils.getString('gallery')),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  if (Platform.isIOS) {
                    _askPermissionPhotos();
                  } else {
                    _askPermissionStorage();
                  }
                },
              ),
            ],
          );
        });
  }
  @override
  void initState() {
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
      if (widget.defaultCountryCode != null) {
        selectedCountryCode = widget.defaultCountryCode;
      } else {
        if (widget.phoneNumber != null) {
          for (int i = 0; i < countryCodeList.length; i++) {
            if (widget.phoneNumber.contains(countryCodeList[i].dialCode)) {
              selectedCountryCode = countryCodeList[i];
              break;
            } else {
              selectedCountryCode = countryCodeList[i];
            }
          }
        } else {
          selectedCountryCode = countryCodeList[13];
        }
      }

      contactNumber.addListener(() {
        if (contactNumber.text.isNotEmpty) {
          for (int i = 0; i < countryCodeList.length; i++) {

            if(!isCountrySelected){
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
          }
        } else {
          setState(() {
            contactNumber.text = selectedCountryCode.dialCode;
            contactNumber.selection = TextSelection.fromPosition(
                TextPosition(offset: contactNumber.text.length));
          });
        }
      });

      if (widget.phoneNumber != null && widget.phoneNumber.isNotEmpty) {
        contactNumber.text = widget.phoneNumber;
        validate("");
      } else {
        validate("");
      }
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
                    child: Text(
                      Utils.getString("newContact"),
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
                  Expanded(child: Container()),
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
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space30.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(Dimens.space32.r),
                                child: PlainFileImageHolder(
                                  width: Dimens.space80,
                                  height: Dimens.space80,
                                  boxFit: BoxFit.cover,
                                  containerAlignment: Alignment.bottomCenter,
                                  iconUrl: CustomIcon.icon_profile,
                                  iconColor: CustomColors.callInactiveColor,
                                  iconSize: Dimens.space68,
                                  boxDecorationColor:
                                      CustomColors.mainDividerColor,
                                  outerCorner: Dimens.space32,
                                  innerCorner: Dimens.space32,
                                  fileUrl: _selectedFile != null
                                      ? _selectedFile.path
                                      : "",
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space5.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              child: TextButton(
                                onPressed: showOptionsDialog,
                                style: TextButton.styleFrom(
                                  backgroundColor: CustomColors.transparent,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: EdgeInsets.fromLTRB(
                                      Dimens.space0.w,
                                      Dimens.space0.h,
                                      Dimens.space0.w,
                                      Dimens.space0.h),
                                ),
                                child: Text(
                                  Utils.getString('uploadPhoto'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                          color:
                                              CustomColors.loadingCircleColor,
                                          fontFamily: Config.manropeSemiBold,
                                          fontSize: Dimens.space14.sp,
                                          fontWeight: FontWeight.normal,
                                          fontStyle: FontStyle.normal),
                                ),
                              ),
                            ),
                            Container(
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
                                containerFillColor: CustomColors.baseLightColor,
                                borderColor: CustomColors.secondaryColor,
                                corner: Dimens.space10,
                                titleFont: Config.manropeBold,
                                titleTextColor: CustomColors.textSecondaryColor,
                                titleFontSize: Dimens.space14,
                                titleFontStyle: FontStyle.normal,
                                titleFontWeight: FontWeight.w700,
                                titleMarginLeft: Dimens.space0,
                                titleMarginRight: Dimens.space0,
                                titleMarginBottom: Dimens.space6,
                                titleMarginTop: Dimens.space0,
                                hintText: Utils.getString('contactName'),
                                hintFontColor: CustomColors.textQuaternaryColor,
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
                            ),
                            Container(
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
                                  selectedCountryCode: selectedCountryCode,
                                  // widget.defaultCountryCode,
                                  onChanged: ()
                                  {
                                    isCountrySelected = false;
                                  },
                                  prefix: true,
                                  height: Dimens.space48,
                                  titleText: Utils.getString("phoneNumber"),
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
                            ),
                            Container(
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
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
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
                                    child: CustomCheckBox(
                                      width: Dimens.space20,
                                      height: Dimens.space20,
                                      boxFit: BoxFit.contain,
                                      iconUrl: Icons.check,
                                      iconColor: CustomColors.white,
                                      selectedColor: CustomColors.mainColor,
                                      unSelectedColor:
                                          CustomColors.callInactiveColor,
                                      iconSize: Dimens.space16,
                                      outerCorner: Dimens.space6,
                                      innerCorner: Dimens.space6,
                                      assetHeight: Dimens.space20,
                                      assetWidth: Dimens.space20,
                                      isChecked: isSelected,
                                      onCheckBoxTap: (value) {
                                        isSelected = !isSelected;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(
                                        Dimens.space10.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    padding: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    child: Text(
                                      Utils.getString('saveNumberPrivately'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            color: CustomColors.textSenaryColor,
                                            fontFamily: Config.manropeBold,
                                            fontSize: Dimens.space14.sp,
                                            letterSpacing:
                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(
                                        Dimens.space10.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    padding: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    child: InkWell(
                                      onTap: () async {
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
                                              return SaveNumberPrivatelyDialog();
                                            });
                                      },
                                      child: Icon(
                                        Icons.info_outline,
                                        color: CustomColors.loadingCircleColor,
                                        size: Dimens.space18.w,
                                        // size: Dimens.space20.,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
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
                                child: TextButton(
                                  onPressed: () {
                                    showAdditionalDetail =
                                        !showAdditionalDetail;
                                    setState(() {});
                                  },
                                  style: TextButton.styleFrom(
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    padding: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    backgroundColor: CustomColors.transparent,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
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
                                          Utils.getString('additionalDetails'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                color: CustomColors
                                                    .loadingCircleColor,
                                                fontFamily:
                                                    Config.manropeSemiBold,
                                                fontSize: Dimens.space14.sp,
                                                fontWeight: FontWeight.normal,
                                                fontStyle: FontStyle.normal,
                                              ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.fromLTRB(
                                            Dimens.space5.w,
                                            Dimens.space0.h,
                                            Dimens.space0.w,
                                            Dimens.space0.h),
                                        padding: EdgeInsets.fromLTRB(
                                            Dimens.space0.w,
                                            Dimens.space0.h,
                                            Dimens.space0.w,
                                            Dimens.space0.h),
                                        child: Icon(
                                          Icons.arrow_right,
                                          color:
                                              CustomColors.loadingCircleColor,
                                          size: Dimens.space18.w,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Offstage(
                              offstage: !showAdditionalDetail,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
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
                                      titleText: Utils.getString("emailId"),
                                      showSubTitle: true,
                                      subTitle: Utils.getString('optional'),
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
                                      autoFocus: false,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                  Container(
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
                                  ),
                                  Container(
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
                                      showSubTitle: true,
                                      subTitle: Utils.getString('optional'),
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
                                      autoFocus: false,
                                      keyboardType: TextInputType.name,
                                      textInputAction: TextInputAction.done,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space18.h,
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
                                buttonText: Utils.getString('addANewContact'),
                                onPressed: () async {
                                  if (ContactValidation.isValidName(
                                          contactName.text)
                                      .isNotEmpty) {
                                    showDialog<dynamic>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ErrorDialog(
                                            message:
                                                ContactValidation.isValidName(
                                                    contactName.text),
                                          );
                                        });
                                  } else if (ContactValidation
                                          .isValidPhoneNumber(
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
                                  } else if (!await ContactValidation
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
                                  } else {
                                    if (email.text.isNotEmpty) {
                                      if (ContactValidation.isValidEmail(
                                              email.text)
                                          .isNotEmpty) {
                                        showDialog<dynamic>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ErrorDialog(
                                                message: ContactValidation
                                                    .isValidEmail(email.text),
                                              );
                                            });
                                      } else {
                                        _proceedAddContact();
                                      }
                                    } else {
                                      _proceedAddContact();
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
                  isCountrySelected = true;
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

  void _proceedAddContact() async {
    if (await Utils.checkInternetConnectivity()) {
      /*TODO: need tor replace the company name*/
      final AddContactRequestParamHolder addContactRequestParamHolder =
          AddContactRequestParamHolder(
        country: selectedCountryCode.id,
        name: contactName.text,
        company: company?.text ?? "",
        visibility: !isSelected,
        phoneNumber: contactNumber.text,
        email: email.text.isEmpty ? "" : email.text,
        address: address?.text ?? "",
        tags: null,
      );
      PsProgressDialog.showDialog(context);
      final Resources<AddContactResponse> addContactResponse =
          await contactsProvider.doAddContactsApiCall(
              addContactRequestParamHolder, _selectedFile);
      if (addContactResponse != null && addContactResponse.data != null) {
        PsProgressDialog.dismissDialog();
        Navigator.pop(context, {
          "data": true,
          "clientId": addContactResponse.data.addContactResponseData.contacts.id
        });
      } else if (addContactResponse != null &&
          addContactResponse.message != null) {
        PsProgressDialog.dismissDialog();
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: addContactResponse.message,
              );
            });
      }
    } else {
      showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(message: Utils.getString('noInternet'));
        },
      );
    }
  }
}
