import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/utils/HexToColor.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/holder/request_holder/ColorHolder.dart';

/*
 * *
 *  * Created by Kedar on 7/13/21 1:08 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/13/21 1:08 PM
 *
 */

class ColorPickerDialog extends StatefulWidget
{
  final Function(ColorHolder) onColorPicked;

  ColorPickerDialog({Key key, this.onColorPicked}) : super(key: key);

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog>
{
  ColorHolder selectedColor;

  List<ColorHolder> listColorHolder = [];
  @override
  void initState()
  {
    listColorHolder.addAll(Config.supportColorHolder);
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
      alignment: Alignment.topCenter,
      height: Dimens.space240.h,
      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              height: Dimens.space52.h,
              margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space10.h, Dimens.space20.w, Dimens.space0.h),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      alignment: Alignment.centerLeft,
                      child: Text(
                          Utils.getString("pickAColor"),
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontFamily: Config.manropeBold,
                            color: CustomColors.textPrimaryColor,
                            fontSize: Dimens.space18.sp,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                          )
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.centerRight,
                      ),
                      onPressed: ()
                      {
                        Navigator.of(context).pop();
                        if (selectedColor != null)
                        {
                          widget.onColorPicked(selectedColor);
                        }
                      },
                      child: Text(
                        Utils.getString('done'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(
                            color: CustomColors.loadingCircleColor,
                            fontFamily: Config.manropeSemiBold,
                            fontSize: Dimens.space15.sp,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal
                        ),
                      ),
                    ),
                  ),
                ],
              )
          ),
          Divider(
            color: CustomColors.mainDividerColor,
            height: Dimens.space1.h,
            thickness: Dimens.space1.h,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space24.h, Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              child: StaggeredGridView.countBuilder(
                crossAxisCount: 8,
                itemCount: listColorHolder.length,
                itemBuilder: (BuildContext context, int index)
                {
                  return Container(
                    height: Dimens.space44.w,
                    width: Dimens.space44.w,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: listColorHolder[index].isChecked?HexToColor(listColorHolder[index].backgroundColorCode):CustomColors.transparent,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(
                          Radius.circular(Dimens.space16)
                      ),
                      border: Border.all(
                        color: listColorHolder[index].isChecked?HexToColor(listColorHolder[index].colorCode):CustomColors.transparent,
                        width: Dimens.space1.w,
                      )
                    ),
                    child: InkWell(
                      onTap: () async
                      {
                        for(int i=0;i<listColorHolder.length;i++)
                        {
                          listColorHolder[i].isChecked=false;
                        }
                        listColorHolder[index].isChecked = !listColorHolder[index].isChecked;
                        if(listColorHolder[index].isChecked)
                        {
                          selectedColor = listColorHolder[index];
                        }
                        else
                        {
                          selectedColor = null;
                        }
                        setState(() {});
                      },
                      child: RoundedNetworkImageHolder(
                        width: Dimens.space24,
                        height: Dimens.space24,
                        boxFit: BoxFit.cover,
                        iconUrl: Icons.check_circle,
                        containerAlignment: Alignment.center,
                        iconColor: listColorHolder[index].isChecked?CustomColors.white:HexToColor(listColorHolder[index].colorCode),
                        iconSize: Dimens.space11,
                        boxDecorationColor: HexToColor(listColorHolder[index].colorCode),
                        outerCorner: Dimens.space10,
                        innerCorner: Dimens.space10,
                        imageUrl: "",
                      ),
                    )
                  );
                },
                staggeredTileBuilder: (int index) => StaggeredTile.count(1, 1),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
