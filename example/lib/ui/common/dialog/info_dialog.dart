import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:flutter/material.dart';

class InfoDialog extends StatefulWidget
{
  const InfoDialog({this.message});
  final String message;
  @override
  _InfoDialogState createState() => _InfoDialogState();
}



class _InfoDialogState extends State<InfoDialog>
{
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

  final InfoDialog widget;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              height: 60,
              width: double.infinity,
              padding: const EdgeInsets.all(Dimens.space8),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  color: CustomColors.mainColor),
              child: Row(
                children: <Widget>[
                  const SizedBox(width: Dimens.space4),
                  Icon(
                    Icons.info,
                    color: CustomColors.white,
                  ),
                  const SizedBox(width: Dimens.space4),
                  Text(
                    Utils.getString('info'),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: CustomColors.white,
                    ),
                  ),
                ],
              )),
          const SizedBox(height: Dimens.space20),
          Container(
            padding: const EdgeInsets.only(
                left: Dimens.space16,
                right: Dimens.space16,
                top: Dimens.space8,
                bottom: Dimens.space8),
            child: Text(
              widget.message,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          const SizedBox(height: Dimens.space20),
          Divider(
            color: CustomColors.black,
            height: 1,
          ),
          MaterialButton(
            height: 50,
            minWidth: double.infinity,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              Utils.getString('ok').toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: CustomColors.mainColor),
            ),
          )
        ],
      ),
    );
  }
}
