import 'package:flutter/material.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundRectangularWidget extends StatelessWidget {

  final Widget child;
  final  double height;
  final  double  width;
  final Color color;
  final Function onTap;

  RoundRectangularWidget({Key key, this.child, this.height, this.width, this.color, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
      width: width.w,
      height: height.h,
      margin: new EdgeInsets.symmetric(horizontal: Dimens.space6.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimens.space10.w),
          topRight: Radius.circular(Dimens.space10.w),
          bottomLeft: Radius.circular(Dimens.space10.w),
          bottomRight: Radius.circular(Dimens.space10.w),
        ),
        color: color,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: new BorderRadius.all(new Radius.circular(Dimens.space10.w)),
        child:  InkWell(
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}
