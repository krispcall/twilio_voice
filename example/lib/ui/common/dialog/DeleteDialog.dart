import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/ui/common/ButtonWidget.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/utils/Utils.dart';

class DeleteDialog extends StatefulWidget {
  const DeleteDialog(
      {
        Key key,
        @required this.title,
        @required this.description,
        @required this.icon,
        @required this.iconColor,
        @required this.deleteSize,
        @required this.cancelText,
        @required this.deleteText,
        @required this.onDeleteTap,
        @required this.deleteSizeContainerColor,
        @required this.deleteSizeTextColor,
      }) : super(key: key);



  final String title, description, cancelText, deleteText;
  final IconData icon;
  final Function onDeleteTap;
  final int deleteSize;
  final Color deleteSizeContainerColor;
  final Color deleteSizeTextColor;
  final Color iconColor;

  @override
  DeleteDialogState createState() => DeleteDialogState();

}

class DeleteDialogState extends State<DeleteDialog>
{
  @override
  Widget build(BuildContext context)
  {
    return NewDialog(widget: widget);
  }
}

class NewDialog extends StatelessWidget
{
  const NewDialog({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final DeleteDialog widget;

  @override
  Widget build(BuildContext context)
  {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(Dimens.space10),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space20, Dimens.space20, Dimens.space20, Dimens.space10),
                padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space24,
                  height: Dimens.space24,
                  boxFit:BoxFit.cover,
                  iconUrl: widget.icon,
                  iconColor: widget.iconColor,
                  iconSize: Dimens.space20,
                  outerCorner: Dimens.space16,
                  innerCorner: Dimens.space16,
                  boxDecorationColor: CustomColors.transparent,
                  imageUrl: "",
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space20, Dimens.space0, Dimens.space0, Dimens.space0),
                    padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                    child: Text(
                      widget.title,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(color: CustomColors.textPrimaryColor, fontFamily: "Manrope", fontWeight: FontWeight.w800 ),
                    ),
                  ),
                  Visibility(
                    visible: widget.deleteSize==0?false:true,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(Dimens.space10, Dimens.space0, Dimens.space10, Dimens.space0),
                      padding: EdgeInsets.fromLTRB(Dimens.space10, Dimens.space0, Dimens.space10, Dimens.space0),
                      decoration: BoxDecoration(
                        color: widget.deleteSizeContainerColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(
                            Radius.circular(Dimens.space16)
                        ),
                      ),
                      child: Text(
                        widget.deleteSize.toString()+" "+Utils.getString("selected"),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: widget.deleteSizeTextColor, fontFamily: "Manrope", fontWeight: FontWeight.w600 ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space20, Dimens.space0, Dimens.space20, Dimens.space10),
                padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                child: Text(
                  widget.description,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: CustomColors.textTertiaryColor, fontFamily: Config.heeboRegular, fontWeight: FontWeight.normal ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space20),
                padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child:Container(
                          margin: EdgeInsets.fromLTRB(Dimens.space20, Dimens.space0, Dimens.space10, Dimens.space0),
                          padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                          child: RoundedButtonWidget(
                            width: double.infinity,
                            height: Dimens.space36,
                            buttonBackgroundColor: CustomColors.transparent,
                            buttonTextColor: CustomColors.textTertiaryColor,
                            buttonBorderColor: CustomColors.transparent,
                            corner: Dimens.space10,
                            buttonText: widget.cancelText,
                            buttonFontSize: Dimens.space16,
                            fontStyle: FontStyle.normal,
                            buttonFontWeight: FontWeight.normal,
                            buttonFontFamily: Config.heeboRegular,
                            onPressed: () async
                            {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child:Container(
                          margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space20, Dimens.space0),
                          padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                          child: RoundedButtonWidget(
                            width: double.infinity,
                            height: Dimens.space36,
                            buttonBackgroundColor: CustomColors.callDeclineColor,
                            buttonBorderColor: CustomColors.callDeclineColor,
                            buttonFontFamily: Config.heeboRegular,
                            buttonFontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                            buttonFontSize: Dimens.space16,
                            buttonTextColor: CustomColors.white,
                            corner: Dimens.space10,
                            buttonText: widget.deleteText,
                            onPressed: () async
                            {
                              Navigator.of(context).pop();
                              widget.onDeleteTap();
                            },
                          ),
                        )
                      ),
                    ]
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
