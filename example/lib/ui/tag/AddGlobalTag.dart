import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/contacts/ContactsProvider.dart';
import 'package:voice_example/repository/ContactRepository.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/ui/common/CustomTextField.dart';
import 'package:voice_example/ui/common/TagsItemWidget.dart';
import 'package:voice_example/ui/common/base/CustomAppBar.dart';
import 'package:voice_example/ui/common/dialog/ErrorDialog.dart';
import 'package:voice_example/ui/common/dialog/ColorPickerDialog.dart';
import 'package:voice_example/utils/HexToColor.dart';
import 'package:voice_example/utils/PsProgressDialog.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/utils/Validation.dart';
import 'package:voice_example/viewobject/holder/request_holder/ColorHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/addTagRequestParamHolder/AddTagRequestParamHolder.dart';
import 'package:voice_example/viewobject/model/addTag/AddTagResponse.dart';
import 'package:provider/provider.dart';

/*
 * *
 *  * Created by Kedar on 7/12/21 12:51 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/12/21 12:51 PM
 *
 */

class AddGlobalTagView extends StatefulWidget {
  final String workspaceName;
  final String workSpaceImage;
  final Function onIncomingTap;
  final Function onOutgoingTap;
  final Function onCallback;

  AddGlobalTagView(
      {Key key,
      @required this.workspaceName,
      @required this.workSpaceImage,
      @required this.onIncomingTap,
      @required this.onOutgoingTap,
      @required this.onCallback})
      : super(key: key);

  @override
  AddTagViewWidgetState createState() => AddTagViewWidgetState();
}

