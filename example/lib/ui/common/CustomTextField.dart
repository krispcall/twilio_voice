import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/viewobject/model/country/CountryCode.dart';

import 'NoLeadingSpaceFormatter.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController textEditingController;

  final String titleText;
  final String subTitle;
  final bool showSubTitle;
  final isForCountry;
  final FocusNode focusNodeNext;

  const CustomTextField(
      {@required this.textEditingController,
      @required this.containerFillColor,
      @required this.borderColor,
      this.hintText,
      this.hintFontColor = const Color(0xFF857F96),
      this.hintFontSize = Dimens.space16,
      this.hintFontStyle = FontStyle.normal,
      this.hintFontWeight = FontWeight.normal,
      this.hintFontFamily = Config.heeboRegular,
      this.titleText,
      this.subTitle,
      this.showSubTitle = false,
      this.titleFont = Config.heeboRegular,
      this.titleFontSize = Dimens.space14,
      this.titleFontStyle = FontStyle.normal,
      this.titleFontWeight = FontWeight.normal,
      this.titleTextColor = const Color(0xFF564D6D),
      this.subtitleFont = Config.heeboRegular,
      this.subtitleFontSize = Dimens.space13,
      this.subtitleFontStyle = FontStyle.normal,
      this.subtitleFontWeight = FontWeight.w500,
      this.subtitleTextColor = const Color(0xFF857F96),
      this.titleMarginLeft = Dimens.space0,
      this.titleMarginRight = Dimens.space0,
      this.titleMarginTop = Dimens.space0,
      this.titleMarginBottom = Dimens.space0,
      this.obscure = false,
      this.inputFontColor = const Color(0xFF251A43),
      this.inputFontSize = Dimens.space16,
      this.inputFontFamily = Config.heeboRegular,
      this.inputFontStyle = FontStyle.normal,
      this.inputFontWeight = FontWeight.normal,
      this.readOnly = false,
      this.height = Dimens.space54,
      this.showTitle = false,
      this.keyboardType = TextInputType.text,
      this.prefix = false,
      this.suffix = false,
      this.autoFocus = false,
      this.codes,
      this.selectedCountryCode,
      this.onPrefixTap,
      this.textInputAction = TextInputAction.done,
      this.onSuffixTap,
      this.corner = Dimens.space10,
      this.borderWidth = Dimens.space1,
      this.isForCountry = true,
      this.focusNodeNext,
      this.onChanged});

  // For Title

  final String titleFont;
  final double titleFontSize;
  final Color titleTextColor;
  final FontWeight titleFontWeight;
  final FontStyle titleFontStyle;
  final double titleMarginLeft;
  final double titleMarginRight;
  final double titleMarginTop;
  final double titleMarginBottom;

  //For Subtitle
  final String subtitleFont;
  final double subtitleFontSize;
  final Color subtitleTextColor;
  final FontWeight subtitleFontWeight;
  final FontStyle subtitleFontStyle;

  //For Hint
  final String hintText;
  final Color hintFontColor;
  final double hintFontSize;
  final FontStyle hintFontStyle;
  final FontWeight hintFontWeight;
  final String hintFontFamily;

  //For Input
  final Color inputFontColor;
  final double inputFontSize;
  final String inputFontFamily;
  final FontStyle inputFontStyle;
  final FontWeight inputFontWeight;

  //For Corner
  final double corner;

  //For Container
  final Color containerFillColor;

  //For Border
  final double borderWidth;
  final Color borderColor;

  final double height;
  final TextInputType keyboardType;
  final bool showTitle;
  final bool prefix;
  final bool suffix;
  final List<CountryCode> codes;
  final CountryCode selectedCountryCode;
  final Function onPrefixTap;
  final Function onSuffixTap;
  final bool autoFocus;
  final bool readOnly;
  final bool obscure;
  final TextInputAction textInputAction;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        showTitle
            ? Container(
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                margin: EdgeInsets.fromLTRB(titleMarginLeft.w, titleMarginTop.h,
                    titleMarginRight.w, titleMarginBottom.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      titleText,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: titleTextColor,
                            fontFamily: titleFont,
                            fontSize: titleFontSize.sp,
                            fontWeight: titleFontWeight,
                            fontStyle: titleFontStyle,
                          ),
                    ),
                    showSubTitle
                        ? Text(subTitle,
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: subtitleTextColor,
                                      fontFamily: subtitleFont,
                                      fontSize: subtitleFontSize.sp,
                                      fontWeight: subtitleFontWeight,
                                      fontStyle: subtitleFontStyle,
                                    ))
                        : Container(),
                  ],
                ),
              )
            : Container(
                height: 0,
              ),
        Container(
            width: MediaQuery.of(context).size.width.sw,
            height: height.h,
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: TextField(
              inputFormatters: [
                NoLeadingSpaceFormatter(),
              ],
              keyboardType: keyboardType,
              maxLines: 1,
              readOnly: readOnly,
              textCapitalization: TextCapitalization.words,
              showCursor: true,
              enabled: !readOnly,
              obscureText: obscure,
              controller: textEditingController,
              textInputAction: textInputAction,
              autofocus: autoFocus,
              onChanged: (data)
              {
                onChanged();
              },
              onSubmitted: (val) {
                if (focusNodeNext != null) {
                  FocusScope.of(context).unfocus();
                  FocusScope.of(context).requestFocus(focusNodeNext);
                } else {
                  FocusScope.of(context).unfocus();
                  FocusScope.of(context).requestFocus(FocusNode());
                }
              },
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: inputFontColor,
                    fontSize: inputFontSize.sp,
                    fontStyle: inputFontStyle,
                    fontFamily: inputFontFamily,
                    fontWeight: FontWeight.normal,
                  ),
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(Dimens.space12.w,
                    Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: borderColor, width: borderWidth.w),
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimens.space10.r)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: borderColor, width: borderWidth.w),
                  borderRadius: BorderRadius.all(Radius.circular(corner.r)),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: borderColor, width: borderWidth.w),
                  borderRadius: BorderRadius.all(Radius.circular(corner.r)),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: borderColor, width: borderWidth.w),
                  borderRadius: BorderRadius.all(Radius.circular(corner.r)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: borderColor, width: borderWidth.w),
                  borderRadius: BorderRadius.all(Radius.circular(corner.r)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: borderColor, width: borderWidth.w),
                  borderRadius: BorderRadius.all(Radius.circular(corner.r)),
                ),
                filled: true,
                fillColor: containerFillColor,
                hintText: hintText,
                hintStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: hintFontColor,
                      fontFamily: hintFontFamily,
                      fontWeight: hintFontWeight,
                      fontStyle: hintFontStyle,
                      fontSize: hintFontSize.sp,
                    ),
                prefixIcon: prefix
                    ? isForCountry
                        ? InkWell(
                            onTap: () {
                              onPrefixTap();
                              FocusScope.of(context).unfocus();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                        width: 1.0,
                                        color: CustomColors.secondaryColor,
                                        style: BorderStyle.solid), //BorderSide
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.fromLTRB(
                                            Dimens.space12.w,
                                            Dimens.space0.h,
                                            Dimens.space0.w,
                                            Dimens.space0.h),
                                        // child: Image.asset(
                                        //   selectedCountryCode.flagUri,
                                        //   fit: BoxFit.contain,
                                        //   width: Dimens.space24.w,
                                        //   height: Dimens.space24.h,
                                        //   cacheWidth: 25,
                                        // ),
                                        child: SvgPicture.network(
                                            Config.countryLogoUrl +
                                                selectedCountryCode.flagUri,
                                            width: Dimens.space20,
                                            fit: BoxFit.cover,
                                            alignment: Alignment.center,
                                            clipBehavior: Clip.antiAlias,
                                            allowDrawingOutsideViewBox: false,
                                            cacheColorFilter: true,
                                            placeholderBuilder:
                                                (BuildContext context) => Icon(
                                                      CustomIcon.icon_person,
                                                      size: Dimens.space20,
                                                      color: CustomColors
                                                          .mainColor,
                                                    ))),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.arrow_drop_down,
                                        color: CustomColors.textQuaternaryColor,
                                        size: Dimens.space24.w,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Icon(
                            CustomIcon.icon_search,
                            size: Dimens.space24.w,
                            color: CustomColors.textQuinaryColor,
                          )
                    : null,
                suffixIcon: suffix
                    ? InkWell(
                        onTap: () {
                          onSuffixTap();
                        },
                        child: Icon(
                          CustomIcon.icon_toggle_password,
                          size: Dimens.space20.w,
                          color: obscure
                              ? CustomColors.textPrimaryLightColor
                              : CustomColors.mainColor,
                        ),
                      )
                    : null,
              ),
            )),
      ],
    );
  }
}

