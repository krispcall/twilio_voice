import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/ui/common/ButtonWidget.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatefulWidget
{
  const ErrorDialog({
    this.message
  });
  final String message;

  @override
  ErrorDialogState createState() => ErrorDialogState();
}

class ErrorDialogState extends State<ErrorDialog> {
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

  final ErrorDialog widget;

  @override
  Widget build(BuildContext context)
  {
    return Dialog(
      backgroundColor: Colors.white,
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
                  iconUrl: Icons.error_outline_rounded,
                  iconColor: CustomColors.callDeclineColor,
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
                      Utils.getString("error"),
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(color: CustomColors.textPrimaryColor, fontFamily: "Manrope", fontWeight: FontWeight.w800 ),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space20, Dimens.space0, Dimens.space20, Dimens.space10),
                padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                child: Text(
                  widget.message,
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
                            child:new Container(
                            )
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(Dimens.space20, Dimens.space0, Dimens.space20, Dimens.space0),
                          padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                          child: RoundedButtonWidget(
                            width: Dimens.space80,
                            height: Dimens.space36,
                            buttonBackgroundColor: CustomColors.callDeclineColor,
                            buttonTextColor: CustomColors.white,
                            buttonBorderColor: CustomColors.callDeclineColor,
                            buttonFontSize: Dimens.space16,
                            fontStyle: FontStyle.normal,
                            buttonFontWeight: FontWeight.normal,
                            buttonFontFamily: Config.heeboRegular,
                            corner: Dimens.space10,
                            buttonText: Utils.getString('ok').toUpperCase(),
                            onPressed: () async
                            {
                              Navigator.pop(context);
                            },
                          ),
                        )
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
