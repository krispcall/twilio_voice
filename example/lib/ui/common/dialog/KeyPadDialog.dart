import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/utils/Utils.dart';

class KeyPadDialog extends StatefulWidget {
  const KeyPadDialog(
      {
        Key key,
        @required this.onKeyTap,
      }) : super(key: key);

  final Function(String) onKeyTap;

  @override
  KeyPadDialogState createState() => KeyPadDialogState();

}



class KeyPadDialogState extends State<KeyPadDialog>
{
  @override
  Widget build(BuildContext context)
  {
    return Container(
      height: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children:
        [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: Dimens.space60,
                height: Dimens.space60,
                margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space10, Dimens.space0, Dimens.space10),
                child: TextButton(
                    style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                      backgroundColor: CustomColors.bottomAppBarColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimens.space100)
                      ),
                    ),
                    onPressed: ()
                    {
                      widget.onKeyTap("1");
                    },
                    child: Text(
                      Utils.getString("1"),
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith()
                          .copyWith(color: CustomColors.textSecondaryColor, fontFamily: "Manrope", fontWeight: FontWeight.w900),
                    )
                ),
              ),
              Container(
                width: Dimens.space60,
                height: Dimens.space60,
                margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space10, Dimens.space0, Dimens.space10),
                child: TextButton(
                    style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                      backgroundColor: CustomColors.bottomAppBarColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimens.space100)
                      ),
                    ),
                    onPressed: ()
                    {
                      widget.onKeyTap("2");
                    },
                    child: Text(
                      Utils.getString("2"),
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith()
                          .copyWith(color: CustomColors.textSecondaryColor, fontFamily: "Manrope", fontWeight: FontWeight.w900),
                    )
                ),
              ),
              Container(
                width: Dimens.space60,
                height: Dimens.space60,
                margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space10, Dimens.space0, Dimens.space10),
                child:TextButton(
                    style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                      backgroundColor: CustomColors.bottomAppBarColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimens.space100)
                      ),
                    ),
                    onPressed: ()
                    {
                      widget.onKeyTap("3");
                    },
                    child: Text(
                      Utils.getString("3"),
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith()
                          .copyWith(color: CustomColors.textSecondaryColor, fontFamily: "Manrope", fontWeight: FontWeight.w900),
                    )
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: Dimens.space60,
                height: Dimens.space60,
                margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space10, Dimens.space0, Dimens.space10),
                child: TextButton(
                    style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                      backgroundColor: CustomColors.bottomAppBarColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimens.space100)
                      ),
                    ),
                    onPressed: ()
                    {
                      widget.onKeyTap("4");
                    },
                    child: Text(
                      Utils.getString("4"),
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith()
                          .copyWith(color: CustomColors.textSecondaryColor, fontFamily: "Manrope", fontWeight: FontWeight.w900),
                    )
                ),
              ),
              Container(
                width: Dimens.space60,
                height: Dimens.space60,
                margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space10, Dimens.space0, Dimens.space10),
                child: TextButton(
                    style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                      backgroundColor: CustomColors.bottomAppBarColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimens.space100)
                      ),
                    ),
                    onPressed: ()
                    {
                      widget.onKeyTap("5");
                    },
                    child: Text(
                      Utils.getString("5"),
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith()
                          .copyWith(color: CustomColors.textSecondaryColor, fontFamily: "Manrope", fontWeight: FontWeight.w900),
                    )
                ),
              ),
              Container(
                width: Dimens.space60,
                height: Dimens.space60,
                margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space10, Dimens.space0, Dimens.space10),
                child: TextButton(
                    style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                      backgroundColor: CustomColors.bottomAppBarColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimens.space100)
                      ),
                    ),
                    onPressed: ()
                    {
                      widget.onKeyTap("6");
                    },
                    child: Text(
                      Utils.getString("6"),
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith()
                          .copyWith(color: CustomColors.textSecondaryColor, fontFamily: "Manrope", fontWeight: FontWeight.w900),
                    )
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: Dimens.space60,
                height: Dimens.space60,
                margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space10, Dimens.space0, Dimens.space10),
                child: TextButton(
                    style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                      backgroundColor: CustomColors.bottomAppBarColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimens.space100)
                      ),
                    ),
                    onPressed: ()
                    {
                      widget.onKeyTap("7");
                    },
                    child: Text(
                      Utils.getString("7"),
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith()
                          .copyWith(color: CustomColors.textSecondaryColor, fontFamily: "Manrope", fontWeight: FontWeight.w900),
                    )
                ),
              ),
              Container(
                width: Dimens.space60,
                height: Dimens.space60,
                margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space10, Dimens.space0, Dimens.space10),
                child:TextButton(
                    style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                      backgroundColor: CustomColors.bottomAppBarColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimens.space100)
                      ),
                    ),
                    onPressed: ()
                    {
                      widget.onKeyTap("8");
                    },
                    child: Text(
                      Utils.getString("8"),
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith()
                          .copyWith(color: CustomColors.textSecondaryColor, fontFamily: "Manrope", fontWeight: FontWeight.w900),
                    )
                ),
              ),
              Container(
                width: Dimens.space60,
                height: Dimens.space60,
                margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space10, Dimens.space0, Dimens.space10),
                child: TextButton(
                    style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                      backgroundColor: CustomColors.bottomAppBarColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimens.space100)
                      ),
                    ),
                    onPressed: ()
                    {
                      widget.onKeyTap("9");
                    },
                    child: Text(
                      Utils.getString("9"),
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith()
                          .copyWith(color: CustomColors.textSecondaryColor, fontFamily: "Manrope", fontWeight: FontWeight.w900),
                    )
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: Dimens.space60,
                height: Dimens.space60,
                margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space10, Dimens.space0, Dimens.space10),
                child: TextButton(
                    style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                      backgroundColor: CustomColors.bottomAppBarColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimens.space100)
                      ),
                    ),
                    onPressed: ()
                    {
                      widget.onKeyTap("*");
                    },
                    child: Text(
                      Utils.getString("*"),
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith()
                          .copyWith(color: CustomColors.textSecondaryColor, fontFamily: "Manrope", fontWeight: FontWeight.w900),
                    )
                ),
              ),
              Container(
                width: Dimens.space60,
                height: Dimens.space60,
                margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space10, Dimens.space0, Dimens.space10),
                child: TextButton(
                    style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                      backgroundColor: CustomColors.bottomAppBarColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimens.space100)
                      ),
                    ),
                    onPressed: ()
                    {
                      widget.onKeyTap("0");
                    },
                    child: Text(
                      Utils.getString("0"),
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith()
                          .copyWith(color: CustomColors.textSecondaryColor, fontFamily: "Manrope", fontWeight: FontWeight.w900),
                    )
                ),
              ),
              Container(
                width: 60,
                height: 60,
                margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space10, Dimens.space0, Dimens.space10),
                child: TextButton(
                    style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                      backgroundColor: CustomColors.bottomAppBarColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimens.space100)
                      ),
                    ),
                    onPressed: ()
                    {
                      widget.onKeyTap("#");
                    },
                    child: Text(
                      Utils.getString("#"),
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith()
                          .copyWith(color: CustomColors.textSecondaryColor, fontFamily: "Manrope", fontWeight: FontWeight.w900),
                    )
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
