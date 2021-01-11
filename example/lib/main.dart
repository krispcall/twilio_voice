
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:voice/voice.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _eventMessage;
  String fcmToken="";
  TextEditingController _toController, _fromController;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _toController = TextEditingController();
    _fromController = TextEditingController(text: "support_agent_+61480031300");
    initPlatformState();
    setUpNotification();
    Voice.phoneCallEventSubscription
        .listen(_onEvent, onError: _onError);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Voice.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void _onEvent(Object event) {
    setState(() {
      _eventMessage =
      "Battery status: ${event == 'charging' ? '' : 'dis'}charging.";
    });
  }

  void _onError(Object error) {
    setState(() {
      _eventMessage = 'Battery status: unknown.';
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      onPressed: () async {
                        Voice.makeCall(
                            from: _fromController.text,
                            to: _toController.text,
                            accessTokenUrl: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImN0eSI6InR3aWxpby1mcGE7dj0xIn0.eyJqdGkiOiJTS2RhNjUxZDliNjEyNDA0NGJjNjVmMDU3NGEwZjMzMDdhLTE2MTAwOTgzODQiLCJncmFudHMiOnsidm9pY2UiOnsiaW5jb21pbmciOnsiYWxsb3ciOnRydWV9LCJvdXRnb2luZyI6eyJhcHBsaWNhdGlvbl9zaWQiOiJBUDA3MzhlN2IxOTA1M2NjODNjMmNhZjNkODgzNzY1YWFiIn0sInB1c2hfY3JlZGVudGlhbF9zaWQiOiJDUmQ0MTdjYWM0MGUyYjlmNTczNTg3MmQxMjQ4YWMyYTliIn0sImlkZW50aXR5Ijoic3VwcG9ydF9hZ2VudF8rNjE0ODAwMzEzMDAifSwiaXNzIjoiU0tkYTY1MWQ5YjYxMjQwNDRiYzY1ZjA1NzRhMGYzMzA3YSIsImV4cCI6MTYxMDEwMTk4NCwibmJmIjoxNjEwMDk4Mzg0LCJzdWIiOiJBQzMyZDQ2ZjU5ZWE2MTk5YzA0ZTUyZWExODAwZTc5NzQ3In0.fecbI5FxMxQhVb6NjxCDzMKDToUT4g0lrH50CCfUBH8",
                            toDisplayName: "Joshan Tandukar",
                            fcmToken:"fWVX4TNjTCSARUwVHqdRdP:APA91bFGp76cEzucyEQeiUnLnPdptQo1XuiZMTG7uYgm0y9so49Em4dVgXftgNMxMsnhwTepFIJ2P2j2HsCBUNuFCum0PKnHUv3Q-oM-5QBjfNVQsiv2Z24I6cBUQQPm4G-6Josw61dU");
                      },
                    ),
                    RaisedButton(
                      child: Text("Make Call"),
                      onPressed: () async {
                        Voice.receiveCalls(_fromController.text);
                        },
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }

  void setUpNotification() {
    _firebaseMessaging.setAutoInitEnabled(true);
    _firebaseMessaging.subscribeToTopic("PhoneCallEvent");
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {});
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        fcmToken=token;
        print("FCM Token "+token);
      });
    });
  }

  Future onSelectNotification(String payload) async {

  }
}