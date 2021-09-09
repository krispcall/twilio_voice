/*
 * *
 *  * Created by Kedar on 7/16/21 1:55 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/16/21 1:55 PM
 *  
 */
import 'package:flutter/material.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/viewobject/model/workspace/workspace_detail/WorkspaceChannel.dart';

import '../CustomImageHolder.dart';

class ChannelSelectionDialog extends StatelessWidget {
  final String clientName;
  final String mutedDate;
  final Function onUmMuteTap;
  final List<WorkspaceChannel> channelList;
  final Function onChannelTap;

  ChannelSelectionDialog(
      {Key key,
      this.clientName,
      this.mutedDate,
      this.onUmMuteTap,
      this.channelList,
      this.onChannelTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0, Dimens.space0.w, Dimens.space0.h),
      child: Column(
        children: <Widget>[
          Container(
              width: Dimens.space80.w,
              height: Dimens.space6.h,
              margin: EdgeInsets.fromLTRB(
                  Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space6.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(Dimens.space33),
                ),
                color: CustomColors.bottomAppBarColor,
              )),
          Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space30.h,
                    Dimens.space0, Dimens.space0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(Dimens.space20.r),topRight: Radius.circular(Dimens.space20.r))),

                child: new Column(
                  children: [
                    Divider(
                      color: CustomColors.mainDividerColor,
                      height: Dimens.space1,
                      thickness: Dimens.space1,
                    ),
                    MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: new ListView.builder(
                            shrinkWrap: true,
                            itemCount: channelList.length,
                            itemBuilder: (context, index) {
                              return ChannelListItemView(
                                channel: channelList[index],
                                onTap: (){
                                  Navigator.of(context).pop();
                                  onChannelTap(channelList[index]);
                                },
                              );
                            }))
                  ],
                ),
              )),
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   alignment: FractionalOffset.center,
          //   margin: new EdgeInsets.fromLTRB(Dimens.space0, Dimens.space20.h,
          //       Dimens.space0, Dimens.space20.h),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.all(new Radius.circular(Dimens.space14.r)),
          //   ),
          //   child: InkWell(
          //       onTap: () {
          //         Navigator.of(context).pop();
          //       },
          //       child: new Container(
          //         height: Dimens.space50.h,
          //         alignment: FractionalOffset.center,
          //         child: new Text(
          //           Utils.getString("cancel"),
          //           style: Theme.of(context).textTheme.bodyText2.copyWith(
          //               color: CustomColors.textPrimaryColor,
          //               fontStyle: FontStyle.normal,
          //               fontWeight: FontWeight.normal,
          //               fontFamily: Config.heeboBlack,
          //               fontSize:Dimens.space15.sp),
          //         ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}

class ChannelListItemView extends StatelessWidget {
  final Function onTap;
  final WorkspaceChannel channel;

  ChannelListItemView({Key key, this.onTap, this.channel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: CustomColors.mainDividerColor,
            ),
          ),
          color: Colors.white,
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space12.h,
                Dimens.space20.w, Dimens.space12.h),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: Dimens.space48.w,
                height: Dimens.space48.w,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space48,
                  height: Dimens.space48,
                  boxFit: BoxFit.cover,
                  containerAlignment: Alignment.bottomCenter,
                  iconUrl: CustomIcon.icon_profile,
                  iconColor: CustomColors.callInactiveColor,
                  iconSize: Dimens.space40,
                  boxDecorationColor: CustomColors.mainDividerColor,
                  outerCorner: Dimens.space25,
                  innerCorner: Dimens.space25,
                  imageUrl: "${Config.countryLogoUrl}${channel.countryLogo}",
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space12.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  alignment: Alignment.centerLeft,
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
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            child: Text("${channel.name}",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: CustomColors.textPrimaryColor,
                                      fontFamily: Config.manropeBold,
                                      fontSize: Dimens.space16.sp,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                    )),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space6.h, Dimens.space0.w, Dimens.space0.h),
                        child: Text(
                          '${channel.number}',
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: CustomColors.textPrimaryLightColor,
                              fontFamily: Config.heeboMedium,
                              fontSize: Dimens.space13.sp,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          onPressed: onTap,
        ));
  }
}
