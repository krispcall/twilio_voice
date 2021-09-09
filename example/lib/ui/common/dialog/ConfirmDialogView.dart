import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/ui/common/ButtonWidget.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:flutter/material.dart';

class ConfirmDialogView extends StatefulWidget
{
  const ConfirmDialogView({
    Key key,
    this.description,
    this.leftButtonText,
    this.rightButtonText,
    this.onAgreeTap
  }): super(key: key);

  final String description, leftButtonText, rightButtonText;
  final Function onAgreeTap;

  @override
  ConfirmDialogViewState createState() => ConfirmDialogViewState();
}

class ConfirmDialogViewState extends State<ConfirmDialogView>
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

  final ConfirmDialogView widget;

  @override
  Widget build(BuildContext context)
  {
    return Dialog(
      backgroundColor: CustomColors.white,
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
                  iconUrl: Icons.help_outline,
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
                      Utils.getString('confirm'),
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
                              buttonFontWeight: FontWeight.normal,
                              buttonFontFamily: Config.heeboRegular,
                              titleTextAlign: TextAlign.center,
                              hasShadow: false,
                              buttonBorderColor: CustomColors.mainColor,
                              buttonBackgroundColor: CustomColors.transparent,
                              buttonTextColor: CustomColors.textTertiaryColor,
                              corner: Dimens.space10,
                              buttonText: widget.leftButtonText,
                              buttonFontSize: Dimens.space16,
                              fontStyle: FontStyle.normal,
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
                                buttonFontWeight: FontWeight.normal,
                                buttonFontFamily: Config.heeboRegular,
                                titleTextAlign: TextAlign.center,
                                hasShadow: false,
                                buttonBorderColor: CustomColors.mainColor,
                                buttonTextColor: CustomColors.white,
                                corner: Dimens.space10,
                                buttonText: widget.rightButtonText,
                                fontStyle: FontStyle.normal,
                                buttonFontSize: Dimens.space16,
                                onPressed: widget.onAgreeTap,
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
