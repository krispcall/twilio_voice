import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/routes.dart';
import 'package:voice_example/utils/media_player_central.dart';
import 'dart:async';
import 'models/media_model.dart';


String payload="";
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

// For example purposes, we only setup display of notifications when
// receiving a message while the app is in the background. This behaviour
// appears consistent with the behaviour demonstrated by the iOS SDK
//#endregion
class App extends StatefulWidget {

  static final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  static String name = 'Push Notifications - Example App';
  static Color mainColor = Color(0xFF9D50DD);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

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