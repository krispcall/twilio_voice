import 'package:flutter/material.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'ButtonWidget.dart';
import 'CustomImageHolder.dart';

class EmptyViewUiWidget extends StatelessWidget
{
  final String assetUrl;
  final String title;
  final String desc;
  final String buttonTitle;
  final IconData icon;
  final VoidCallback onPressed;
  final bool showButton;

  EmptyViewUiWidget({
    Key key,
    this.onPressed,
    this.assetUrl,
    this.title,
    this.desc,
    this.buttonTitle,
    this.icon,
    this.showButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          PlainAssetImageHolder(
            assetUrl: assetUrl,
            width: Dimens.space152,
            height: Dimens.space152,
            assetWidth: Dimens.space152,
            assetHeight: Dimens.space152,
            boxFit: BoxFit.contain,
            outerCorner: Dimens.space0,
            innerCorner: Dimens.space0,
            iconSize: Dimens.space152,
            iconUrl: CustomIcon.icon_call,
            iconColor: CustomColors.white,
            boxDecorationColor: CustomColors.white,
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space40.w, Dimens.space20.h, Dimens.space40.w, Dimens.space0.h),
            child: Text(
              "${title}",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: Dimens.space20.sp,
                    color: CustomColors.textPrimaryColor,
                    fontFamily: Config.manropeBold,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                  ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space37.w, Dimens.space10.h, Dimens.space37.w, Dimens.space0.h),
            child: Text("${desc}",
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: CustomColors.textTertiaryColor,
                    fontFamily: Config.heeboRegular,
                    fontSize: Dimens.space15.sp,
                    fontWeight: FontWeight.normal
                ),
                textAlign: TextAlign.center
            ),
          ),
         showButton? Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space20.h, Dimens.space0.w, Dimens.space20.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              child: RoundedButtonWidgetWithPrefix(
                corner: Dimens.space10,
                titleText: buttonTitle,
                buttonColor: CustomColors.loadingCircleColor,
                titleTextAlign: TextAlign.center,
                textFontWeight: FontWeight.normal,
                textFontStyle: FontStyle.normal,
                textFontSize: Dimens.space16,
                textFontFamily: Config.manropeSemiBold,
                textColor: CustomColors.white,
                icon: icon,
                iconColor: CustomColors.white,
                iconSize: Dimens.space20.w,
                onPressed: onPressed,
                height: Dimens.space54,
                width: Dimens.space270,
              )
          ) : Container(height: 50,)
        ],
      ),
    );
  }
}

class RoundCornerWitIcon extends StatelessWidget
{
  RoundCornerWitIcon({
    @required this.onPressed,
    @required this.fillColor,
    @required this.iconColor,
    this.text,
    this.textColor,
    this.icon,
    this.verticalPadding,
    this.horizontalPadding,
    this.textstyle,
    this.iconSize
  });

  final GestureTapCallback onPressed;
  final Color fillColor;
  final Color iconColor;
  final IconData icon;
  final double iconSize;

  final String text;
  final Color textColor;
  final double verticalPadding;
  final double horizontalPadding;
  final TextStyle textstyle;

  @override
  Widget build(BuildContext context)
  {
    return Container(
      height: Dimens.space50.h,
      margin: EdgeInsets.symmetric(
          vertical: verticalPadding != null ? verticalPadding : Dimens.space4.h,
          horizontal: horizontalPadding != null ? horizontalPadding : Dimens.space0),
      child: RawMaterialButton(
        fillColor: fillColor,
        textStyle: TextStyle(color: textColor),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: Dimens.space10.h),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: iconSize,
              ),
              Container(
                margin: new EdgeInsets.only(left: Dimens.space10.w),
                child: Text(
                  text,
                  style: textstyle != null
                      ? textstyle
                      : Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: Dimens.space16.sp,
                          fontWeight: FontWeight.normal,
                          color: textColor,
                          fontFamily: Config.manropeSemiBold,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 1.0),
                ),
              ),
            ],
          ),
        ),
        onPressed: onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.space10)),
      ),
    );
  }
}
