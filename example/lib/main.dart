
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:voice/twiliovoice.dart';

const String accessToken="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImN0eSI6InR3aWxpby1mcGE7dj0xIn0.eyJqdGkiOiJTSzdjNTI3ZGNmNTY3ZjM1NTUyYWZjNWI1YWFmYzk2YTYzLTE2MTA2MTI1OTMiLCJncmFudHMiOnsidm9pY2UiOnsiaW5jb21pbmciOnsiYWxsb3ciOnRydWV9LCJvdXRnb2luZyI6eyJhcHBsaWNhdGlvbl9zaWQiOiJBUGYwNDcwOTg4OGI2NThkMzVjZWVmNjQ0MWQ0ODQ5MGU2In0sInB1c2hfY3JlZGVudGlhbF9zaWQiOiJDUmQ0MTdjYWM0MGUyYjlmNTczNTg3MmQxMjQ4YWMyYTliIn0sImlkZW50aXR5Ijoiam9zaGFuIn0sImlzcyI6IlNLN2M1MjdkY2Y1NjdmMzU1NTJhZmM1YjVhYWZjOTZhNjMiLCJleHAiOjE2MTA2MTYxOTMsIm5iZiI6MTYxMDYxMjU5Mywic3ViIjoiQUMzMmQ0NmY1OWVhNjE5OWMwNGU1MmVhMTgwMGU3OTc0NyJ9.c6gEiFuIx64JMeDvQUbNyOacPPKf_hxpRy3IrWCoBww";
final VoiceClient voiceClient=VoiceClient(accessToken);


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  registerForNotifications();
  _configureNotifications();
  runApp(MyApp());
}

Future registerForNotifications() async {
  var token;
  if (Platform.isAndroid) {
    token = await FirebaseMessaging().getToken();
  }
  await voiceClient.registerForNotification(accessToken,token);
}

void _configureNotifications()
{
  if (Platform.isAndroid) {
    FirebaseMessaging().configure(
      onMessage: onMessage,
      onBackgroundMessage: onBackgroundMessage,
      onLaunch: onLaunch,
      onResume: onResume,
    );
    FlutterLocalNotificationsPlugin()
      ..initialize(
        InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        ),
      )
      ..resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>().createNotificationChannel(
        AndroidNotificationChannel(
          '0',
          'Chat',
          'Twilio Chat Channel 0',
        ),
      );
  }
}

// For example purposes, we only setup display of notifications when
// receiving a message while the app is in the background. This behaviour
// appears consistent with the behaviour demonstrated by the iOS SDK
Future<dynamic> onMessage(Map<String, dynamic> message) async {
  print('Main::onMessage => $message');
  await FlutterLocalNotificationsPlugin().show(
    0,
    message['data']['channel_title'],
    message['data']['twi_from']+" is calling.",
    NotificationDetails(
      android: AndroidNotificationDetails(
        '0',
        'Chat',
        'Twilio Chat Channel 0',
        importance: Importance.high,
        priority: Priority.defaultPriority,
        showWhen: true,
        fullScreenIntent: true,
        channelShowBadge: true,
        enableLights: true,
        enableVibration: true,
        indeterminate: true,
        ongoing: true,
        playSound: true,
      ),
    ),
    payload: jsonEncode(message),
  );
}

Future<dynamic> onBackgroundMessage(Map<String, dynamic> message) async {
  print('Main::onBackgroundMessage => $message');
  await FlutterLocalNotificationsPlugin().show(
    0,
    message['data']['channel_title'],
    message['data']['twi_from']+" is calling.",
    NotificationDetails(
      android: AndroidNotificationDetails(
        '0',
        'Chat',
        'Twilio Chat Channel 0',
        importance: Importance.high,
        priority: Priority.defaultPriority,
        showWhen: true,
        fullScreenIntent: true,
        channelShowBadge: true,
        enableLights: true,
        enableVibration: true,
        indeterminate: true,
        ongoing: true,
        playSound: true,
      ),
    ),
    payload: jsonEncode(message),
  );
}

Future<dynamic> onLaunch(Map<String, dynamic> message) async {
  print('Main::onLaunch => $message');
  await FlutterLocalNotificationsPlugin().show(
    0,
    message['data']['channel_title'],
    message['data']['twi_from']+" is calling.",
    NotificationDetails(
      android: AndroidNotificationDetails(
        '0',
        'Chat',
        'Twilio Chat Channel 0',
        importance: Importance.high,
        priority: Priority.defaultPriority,
        showWhen: true,
        fullScreenIntent: true,
        channelShowBadge: true,
        enableLights: true,
        enableVibration: true,
        indeterminate: true,
        ongoing: true,
        playSound: true,
      ),
    ),
    payload: jsonEncode(message),
  );
}

Future<dynamic> onResume(Map<String, dynamic> message) async {
  print('Main::onResume => $message');
  await FlutterLocalNotificationsPlugin().show(
    0,
    message['data']['channel_title'],
    message['data']['twi_from']+" is calling.",
    NotificationDetails(
      android: AndroidNotificationDetails(
        '0',
        'Chat',
        'Twilio Chat Channel 0',
        importance: Importance.high,
        priority: Priority.defaultPriority,
        showWhen: true,
        fullScreenIntent: true,
        channelShowBadge: true,
        enableLights: true,
        enableVibration: true,
        indeterminate: true,
        ongoing: true,
        playSound: true,
      ),
    ),
    payload: jsonEncode(message),
  );
}
//#endregion

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _eventMessage="Event Unknow";
  String fcmToken="";
  TextEditingController _toController, _fromController;
  @override
  void initState() {
    super.initState();
    _toController = TextEditingController();
    _fromController = TextEditingController(text: "support_agent_+61480031300");
  }


  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Twilio Voice Example'),
        ),
        body: SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Running on: $_platformVersion\n'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Running on: $_eventMessage\n'),
                    ),
                    TextFormField(
                      controller: _fromController,
                      decoration: InputDecoration(
                          labelText: 'Sender Identifier or Phone Number'),
                    ),
                    Divider(),
                    TextFormField(
                      controller: _toController,
                      decoration: InputDecoration(
                          labelText: 'Receiver Identifier or Phone Number'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                      child: Text("Make Call"),
                      onPressed: () async
                      {
                        await voiceClient.makeCall(
                          accessToken,
                          _fromController.text,
                          _toController.text,
                          "joshan",
                        );
                      },
                    ),
                    RaisedButton(
                      child: Text("Make Call"),
                      onPressed: () async {
                        // TwilioVoice.receiveCalls(_fromController.text);
                      },
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}