class CustomSearchTextField extends StatelessWidget {
  final TextEditingController textEditingController;

  final String titleText;
  final String subTitle;
  final bool showSubTitle;
  final isForCountry;

  const CustomSearchTextField({
    @required this.textEditingController,
    @required this.containerFillColor,
    @required this.borderColor,
    this.hintText,
    this.hintFontColor = const Color(0xFF857F96),
    this.hintFontSize = Dimens.space16,
    this.hintFontStyle = FontStyle.normal,
    this.hintFontWeight = FontWeight.normal,
    this.hintFontFamily = Config.heeboRegular,
    this.titleText,
    this.subTitle,
    this.showSubTitle = false,
    this.titleFont = Config.heeboRegular,
    this.titleFontSize = Dimens.space14,
    this.titleFontStyle = FontStyle.normal,
    this.titleFontWeight = FontWeight.normal,
    this.titleTextColor = const Color(0xFF564D6D),
    this.subtitleFont = Config.heeboRegular,
    this.subtitleFontSize = Dimens.space13,
    this.subtitleFontStyle = FontStyle.normal,
    this.subtitleFontWeight = FontWeight.w500,
    this.subtitleTextColor = const Color(0xFF857F96),
    this.titleMarginLeft = Dimens.space0,
    this.titleMarginRight = Dimens.space0,
    this.titleMarginTop = Dimens.space0,
    this.titleMarginBottom = Dimens.space0,
    this.obscure = false,
    this.inputFontColor = const Color(0xFF251A43),
    this.inputFontSize = Dimens.space16,
    this.inputFontFamily = Config.heeboRegular,
    this.inputFontStyle = FontStyle.normal,
    this.inputFontWeight = FontWeight.normal,
    this.readOnly = false,
    this.height = Dimens.space54,
    this.showTitle = false,
    this.keyboardType = TextInputType.text,
    this.prefix = false,
    this.suffix = false,
    this.autoFocus = false,
    this.codes,
    this.selectedCountryCode,
    this.onPrefixTap,
    this.textInputAction = TextInputAction.done,
    this.onSuffixTap,
    this.corner = Dimens.space10,
    this.borderWidth = Dimens.space1,
    this.isForCountry = true,
    this.onSubmit,
  });

