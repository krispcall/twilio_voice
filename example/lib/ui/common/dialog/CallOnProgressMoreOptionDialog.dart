import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/ui/common/ButtonWidget.dart';
import 'package:voice_example/utils/Utils.dart';

class CallOnProgressMoreOptionDialog extends StatefulWidget {
  const CallOnProgressMoreOptionDialog({
    Key key,
    @required this.onContactTap,
    @required this.onAddTagTap,
    @required this.onAddNoteTap,
    @required this.onTransferCallTap,
  }) : super(key: key);

  final Function onContactTap;
  final Function onAddTagTap;
  final Function onAddNoteTap;
  final Function onTransferCallTap;

  @override
  CallOnProgressMoreOptionDialogState createState() =>
      CallOnProgressMoreOptionDialogState();
}

class CallOnProgressMoreOptionDialogState
    extends State<CallOnProgressMoreOptionDialog>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.transparent,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space0.h,
          Dimens.space20.w, Dimens.space30.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: CustomColors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.space16.r),
                  topRight: Radius.circular(Dimens.space16.r),
                )),
              ),
              onPressed: () {
                widget.onTransferCallTap();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: Dimens.space48,
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space10.w, Dimens.space0.h),
                      child: Icon(
                        CustomIcon.icon_transfer_call,
                        color: CustomColors.blueLightColor,
                        size: Dimens.space15.w,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(
                        Utils.getString("transferCall"),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: CustomColors.blueLightColor,
                              fontStyle: FontStyle.normal,
                              fontSize: Dimens.space15.sp,
                              fontWeight: FontWeight.normal,
                              fontFamily: Config.manropeSemiBold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: CustomColors.white,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(Dimens.space0.r))),
              ),
              onPressed: widget.onAddTagTap,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: Dimens.space48,
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space10.w, Dimens.space0.h),
                      child: Icon(
                        CustomIcon.icon_tag,
                        color: CustomColors.textQuaternaryColor,
                        size: Dimens.space15.w,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(
                        Utils.getString("addTags"),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: CustomColors.textPrimaryColor,
                              fontStyle: FontStyle.normal,
                              fontSize: Dimens.space15.sp,
                              fontWeight: FontWeight.normal,
                              fontFamily: Config.manropeSemiBold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: CustomColors.white,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(Dimens.space0.r))),
              ),
              onPressed: widget.onAddNoteTap,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: Dimens.space48,
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space10.w, Dimens.space0.h),
                      child: Icon(
                        CustomIcon.icon_notes,
                        color: CustomColors.textQuaternaryColor,
                        size: Dimens.space15.w,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(
                        Utils.getString("addNote"),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: CustomColors.textPrimaryColor,
                              fontStyle: FontStyle.normal,
                              fontSize: Dimens.space15.sp,
                              fontWeight: FontWeight.normal,
                              fontFamily: Config.manropeSemiBold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: CustomColors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Dimens.space16.r),
                  bottomRight: Radius.circular(Dimens.space16.r),
                )),
              ),
              onPressed: widget.onContactTap,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: Dimens.space48,
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space10.w, Dimens.space0.h),
                      child: Icon(
                        CustomIcon.icon_person_full,
                        color: CustomColors.textQuaternaryColor,
                        size: Dimens.space15.w,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(
                        Utils.getString("contacts"),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: CustomColors.textPrimaryColor,
                              fontStyle: FontStyle.normal,
                              fontSize: Dimens.space15.sp,
                              fontWeight: FontWeight.normal,
                              fontFamily: Config.manropeSemiBold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space15.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            child: RoundedButtonWidget(
              width: MediaQuery.of(context).size.width,
              height: Dimens.space48,
              titleTextAlign: TextAlign.center,
              buttonBackgroundColor: CustomColors.white,
              buttonTextColor: CustomColors.textPrimaryColor,
              buttonBorderColor: CustomColors.white,
              corner: Dimens.space16,
              buttonFontSize: Dimens.space15,
              buttonFontFamily: Config.manropeSemiBold,
              fontStyle: FontStyle.normal,
              buttonFontWeight: FontWeight.normal,
              buttonText: Utils.getString('cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
