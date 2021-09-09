import 'package:voice_example/api/ApiService.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/utils/Utils.dart';

class DeleteContactDialog extends StatefulWidget {
  final Function onTap;

  const DeleteContactDialog(
      {Key key,
        this.onTap,
      })
      : super(key: key);
  @override
  DeleteContactDialogState createState() =>
      DeleteContactDialogState();
}

class DeleteContactDialogState extends State<DeleteContactDialog>
    with SingleTickerProviderStateMixin {
  ApiService apiService = ApiService();
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
    return Padding(
      padding: EdgeInsets.fromLTRB(
          Dimens.space16.w, Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
      child: Container(
        height: Dimens.space348.h,
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: Dimens.space246.h,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimens.space16.r)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: Dimens.space54,
                    alignment: Alignment.center,
                    child: Container(
                      width: Dimens.space54,
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(
                          Dimens.space0.w,
                          Dimens.space0.h,
                          Dimens.space0.w,
                          Dimens.space2.h),
                      padding: EdgeInsets.fromLTRB(
                          Dimens.space0.w,
                          Dimens.space0.h,
                          Dimens.space0.w,
                          Dimens.space0.h),
                      child: RoundedAssetImageHolder(
                        assetUrl: "assets/images/delete_contact.png",
                        width: Dimens.space54,
                        height: Dimens.space54,
                        boxFit: BoxFit.cover,
                        iconUrl: CustomIcon.icon_profile,
                        iconColor: CustomColors.callInactiveColor,
                        iconSize: Dimens.space50,
                        boxDecorationColor: CustomColors.mainDividerColor,
                        outerCorner: Dimens.space50,
                        innerCorner: Dimens.space0,
                        containerAlignment: Alignment.bottomCenter,
                      ),
                    ),

                  ),
                  SizedBox(height: Dimens.space20.h),
                  Text(
                    Utils.getString('delete'),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: CustomColors.textPrimaryColor,
                      fontFamily: Config.manropeRegular,
                      fontSize: Dimens.space20.sp,
                      letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: Dimens.space10.h),
                  Padding(
                    padding: EdgeInsets.fromLTRB(Dimens.space27.w,
                        Dimens.space0.h, Dimens.space27.w, Dimens.space8.h),
                    child: Text(
                      "${Utils.getString('onceYouDeleteYourContact')}",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: CustomColors.textPrimaryColor,
                        fontFamily: Config.manropeRegular,
                        fontSize: Dimens.space15.sp,
                        letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(Dimens.space21.w,
                        Dimens.space0.h, Dimens.space21.w, Dimens.space0.h),
                    child: InkWell(
                      onTap: ()  {
                        // widget.onTap();
                        Navigator.of(context).pop({"data": true, "action": "delete"});
                      },
                      child: Container(
                        child: Text(
                          Utils.getString('deleteContact'),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: CustomColors.textPrimaryErrorColor,
                            fontFamily: Config.manropeRegular,
                            fontSize: Dimens.space15.sp,
                            letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: Dimens.space16.h),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: Dimens.space48.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Dimens.space16.r)),
                child: Center(
                  child: Text(
                    Utils.getString('cancel'),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: CustomColors.textSenaryColor,
                      fontFamily: Config.manropeBold,
                      fontSize: Dimens.space15.sp,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: Dimens.space32.h),
          ],
        ),
      ),
    );
  }
}