class AddTagViewWidgetState extends State<AddGlobalTagView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  TextEditingController controllerSearchTag = TextEditingController();
  ContactRepository contactRepository;
  ContactsProvider contactsProvider;
  ColorHolder selectedColor;
  List<String> selectedTags = [];
  String clientId = "";

  @override
  void initState() {
    selectedColor = Config.supportColorHolder[0];
    contactRepository = Provider.of<ContactRepository>(context, listen: false);
    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, clientId);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    animationController.forward();

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
                                  textAlign: TextAlign.center,
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
                        Utils.getString("addTags"),
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
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space16.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h)),
                    ),
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
                return ContactsProvider(contactRepository: contactRepository);
              },
              onProviderReady: (ContactsProvider provider) async {
                contactsProvider = provider;
                contactsProvider.doContactDetailApiCall(clientId).then((value) {
                  if (contactsProvider.contactDetailResponse.data != null &&
                      contactsProvider.contactDetailResponse.data
                              .contactDetailResponseData.contacts.tags !=
                          null &&
                      contactsProvider.contactDetailResponse.data
                              .contactDetailResponseData.contacts.tags.length !=
                          0) {
                    for (int i = 0;
                        i <
                            contactsProvider.contactDetailResponse.data
                                .contactDetailResponseData.contacts.tags.length;
                        i++) {
                      setState(() {
                        selectedTags.add(contactsProvider
                            .contactDetailResponse
                            .data
                            .contactDetailResponseData
                            .contacts
                            .tags[i]
                            .id);
                      });
                    }
                  }
                  contactsProvider.doGetAllTagsApiCall();
                });
                controllerSearchTag.addListener(() {
                  if (controllerSearchTag.text != null &&
                      controllerSearchTag.text.isNotEmpty) {
                    contactsProvider.doDbTagSearch(controllerSearchTag.text);
                  } else {
                    contactsProvider.doGetTagsFromDb();
                  }
                });
              },
              builder: (BuildContext context, ContactsProvider provider,
                  Widget child) {
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
                                              curve: const Interval(
                                                  0.5 * 1, 1.0,
                                                  curve: Curves.fastOutSlowIn)))
                                          .value),
                              0.0),
                          child: Container(
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
                            child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space32.h,
                                              Dimens.space0.w,
                                              Dimens.space0),
                                          alignment: Alignment.center,
                                          child: RoundedNetworkImageHolder(
                                            width: Dimens.space40,
                                            height: Dimens.space40,
                                            boxFit: BoxFit.cover,
                                            iconUrl: CustomIcon.icon_gallery,
                                            containerAlignment:
                                                Alignment.bottomCenter,
                                            iconColor:
                                                CustomColors.callInactiveColor,
                                            iconSize: Dimens.space34,
                                            boxDecorationColor:
                                                CustomColors.transparent,
                                            outerCorner: Dimens.space14,
                                            innerCorner: Dimens.space14,
                                            imageUrl: widget.workSpaceImage !=
                                                    null
                                                ? "${Config.imageUrl + widget.workSpaceImage}"
                                                : "",
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space10.h,
                                              Dimens.space0.w,
                                              Dimens.space0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.fromLTRB(
                                                    Dimens.space0.w,
                                                    Dimens.space10.h,
                                                    Dimens.space0.w,
                                                    Dimens.space0),
                                                child: Text(
                                                  widget.workspaceName,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                          fontFamily: Config
                                                              .manropeExtraBold,
                                                          fontSize:
                                                              Dimens.space20.sp,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: CustomColors
                                                              .textPrimaryColor,
                                                          fontStyle:
                                                              FontStyle.normal),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    Dimens.space6.w,
                                                    Dimens.space0.h,
                                                    Dimens.space0.w,
                                                    Dimens.space0.h),
                                                child: RoundedNetworkSvgHolder(
                                                  containerWidth:
                                                      Dimens.space16,
                                                  containerHeight:
                                                      Dimens.space16,
                                                  boxFit: BoxFit.contain,
                                                  imageWidth: Dimens.space16,
                                                  imageHeight: Dimens.space16,
                                                  outerCorner: Dimens.space0,
                                                  innerCorner: Dimens.space0,
                                                  iconUrl:
                                                      CustomIcon.icon_person,
                                                  iconColor: CustomColors.white,
                                                  iconSize: Dimens.space16,
                                                  boxDecorationColor:
                                                      Colors.transparent,
                                                  imageUrl: (contactsProvider
                                                                  .contactDetailResponse !=
                                                              null &&
                                                          contactsProvider
                                                                  .contactDetailResponse
                                                                  .data !=
                                                              null &&
                                                          contactsProvider
                                                                  .contactDetailResponse
                                                                  .data
                                                                  .contactDetailResponseData
                                                                  .contacts !=
                                                              null)
                                                      ? contactsProvider
                                                          .contactDetailResponse
                                                          .data
                                                          .contactDetailResponseData
                                                          .contacts
                                                          .flagUrl
                                                      : "",
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      color: Colors.white,
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space16.w,
                                          Dimens.space20.h,
                                          Dimens.space16.w,
                                          Dimens.space0.h),
                                      padding: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      child: CustomSearchFieldWidgetWithIcon(
                                          animationController:
                                              animationController,
                                          textEditingController:
                                              controllerSearchTag,
                                          customIcon: CustomIcon.icon_search,
                                          hint: Utils.getString("searchTags"))),
                                  contactsProvider.tags.data != null
                                      ? contactsProvider.tags.data.length != 0
                                          ? Expanded(
                                              flex: 1,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemCount: contactsProvider
                                                    .tags.data.length,
                                                padding: EdgeInsets.fromLTRB(
                                                    Dimens.space0.w,
                                                    Dimens.space20.h,
                                                    Dimens.space0.w,
                                                    Dimens.space0.h),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Container(
                                                    color: Colors.transparent,
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.fromLTRB(
                                                        Dimens.space0.w,
                                                        Dimens.space0.h,
                                                        Dimens.space0.w,
                                                        Dimens.space0.h),
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            Dimens.space0.w,
                                                            Dimens.space0.h,
                                                            Dimens.space0.w,
                                                            Dimens.space0.h),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Divider(
                                                          color: CustomColors
                                                              .mainDividerColor,
                                                          height:
                                                              Dimens.space1.h,
                                                          thickness:
                                                              Dimens.space1.h,
                                                        ),
                                                        Container(
                                                          color: Colors
                                                              .transparent,
                                                          alignment:
                                                              Alignment.center,
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  Dimens.space20
                                                                      .w,
                                                                  Dimens
                                                                      .space0.h,
                                                                  Dimens
                                                                      .space0.w,
                                                                  Dimens.space0
                                                                      .h),
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  Dimens
                                                                      .space0.w,
                                                                  Dimens
                                                                      .space0.h,
                                                                  Dimens
                                                                      .space0.w,
                                                                  Dimens.space0
                                                                      .h),
                                                          height:
                                                              Dimens.space52.h,
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Container(
                                                                color: Colors
                                                                    .transparent,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                margin: EdgeInsets.fromLTRB(
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h,
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h),
                                                                padding: EdgeInsets.fromLTRB(
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h,
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h),
                                                                child:
                                                                    CustomCheckBox(
                                                                  width: Dimens
                                                                      .space20,
                                                                  height: Dimens
                                                                      .space20,
                                                                  boxFit: BoxFit
                                                                      .contain,
                                                                  iconUrl: Icons
                                                                      .check,
                                                                  iconColor:
                                                                      CustomColors
                                                                          .white,
                                                                  selectedColor:
                                                                      CustomColors
                                                                          .loadingCircleColor,
                                                                  unSelectedColor:
                                                                      CustomColors
                                                                          .textQuinaryColor,
                                                                  iconSize: Dimens
                                                                      .space16,
                                                                  outerCorner:
                                                                      Dimens
                                                                          .space6,
                                                                  innerCorner:
                                                                      Dimens
                                                                          .space6,
                                                                  assetHeight:
                                                                      Dimens
                                                                          .space20,
                                                                  assetWidth:
                                                                      Dimens
                                                                          .space20,
                                                                  isChecked:
                                                                      contactsProvider
                                                                          .tags
                                                                          .data[
                                                                              index]
                                                                          .check,
                                                                  onCheckBoxTap:
                                                                      (value) {
                                                                    if (!value) {
                                                                      selectedTags.add(contactsProvider
                                                                          .tags
                                                                          .data[
                                                                              index]
                                                                          .id);
                                                                      contactsProvider
                                                                          .tags
                                                                          .data[
                                                                              index]
                                                                          .check = true;
                                                                    } else {
                                                                      selectedTags.remove(contactsProvider
                                                                          .tags
                                                                          .data[
                                                                              index]
                                                                          .id);
                                                                      contactsProvider
                                                                          .tags
                                                                          .data[
                                                                              index]
                                                                          .check = false;
                                                                    }
                                                                    setState(
                                                                        () {

                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                              Container(
                                                                color: Colors
                                                                    .transparent,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                margin: EdgeInsets.fromLTRB(
                                                                    Dimens
                                                                        .space14
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h,
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h),
                                                                padding: EdgeInsets.fromLTRB(
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h,
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h),
                                                                child:
                                                                    TagsItemWidget(
                                                                  tags: contactsProvider
                                                                          .tags
                                                                          .data[
                                                                      index],
                                                                  fromContact:
                                                                      false,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        controllerSearchTag.text
                                                                    .isNotEmpty &&
                                                                index ==
                                                                    contactsProvider
                                                                            .tags
                                                                            .data
                                                                            .length -
                                                                        1
                                                            ? TextButton(
                                                                style: TextButton
                                                                    .styleFrom(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            Dimens
                                                                                .space0.w,
                                                                            Dimens
                                                                                .space0.h,
                                                                            Dimens
                                                                                .space0.w,
                                                                            Dimens
                                                                                .space0.h),
                                                                        tapTargetSize:
                                                                            MaterialTapTargetSize
                                                                                .shrinkWrap,
                                                                        alignment:
                                                                            Alignment
                                                                                .centerLeft,
                                                                        side:
                                                                            BorderSide(
                                                                          width: Dimens
                                                                              .space1
                                                                              .h,
                                                                          color:
                                                                              CustomColors.mainDividerColor,
                                                                        )),
                                                                onPressed:
                                                                    () async {
                                                                  await showModalBottomSheet(
                                                                      context:
                                                                          context,
                                                                      isScrollControlled:
                                                                          true,
                                                                      isDismissible:
                                                                          true,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(Dimens.space16.r),
                                                                            topRight: Radius.circular(Dimens.space16.r)),
                                                                      ),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return ColorPickerDialog(onColorPicked:
                                                                            (value) async {
                                                                          setState(
                                                                              () {
                                                                            selectedColor =
                                                                                value;
                                                                          });
                                                                          if (TagsValidation.isValidTagsValidation(controllerSearchTag.text)
                                                                              .isEmpty) {
                                                                            AddTagRequestParamHolder
                                                                                param =
                                                                                AddTagRequestParamHolder(
                                                                              title: controllerSearchTag.text,
                                                                              backgroundColorCode: selectedColor.backgroundColorCode,
                                                                              colorCode: selectedColor.colorCode,
                                                                            );
                                                                            PsProgressDialog.showDialog(context);
                                                                            Resources<AddTagResponse>
                                                                                response =
                                                                                await contactsProvider.doAddNewTagApiCall(param);
                                                                            if (response.data != null &&
                                                                                response.data.addTagsResponseData != null &&
                                                                                response.data.addTagsResponseData.tag != null) {
                                                                              PsProgressDialog.dismissDialog();
                                                                              widget.onCallback();
                                                                              contactsProvider.doGetAllTagsApiCall();
                                                                            } else {
                                                                              PsProgressDialog.dismissDialog();
                                                                              Utils.showToastMessage(response.message);
                                                                            }
                                                                          } else {
                                                                            showDialog<dynamic>(
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  return ErrorDialog(
                                                                                    message: TagsValidation.isValidTagsValidation(controllerSearchTag.text),
                                                                                  );
                                                                                });
                                                                          }
                                                                        });
                                                                      });
                                                                },
                                                                child:
                                                                    Container(
                                                                        alignment:
                                                                            Alignment
                                                                                .centerLeft,
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            Dimens
                                                                                .space20.w,
                                                                            Dimens
                                                                                .space0.h,
                                                                            Dimens
                                                                                .space20.w,
                                                                            Dimens
                                                                                .space0.h),
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            Dimens
                                                                                .space0.w,
                                                                            Dimens
                                                                                .space0.h,
                                                                            Dimens
                                                                                .space0.w,
                                                                            Dimens
                                                                                .space0.h),
                                                                        height: Dimens
                                                                            .space52
                                                                            .h,
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: <
                                                                              Widget>[
                                                                            Container(
                                                                              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                                                              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                                                              alignment: Alignment.center,
                                                                              child: Icon(
                                                                                Icons.add_circle_outline,
                                                                                color: CustomColors.loadingCircleColor,
                                                                                size: Dimens.space20.w,
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                                child: Container(
                                                                              width: double.infinity,
                                                                              height: Dimens.space50.h,
                                                                              margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                                                              alignment: Alignment.centerLeft,
                                                                              child: Text('${Utils.getString('createTag')} ${controllerSearchTag.text.isNotEmpty ? "\"${controllerSearchTag.text}\"" : ""}',
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                                                                                        fontFamily: Config.heeboMedium,
                                                                                        color: CustomColors.loadingCircleColor,
                                                                                        fontSize: Dimens.space16.sp,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        fontStyle: FontStyle.normal,
                                                                                      )),
                                                                            )),
                                                                            Container(
                                                                              alignment: Alignment.center,
                                                                              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                                                              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                                                              child: RoundedNetworkImageHolder(
                                                                                width: Dimens.space20,
                                                                                height: Dimens.space20,
                                                                                boxFit: BoxFit.cover,
                                                                                iconUrl: CustomIcon.icon_profile,
                                                                                containerAlignment: Alignment.center,
                                                                                iconColor: HexToColor(selectedColor.colorCode),
                                                                                iconSize: Dimens.space20,
                                                                                boxDecorationColor: HexToColor(selectedColor.colorCode),
                                                                                outerCorner: Dimens.space8,
                                                                                innerCorner: Dimens.space8,
                                                                                imageUrl: "",
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )),
                                                              )
                                                            : Container(),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                physics:
                                                    AlwaysScrollableScrollPhysics(),
                                              ),
                                            )
                                          : Expanded(
                                              child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space20.h,
                                                  Dimens.space0.w,
                                                  Dimens.space0.h),
                                              padding: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                  Dimens.space0.w,
                                                  Dimens.space0.h),
                                              child: Column(
                                                children: [
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        tapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        side: BorderSide(
                                                          width:
                                                              Dimens.space1.h,
                                                          color: CustomColors
                                                              .mainDividerColor,
                                                        )),
                                                    onPressed: () async {
                                                      await showModalBottomSheet(
                                                          context: context,
                                                          isScrollControlled:
                                                              true,
                                                          isDismissible: true,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(Dimens
                                                                        .space16
                                                                        .r),
                                                                topRight: Radius
                                                                    .circular(Dimens
                                                                        .space16
                                                                        .r)),
                                                          ),
                                                          backgroundColor:
                                                              Colors.white,
                                                          builder: (BuildContext
                                                              context) {
                                                            return ColorPickerDialog(
                                                              onColorPicked:
                                                                  (value) async {
                                                                setState(() {
                                                                  selectedColor =
                                                                      value;
                                                                });

                                                                if (TagsValidation.isValidTagsValidation(
                                                                        controllerSearchTag
                                                                            .text)
                                                                    .isEmpty) {
                                                                  AddTagRequestParamHolder
                                                                      param =
                                                                      AddTagRequestParamHolder(
                                                                    title:
                                                                        controllerSearchTag
                                                                            .text,
                                                                    backgroundColorCode:
                                                                        selectedColor
                                                                            .backgroundColorCode,
                                                                    colorCode:
                                                                        selectedColor
                                                                            .colorCode,
                                                                  );
                                                                  PsProgressDialog
                                                                      .showDialog(
                                                                          context);
                                                                  Resources<
                                                                          AddTagResponse>
                                                                      response =
                                                                      await contactsProvider
                                                                          .doAddNewTagApiCall(
                                                                              param);
                                                                  if (response.data != null &&
                                                                      response.data
                                                                              .addTagsResponseData !=
                                                                          null &&
                                                                      response
                                                                              .data
                                                                              .addTagsResponseData
                                                                              .tag !=
                                                                          null) {
                                                                    PsProgressDialog
                                                                        .dismissDialog();
                                                                    contactsProvider
                                                                        .doGetAllTagsApiCall();
                                                                    controllerSearchTag
                                                                        .text = "";
                                                                  } else {
                                                                    PsProgressDialog
                                                                        .dismissDialog();
                                                                    Utils.showToastMessage(
                                                                        response
                                                                            .message);
                                                                  }
                                                                } else {
                                                                  showDialog<
                                                                          dynamic>(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return ErrorDialog(
                                                                          message:
                                                                              TagsValidation.isValidTagsValidation(controllerSearchTag.text),
                                                                        );
                                                                      });
                                                                }
                                                              },
                                                            );
                                                          });
                                                    },
                                                    child: Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens
                                                                    .space20.w,
                                                                Dimens.space0.h,
                                                                Dimens
                                                                    .space20.w,
                                                                Dimens
                                                                    .space0.h),
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        height:
                                                            Dimens.space52.h,
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .fromLTRB(
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h,
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h),
                                                              padding: EdgeInsets
                                                                  .fromLTRB(
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h,
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Icon(
                                                                Icons
                                                                    .add_circle_outline,
                                                                color: CustomColors
                                                                    .loadingCircleColor,
                                                                size: Dimens
                                                                    .space20.w,
                                                              ),
                                                            ),
                                                            Expanded(
                                                                child:
                                                                    Container(
                                                              width: double
                                                                  .infinity,
                                                              height: Dimens
                                                                  .space50.h,
                                                              margin: EdgeInsets
                                                                  .fromLTRB(
                                                                      Dimens
                                                                          .space10
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h,
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h),
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                  '${Utils.getString('createTag')} ${controllerSearchTag.text.isNotEmpty ? "\"${controllerSearchTag.text}\"" : ""}',
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyText1
                                                                      .copyWith(
                                                                        fontFamily:
                                                                            Config.heeboMedium,
                                                                        color: CustomColors
                                                                            .loadingCircleColor,
                                                                        fontSize: Dimens
                                                                            .space16
                                                                            .sp,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        fontStyle:
                                                                            FontStyle.normal,
                                                                      )),
                                                            )),
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              margin: EdgeInsets
                                                                  .fromLTRB(
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h,
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h),
                                                              padding: EdgeInsets
                                                                  .fromLTRB(
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h,
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h),
                                                              child:
                                                                  RoundedNetworkImageHolder(
                                                                width: Dimens
                                                                    .space20,
                                                                height: Dimens
                                                                    .space20,
                                                                boxFit: BoxFit
                                                                    .cover,
                                                                iconUrl: CustomIcon
                                                                    .icon_profile,
                                                                containerAlignment:
                                                                    Alignment
                                                                        .center,
                                                                iconColor: HexToColor(
                                                                    selectedColor
                                                                        .colorCode),
                                                                iconSize: Dimens
                                                                    .space20,
                                                                boxDecorationColor:
                                                                    HexToColor(
                                                                        selectedColor
                                                                            .colorCode),
                                                                outerCorner:
                                                                    Dimens
                                                                        .space8,
                                                                innerCorner:
                                                                    Dimens
                                                                        .space8,
                                                                imageUrl: "",
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ))
                                      : Expanded(
                                          child: SpinKitCircle(
                                            color: CustomColors.mainColor,
                                          ),
                                        )
                                ]),
                          ),
                        ),
                      );
                    });
              })),
    );
  }
}
