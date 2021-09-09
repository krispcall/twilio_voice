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

class BlockContactDialog extends StatefulWidget {
  final Function onTap;
  final String userName;
  final bool block;

  const BlockContactDialog(
      {Key key,
        this.onTap,
        this.userName,
        this.block,
      })
      : super(key: key);
  @override
  BlockContactDialogState createState() =>
      BlockContactDialogState();
}

class BlockContactDialogState extends State<BlockContactDialog>
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
                      assetUrl: "assets/images/block_contact.png",
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
                  SizedBox(height: Dimens.space20.h),
                  Text(
                    widget.block? Utils.getString("unblock"): Utils.getString('block'),
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
                      widget.block? Utils.getString("youWillReceivePhoneCalls"): Utils.getString('youWillNotReceivePhoneCalls'),
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
                        Navigator.of(context).pop({"data": true, "action": "block"});
                      },
                      child: Container(
                        child: Text(
                          widget.block? Utils.getString("unblockContact"): Utils.getString('blockContact'),
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
