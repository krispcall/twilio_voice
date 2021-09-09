import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/model/allContact/Tags.dart';
/*Todo Need to provide the clientId and Client Name*/


class TagsVerticalItemView extends StatelessWidget {
  const TagsVerticalItemView({
    Key key,
    @required this.tag,
    @required this.animationController,
    @required this.animation, this.onTap,
  }) : super(key: key);

  final Tags tag;
  final AnimationController animationController;
  final Animation<double> animation;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    if (tag != null) {
      return
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            alignment: Alignment.center,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.fromLTRB(
                Dimens.space0.w,
                Dimens.space0.h,
                Dimens.space0.w,
                Dimens.space0.h),
          ),
          child:  Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space12.h,
                Dimens.space20.w, Dimens.space12.h),
            margin: EdgeInsets.fromLTRB(
                Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
            decoration: BoxDecoration(
              border: Border(
                bottom:
                BorderSide(color: CustomColors.mainDividerColor, width: 0.8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                        Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                        Dimens.space0.w, Dimens.space0.h),
                    child: RoundedAssetImageHolder(
                      width: Dimens.space36,
                      height: Dimens.space36,
                      boxFit: BoxFit.contain,
                      iconUrl: CustomIcon.icon_tag,
                      iconColor: CustomColors.white,
                      iconSize: Dimens.space18,
                      boxDecorationColor: Utils.hexToColor(tag.colorCode),
                      outerCorner: Dimens.space20,
                      innerCorner: Dimens.space20,
                      containerAlignment: Alignment.center,
                      assetUrl: "",
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h,
                          Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                          Dimens.space0.w, Dimens.space0.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tag.title,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: CustomColors.textSecondaryColor,
                                fontFamily: Config.manropeBold,
                                fontSize: Dimens.space14.sp,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '${tag.count} Users',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: CustomColors.textPrimaryLightColor,
                                fontFamily: Config.manropeSemiBold,
                                fontSize: Dimens.space13.sp,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      )),
                ),
                Icon(
                  CustomIcon.icon_arrow_right,
                  size: Dimens.space24.w,
                  color: CustomColors.textQuinaryColor,
                )
              ],
            ),
          ),
        );
    } else {
      return Container();
    }
  }
}
