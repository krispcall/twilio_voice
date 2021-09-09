import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/viewobject/model/sound/Sound.dart';

class SoundSelectionDialog extends StatefulWidget
{
  const SoundSelectionDialog(
      {
        Key key,
        this.soundList,
        this.selectedSound,
        this.onSelectSound
      }) : super(key: key);
  final List<Sound> soundList;
  final Function(Sound) onSelectSound;
  final Sound selectedSound;

  @override
  SoundSelectionDialogState createState() => SoundSelectionDialogState();
}

class SoundSelectionDialogState extends State<SoundSelectionDialog>
{
  @override
  void initState()
  {
    super.initState();
  }
  @override
  Widget build(BuildContext context)
  {
    return Container(
      height: Dimens.space160,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children:
        [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space20),
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemExtent: Dimens.space52,
              itemCount: widget.soundList.length,
              itemBuilder: (context, position) {
                return Container(
                  height: Dimens.space52,
                  margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: CustomColors.mainDividerColor,
                      ),
                    ),
                  ),
                  child:FlatButton(
                    padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space10, Dimens.space0, Dimens.space10),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    color: widget.selectedSound==widget.soundList[position]?CustomColors.baseLightColor:CustomColors.transparent,
                    onPressed: ()
                    {
                      widget.onSelectSound(widget.soundList[position]);
                      Navigator.of(context).pop();
                    },
                    child:Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(Dimens.space10, Dimens.space0, Dimens.space10, Dimens.space0),
                          alignment: Alignment.center,
                          child : PlainAssetImageHolder(
                            assetUrl: "",
                            width: Dimens.space20,
                            height: Dimens.space20,
                            assetWidth: Dimens.space20,
                            assetHeight: Dimens.space20,
                            boxFit: BoxFit.contain,
                            iconUrl: Icons.music_note_outlined,
                            iconSize: Dimens.space20,
                            iconColor: CustomColors.mainColor,
                            boxDecorationColor: CustomColors.transparent,
                            outerCorner: Dimens.space0,
                            innerCorner: Dimens.space0,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.soundList[position].name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(fontWeight: FontWeight.normal)
                                  .copyWith(color: widget.selectedSound==widget.soundList[position]?CustomColors.textPrimaryColor:CustomColors.textPrimaryLightColor),
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
