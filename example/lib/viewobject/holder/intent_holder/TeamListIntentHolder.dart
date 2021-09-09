import 'package:flutter/material.dart';

class TeamListIntentHolder {
  const TeamListIntentHolder({
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
  });

  final Function onIncomingTap;
  final Function onOutgoingTap;
}
