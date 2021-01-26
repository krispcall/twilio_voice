
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/string/Strings.dart';
import 'package:voice_example/view/splash/SplashView.dart';
import 'AppInjector.dart';
import 'colors/colors.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  AppInjector.inject();
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'incoming',
          channelName: 'incoming',
          channelDescription: 'incoming',
          importance: NotificationImportance.Max,
          defaultColor: Colors.red,
          ledColor: Colors.green,
          playSound: true,
          vibrationPattern: highVibrationPattern,
          locked: true,
        ),
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white
        ),
        NotificationChannel(
            channelKey: 'badge_channel',
            channelName: 'Badge indicator notifications',
            channelDescription: 'Notification channel to activate badge indicator',
            channelShowBadge: true,
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.yellow
        ),
        NotificationChannel(
            icon: 'resource://drawable/schedule_icon',
            channelKey: 'schedule',
            channelName: 'Scheduled Notifications',
            channelDescription: 'Notifications with schedule time',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white
        ),
        NotificationChannel(
            channelKey: 'updated_channel',
            channelName: 'Channel to update',
            channelDescription: 'Notifications with not updated channel',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white
        ),
        NotificationChannel(
            channelKey: 'low_intensity',
            channelName: 'Low intensity notifications',
            channelDescription: 'Notification channel for notifications with low intensity',
            defaultColor: Colors.green,
            ledColor: Colors.green,
            vibrationPattern: lowVibrationPattern
        ),
        NotificationChannel(
            channelKey: 'medium_intensity',
            channelName: 'Medium intensity notifications',
            channelDescription: 'Notification channel for notifications with medium intensity',
            defaultColor: Colors.yellow,
            ledColor: Colors.yellow,
            vibrationPattern: mediumVibrationPattern
        ),
        NotificationChannel(
            channelKey: 'high_intensity',
            channelName: 'High intensity notifications',
            channelDescription: 'Notification channel for notifications with high intensity',
            defaultColor: Colors.red,
            ledColor: Colors.red,
            vibrationPattern: highVibrationPattern
        ),
        NotificationChannel(
            icon: 'resource://drawable/res_power_ranger_thunder',
            channelKey: "custom_sound",
            channelName: "Custom sound notifications",
            channelDescription: "Notifications with custom sound",
            playSound: true,
            soundSource: 'resource://raw/res_morph_power_rangers',
            defaultColor: Colors.red,
            ledColor: Colors.red,
            vibrationPattern: lowVibrationPattern
        ),
        NotificationChannel(
            channelKey: "silenced",
            channelName: "Silenced notifications",
            channelDescription: "The most quiet notifications",
            playSound: false,
            enableVibration: false,
            enableLights: false
        ),
        NotificationChannel(
          icon: 'resource://drawable/res_media_icon',
          channelKey: 'media_player',
          channelName: 'Media player controller',
          channelDescription: 'Media player controller',
          defaultPrivacy: NotificationPrivacy.Public,
          enableVibration: false,
          enableLights: false,
          playSound: false,
          locked: true,
        ),
        NotificationChannel(
            channelKey: 'big_picture',
            channelName: 'Big pictures',
            channelDescription: 'Notifications with big and beautiful images',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Color(0xFF9D50DD),
            vibrationPattern: lowVibrationPattern
        ),
        NotificationChannel(
            channelKey: 'big_text',
            channelName: 'Big text notifications',
            channelDescription: 'Notifications with a expandable body text',
            defaultColor: Colors.blueGrey,
            ledColor: Colors.blueGrey,
            vibrationPattern: lowVibrationPattern
        ),
        NotificationChannel(
            channelKey: 'inbox',
            channelName: 'Inbox notifications',
            channelDescription: 'Notifications with inbox layout',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Color(0xFF9D50DD),
            vibrationPattern: mediumVibrationPattern
        ),
        NotificationChannel(
          channelKey: 'scheduled',
          channelName: 'Scheduled notifications',
          channelDescription: 'Notifications with schedule functionality',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Color(0xFF9D50DD),
          vibrationPattern: lowVibrationPattern,
          importance: NotificationImportance.High,
        ),
        NotificationChannel(
            icon: 'resource://drawable/res_download_icon',
            channelKey: 'progress_bar',
            channelName: 'Progress bar notifications',
            channelDescription: 'Notifications with a progress bar layout',
            defaultColor: Colors.deepPurple,
            ledColor: Colors.deepPurple,
            vibrationPattern: lowVibrationPattern,
            onlyAlertOnce: true
        ),
        NotificationChannel(
            channelKey: 'grouped',
            channelName: 'Grouped notifications',
            channelDescription: 'Notifications with group functionality',
            groupKey: 'grouped',
            setAsGroupSummary: true,
            defaultColor: Colors.lightGreen,
            ledColor: Colors.lightGreen,
            vibrationPattern: lowVibrationPattern,
            importance: NotificationImportance.High
        )
      ]
  );
  runApp(App());
}

// For example purposes, we only setup display of notifications when
// receiving a message while the app is in the background. This behaviour
// appears consistent with the behaviour demonstrated by the iOS SDK
//#endregion
class App extends StatefulWidget
{
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState()
  {
    super.initState();
  }

  @override
  void dispose()
  {
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: Strings.appName,
      home: SplashView(),
      color: CustomColor.themeRed,
      debugShowCheckedModeBanner: false,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1,),
          child: child,
        );
      },
    );
  }
}