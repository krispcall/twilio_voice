import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/provider/call_log/CallLogProvider.dart';
import 'package:voice_example/repository/CallLogRepository.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTabWidget extends StatefulWidget {
  CustomTabWidget({
    Key key,
    @required this.title,
    @required this.selected,
    this.offstage = true,
    this.callLogProvider,
  }) : super(key: key);
  final String title;
  final bool offstage;
  final bool selected;
  final CallLogProvider callLogProvider;

  @override
  _CustomTabWidgetState createState() {
    return _CustomTabWidgetState();
  }
}

class _CustomTabWidgetState extends State<CustomTabWidget> {
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
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontSize: Dimens.space14.sp,
                    fontWeight: FontWeight.normal,
                    color: widget.selected
                        ? CustomColors.mainColor
                        : CustomColors.textTertiaryColor,
                    fontFamily: Config.manropeSemiBold,
                    fontStyle: FontStyle.normal,
                  ),

            ),
          ),
          Offstage(
            offstage: widget.offstage,
            child: Container(
              width: Dimens.space20.w,
              height: Dimens.space20.h,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CustomColors.textPrimaryErrorColor),
              alignment: Alignment.center,
              child: Text(
                "${(widget.callLogProvider != null && widget.callLogProvider.newCount.data != null) ? widget.callLogProvider.newCount.data : "0"}",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: CustomColors.white,
                      fontFamily: Config.manropeBold,
                      fontSize: Dimens.space12.sp,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomTagTabWidget extends StatelessWidget {
  CustomTagTabWidget({
    Key key,
    @required this.title,
    @required this.selected,
    this.offstage = true,
  }) : super(key: key);
  final String title;
  final bool offstage;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                fontSize: Dimens.space14.sp,
                fontWeight: FontWeight.normal,
                color: selected
                    ? CustomColors.mainColor
                    : CustomColors.textTertiaryColor,
                fontFamily: Config.manropeSemiBold,
                fontStyle: FontStyle.normal,
              ),
        ),
      ),
    );
  }
}
