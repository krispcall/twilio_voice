import 'package:flutter/material.dart';
import 'package:voice_example/pages/CallIncoming.dart';
import 'package:voice_example/pages/CallOutgoing.dart';
import 'package:voice_example/pages/notification_examples_page.dart';

import 'Constants/Constants.dart';

Map<String, WidgetBuilder> materialRoutes = {
  Constants.PAGE_HOME: (context) => NotificationExamplesPage(),
  Constants.PAGE_CALL_INCOMING: (context) => CallIncoming(ModalRoute.of(context).settings.arguments,true),
  Constants.PAGE_CALL_OUTGOING: (context) => CallOutgoing(ModalRoute.of(context).settings.arguments),
};