  // For Title
  final String titleFont;
  final double titleFontSize;
  final Color titleTextColor;
  final FontWeight titleFontWeight;
  final FontStyle titleFontStyle;
  final double titleMarginLeft;
  final double titleMarginRight;
  final double titleMarginTop;
  final double titleMarginBottom;

  //For Subtitle
  final String subtitleFont;
  final double subtitleFontSize;
  final Color subtitleTextColor;
  final FontWeight subtitleFontWeight;
  final FontStyle subtitleFontStyle;

  //For Hint
  final String hintText;
  final Color hintFontColor;
  final double hintFontSize;
  final FontStyle hintFontStyle;
  final FontWeight hintFontWeight;
  final String hintFontFamily;

  //For Input
  final Color inputFontColor;
  final double inputFontSize;
  final String inputFontFamily;
  final FontStyle inputFontStyle;
  final FontWeight inputFontWeight;

  //For Corner
  final double corner;

  //For Container
  final Color containerFillColor;

  //For Border
  final double borderWidth;
  final Color borderColor;

  final double height;
  final TextInputType keyboardType;
  final bool showTitle;
  final bool prefix;
  final bool suffix;
  final List<CountryCode> codes;
  final CountryCode selectedCountryCode;
  final Function onPrefixTap;
  final Function onSuffixTap;
  final Function(String) onSubmit;
  final bool autoFocus;
  final bool readOnly;
  final bool obscure;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        showTitle
            ? Container(
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                margin: EdgeInsets.fromLTRB(titleMarginLeft.w, titleMarginTop.h,
                    titleMarginRight.w, titleMarginBottom.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      titleText,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: titleTextColor,
                            fontFamily: titleFont,
                            fontSize: titleFontSize.sp,
                            fontWeight: titleFontWeight,
                            fontStyle: titleFontStyle,
                          ),
                    ),
                    showSubTitle
                        ? Text(subTitle,
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: subtitleTextColor,
                                      fontFamily: subtitleFont,
                                      fontSize: subtitleFontSize.sp,
                                      fontWeight: subtitleFontWeight,
                                      fontStyle: subtitleFontStyle,
                                    ))
                        : Container(),
                  ],
                ),
              )
            : Container(
                height: 0,
              ),
        Container(
            width: MediaQuery.of(context).size.width.sw,
            height: height.h,
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: TextField(
              inputFormatters: [
                NoLeadingSpaceFormatter(),
              ],
              keyboardType: keyboardType,
              maxLines: 1,
              readOnly: readOnly,
              showCursor: true,
              enabled: !readOnly,
              obscureText: obscure,
              controller: textEditingController,
              textInputAction: textInputAction,
              autofocus: autoFocus,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: inputFontColor,
                    fontSize: inputFontSize.sp,
                    fontStyle: inputFontStyle,
                    fontFamily: inputFontFamily,
                    fontWeight: FontWeight.normal,
                  ),
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(Dimens.space12.w,
                    Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: borderColor, width: borderWidth.w),
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimens.space10.r)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: borderColor, width: borderWidth.w),
                  borderRadius: BorderRadius.all(Radius.circular(corner.r)),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: borderColor, width: borderWidth.w),
                  borderRadius: BorderRadius.all(Radius.circular(corner.r)),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: borderColor, width: borderWidth.w),
                  borderRadius: BorderRadius.all(Radius.circular(corner.r)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: borderColor, width: borderWidth.w),
                  borderRadius: BorderRadius.all(Radius.circular(corner.r)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: borderColor, width: borderWidth.w),
                  borderRadius: BorderRadius.all(Radius.circular(corner.r)),
                ),
                filled: true,
                fillColor: containerFillColor,
                hintText: hintText,
                hintStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: hintFontColor,
                      fontFamily: hintFontFamily,
                      fontWeight: hintFontWeight,
                      fontStyle: hintFontStyle,
                      fontSize: hintFontSize.sp,
                    ),
                prefixIcon: prefix
                    ? isForCountry
                        ? InkWell(
                            onTap: () {
                              onPrefixTap();
                              FocusScope.of(context).unfocus();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                        width: 1.0,
                                        color: CustomColors.secondaryColor,
                                        style: BorderStyle.solid), //BorderSide
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.fromLTRB(
                                            Dimens.space12.w,
                                            Dimens.space0.h,
                                            Dimens.space0.w,
                                            Dimens.space0.h),
                                        // child: Image.asset(
                                        //   selectedCountryCode.flagUri,
                                        //   fit: BoxFit.contain,
                                        //   width: Dimens.space24.w,
                                        //   height: Dimens.space24.h,
                                        //   cacheWidth: 25,
                                        // ),
                                        child: SvgPicture.network(
                                            Config.countryLogoUrl +
                                                selectedCountryCode.flagUri,
                                            width: Dimens.space20,
                                            fit: BoxFit.cover,
                                            alignment: Alignment.center,
                                            clipBehavior: Clip.antiAlias,
                                            allowDrawingOutsideViewBox: false,
                                            cacheColorFilter: true,
                                            placeholderBuilder:
                                                (BuildContext context) => Icon(
                                                      CustomIcon.icon_person,
                                                      size: Dimens.space20,
                                                      color: CustomColors
                                                          .mainColor,
                                                    ))),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.arrow_drop_down,
                                        color: CustomColors.textQuaternaryColor,
                                        size: Dimens.space24.w,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Icon(
                            CustomIcon.icon_search,
                            size: Dimens.space24.w,
                            color: CustomColors.textQuinaryColor,
                          )
                    : null,
                suffixIcon: suffix
                    ? InkWell(
                        onTap: () {
                          onSuffixTap();
                          FocusScope.of(context).unfocus();
                        },
                        child: Icon(
                          CustomIcon.icon_toggle_password,
                          size: Dimens.space20.w,
                          color: obscure
                              ? CustomColors.textPrimaryLightColor
                              : CustomColors.mainColor,
                        ),
                      )
                    : null,
              ),
              onSubmitted: (data) {
                onSubmit(data);
              },
            )),
      ],
    );
  }
}

