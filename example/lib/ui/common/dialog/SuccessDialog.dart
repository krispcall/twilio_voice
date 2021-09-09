import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/ui/common/ButtonWidget.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:flutter/material.dart';

class SuccessDialog extends StatefulWidget
{
  const SuccessDialog({@required this.message, @required this.onTap});

  final String message;
  final Function onTap;

  @override
  SuccessDialogState createState() => SuccessDialogState();
}

class SuccessDialogState extends State<SuccessDialog> {
  @override
  Widget build(BuildContext context) {
    return NewDialog(widget: widget);
  }
}

class NewDialog extends StatelessWidget {
  const NewDialog({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final SuccessDialog widget;

  @override
  Widget build(BuildContext context) {
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
                margin: EdgeInsets.fromLTRB(Dimens.space20, Dimens.space20,
                    Dimens.space20, Dimens.space10),
                padding: EdgeInsets.fromLTRB(
                    Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                child: RoundedNetworkImageHolder(
                  width: Dimens.space24,
                  height: Dimens.space24,
                  boxFit: BoxFit.cover,
                  iconUrl: Icons.check_circle,
                  iconColor: CustomColors.callAcceptColor,
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
                    margin: EdgeInsets.fromLTRB(Dimens.space20, Dimens.space0,
                        Dimens.space0, Dimens.space0),
                    padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0,
                        Dimens.space0, Dimens.space0),
                    child: Text(
                      Utils.getString('success'),
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                          color: CustomColors.textPrimaryColor,
                          fontFamily: "Manrope",
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space20, Dimens.space0,
                    Dimens.space20, Dimens.space10),
                padding: EdgeInsets.fromLTRB(
                    Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                child: Text(
                  widget.message,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: CustomColors.textTertiaryColor,
                      fontFamily: Config.heeboRegular,
                      fontWeight: FontWeight.normal),
                ),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0,
                      Dimens.space0, Dimens.space20),
                  padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0,
                      Dimens.space0, Dimens.space0),
                  child: new Container(
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    child:  Container(
                      margin: EdgeInsets.fromLTRB(Dimens.space20,
                          Dimens.space0, Dimens.space20, Dimens.space0),
                      padding: EdgeInsets.fromLTRB(Dimens.space0,
                          Dimens.space0, Dimens.space0, Dimens.space0),
                      width: 60,
                      child: RoundedButtonWidget(
                        width: double.infinity,
                        height: Dimens.space36,
                        buttonBackgroundColor: CustomColors.callAcceptColor,
                        buttonBorderColor: CustomColors.callAcceptColor,
                        buttonTextColor: CustomColors.white,
                        corner: Dimens.space10,
                        buttonText: Utils.getString('ok').toUpperCase(),
                        buttonFontFamily: Config.heeboRegular,
                        buttonFontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                        buttonFontSize: Dimens.space16,
                        onPressed: () async {
                          Navigator.of(context).pop();
                          if (widget.onTap != null) {
                            widget.onTap();
                          }
                        },
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
