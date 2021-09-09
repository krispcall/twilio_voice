import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:flutter/material.dart';

class PsDropdownBaseWidget extends StatelessWidget {
  const PsDropdownBaseWidget(
      {Key key, @required this.title, @required this.onTap, this.selectedText})
      : super(key: key);

  final String title;
  final String selectedText;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              left: Dimens.space12,
              top: Dimens.space4,
              right: Dimens.space12),


          child: Row(
            children: <Widget>[
              Text(
                title,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: Dimens.space44,
            margin: const EdgeInsets.all(Dimens.space12),
            decoration: BoxDecoration(
              color: CustomColors.backgroundColor,
              borderRadius: BorderRadius.circular(Dimens.space4),
              border: Border.all(color: CustomColors.mainDividerColor),
            ),
            child: Container(
              margin: const EdgeInsets.all(Dimens.space12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      child: Text(
                        selectedText == ''
                            ? Utils.getString('notSet')
                            : selectedText,
                        overflow: TextOverflow.ellipsis,
                        style: selectedText == ''
                            ? Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(color: CustomColors.textPrimaryLightColor)
                            : Theme.of(context).textTheme.bodyText2
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
