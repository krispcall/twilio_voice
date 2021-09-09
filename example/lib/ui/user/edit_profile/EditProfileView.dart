import 'dart:io';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/country/CountryListProvider.dart';
import 'package:voice_example/provider/user/UserProvider.dart';
import 'package:voice_example/repository/CountryListRepository.dart';
import 'package:voice_example/repository/UserRepository.dart';
import 'package:voice_example/ui/common/base/CustomAppBar.dart';
import 'package:voice_example/ui/common/ButtonWidget.dart';
import 'package:voice_example/ui/common/dialog/CountryCodeSelectorDialog.dart';
import 'package:voice_example/ui/common/dialog/ErrorDialog.dart';
import 'package:voice_example/ui/common/dialog/ImagePickerDialog.dart';
import 'package:voice_example/ui/common/CustomTextField.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/utils/utils.dart';
import 'package:voice_example/viewobject/model/country/CountryCode.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({
    Key key,
    @required this.selectedCountryCode,
    @required this.phoneNumber,
    @required this.name,
    @required this.email,
    @required this.callback,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
  }) : super(key: key);

  final CountryCode selectedCountryCode;
  final String phoneNumber;
  final String name;
  final String email;
  final VoidCallback callback;
  final Function onIncomingTap;
  final Function onOutgoingTap;

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView>
    with SingleTickerProviderStateMixin {
  UserRepository userRepository;
  UserProvider userProvider;
  ValueHolder valueHolder;
  AnimationController animationController;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController aboutMeController = TextEditingController();
  final TextEditingController userAddressController = TextEditingController();
  final TextEditingController shippingAreaController = TextEditingController();

  bool bindDataFirstTime = true;

  CountryRepository countryRepository;
  CountryListProvider countryListProvider;

  @override
  void initState()
  {
    animationController = AnimationController(duration: Config.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    userRepository = Provider.of<UserRepository>(context);
    valueHolder = Provider.of<ValueHolder>(context);
    countryRepository = Provider.of<CountryRepository>(context);
    countryListProvider = CountryListProvider(countryListRepository: countryRepository);

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

    return WillPopScope(
        onWillPop: _requestPop,
        child: CustomAppBar<UserProvider>(
            titleWidget: Text(
              Utils.getString("appName"),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(
                color: CustomColors.textPrimaryColor,
                fontFamily: Config.manropeBold,
                fontSize: Dimens.space16.sp,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
              ),
            ),
            leadingWidget: Icon(
                Icons.add
            ),
            elevation: 0,
            onIncomingTap: ()
            {
              widget.onIncomingTap();
            },
            onOutgoingTap: ()
            {
              widget.onOutgoingTap();
            },
            initProvider: () {
              return UserProvider(
                  userRepository: userRepository, valueHolder: valueHolder);
            },
            onProviderReady: (UserProvider provider) async
            {
              await provider.getUserProfileDetails();
              userProvider = provider;
            },
            builder: (BuildContext context, UserProvider provider, Widget child)
            {
              // if (userProvider != null && userProvider.userUserDetail != null && userProvider.userUserDetail.data != null)
              // {
              //   return SingleChildScrollView(
              //       child: Container(
              //           color: CustomColors.white,
              //           height: MediaQuery.of(context).size.height,
              //           padding: const EdgeInsets.fromLTRB(
              //             Dimens.space20,
              //             Dimens.space0,
              //             Dimens.space20,
              //             Dimens.space0,
              //           ),
              //           child: SingleChildScrollView(
              //             child: Column(
              //               children: <Widget>[
              //                 ImageWidget(
              //                     userProvider: provider,
              //                     callback: widget.callback),
              //                 InputControllerWidget(
              //                     firstNameController: firstNameController,
              //                     lastNameController: lastNameController,
              //                     emailController: emailController,
              //                     phoneController: phoneController,
              //                     selected:
              //                         CountryMapperUtils.getCountryCodeDetails(
              //                             ""),
              //                     codes: CountryMapperUtils.getCodes(),
              //                     onPrefixTap: () {}),
              //                 ButtonWidget(
              //                   userProvider: provider,
              //                   firstNameController: firstNameController,
              //                   lastNameController: lastNameController,
              //                   emailController: emailController,
              //                   phoneController: phoneController,
              //                   callback: widget.callback,
              //                 ),
              //               ],
              //             ),
              //           )));
              // }
              // else
              // {
              return SingleChildScrollView(
                  child: Container(
                      color: CustomColors.white,
                      height: MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.fromLTRB(
                        Dimens.space20,
                        Dimens.space0,
                        Dimens.space20,
                        Dimens.space0,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            ImageWidget(userProvider: provider),
                            InputControllerWidget(
                                firstNameController: firstNameController,
                                lastNameController: lastNameController,
                                emailController: emailController,
                                phoneController: phoneController,
                                selected:null,
                                codes: countryListProvider.countryList.data,
                                onPrefixTap: () {}),
                            ButtonWidget(
                              userProvider: provider,
                              firstNameController: firstNameController,
                              lastNameController: lastNameController,
                              emailController: emailController,
                              phoneController: phoneController,
                              callback: widget.callback,
                            ),
                          ],
                        ),
                      )
                  )
              );
            })
    );
  }

  void showCountryCodeSelectorDialog() async
  {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.white,
        builder: (BuildContext context)
        {
          return CountryCodeSelectorDialog(
            countryCodeList: countryListProvider.countryList.data,
            selectedCountryCode: null,
            onSelectCountryCode: (CountryCode countryCode) {},
          );
        });
  }
}

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    @required this.userProvider,
    @required this.firstNameController,
    @required this.lastNameController,
    @required this.emailController,
    @required this.phoneController,
    @required this.callback,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final UserProvider userProvider;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.fromLTRB(
              Dimens.space0, Dimens.space20, Dimens.space0, Dimens.space0),
          child: RoundedButtonWidget(
            width: double.infinity,
            height: Dimens.space48,
            corner: Dimens.space10,
            buttonBackgroundColor: CustomColors.mainColor,
            buttonTextColor: CustomColors.white,
            buttonText: Utils.getString('saveProfile'),
            buttonBorderColor: CustomColors.mainColor,
            fontStyle: FontStyle.normal,
            buttonFontFamily: Config.heeboRegular,
            buttonFontSize: Dimens.space16,
            buttonFontWeight: FontWeight.normal,
            onPressed: () async {
              // if (firstNameController.text == '') {
              //   showDialog<dynamic>(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return ErrorDialog(
              //           message: Utils.getString('firstNameEmpty'),
              //         );
              //       });
              // } else if (lastNameController.text == '') {
              //   showDialog<dynamic>(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return ErrorDialog(
              //           message: Utils.getString('lastNameEmpty'),
              //         );
              //       });
              // } else if (emailController.text == '') {
              //   showDialog<dynamic>(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return ErrorDialog(
              //           message: Utils.getString('emailAddressEmpty'),
              //         );
              //       });
              // } else {
              //   if (await Utils.checkInternetConnectivity()) {
              //     /*Update user name*/
              //     final UserNameUpdateParamHolder userNaneUpdateHolder =
              //         UserNameUpdateParamHolder(
              //             firstName: firstNameController.text,
              //             lastName: lastNameController.text);
              //
              //     PsProgressDialog.showDialog(context);
              //
              //     // final Resources<User> _apiStatus = await userProvider
              //     //     .postUserNameUpdate(userNaneUpdateHolder.toMap());
              //
              //     /*Update user email*/
              //
              //     // final UserUpdateEmailParamHolder
              //     // userEmailUpdateHolder =
              //     // UserUpdateEmailParamHolder(
              //     //     email: emailController.text,
              //     // );
              //     // final Resources<User> _apiStatus = await userProvider
              //     //     .postUserEmailUpdate(userEmailUpdateHolder.toMap());
              //
              //     if (_apiStatus.data != null) {
              //       userProvider.setUpdatedUserNameToVerify(
              //           _apiStatus.data.login.data.details.userProfile);
              //       PsProgressDialog.dismissDialog();
              //
              //       showDialog<dynamic>(
              //           barrierDismissible: false,
              //           useRootNavigator: false,
              //           context: context,
              //           builder: (BuildContext context) {
              //             return SuccessDialog(
              //               message: Utils.getString("editProfileSuccess"),
              //               onTap: callback,
              //             );
              //           });
              //     } else {
              //       PsProgressDialog.dismissDialog();
              //
              //       showDialog<dynamic>(
              //           context: context,
              //           builder: (BuildContext context) {
              //             return ErrorDialog(
              //               message: _apiStatus.message,
              //             );
              //           });
              //     }
              //   } else {
              //     showDialog<dynamic>(
              //         context: context,
              //         builder: (BuildContext context) {
              //           return ErrorDialog(
              //             message: Utils.getString('noInternet'),
              //           );
              //         });
              //   }
              // }
            },
          ),
        ),
      ],
    );
  }
}

