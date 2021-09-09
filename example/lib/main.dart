import 'dart:async';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';

// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stetho/flutter_stetho.dart';
import 'package:voice_example/config/Router.dart' as router;
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Constants.dart';
import 'package:voice_example/db/common/ps_shared_preferences.dart';
import 'package:voice_example/provider/ps_provider_dependencies.dart';
import 'package:voice_example/viewobject/common/Language.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:voice/twiliovoice.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:no_context_navigation/no_context_navigation.dart';

VoiceClient voiceClient = VoiceClient("abc");
WebSocketChannel channel;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await FlutterLibphonenumber().init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp();
  GestureBinding.instance.resamplingEnabled = false;
  AndroidAlarmManager.initialize();
  if (kDebugMode) {
    Stetho.initialize();
  }

  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: Const.NOTIFICATION_CHANNEL_CALL_INCOMING,
        channelName: Const.NOTIFICATION_CHANNEL_CALL_INCOMING,
        channelDescription: Const.NOTIFICATION_CHANNEL_CALL_INCOMING,
        importance: NotificationImportance.Max,
        defaultColor: Colors.purple,
        ledColor: Colors.purple,
        playSound: false,
        locked: true,
        channelShowBadge: true,
        enableLights: true,
        groupAlertBehavior: GroupAlertBehavior.All,
        defaultPrivacy: NotificationPrivacy.Private,
        onlyAlertOnce: false,
        enableVibration: true,
        vibrationPattern: highVibrationPattern),
    NotificationChannel(
        channelKey: Const.NOTIFICATION_SMS_CHANNEL,
        channelName: Const.NOTIFICATION_SMS_CHANNEL,
        channelDescription: Const.NOTIFICATION_SMS_CHANNEL,
        importance: NotificationImportance.Max,
        defaultColor: Colors.purple,
        ledColor: Colors.purple,
        playSound: false,
        locked: true,
        channelShowBadge: true,
        enableLights: true,
        groupAlertBehavior: GroupAlertBehavior.All,
        defaultPrivacy: NotificationPrivacy.Private,
        onlyAlertOnce: false,
        enableVibration: true,
        vibrationPattern: highVibrationPattern),
    NotificationChannel(
      channelKey: Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_OUTGOING,
      channelName: Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_OUTGOING,
      channelDescription: Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_OUTGOING,
      importance: NotificationImportance.Max,
      defaultColor: Colors.purple,
      ledColor: Colors.purple,
      playSound: false,
      locked: true,
      channelShowBadge: true,
      enableLights: false,
      groupAlertBehavior: GroupAlertBehavior.All,
      defaultPrivacy: NotificationPrivacy.Private,
      onlyAlertOnce: false,
      enableVibration: false,
    ),
    NotificationChannel(
      channelKey: Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_INCOMING,
      channelName: Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_INCOMING,
      channelDescription: Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_INCOMING,
      importance: NotificationImportance.Max,
      defaultColor: Colors.purple,
      ledColor: Colors.purple,
      playSound: false,
      locked: true,
      channelShowBadge: true,
      enableLights: false,
      groupAlertBehavior: GroupAlertBehavior.All,
      defaultPrivacy: NotificationPrivacy.Private,
      onlyAlertOnce: false,
      enableVibration: false,
    )
  ]);

  // initializePusher();

  // runZonedGuarded(() {
  runApp(EasyLocalization(
    // data: data,
    // assetLoader: CsvAssetLoader(),
    path: 'assets/langs',
    supportedLocales: getSupportedLanguages(),
    child: EasyDynamicThemeWidget(
      child: PSApp(),
    ),
  ));
  // }, FirebaseCrashlytics.instance.recordError);
}

onDone() {
}

List<Locale> getSupportedLanguages() {
  final List<Locale> localeList = <Locale>[];
  for (final Language lang in Config.psSupportedLanguageList) {
    localeList.add(Locale(lang.languageCode, lang.countryCode));
  }
  return localeList;
}

class PSApp extends StatefulWidget {
  @override
  _PSAppState createState() => _PSAppState();
}

class _PSAppState extends State<PSApp> {
  Completer<ThemeData> themeDataCompleter;
  PsSharedPreferences psSharedPreferences;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CustomColors.loadColor(context);
    return ScreenUtilInit(
        designSize: Size(414, 896),
        builder: () => MultiProvider(
                providers: <SingleChildWidget>[
                  ...providers,
                ],
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  builder: (BuildContext context, Widget child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaleFactor: 1,
                      ), //set desired text scale factor here
                      child: child,
                    );
                  },
                  title: 'KrispCall',
                  theme: ThemeData.light(),
                  darkTheme: ThemeData.dark(),
                  themeMode: EasyDynamicTheme.of(context).themeMode,
                  navigatorKey: NavigationService.navigationKey,
                  initialRoute: '/',
                  routes: router.routes,
                  localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    EasyLocalization.of(context).delegate,
                  ],
                  supportedLocales: EasyLocalization.of(context).supportedLocales,
                  locale: EasyLocalization.of(context).locale,
                )
        )
    );
  }
}
