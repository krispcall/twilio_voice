import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/contacts/ContactsProvider.dart';
import 'package:voice_example/repository/ContactRepository.dart';
import 'package:voice_example/ui/common/NoLeadingSpaceFormatter.dart';
import 'package:voice_example/ui/common/base/CustomAppBar.dart';
import 'package:voice_example/ui/common/dialog/ErrorDialog.dart';
import 'package:voice_example/utils/PsProgressDialog.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/utils/Validation.dart';
import 'package:voice_example/viewobject/holder/request_holder/addNoteByNumberRequestParamHolder/AddNoteByNumberRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/addNotesToContactRequestParamHolder/AddNoteToContactRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/addNotesToContactRequestParamHolder/AddNoteToContactRequestParamHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/contactPinUnpinRequestParamHolder/ContactPinUnpinRequestHolder.dart';
import 'package:voice_example/viewobject/model/addNoteByNumber/AddNoteByNumberResponse.dart';
import 'package:voice_example/viewobject/model/addNotes/AddNoteResponse.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddNotesView extends StatefulWidget {
  final String clientId;
  final String clientNumber;
  final Function onIncomingTap;
  final Function onOutgoingTap;

  AddNotesView({
    Key key,
    @required this.clientId,
    @required this.clientNumber,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
  }) : super(key: key);

  @override
  AddNotesViewState createState() => AddNotesViewState();
}

