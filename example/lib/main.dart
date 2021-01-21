
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voice/twiliovoice.dart';
import 'package:voice_example/routes.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
String accessToken="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImN0eSI6InR3aWxpby1mcGE7dj0xIn0.eyJqdGkiOiJTSzdjNTI3ZGNmNTY3ZjM1NTUyYWZjNWI1YWFmYzk2YTYzLTE2MTEyMTg5OTYiLCJncmFudHMiOnsidm9pY2UiOnsiaW5jb21pbmciOnsiYWxsb3ciOnRydWV9LCJvdXRnb2luZyI6eyJhcHBsaWNhdGlvbl9zaWQiOiJBUGYwNDcwOTg4OGI2NThkMzVjZWVmNjQ0MWQ0ODQ5MGU2In0sInB1c2hfY3JlZGVudGlhbF9zaWQiOiJDUmQ0MTdjYWM0MGUyYjlmNTczNTg3MmQxMjQ4YWMyYTliIn0sImlkZW50aXR5Ijoiam9zaGFuIn0sImlzcyI6IlNLN2M1MjdkY2Y1NjdmMzU1NTJhZmM1YjVhYWZjOTZhNjMiLCJleHAiOjE2MTEyMzMzOTYsIm5iZiI6MTYxMTIxODk5Niwic3ViIjoiQUMzMmQ0NmY1OWVhNjE5OWMwNGU1MmVhMTgwMGU3OTc0NyJ9.4CwkYMnrdrwPuNkvu7X1WehWlZ3SMt07XTB_7h5b0-I";
VoiceClient voiceClient=VoiceClient(accessToken);


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _configureNotifications();
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
  voiceClient.registerForNotification(accessToken, await FirebaseMessaging().getToken());
  print("FCM "+await FirebaseMessaging().getToken());
  runApp(App());
}

// For example purposes, we only setup display of notifications when
// receiving a message while the app is in the background. This behaviour
// appears consistent with the behaviour demonstrated by the iOS SDK
//#endregion
class App extends StatefulWidget
{

  static final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  static String name = 'Push Notifications - Example App';
  static Color mainColor = Color(0xFF9D50DD);

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
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      navigatorKey: App.navKey,
      title: App.name,
      color: App.mainColor,
      initialRoute: PAGE_HOME,
      //onGenerateRoute: generateRoute,
      routes: materialRoutes,
      builder: (context, child) =>
          MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child),
      theme: ThemeData(

        brightness: Brightness.light,

        primaryColor:   App.mainColor,
        accentColor:    Colors.blueGrey,
        primarySwatch:  Colors.blueGrey,
        canvasColor:    Colors.white,
        focusColor:     Colors.blueAccent,
        disabledColor:  Colors.grey,

        backgroundColor: Colors.blueGrey.shade400,

        appBarTheme: AppBarTheme(
            brightness: Brightness.dark,
            color: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(
              color: App.mainColor,
            ),
            textTheme: TextTheme(
              headline6: TextStyle(color: App.mainColor, fontSize: 18),
            )
        ),

        fontFamily: 'Robot',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 64.0, height: 1.5, fontWeight: FontWeight.w500),
          headline2: TextStyle(fontSize: 52.0, height: 1.5, fontWeight: FontWeight.w500),
          headline3: TextStyle(fontSize: 48.0, height: 1.5, fontWeight: FontWeight.w500),
          headline4: TextStyle(fontSize: 32.0, height: 1.5, fontWeight: FontWeight.w500),
          headline5: TextStyle(fontSize: 28.0, height: 1.5, fontWeight: FontWeight.w500),
          headline6: TextStyle(fontSize: 22.0, height: 1.5, fontWeight: FontWeight.w500),
          subtitle1: TextStyle(fontSize: 18.0, height: 1.5, color: Colors.black54),
          subtitle2: TextStyle(fontSize: 12.0, height: 1.5, color: Colors.black54),
          button:    TextStyle(fontSize: 16.0, height: 1.5, color: Colors.black54),
          bodyText1: TextStyle(fontSize: 16.0, height: 1.5),
          bodyText2: TextStyle(fontSize: 16.0, height: 1.5),
        ),

        buttonTheme: ButtonThemeData(
          buttonColor: Colors.grey.shade200,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          textTheme: ButtonTextTheme.accent,
        ),
      ),
    );
  }
}

void _configureNotifications() async
{
  _firebaseMessaging.setAutoInitEnabled(true);
  _firebaseMessaging.subscribeToTopic("com.flutter.twilio.voice_example");
  _firebaseMessaging.configure(
    onMessage: onMessage,
    onBackgroundMessage: onBackgroundMessage,
    onLaunch: onLaunch,
    onResume: onResume,
  );
}

Future<dynamic> onMessage(Map<String, dynamic> message) async
{
  print('Main::onMessage => $message');
  voiceClient.handleMessage(message);
  showIncomingCallNotification(3,NotificationImportance.Max,message);
}

Future<dynamic> onBackgroundMessage(Map<String, dynamic> message) async {
  print('Main::onBackgroundMessage => $message');
  voiceClient.handleMessage(message);
  showBackgroundCallNotification(3,NotificationImportance.Max,message);
}

Future<dynamic> onLaunch(Map<String, dynamic> message) async {
  print('Main::onLaunch => $message');
}

Future<dynamic> onResume(Map<String, dynamic> message) async {
  print('Main::onResume => $message');
}

Future<void> showIncomingCallNotification(int id,NotificationImportance importance,Map<String,dynamic> message) async
{
  String importanceKey = importance.toString().toLowerCase().split('.').last;
  String channelKey = 'importance_'+importanceKey+'_channel';
  String title = 'KrispCall';
  String body=message['data']['twi_from']+" is calling.";

  await AwesomeNotifications().setChannel(
    NotificationChannel(
      channelKey: channelKey,
      channelName: title,
      channelDescription: body,
      importance: importance,
      defaultColor: Colors.red,
      ledColor: Colors.green,
      playSound: true,
      vibrationPattern: highVibrationPattern,
      enableVibration: true,
    ),
  );

  await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: channelKey,
        title: title,
        body: body,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'decline',
          label: 'Decline',
          buttonType: ActionButtonType.DisabledAction,
          autoCancel: true,
          enabled: true,
        ),
        NotificationActionButton(
          key: 'accept',
          label: 'Accept',
          buttonType: ActionButtonType.Default,
          autoCancel: true,
          enabled: true,
        ),
      ]);
}

Future<dynamic> showBackgroundCallNotification(int id,NotificationImportance importance,Map<String,dynamic> message) async
{
  String importanceKey = importance.toString().toLowerCase().split('.').last;
  String channelKey = 'importance_'+importanceKey+'_channel';
  String title = 'KrispCall';
  String body=message['data']['twi_from']+" is calling.";
  await AwesomeNotifications().setChannel(
    NotificationChannel(
      channelKey: channelKey,
      channelName: title,
      channelDescription: body,
      importance: importance,
      defaultColor: Colors.red,
      ledColor: Colors.green,
      playSound: true,
      vibrationPattern: highVibrationPattern,
      enableVibration: true,
    ),
  );

  await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: channelKey,
        title: title,
        body: body,
      ),
  );
}
