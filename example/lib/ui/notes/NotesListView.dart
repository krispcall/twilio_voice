import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/constant/RoutePaths.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/contacts/ContactsProvider.dart';
import 'package:voice_example/repository/ContactRepository.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/ui/common/EmptyViewUiWidget.dart';
import 'package:voice_example/ui/common/base/CustomAppBar.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/holder/intent_holder/AddNotesIntentHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/ColorHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/contactPinUnpinRequestParamHolder/ContactPinUnpinRequestHolder.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotesListView extends StatefulWidget {
  final String clientId;
  final String clientNumber;

  NotesListView({
    Key key,
    @required this.clientId,
    @required this.clientNumber,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
  }) : super(key: key);

  final Function onIncomingTap;
  final Function onOutgoingTap;

  @override
  NotesListViewState createState() => NotesListViewState();
}

class NotesListViewState extends State<NotesListView>
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
    clientId = widget.clientId;
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
          Navigator.of(context).pop({'data': true, 'clientId': clientId});
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                CustomIcon.icon_arrow_left,
                                color: CustomColors.loadingCircleColor,
                                size: Dimens.space22.w,
                              ),
                              Text(
                                Utils.getString('back'),
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
                      Utils.getString("notes"),
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
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      width: Dimens.space20.w,
                      child: TextButton(
                        onPressed: () async {
                          final dynamic returnData = await Navigator.pushNamed(
                              context, RoutePaths.addNewNotes,
                              arguments: AddNotesIntentHolder(
                                clientId: widget.clientId,
                                number: contactsProvider
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
                                    : widget.clientNumber,
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
                              contact: widget.clientNumber,
                              pinned: false,
                            );
                            return contactsProvider
                                .doGetAllNotesApiCall(param)
                                .then((value) {
                              setState(() {
                                clientId = returnData['clientId'];
                              });
                            });
                          }
                        },
                        style: TextButton.styleFrom(
                          alignment: Alignment.center,
                          backgroundColor: CustomColors.transparent,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.fromLTRB(Dimens.space0,
                              Dimens.space0, Dimens.space0, Dimens.space0),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(Dimens.space0.r),
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
                    ),
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
              contactsProvider.doContactDetailApiCall(widget.clientId);
              ContactPinUnpinRequestHolder param = ContactPinUnpinRequestHolder(
                channel: contactsProvider.getDefaultChannel().id,
                contact: widget.clientNumber,
                pinned: false,
              );
              contactsProvider.doGetAllNotesApiCall(param);
            },
            builder: (BuildContext context, ContactsProvider provider,
                Widget child) {
              animationController.forward();
              return RefreshIndicator(
                color: CustomColors.mainColor,
                backgroundColor: CustomColors.white,
                child: AnimatedBuilder(
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
                                Dimens.space16.w,
                                Dimens.space0.h,
                                Dimens.space16.w,
                                Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  contactsProvider.notes.data != null
                                      ? contactsProvider.notes.data.length != 0
                                          ? Expanded(
                                              flex: 1,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemCount: contactsProvider
                                                    .notes.data.length,
                                                padding: EdgeInsets.fromLTRB(
                                                    Dimens.space0.w,
                                                    Dimens.space0.h,
                                                    Dimens.space0.w,
                                                    Dimens.space0.h),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  Color color = Color(
                                                      (Random().nextDouble() *
                                                              0xFFFFFF)
                                                          .toInt());
                                                  return Container(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    margin: EdgeInsets.fromLTRB(
                                                        Dimens.space0.w,
                                                        Dimens.space10.h,
                                                        Dimens.space0.w,
                                                        Dimens.space0.h),
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            Dimens.space0.w,
                                                            Dimens.space18.h,
                                                            Dimens.space0.w,
                                                            Dimens.space18.h),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  Dimens.space10
                                                                      .r)),
                                                      color: color
                                                          .withOpacity(0.4),
                                                      gradient: LinearGradient(
                                                          stops: [
                                                            0.01,
                                                            0.01
                                                          ],
                                                          colors: [
                                                            color
                                                                .withOpacity(1),
                                                            color.withOpacity(
                                                                0.4)
                                                          ]),
                                                    ),
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
                                                        // Container(
                                                        //   color: Colors.transparent,
                                                        //   alignment: Alignment.centerLeft,
                                                        //   margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                                        //   padding: EdgeInsets.fromLTRB(Dimens.space21.w, Dimens.space0.h, Dimens.space21.w, Dimens.space0.h),
                                                        //   child: Text(
                                                        //     "Note Title",
                                                        //     textAlign: TextAlign.center,
                                                        //     style: Theme.of(context)
                                                        //         .textTheme
                                                        //         .bodyText1
                                                        //         .copyWith(
                                                        //       color: CustomColors.textSenaryColor,
                                                        //       fontFamily: Config.manropeBold,
                                                        //       fontSize: Dimens.space16.sp,
                                                        //       fontWeight: FontWeight.normal,
                                                        //       fontStyle: FontStyle.normal,
                                                        //     ),
                                                        //   ),
                                                        // ),
                                                        Container(
                                                          color: Colors
                                                              .transparent,
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  Dimens
                                                                      .space0.w,
                                                                  Dimens.space12
                                                                      .h,
                                                                  Dimens
                                                                      .space0.w,
                                                                  Dimens.space0
                                                                      .h),
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  Dimens.space21
                                                                      .w,
                                                                  Dimens
                                                                      .space0.h,
                                                                  Dimens.space21
                                                                      .w,
                                                                  Dimens.space0
                                                                      .h),
                                                          child: Text(
                                                            Utils.dateFullMonthYearTimeWithAt(
                                                                Config
                                                                    .dateFormat,
                                                                contactsProvider
                                                                    .notes
                                                                    .data[index]
                                                                    .createdAt),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1
                                                                .copyWith(
                                                                  color: CustomColors
                                                                      .textTertiaryColor,
                                                                  fontFamily: Config
                                                                      .heeboRegular,
                                                                  fontSize: Dimens
                                                                      .space13
                                                                      .sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                ),
                                                          ),
                                                        ),
                                                        Container(
                                                          color: Colors
                                                              .transparent,
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  Dimens
                                                                      .space0.w,
                                                                  Dimens.space10
                                                                      .h,
                                                                  Dimens
                                                                      .space0.w,
                                                                  Dimens.space0
                                                                      .h),
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  Dimens.space21
                                                                      .w,
                                                                  Dimens
                                                                      .space0.h,
                                                                  Dimens.space21
                                                                      .w,
                                                                  Dimens.space0
                                                                      .h),
                                                          child: Text(
                                                            contactsProvider
                                                                .notes
                                                                .data[index]
                                                                .title,
                                                            textAlign:
                                                                TextAlign.left,
                                                            maxLines: 100,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1
                                                                .copyWith(
                                                                  color: CustomColors
                                                                      .textSecondaryColor,
                                                                  fontFamily: Config
                                                                      .heeboRegular,
                                                                  fontSize: Dimens
                                                                      .space15
                                                                      .sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                ),
                                                          ),
                                                        ),
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
                                                          "assets/images/empty_notes.png",
                                                      title: Utils.getString(
                                                          'noNotes'),
                                                      desc: Utils.getString(
                                                          'noNotesDescription'),
                                                      buttonTitle:
                                                          Utils.getString(
                                                              'addNewNotes'),
                                                      icon: Icons
                                                          .add_circle_outline,
                                                      onPressed: () async {
                                                        final dynamic
                                                            returnData =
                                                            await Navigator.pushNamed(
                                                                context,
                                                                RoutePaths
                                                                    .addNewNotes,
                                                                arguments:
                                                                    AddNotesIntentHolder(
                                                                  clientId: widget
                                                                      .clientId,
                                                                  number: contactsProvider.contactDetailResponse.data !=
                                                                              null &&
                                                                          contactsProvider.contactDetailResponse.data.contactDetailResponseData.contacts !=
                                                                              null
                                                                      ? contactsProvider
                                                                          .contactDetailResponse
                                                                          .data
                                                                          .contactDetailResponseData
                                                                          .contacts
                                                                          .number
                                                                      : widget
                                                                          .clientNumber,
                                                                  onIncomingTap:
                                                                      () {
                                                                    widget
                                                                        .onIncomingTap();
                                                                  },
                                                                  onOutgoingTap:
                                                                      () {
                                                                    widget
                                                                        .onOutgoingTap();
                                                                  },
                                                                ));
                                                        if (returnData !=
                                                                null &&
                                                            returnData[
                                                                    'data'] !=
                                                                null &&
                                                            returnData[
                                                                'data']) {
                                                          ContactPinUnpinRequestHolder
                                                              param =
                                                              ContactPinUnpinRequestHolder(
                                                            channel:
                                                                contactsProvider
                                                                    .getDefaultChannel()
                                                                    .id,
                                                            contact: widget
                                                                .clientNumber,
                                                            pinned: false,
                                                          );
                                                          return contactsProvider
                                                              .doGetAllNotesApiCall(
                                                                  param)
                                                              .then((value) {
                                                            setState(() {
                                                              clientId =
                                                                  returnData[
                                                                      'clientId'];
                                                            });
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  )),
                                            )
                                      : Expanded(
                                          child: SpinKitCircle(
                                            color: CustomColors.mainColor,
                                          ),
                                        )
                                ]),
                          ),
                        ),
                      );
                    }),
                onRefresh: () {
                  contactsProvider.doContactDetailApiCall(widget.clientId);
                  ContactPinUnpinRequestHolder param =
                      ContactPinUnpinRequestHolder(
                    channel: contactsProvider.getDefaultChannel().id,
                    contact: widget.clientNumber,
                    pinned: false,
                  );
                  return contactsProvider.doGetAllNotesApiCall(param);
                },
              );
            }),
      ),
    );
  }
}
