/*
 * *
 *  * Created by Kedar on 7/29/21 2:35 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/28/21 3:33 PM
 *
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/login_workspace/LoginWorkspaceProvider.dart';
import 'package:voice_example/repository/LoginWorkspaceRepository.dart';
import 'package:voice_example/ui/common/ButtonWidget.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/ui/common/CustomTextField.dart';
import 'package:voice_example/ui/common/base/CustomAppBar.dart';
import 'package:voice_example/ui/common/dialog/ErrorDialog.dart';
import 'package:voice_example/utils/PsProgressDialog.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:voice_example/viewobject/model/workspace/uploadImage/UploadWorkSpaceImageResponse.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

/*
 * *
 *  * Created by Kedar on 7/28/21 2:35 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/28/21 2:35 PM
 *
 */

class OverViewWidget extends StatefulWidget {
  OverViewWidget({
    Key key,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
    this.onCallBack
  }) : super(key: key);

  final Function onCallBack;
  final Function onIncomingTap;
  final Function onOutgoingTap;
  @override
  _InviteWorkSpaceWidgetState createState() {
    return _InviteWorkSpaceWidgetState();
  }
}

class _InviteWorkSpaceWidgetState extends State<OverViewWidget>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  TextEditingController textEditingController = new TextEditingController();

  LoginWorkspaceProvider workspaceProvider;
  LoginWorkspaceRepository workspaceRepository;
  ValueHolder valueHolder;

  File _image;
  final _picker = ImagePicker();
  File _selectedFile;
  String selectedFilePath;
  bool isImageSelected = false;

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
          this.isImageSelected = true;
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
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Config.animation_duration);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<ValueHolder>(context);
    workspaceRepository = Provider.of<LoginWorkspaceRepository>(context);

    // TODO: implement build
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomAppBar<LoginWorkspaceProvider>(
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
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(Dimens.space16.w,
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
                            backgroundColor: CustomColors.transparent,
                            alignment: Alignment.centerLeft,
                          ),
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
                      Utils.getString("overview"),
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
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    ),
                  ),
                ],
              ),
            ),
            leadingWidget: null,
            centerTitle: false,
            elevation: 1,
            onIncomingTap: ()
            {
              widget.onIncomingTap();
            },
            onOutgoingTap: ()
            {
              widget.onOutgoingTap();
            },
            initProvider: ()
            {
              return LoginWorkspaceProvider(loginWorkspaceRepository: workspaceRepository);
            },
            onProviderReady: (LoginWorkspaceProvider provider) async
            {
              workspaceProvider = provider;
              workspaceProvider.getWorkspaceDetailFromDb();
              },
            builder: (BuildContext context, LoginWorkspaceProvider provider,
                Widget child) {

             textEditingController.text = (provider.loginWorkspaceDetail != null &&
                 provider.loginWorkspaceDetail
                     .data !=
                     null)
                 ? provider.loginWorkspaceDetail.data
                 .workspace.data.title
                 : "";
              animationController.forward();
              return AnimatedBuilder(
                  animation: animationController,
                  builder: (BuildContext context, Widget child) {
                    return FadeTransition(
                      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController,
                              curve: const Interval(0.5 * 1, 1.0,
                                  curve: Curves.fastOutSlowIn))),
                      child: Transform(
                        transform: Matrix4.translationValues(
                            0.0,
                            100 *
                                (1.0 -
                                    Tween<double>(begin: 0.0, end: 1.0)
                                        .animate(CurvedAnimation(
                                            parent: animationController,
                                            curve: const Interval(0.5 * 1, 1.0,
                                                curve: Curves.fastOutSlowIn)))
                                        .value),
                            0.0),
                        child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space16.w,
                                Dimens.space8.h,
                                Dimens.space16.w,
                                Dimens.space0.h),
                            height: ScreenUtil().screenHeight * 0.80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(Dimens.space16.w),
                                  topLeft: Radius.circular(Dimens.space16.w)),
                              color: CustomColors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
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
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Container(
                                          width: Dimens.space90.w,
                                          height: Dimens.space90.w,
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
                                          child: Stack(
                                            children: [
                                              Container(
                                                child: isImageSelected
                                                    ? PlainFileImageHolder(
                                                        fileUrl: (selectedFilePath !=
                                                            null &&
                                                            selectedFilePath.isNotEmpty)
                                                            ? "${selectedFilePath}"
                                                            : "",
                                                        width: Dimens.space80,
                                                        height: Dimens.space80,
                                                        boxFit: BoxFit.cover,
                                                        outerCorner:
                                                            Dimens.space20,
                                                        innerCorner:
                                                            Dimens.space20,
                                                        iconSize:
                                                            Dimens.space40,
                                                        iconUrl: CustomIcon
                                                            .icon_profile,
                                                        iconColor: CustomColors
                                                            .mainDividerColor,
                                                        boxDecorationColor:
                                                            CustomColors
                                                                .bottomAppBarColor,
                                                      )
                                                    : RoundedNetworkImageTextHolder(
                                                        imageUrl: (provider.loginWorkspaceDetail != null &&
                                                            provider.loginWorkspaceDetail
                                                                .data !=
                                                                null)
                                                            ? provider.loginWorkspaceDetail.data
                                                            .workspace.data.photo
                                                            : "",
                                                        width: Dimens.space80,
                                                        height: Dimens.space80,
                                                        text:(provider
                                                            .loginWorkspaceDetail !=
                                                            null &&
                                                            provider.loginWorkspaceDetail.data !=
                                                                null &&
                                                            provider
                                                                .loginWorkspaceDetail
                                                                .data
                                                                .workspace !=
                                                                null &&
                                                            provider
                                                                .loginWorkspaceDetail
                                                                .data
                                                                .workspace
                                                                .data !=
                                                                null &&
                                                            provider
                                                                .loginWorkspaceDetail
                                                                .data
                                                                .workspace
                                                                .data
                                                                .title !=
                                                                null)
                                                            ? "${provider.loginWorkspaceDetail.data.workspace.data.title.characters.first.toUpperCase()}"
                                                            : "",
                                                        corner:
                                                            Dimens.space20,
                                                        iconSize:
                                                            Dimens.space40,
                                                        fontSize: Dimens.space40,
                                                        textColor: CustomColors.white,
                                                        iconUrl: CustomIcon
                                                            .icon_profile,
                                                        iconColor: CustomColors
                                                            .white,
                                                  boxFit: BoxFit.cover,
                                                  boxDecorationColor:
                                                            CustomColors
                                                                .mainColor,
                                                      ),
                                              ),
                                              Positioned(
                                                  bottom: 0,
                                                  right: 0,
                                                  child:
                                                      RoundedNetworkImageHolder(
                                                    width: Dimens.space20,
                                                    height: Dimens.space20,
                                                    boxFit: BoxFit.cover,
                                                    iconUrl: CustomIcon
                                                        .icon_plus_rounded,
                                                    iconColor:
                                                        CustomColors.white,
                                                    iconSize: Dimens.space18,
                                                    outerCorner: Dimens.space12,
                                                    innerCorner: Dimens.space12,
                                                    boxDecorationColor:
                                                        CustomColors
                                                            .loadingCircleColor,
                                                    imageUrl: "",
                                                    onTap: showOptionsDialog,
                                                  ))
                                            ],
                                          )),
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.fromLTRB(
                                            Dimens.space0.w,
                                            Dimens.space0.h,
                                            Dimens.space0.w,
                                            Dimens.space10),
                                        child: TextButton(
                                          onPressed: (){
                                            selectedFilePath = '';
                                            isImageSelected = false;
                                            setState(() {
                                            });
                                          },
                                          child: Text(
                                            Utils.getString("remove"),
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                              fontSize: Dimens.space15.sp,
                                              color: CustomColors
                                                  .textTertiaryColor,
                                              fontFamily:
                                              Config.manropeSemiBold,
                                              fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.normal,
                                            ),
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
                                      Dimens.space36.h,
                                      Dimens.space0.w,
                                      Dimens.space0.h),
                                  padding: EdgeInsets.fromLTRB(
                                      Dimens.space0.w,
                                      Dimens.space0.h,
                                      Dimens.space0.w,
                                      Dimens.space0.h),
                                  child: CustomTextField(
                                    height: Dimens.space48,
                                    titleText: Utils.getString("workspaceName"),
                                    containerFillColor:
                                        CustomColors.baseLightColor,
                                    borderColor: CustomColors.secondaryColor,
                                    corner: Dimens.space10,
                                    titleFont: Config.manropeBold,
                                    readOnly: true,
                                    titleTextColor:
                                        CustomColors.textSecondaryColor,
                                    titleFontSize: Dimens.space14,
                                    titleFontStyle: FontStyle.normal,
                                    titleFontWeight: FontWeight.w700,
                                    titleMarginLeft: Dimens.space0,
                                    titleMarginRight: Dimens.space0,
                                    titleMarginBottom: Dimens.space6,
                                    titleMarginTop: Dimens.space0,
                                    hintText: Utils.getString(''),
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
                                    textEditingController:
                                        textEditingController,
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
                                      Dimens.space24.h,
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
                                    buttonBackgroundColor:
                                        CustomColors.mainColor,
                                    buttonTextColor: CustomColors.white,
                                    corner: Dimens.space10,
                                    buttonBorderColor: CustomColors.mainColor,
                                    buttonFontFamily: Config.manropeSemiBold,
                                    buttonFontSize: Dimens.space16,
                                    titleTextAlign: TextAlign.center,
                                    buttonFontWeight: FontWeight.normal,
                                    buttonText: Utils.getString('saveChanges'),
                                    onPressed: () async {
                                      if (selectedFilePath.isEmpty) {
                                        showDialog<dynamic>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ErrorDialog(
                                                message: Utils.getString(
                                                    'workSpaceRequired'),
                                              );
                                            });
                                      } else {
                                        bool connectivity = await Utils.checkInternetConnectivity();
                                        if(connectivity){
                                          PsProgressDialog.showDialog(context);
                                          Resources<UploadWorkSpaceImageResponse> response =
                                          await workspaceProvider.doUploadWorkSppaceImageApiCall(Utils.convertImageToBase64String("photoUpload", new File(selectedFilePath)));
                                          if (response.data != null && response.data.data != null) {
                                            PsProgressDialog.dismissDialog();
                                            widget.onCallBack();
                                            Utils.showToastMessage("Workspace image update successful");
                                            workspaceProvider.loginWorkspaceDetail.data.workspace.data.photo = response.data.data.data.photo;
                                            provider.saveWorkSpaceDetils(workspaceProvider.loginWorkspaceDetail.data);
                                          } else {
                                            PsProgressDialog.dismissDialog();
                                            Utils.showToastMessage(response.message!=null?response.message:"Error in updating image!");
                                          }
                                        }else{
                                          showDialog<dynamic>(
                                              context: context,
                                              builder: (BuildContext context)
                                              {
                                                return ErrorDialog(
                                                  message: Utils.getString(
                                                      'noInternet'),
                                                );
                                              });
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            )),
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
