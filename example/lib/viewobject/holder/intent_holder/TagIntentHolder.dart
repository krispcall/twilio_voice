import 'package:flutter/cupertino.dart';
import 'package:voice_example/viewobject/model/allContact/Tags.dart';

class TagsIntentHolder {
  TagsIntentHolder({
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
    this.onCallBack,
    this.tag,
  });
  Tags tag;
  final Function onCallBack;
  final Function onIncomingTap;
  final Function onOutgoingTap;
}