class ImageWidget extends StatefulWidget {
  final VoidCallback callback;

  const ImageWidget({this.userProvider, this.callback});

  final UserProvider userProvider;

  @override
  ImageWidgetState createState() => ImageWidgetState();
}

File pickedImage = null;

class ImageWidgetState extends State<ImageWidget> {
  Future<bool> requestGalleryPermission() async {
    final Permission _photos = Permission.photos;
    final PermissionStatus permissionss = await _photos.request();

    if (permissionss != null && permissionss == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  chooseImage(ImageSource imageSource) async {
    if (imageSource != null) {
      // if (ImagePicker != null && ImagePicker.pickImage != null)
      // {
      //   try {
      //     pickedImage = await ImagePicker.pickImage(source: imageSource);
      //     if (pickedImage != null)
      //     {
      //       PsProgressDialog.showDialog(context);
      //
      //       final Resources<User> _apiStatus = await widget.userProvider.postImageUpload(widget.userProvider.valueHolder, Const.PLATFORM, pickedImage);
      //
      //       if (_apiStatus.data != null)
      //       {
      //         widget.userProvider.updateImagePath(_apiStatus.data.login.data.details.userProfile.profilePicture);
      //         PsProgressDialog.dismissDialog();
      //         showDialog<dynamic>(
      //             barrierDismissible: false,
      //             useRootNavigator: false,
      //             context: context,
      //             builder: (BuildContext context)
      //             {
      //               return SuccessDialog(
      //                 title: Utils.getString("editProfileSuccess"),
      //                 description: Utils.getString(""),
      //                 cancelText: Utils.getString('cancel'),
      //                 okText: Utils.getString('ok'),
      //                 icon: CustomIcon.icon_call_delete,
      //                 iconColor: CustomColors.callDeclineColor,
      //                 okSize: 0,
      //                 okSizeContainerColor: CustomColors.callDeclineColorLight,
      //                 okSizeTextColor: CustomColors.callDeclineColorLight,
      //                 onOkTap: widget.callback,
      //               );
      //             });
      //       }
      //     }
      //   } catch (e) {
      //     PsProgressDialog.dismissDialog();
      //
      //     if(e is PlatformException){
      //       PlatformException  exception = e;
      //       showDialog<dynamic>(
      //           context: context,
      //           builder: (BuildContext context) {
      //             return ErrorDialog(
      //               message: exception.message,
      //             );
      //           });
      //     }else{
      //       showDialog<dynamic>(
      //           context: context,
      //           builder: (BuildContext context) {
      //             return ErrorDialog(
      //               message: "Error in uploading image",
      //             );
      //           });
      //     }
      //
      //   }
      // }
      // else
      // {
      //   PsProgressDialog.dismissDialog();
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic _pickImage() async {
      await showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: Colors.transparent,
          builder: (builder) {
            return ImagePickerDialog(onGalleryTap: () {
              Navigator.pop(context);
              chooseImage(ImageSource.gallery);
            }, onCameraTap: () {
              Navigator.pop(context);
              chooseImage(ImageSource.camera);
            });
          });
    }

    final Widget _editWidget = Container(
      padding: EdgeInsets.fromLTRB(
          Dimens.space2, Dimens.space2, Dimens.space2, Dimens.space2),
      child: Container(
        padding: EdgeInsets.fromLTRB(
            Dimens.space2, Dimens.space2, Dimens.space2, Dimens.space2),
        child: Icon(
          CustomIcon.icon_add_image,
          color: CustomColors.white,
          size: Dimens.space16,
        ),
        width: Dimens.space40,
        height: Dimens.space40,
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: CustomColors.mainColor),
          color: CustomColors.mainSecondaryColor,
          borderRadius: BorderRadius.circular(Dimens.space28),
        ),
      ),
      width: Dimens.space36,
      height: Dimens.space36,
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: CustomColors.white),
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(Dimens.space28),
      ),
    );

    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0, Dimens.space32, Dimens.space0, Dimens.space0),
      child: Stack(
        children: <Widget>[
          Container(
            child: (widget.userProvider.valueHolder.userProfilePicture !=
                    null)
                ? Container(
                    width: Dimens.space92,
                    height: Dimens.space92,
                    margin: const EdgeInsets.fromLTRB(Dimens.space10,
                        Dimens.space0, Dimens.space10, Dimens.space0),
                    padding: const EdgeInsets.fromLTRB(Dimens.space0,
                        Dimens.space0, Dimens.space0, Dimens.space0),
                    child: RoundedNetworkImageHolder(
                      width: Dimens.space92,
                      height: Dimens.space92,
                      boxFit: BoxFit.cover,
                      innerCorner: Dimens.space16,
                      outerCorner: Dimens.space16,
                      iconSize: Dimens.space40,
                      iconColor: CustomColors.mainColor,
                      iconUrl: CustomIcon.icon_person,
                      boxDecorationColor: CustomColors.bottomAppBarColor,
                      imageUrl: widget.userProvider.valueHolder.userProfilePicture,
                      onTap: () async
                      {
                        if (await Utils.checkInternetConnectivity())
                        {
                          requestGalleryPermission().then((bool status) async {
                            if (status)
                            {
                              FocusScope.of(context).requestFocus(new FocusNode());
                              await _pickImage();
                            }
                          });
                        } else {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          showDialog<dynamic>(
                              context: context,
                              builder: (BuildContext context) {
                                return ErrorDialog(
                                  message: Utils.getString('noInternet'),
                                );
                              });
                        }
                      },
                    ),
                  )
                : PlainFileImageHolder(
                    fileUrl:
                        pickedImage != null ? pickedImage.path.toString() : "",
                    width: Dimens.space92,
                    height: Dimens.space92,
                    boxFit: BoxFit.cover,
                    corner: Dimens.space16,
                    iconSize: Dimens.space40,
                    iconColor: CustomColors.mainColor,
                    iconUrl: CustomIcon.icon_person,
                    onTap: () async {
                      if (await Utils.checkInternetConnectivity()) {
                        requestGalleryPermission().then((bool status) async {
                          if (status) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            await _pickImage();
                          }
                        });
                      } else {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        showDialog<dynamic>(
                            context: context,
                            builder: (BuildContext context) {
                              return ErrorDialog(
                                message: Utils.getString('noInternet'),
                              );
                            });
                      }
                    },
                  ),
          ),
          Positioned(
            bottom: 1,
            right: 1,
            child: new GestureDetector(
              onTap: () async {
                if (await Utils.checkInternetConnectivity()) {
                  requestGalleryPermission().then((bool status) async {
                    if (status) {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      await _pickImage();
                    }
                  });
                } else {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                          message: Utils.getString('noInternet'),
                        );
                      });
                }
              },
              child: _editWidget,
            ),
          ),
        ],
      ),
    );
  }
}

