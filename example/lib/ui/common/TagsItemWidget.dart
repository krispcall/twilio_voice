import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/utils/HexToColor.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/model/allContact/Tags.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TagsItemWidget extends StatelessWidget
{
  final Tags tags;
  final fromContact;

  TagsItemWidget({Key key, this.tags, this.fromContact = true}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Container(
      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(Dimens.space8.w, Dimens.space0.h, Dimens.space8.w, Dimens.space0.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(Dimens.space5.r)),
        color: CustomColors.bottomAppBarColor,
      ),
      height: Dimens.space24.h,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              child: Icon(
                CustomIcon.icon_circle,
                color: HexToColor(tags.colorCode),
                size: Dimens.space12.w,
              )
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space8.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
            child: Text(
              tags.title,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(
                  color:CustomColors.textSenaryColor,
                  fontFamily: Config.heeboMedium,
                  fontSize:  fromContact?Dimens.space12.sp:Dimens.space14.sp,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal
              ),
            ),
          ),
          Offstage(
            offstage: fromContact,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space8.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              child: Text(
                tags.count!=null?tags.count.toString():Utils.getString("0"),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(
                    color: CustomColors.textPrimaryColor,
                    fontFamily: Config.heeboMedium,
                    fontSize: Dimens.space12.sp,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal
                ),
              ),
            )
          ),
        ],
      ),
    );
  }

}