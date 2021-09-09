import 'package:flutter/material.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/repository/MessageDetailsRepository.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatTextFieldWidgetWithIcon extends StatefulWidget
{
  const ChatTextFieldWidgetWithIcon({
    Key key,
    @required this.onSendTap,
    @required this.textEditingController,
    @required this.animationController,
    @required this.isSendIconVisible,
    @required this.onChanged,
    @required this.listConversationEdge,
    this.customIcon,
    this.onFileSelectTap
  }) : super(key: key);

  final Function onSendTap;
  final Function onFileSelectTap;
  final TextEditingController textEditingController;
  final AnimationController animationController;
  final IconData customIcon;
  final bool isSendIconVisible;
  final Function(String) onChanged;
  final List<MessageDetailsObjectWithType> listConversationEdge;

  @override
  _ChatTextFieldWidgetWithIconState createState() => _ChatTextFieldWidgetWithIconState();
}

class _ChatTextFieldWidgetWithIconState extends State<ChatTextFieldWidgetWithIcon>
{
  final FocusNode focusNode = FocusNode();

  @override
  void initState()
  {
    super.initState();
    focusNode.addListener(onFocusChange);
  }

  @override
  void dispose()
  {
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return widget.listConversationEdge != null && widget.listConversationEdge.isNotEmpty?Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space8.h, Dimens.space0.w, Dimens.space8.h),
      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: Dimens.space40.w,
            height: Dimens.space40.w,
            margin: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
            child: RoundedNetworkImageHolder(
              width: Dimens.space44,
              height: Dimens.space44,
              boxFit: BoxFit.cover,
              containerAlignment: Alignment.center,
              iconUrl: CustomIcon.icon_attachment,
              iconColor: CustomColors.textPrimaryLightColor,
              iconSize: Dimens.space16,
              boxDecorationColor: CustomColors.baseLightColor,
              outerCorner: Dimens.space300,
              innerCorner: Dimens.space300,
              imageUrl: "",
              onTap: widget.onFileSelectTap,
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(Dimens.space12.w, Dimens.space0.h, Dimens.space12.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              alignment: Alignment.center,
              child: TextField(
                maxLines: 1,
                controller: widget.textEditingController,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: CustomColors.textPrimaryLightColor,
                    fontFamily: Config.heeboRegular,
                    fontSize: Dimens.space14.sp,
                    fontWeight: FontWeight.normal),
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.center,
                onChanged: (value)
                {
                  widget.onChanged(value);
                },
                decoration: InputDecoration(
                  contentPadding:EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent, width: Dimens.space0.w),
                    borderRadius: BorderRadius.all(Radius.circular(Dimens.space12.w)),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent, width: Dimens.space0.w),
                    borderRadius: BorderRadius.all(Radius.circular(Dimens.space12.w)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent, width: Dimens.space0.w),
                    borderRadius: BorderRadius.all(Radius.circular(Dimens.space12.w)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent, width: Dimens.space0.w),
                    borderRadius: BorderRadius.all(Radius.circular(Dimens.space12.w)),
                  ),
                  enabledBorder:OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent, width: Dimens.space0.w),
                    borderRadius: BorderRadius.all(Radius.circular(Dimens.space12.w)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent, width: Dimens.space0.w),
                    borderRadius: BorderRadius.all(Radius.circular(Dimens.space12.w)),
                  ),
                  filled: true,
                  fillColor: CustomColors.baseLightColor,
                  hintText: Utils.getString("typeYourMessage"),
                  hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: CustomColors.textPrimaryLightColor,
                      fontFamily: Config.heeboRegular,
                      fontSize: Dimens.space14.sp,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),
          ),
          Offstage(
            offstage: !widget.isSendIconVisible,
            child: Container(
              width: Dimens.space40.w,
              height: Dimens.space40.w,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              child: RoundedNetworkImageHolder(
                width: Dimens.space44,
                height: Dimens.space44,
                boxFit: BoxFit.cover,
                containerAlignment: Alignment.center,
                iconUrl: CustomIcon.icon_message_send,
                iconColor: CustomColors.white,
                iconSize: Dimens.space16,
                boxDecorationColor: CustomColors.mainColor,
                outerCorner: Dimens.space300,
                innerCorner: Dimens.space300,
                imageUrl: "",
                onTap: widget.onSendTap,
              ),
            ),
          )
        ],
      ),
    ): Container();
  }

  void onFocusChange()
  {
    if (focusNode.hasFocus)
    {
      // Hide sticker when keyboard appear
      setState(() {
        // isShowSticker = false;
      });
    }
  }
}