class InputControllerWidget extends StatelessWidget {
  const InputControllerWidget({
    @required this.firstNameController,
    @required this.lastNameController,
    @required this.emailController,
    @required this.phoneController,
    @required this.selected,
    @required this.codes,
    @required this.onPrefixTap,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final CountryCode selected;
  final List<CountryCode> codes;
  final Function onPrefixTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        Dimens.space0,
        Dimens.space20,
        Dimens.space0,
        Dimens.space0,
      ),
      padding: const EdgeInsets.fromLTRB(
        Dimens.space0,
        Dimens.space0,
        Dimens.space0,
        Dimens.space0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Row(
            children: [
              new Flexible(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(
                    Dimens.space0,
                    Dimens.space20,
                    Dimens.space0,
                    Dimens.space0,
                  ),
                  padding: const EdgeInsets.fromLTRB(
                    Dimens.space0,
                    Dimens.space0,
                    Dimens.space0,
                    Dimens.space0,
                  ),
                  child: CustomTextField(
                    titleText: Utils.getString("firstName"),
                    hintText: Utils.getString("enterfirstName"),
                    textEditingController: firstNameController,
                    borderColor: CustomColors.mainColor,
                    containerFillColor: CustomColors.mainColor,
                    hintFontColor: CustomColors.mainColor,
                    titleTextColor: CustomColors.mainColor,
                    inputFontColor: CustomColors.mainColor,
                    onPrefixTap: () {
                      onPrefixTap();
                    },
                  ),
                ),
              ),
              new Flexible(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(
                    Dimens.space10,
                    Dimens.space20,
                    Dimens.space0,
                    Dimens.space0,
                  ),
                  padding: const EdgeInsets.fromLTRB(
                    Dimens.space0,
                    Dimens.space0,
                    Dimens.space0,
                    Dimens.space0,
                  ),
                  child: CustomTextField(
                    titleText: Utils.getString("lastName"),
                    hintText: Utils.getString("enterLastName"),
                    textEditingController: lastNameController,
                    borderColor: CustomColors.mainColor,
                    containerFillColor: CustomColors.mainColor,
                    hintFontColor: CustomColors.mainColor,
                    titleTextColor: CustomColors.mainColor,
                    inputFontColor: CustomColors.mainColor,
                    onPrefixTap: () {
                      onPrefixTap();
                    },
                  ),
                ),
              )
            ],
          ),
          AbsorbPointer(
            absorbing: true,
            child: Container(
              margin: const EdgeInsets.fromLTRB(
                Dimens.space0,
                Dimens.space20,
                Dimens.space0,
                Dimens.space0,
              ),
              padding: const EdgeInsets.fromLTRB(
                Dimens.space0,
                Dimens.space0,
                Dimens.space0,
                Dimens.space0,
              ),
              child: CustomTextField(
                titleText: Utils.getString("contactNumber"),
                // hintText: selected.dialCode,
                hintText: "",
                textEditingController: phoneController,
                inputFontColor: CustomColors.textQuaternaryColor,
                borderColor: CustomColors.mainColor,
                containerFillColor: CustomColors.mainColor,
                hintFontColor: CustomColors.mainColor,
                titleTextColor: CustomColors.mainColor,
                onPrefixTap: () {
                  onPrefixTap();
                },
              ),
            ),
          ),
          AbsorbPointer(
            absorbing: true,
            child: Container(
              margin: const EdgeInsets.fromLTRB(
                Dimens.space0,
                Dimens.space20,
                Dimens.space0,
                Dimens.space0,
              ),
              padding: const EdgeInsets.fromLTRB(
                Dimens.space0,
                Dimens.space0,
                Dimens.space0,
                Dimens.space0,
              ),
              child: CustomTextField(
                titleText: Utils.getString("emailAddress"),
                hintText: Utils.getString("enterEmailAddress"),
                textEditingController: emailController,
                inputFontColor: CustomColors.textQuaternaryColor,
                containerFillColor: CustomColors.mainColor,
                borderColor: CustomColors.mainColor,
                titleTextColor: CustomColors.mainColor,
                hintFontColor: CustomColors.mainColor,
                onPrefixTap: () {
                  onPrefixTap();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
