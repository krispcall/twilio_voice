import 'package:flutter/cupertino.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/viewobject/model/login/LoginWorkspace.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkspaceListItemView extends StatelessWidget
{
  const WorkspaceListItemView({
    Key key,
    @required this.workspace,
    @required this.animationController,
    @required this.animation,
    @required this.index,
    @required this.count,
    @required this.defaultWorkspace,
    @required this.onWorkspaceTap,
  }) : super(key: key);

  final LoginWorkspace workspace;
  final AnimationController animationController;
  final Animation<double> animation;
  final int index;
  final int count;
  final String defaultWorkspace;
  final Function onWorkspaceTap;

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 100 * (1.0 - animation.value), 0.0),
              child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space14.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      RoundedNetworkImageTextHolder(
                        width: Dimens.space48,
                        height: Dimens.space48,
                        text: workspace.title.isEmpty ? "" : workspace.title[0],
                        textColor: CustomColors.mainColor,
                        fontWeight: FontWeight.normal,
                        fontFamily: Config.heeboExtraBold,
                        fontSize: Dimens.space24,
                        boxFit: BoxFit.cover,
                        iconSize: Dimens.space30,
                        boxDecorationColor: index == (count - 1)
                            ? CustomColors.transparent
                            : CustomColors.white,
                        corner: Dimens.space15,
                        imageUrl: workspace.photo,
                        onTap: () {
                          onWorkspaceTap();
                        },
                      ),
                      workspace.id == defaultWorkspace
                          ? Container(
                              width: Dimens.space46.w,
                              height: Dimens.space46.w,
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              decoration: BoxDecoration(
                                  color: CustomColors.transparent,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Dimens.space15.r)),
                                  border: Border.all(
                                    color: CustomColors.mainColor,
                                    width: Dimens.space2,
                                  )),
                            )
                          : Container(),
                    ],
                  )),
            ),
          );
        });
  }
}
