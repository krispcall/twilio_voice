import 'package:flutter/material.dart';
import 'package:voice_example/pages/call_accept_page.dart';
import 'package:voice_example/pages/notification_examples_page.dart';

const String PAGE_HOME = '/';
const String PAGE_INCOMING_CALL='/incoming_call';

Map<String, WidgetBuilder> materialRoutes = {
  PAGE_HOME: (context) => NotificationExamplesPage(),
  PAGE_INCOMING_CALL: (context) => CallAcceptPage(ModalRoute.of(context).settings.arguments,true),
};