class AddNotesViewState extends State<AddNotesView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  // TextEditingController controllerNoteTitle = TextEditingController();
  TextEditingController controllerNote = TextEditingController();
  ContactRepository contactRepository;
  ContactsProvider contactsProvider;
  String clientId = "";

  @override
  void initState() {
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
        body:CustomAppBar<ContactsProvider>(
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
                          if (NoteValidation.isValidNote(controllerNote.text)
                              .isEmpty) {
                            if (clientId != null) {
                              AddNoteToContactRequestHolder param =
                              AddNoteToContactRequestHolder(
                                  clientId: clientId,
                                  data: AddNoteToContactRequestParamHolder(
                                    channelId: contactsProvider
                                        .getDefaultChannel()
                                        .id,
                                    title: controllerNote.text,
                                  ));
                              PsProgressDialog.showDialog(context);
                              Resources<AddNoteResponse> response =
                              await contactsProvider
                                  .doAddNoteToContactApiCall(param);
                              if (response.data != null &&
                                  response.data.addNoteResponseData != null &&
                                  response.data.addNoteResponseData.data !=
                                      null) {
                                PsProgressDialog.dismissDialog();
                                Navigator.of(context)
                                    .pop({'data': true, 'clientId': clientId});
                              } else {
                                PsProgressDialog.dismissDialog();
                                Utils.showToastMessage(response.message);
                              }
                            } else {
                              AddNoteByNumberRequestHolder param =
                              AddNoteByNumberRequestHolder(
                                  contact: widget.clientNumber,
                                  data: AddNoteToContactRequestParamHolder(
                                    channelId: contactsProvider
                                        .getDefaultChannel()
                                        .id,
                                    title: controllerNote.text,
                                  ));
                              PsProgressDialog.showDialog(context);
                              Resources<AddNoteByNumberResponse> response =
                              await contactsProvider
                                  .doAddNoteByNumberApiCall(param);
                              if (response.data != null &&
                                  response.data.addNoteByNumberResponseData !=
                                      null &&
                                  response.data.addNoteByNumberResponseData
                                      .data !=
                                      null) {
                                PsProgressDialog.dismissDialog();
                                Navigator.of(context).pop({
                                  'data': true,
                                  'clientId': response
                                      .data
                                      .addNoteByNumberResponseData
                                      .data
                                      .contacts
                                      .id
                                });
                              } else {
                                PsProgressDialog.dismissDialog();
                                Utils.showToastMessage(response.message);
                              }
                            }
                          } else {
                            showDialog<dynamic>(
                                context: context,
                                builder: (BuildContext context) {
                                  return ErrorDialog(
                                    message: NoteValidation.isValidNote(
                                        controllerNote.text),
                                  );
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
                            borderRadius: BorderRadius.circular(Dimens.space0.r),
                          ),
                        ),
                        child: Text(
                          Utils.getString('done'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: CustomColors.loadingCircleColor,
                              fontFamily: Config.manropeSemiBold,
                              fontSize: Dimens.space15.sp,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal),
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
              ContactPinUnpinRequestHolder param = ContactPinUnpinRequestHolder(
                channel: contactsProvider.getDefaultChannel().id,
                contact: widget.clientNumber,
                pinned: false,
              );
              contactsProvider.doGetAllNotesApiCall(param);
            },
            builder:
                (BuildContext context, ContactsProvider provider, Widget child) {
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
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                              Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space30.w,
                              Dimens.space28.h,
                              Dimens.space30.w,
                              Dimens.space28.h),
                          child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Container(
                                //   alignment: Alignment.center,
                                //   margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                //   padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                //   child: TextField(
                                //     controller: controllerNoteTitle,
                                //     style: Theme.of(context).textTheme.bodyText1.copyWith(
                                //         color: CustomColors.textSenaryColor,
                                //         fontFamily: Config.manropeBold,
                                //         fontWeight: FontWeight.normal,
                                //         fontSize: Dimens.space22.sp,
                                //         fontStyle: FontStyle.normal
                                //     ),
                                //     decoration: InputDecoration(
                                //       contentPadding: EdgeInsets.fromLTRB(
                                //           Dimens.space0.w,
                                //           Dimens.space13.h,
                                //           Dimens.space0.w,
                                //           Dimens.space13.h),
                                //       isDense: true,
                                //       border: OutlineInputBorder(
                                //         borderSide: BorderSide(
                                //           color: Colors.transparent,
                                //           width: Dimens.space0.w,
                                //         ),
                                //         borderRadius: BorderRadius.all(
                                //             Radius.circular(Dimens.space10.r)),
                                //       ),
                                //       disabledBorder: OutlineInputBorder(
                                //         borderSide: BorderSide(
                                //           color: Colors.transparent,
                                //           width: Dimens.space0.w,
                                //         ),
                                //         borderRadius: BorderRadius.all(
                                //             Radius.circular(Dimens.space10.r)),
                                //       ),
                                //       errorBorder: OutlineInputBorder(
                                //         borderSide: BorderSide(
                                //           color: Colors.transparent,
                                //           width: Dimens.space0.w,
                                //         ),
                                //         borderRadius: BorderRadius.all(
                                //             Radius.circular(Dimens.space10.r)),
                                //       ),
                                //       focusedErrorBorder: OutlineInputBorder(
                                //         borderSide: BorderSide(
                                //           color: Colors.transparent,
                                //           width: Dimens.space0.w,
                                //         ),
                                //         borderRadius: BorderRadius.all(
                                //             Radius.circular(Dimens.space10.r)),
                                //       ),
                                //       enabledBorder: OutlineInputBorder(
                                //         borderSide: BorderSide(
                                //           color: Colors.transparent,
                                //           width: Dimens.space0.w,
                                //         ),
                                //         borderRadius: BorderRadius.all(
                                //             Radius.circular(Dimens.space10.r)),
                                //       ),
                                //       focusedBorder: OutlineInputBorder(
                                //         borderSide: BorderSide(
                                //           color: Colors.transparent,
                                //           width: Dimens.space0.w,
                                //         ),
                                //         borderRadius: BorderRadius.all(
                                //             Radius.circular(Dimens.space10.r)),
                                //       ),
                                //       filled: true,
                                //       fillColor: CustomColors.transparent,
                                //       hintText: Utils.getString('noteTitle'),
                                //       hintStyle: Theme.of(context)
                                //           .textTheme
                                //           .bodyText1
                                //           .copyWith(
                                //           color: CustomColors.textQuaternaryColor,
                                //           fontFamily: Config.manropeBold,
                                //           fontWeight: FontWeight.normal,
                                //           fontSize: Dimens.space22.sp,
                                //           fontStyle: FontStyle.normal
                                //       ),
                                //     ),
                                //     keyboardType: TextInputType.name,
                                //     textInputAction: TextInputAction.next,
                                //   ),
                                // ),
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
                                  child: TextField(
                                    inputFormatters: [
                                      NoLeadingSpaceFormatter(),
                                    ],
                                    controller: controllerNote,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color:
                                        CustomColors.textSecondaryColor,
                                        fontFamily: Config.heeboRegular,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space16.sp,
                                        fontStyle: FontStyle.normal),
                                    maxLines: 10,
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
                                      fillColor: CustomColors.transparent,
                                      hintText: Utils.getString('writeANoteHere'),
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                          color: CustomColors
                                              .textQuaternaryColor,
                                          fontFamily: Config.heeboRegular,
                                          fontWeight: FontWeight.normal,
                                          fontSize: Dimens.space16.sp,
                                          fontStyle: FontStyle.normal),
                                    ),
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.done,
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    );
                  });
            })
      ),
    );
  }
}
