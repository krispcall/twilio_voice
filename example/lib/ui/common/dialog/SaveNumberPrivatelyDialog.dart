
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/ui/common/ButtonWidget.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/utils/Utils.dart';

class SaveNumberPrivatelyDialog extends StatefulWidget
{
  @override
  SaveNumberPrivatelyDialogState createState() => SaveNumberPrivatelyDialogState();
}

class SaveNumberPrivatelyDialogState extends State<SaveNumberPrivatelyDialog>
{
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  @override
  void initState()
  {
    super.initState();
  }

  @override
  void dispose()
  {
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return Container(
      alignment: Alignment.center,
      height: Dimens.space328.h,
      color: CustomColors.transparent,
      margin: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimens.space16.r)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space28.h, Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                  child: PlainAssetImageHolder(
                    assetUrl: "assets/images/private_number.png",
                    width: Dimens.space58,
                    height: Dimens.space58,
                    boxFit: BoxFit.contain,
                    assetWidth: Dimens.space58,
                    assetHeight: Dimens.space58,
                    iconUrl: CustomIcon.icon_person,
                    iconSize: Dimens.space58,
                    iconColor: CustomColors.mainColor,
                    boxDecorationColor: CustomColors.transparent,
                    outerCorner: Dimens.space0,
                    innerCorner: Dimens.space0,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space28.h, Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    Utils.getString("saveNumberPrivately"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: CustomColors.textPrimaryColor,
                      fontFamily: Config.manropeBold,
                      fontSize: Dimens.space20.sp,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space21.w, Dimens.space10.h, Dimens.space21.w, Dimens.space21.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    Utils.getString("numbersSavedPrivatelyCannotBeAccessed"),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: CustomColors.textTertiaryColor,
                      fontFamily: Config.heeboRegular,
                      fontSize: Dimens.space15.sp,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space16.h, Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            child: RoundedButtonWidget(
              width: MediaQuery.of(context).size.width,
              height: Dimens.space54,
              titleTextAlign: TextAlign.center,
              buttonBackgroundColor: CustomColors.white,
              buttonBorderColor: CustomColors.white,
              buttonTextColor: CustomColors.textPrimaryColor,
              corner: Dimens.space12,
              buttonFontSize: Dimens.space16,
              buttonFontFamily: Config.manropeSemiBold,
              fontStyle: FontStyle.normal,
              buttonFontWeight: FontWeight.normal,
              buttonText: Utils.getString('close'),
              onPressed:()
              {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}





