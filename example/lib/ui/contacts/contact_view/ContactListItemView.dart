import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/model/allContact/AllContactEdges.dart';

class ContactListItemView extends StatelessWidget
{
  const ContactListItemView({
    Key key,
    @required this.contactEdges,
    @required this.onTap,
    @required this.animationController,
    @required this.offStage,
    @required this.animation,
  }) : super(key: key);

  final AllContactEdges contactEdges;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;
  final bool offStage;

  @override
  Widget build(BuildContext context)
  {
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child)
        {
          return FadeTransition(
            opacity: animation,
            child: Transform(
              transform: Matrix4.translationValues(0.0, 100 * (1.0 - animation.value), 0.0),
              child: Container(
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space10.h, Dimens.space20.w, Dimens.space10.h),
                child: TextButton(
                  onPressed: onTap,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.center,
                  ),
                  child: ContactListItemWidget(
                    contactEdges: contactEdges,
                    offStage: offStage,
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class ContactListItemWidget extends StatelessWidget
{
  const ContactListItemWidget({
    Key key,
    @required this.contactEdges,
    @required this.offStage,
  }) : super(key: key);

  final AllContactEdges contactEdges;
  final bool offStage;

  @override
  Widget build(BuildContext context)
  {
    if (contactEdges != null)
    {
      return Container(
        margin:  EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              alignment: Alignment.center,
              child: RoundedNetworkImageHolder(
                width: Dimens.space36,
                height: Dimens.space36,
                boxFit: BoxFit.cover,
                iconUrl: CustomIcon.icon_profile,
                containerAlignment: Alignment.bottomCenter,
                iconColor: CustomColors.callInactiveColor,
                iconSize: Dimens.space30,
                boxDecorationColor: CustomColors.mainDividerColor,
                outerCorner: Dimens.space14,
                innerCorner: Dimens.space14,
                imageUrl: contactEdges.contactNode.profilePicture!=null && contactEdges.contactNode.profilePicture.isNotEmpty?contactEdges.contactNode.profilePicture:"",
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            contactEdges.contactNode.name != null && contactEdges.contactNode.name.isNotEmpty ? contactEdges.contactNode.name : Utils.getString("unknown"),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                              color: contactEdges.contactNode.blocked!=null && contactEdges.contactNode.blocked?CustomColors.textSenaryColor.withOpacity(0.4): CustomColors.textSenaryColor,
                              fontFamily: Config.manropeSemiBold,
                              fontSize: Dimens.space16.sp,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.centerLeft,
                        child: Offstage(
                          offstage: offStage,
                          child: RoundedNetworkSvgHolder(
                            containerWidth: Dimens.space14,
                            containerHeight: Dimens.space14,
                            boxFit: BoxFit.contain,
                            imageWidth: Dimens.space14,
                            imageHeight: Dimens.space14,
                            imageUrl: contactEdges.contactNode.flagUrl!=null?Config.countryLogoUrl+contactEdges.contactNode.flagUrl:"",
                            outerCorner: Dimens.space0,
                            innerCorner: Dimens.space0,
                            iconUrl: CustomIcon.icon_person,
                            iconColor: CustomColors.mainColor,
                            iconSize: Dimens.space14,
                            boxDecorationColor: CustomColors.transparent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.centerLeft,
                    child: Offstage(
                      offstage: offStage,
                      child: Text(
                        contactEdges.contactNode.number != null ? contactEdges.contactNode.number : Utils.getString("unknown"),
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(
                          color: CustomColors.textPrimaryLightColor,
                          fontFamily: Config.manropeSemiBold,
                          fontSize: Dimens.space14.sp,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    else
    {
      return Container();
    }
  }
}