class CustomSearchFieldWidgetWithIcon extends StatelessWidget {
  CustomSearchFieldWidgetWithIcon(
      {this.textEditingController,
      this.animationController,
      this.customIcon,
      this.hint,
      Key key})
      : super(key: key);

  final TextEditingController textEditingController;
  final AnimationController animationController;
  final IconData customIcon;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        child: TextField(
          inputFormatters: [
            NoLeadingSpaceFormatter(),
          ],
          maxLines: 1,
          controller: textEditingController,
          style: Theme.of(context).textTheme.bodyText2.copyWith(
              color: CustomColors.textTertiaryColor,
              fontFamily: Config.heeboRegular,
              fontSize: Dimens.space16.sp,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.normal),
          textAlign: TextAlign.left,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(
              Dimens.space15.w,
              Dimens.space15.h,
              Dimens.space15.w,
              Dimens.space15.h,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: CustomColors.callInactiveColor,
                  width: Dimens.space1.w),
              borderRadius: BorderRadius.all(Radius.circular(Dimens.space10.r)),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: CustomColors.callInactiveColor,
                  width: Dimens.space1.w),
              borderRadius: BorderRadius.all(Radius.circular(Dimens.space10.r)),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: CustomColors.callInactiveColor,
                  width: Dimens.space1.w),
              borderRadius: BorderRadius.all(Radius.circular(Dimens.space10.r)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: CustomColors.callInactiveColor,
                  width: Dimens.space1.w),
              borderRadius: BorderRadius.all(Radius.circular(Dimens.space10.r)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: CustomColors.callInactiveColor,
                  width: Dimens.space1.w),
              borderRadius: BorderRadius.all(Radius.circular(Dimens.space10.r)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: CustomColors.callInactiveColor,
                  width: Dimens.space1.w),
              borderRadius: BorderRadius.all(Radius.circular(Dimens.space10.r)),
            ),
            filled: true,
            fillColor: CustomColors.baseLightColor,
            hintText: hint,
            hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                color: CustomColors.textTertiaryColor,
                fontFamily: Config.heeboRegular,
                fontSize: Dimens.space16.sp,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal),
            prefixIcon: Icon(
              customIcon,
              size: Dimens.space20.w,
              color: CustomColors.textPrimaryLightColor,
            ),
          ),
        ));
  }
}
