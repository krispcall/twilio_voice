import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:audio_manager/audio_manager.dart';
import 'package:awesome_notifications/android_foreground_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Constants.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/db/common/ps_shared_preferences.dart';
import 'package:voice_example/viewobject/model/notification/NotificationMessage.dart';
import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Utils {
  Utils._();

  static String getString(String key, {onTap}) {
    if (key != '') {
      return tr(key) ?? '';
    } else {
      return '';
    }
  }

  static DateTime previous;

  static bool isLightMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light;
  }

  static Brightness getBrightnessForAppBar(BuildContext context) {
    if (Platform.isAndroid) {
      return Brightness.dark;
    } else {
      return Theme.of(context).brightness;
    }
  }

  static Future<bool> checkInternetConnectivity() async {
    return await InternetConnectionChecker().hasConnection;
  }

  static dynamic launchURL() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String url =
        'https://play.google.com/store/apps/details?id=${packageInfo.packageName}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static dynamic playRingTone() async {
    List<AudioInfo> list = [];
    list.add(AudioInfo("assets/audio/incoming.wav"));
    if (Platform.isAndroid) {
      AudioManager.instance.audioList = list;
      AudioManager.instance.play();
    }
  }

  static dynamic stopRingTone() async {
    if (Platform.isAndroid) {
      AudioManager.instance.stop();
      AudioManager.instance.audioList.clear();
      AudioManager.instance.release();
    }
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double getBottomNotchHeight(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  static dynamic showNotificationWithActionButtons(
      NotificationMessage notificationMessage, DateTime dateTime) async {
    String contact = "";
    if (notificationMessage.data.customParameters != null) {
      if (notificationMessage.data.customParameters.contactName != null) {
        contact = notificationMessage.data.customParameters.contactName;
      } else {
        contact = notificationMessage.data.twiFrom;
      }
    } else {
      contact = notificationMessage.data.twiFrom;
    }
    await AwesomeNotifications().setChannel(NotificationChannel(
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
        soundSource: "assets/audio/beep.mp3",
        vibrationPattern: highVibrationPattern));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: Const.NOTIFICATION_CHANNEL_ID_CALL_INCOMING,
        channelKey: Const.NOTIFICATION_CHANNEL_CALL_INCOMING,
        title: "Krispcall Audio (${dateTime.hour}:${dateTime.minute}:${dateTime.second})",
        body: contact,
        payload: notificationMessage.data.toJson(),
        locked: true,
        showWhen: true,
        createdDate: DateTime.now().toString(),
        createdSource: NotificationSource.Firebase,
        notificationLayout: NotificationLayout.Messaging,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'reject',
          label: 'Reject',
          autoCancel: true,
        ),
        NotificationActionButton(
            key: 'accept', label: 'Accept', autoCancel: false)
      ],
    );
  }

  static dynamic showCallInProgressNotificationOutgoing(
      int seconds, int minutes) async {
    await AwesomeNotifications().setChannel(
      NotificationChannel(
        channelKey: Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_OUTGOING,
        channelName: Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_OUTGOING,
        channelDescription:
            Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_OUTGOING,
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
    );
    if (Platform.isAndroid) {
      AndroidForegroundService.startForeground(
        content: NotificationContent(
          id: Const.NOTIFICATION_CHANNEL_ID_CALL_IN_PROGRESS_OUTGOING,
          channelKey: Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_OUTGOING,
          title: "Call In Progress",
          body: minutes.toString().padLeft(2, '0') +
              ":" +
              seconds.toString().padLeft(2, '0'),
          payload: {},
          locked: true,
          showWhen: true,
          createdDate: DateTime.now().toString(),
          createdSource: NotificationSource.Local,
          notificationLayout: NotificationLayout.Default,
        ),
      );
    } else {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: Const.NOTIFICATION_CHANNEL_ID_CALL_IN_PROGRESS_OUTGOING,
          channelKey: Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_OUTGOING,
          title: "Call In Progress",
          body: "Call In Progress",
          payload: {},
          locked: true,
          showWhen: true,
          createdDate: DateTime.now().toString(),
          createdSource: NotificationSource.Local,
          notificationLayout: NotificationLayout.Default,
        ),
      );
    }
  }

  static dynamic showCallInProgressNotificationIncoming(
      NotificationMessage notificationMessage, int minutes, int seconds) async {
    await AwesomeNotifications().setChannel(NotificationChannel(
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
    ));
    if (Platform.isAndroid) {
      AndroidForegroundService.startForeground(
        content: NotificationContent(
          id: Const.NOTIFICATION_CHANNEL_ID_CALL_IN_PROGRESS_INCOMING,
          channelKey: Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_INCOMING,
          title: "Call In Progress",
          body: minutes.toString().padLeft(2, '0') +
              ":" +
              seconds.toString().padLeft(2, '0'),
          payload: notificationMessage.data.toJson(),
          locked: true,
          showWhen: true,
          createdDate: DateTime.now().toString(),
          createdSource: NotificationSource.Local,
          notificationLayout: NotificationLayout.Default,
        ),
      );
    } else {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: Const.NOTIFICATION_CHANNEL_ID_CALL_IN_PROGRESS_INCOMING,
          channelKey: Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_INCOMING,
          title: "Call In Progress",
          body: "Call In Progress",
          payload: notificationMessage.data.toJson(),
          locked: true,
          showWhen: true,
          createdDate: DateTime.now().toString(),
          createdSource: NotificationSource.Local,
          notificationLayout: NotificationLayout.Default,
        ),
      );
    }
  }

  static dynamic showSmsNotification(String title, String body) async {
    DateTime dateTime = DateTime.now();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: Const.NOTIFICATION_SMS_ID,
        channelKey: Const.NOTIFICATION_SMS_CHANNEL,
        title: title +" ${dateTime.hour} ${dateTime.minute} ${dateTime.second}",
        body: body,
        payload: {'title': '$title', 'body': '$body'},
        locked: true,
        showWhen: true,
        createdDate: DateTime.now().toString(),
        createdSource: NotificationSource.Firebase,
        notificationLayout: NotificationLayout.Messaging,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'view',
          label: 'View',
          autoCancel: false,
        ),
      ],
    );
  }

  static dynamic cancelNotification() async {
    AwesomeNotifications().cancel(Const.NOTIFICATION_CHANNEL_ID_CALL_INCOMING);
    AwesomeNotifications()
        .cancel(Const.NOTIFICATION_CHANNEL_ID_CALL_IN_PROGRESS_OUTGOING);
    AwesomeNotifications()
        .cancel(Const.NOTIFICATION_CHANNEL_ID_CALL_IN_PROGRESS_INCOMING);
    AndroidForegroundService.stopForeground();
  }

  static dynamic launchAppStoreURL({String iOSAppId}) async {
    LaunchReview.launch(writeReview: false, iOSAppId: iOSAppId);
  }

  static String checkUserLoginId(ValueHolder valueHolder) {
    if (valueHolder.loginUserId == null) {
      return 'nologinuser';
    } else {
      return valueHolder.loginUserId;
    }
  }

  static Color hexToColor(String code) {
    if (code != null && code != '') {
      return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    } else {
      return CustomColors.white;
    }
  }

  static Resources<List<T>> removeDuplicateObj<T>(Resources<List<T>> resource) {
    final Map<String, String> _keyMap = HashMap<String, String>();
    final List<T> _tmpDataList = <T>[];

    if (resource != null && resource.data != null) {
      for (T obj in resource.data) {
        if (obj is Object) {
          final String _primaryKey = obj.getPrimaryKey();
          if (!_keyMap.containsKey(_primaryKey)) {
            _keyMap[_primaryKey] = _primaryKey;
            _tmpDataList.add(obj);
          }
        }
      }
    }

    resource.data = _tmpDataList;

    return resource;
  }

  static void showToastMessage(String message) async {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static String dateFullMonthYearTimeWithAt(String dateFormat, String input) {
    try {
      return DateFormat(Config.dateFullMonthYearAndTimeFormat).format(
              DateTime.parse(DateFormat(dateFormat).parse(input).toString())) +
          " " +
          Utils.getString("at") +
          " " +
          Utils.convertDateToTime(input);
    } catch (e) {
      return "";
    }
  }

  static int formDateToUnixTimeStamp(String dateformat, String input) {
    return DateFormat(dateformat).parse(input).millisecondsSinceEpoch;
  }

  static String readTimestamp(String timestamp, DateFormat inputformat) {
    if (timestamp != null) {
      try {
        var now = DateTime.now();
        var date = inputformat.parse(timestamp.split("+")[0]);
        var strToDateTime = DateTime.parse(timestamp.split("+")[0] + 'Z');
        final convertLocal = strToDateTime.toLocal();
        date = convertLocal;
        var diff = now.difference(date);
        var time = '';
        if (diff.inSeconds <= 0 ||
            diff.inSeconds > 0 && diff.inMinutes == 0 ||
            diff.inMinutes > 0 && diff.inHours == 0 ||
            diff.inHours > 0 && diff.inDays == 0) {
          time = DateFormat('hh:mm a').format(date);
        } else if (diff.inDays > 0 && diff.inDays < 7) {
          if (diff.inDays == 1) {
            time = "Yesterday";
          } else if (diff.inDays == 2) {
            time = "2d";
          } else if (diff.inDays == 3) {
            time = "3d";
          } else if (diff.inDays == 4) {
            time = "4d";
          } else if (diff.inDays == 5) {
            time = "5d";
          } else if (diff.inDays == 6) {
            time = "6d";
          } else if (diff.inDays == 7) {
            time = "1W";
          } else if (diff.inDays <= 14) {
            time = "2W";
          } else if (diff.inDays <= 21) {
            time = "3W";
          } else if (diff.inDays <= 28) {
            time = "4W";
          } else {
            var date = inputformat.parse(timestamp);
            time = new DateFormat('dd MMM').format(date);
          }
        } else {
          var date = inputformat.parse(timestamp);
          time = new DateFormat('dd MMM').format(date);
        }
        return time;
      } catch (e) {
        return "";
      }
    } else {
      return "";
    }
  }

  static String convertDateTime(String timestamp, DateFormat inputformat) {
    if (timestamp != null) {
      try {
        var now = DateTime.now();
        var date = inputformat.parse(timestamp.split("+")[0]);
        var diff = now.difference(date);
        var time = '';
        if (diff.inSeconds <= 0 ||
            diff.inSeconds > 0 && diff.inMinutes == 0 ||
            diff.inMinutes > 0 && diff.inHours == 0 ||
            diff.inHours > 0 && diff.inDays == 0) {
          time = "Today";
        } else if (diff.inDays > 0 && diff.inDays < 7) {
          if (diff.inDays == 1) {
            time = "Yesterday";
          } else {
            var date = inputformat.parse(timestamp);
            time = new DateFormat('dd MMM').format(date);
          }
        } else {
          var date = inputformat.parse(timestamp);
          time = new DateFormat('dd MMM').format(date);
        }
        return time;
      } catch (e) {
        return "";
      }
    } else {
      return "";
    }
  }

  static String formatTimeStamp(DateFormat dateFormat, String timestamp) {
    try {
      var date =
          DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) * 1000);
      return DateFormat('HH:mm a').format(date);
    } catch (e) {
      return "";
    }
  }

  static String formatTimeStampToReadableDate(
      int timeStamp, String outputFormat) {
    var date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    var formattedDate = DateFormat(outputFormat).format(date);
    return formattedDate.toString();
  }

  static dynamic playSmsTone() async {
    List<AudioInfo> list = [];
    list.clear();
    if (PsSharedPreferences.instance.shared != null) {
      if (PsSharedPreferences.instance.getSelectedSound() != null) {
        list.add(AudioInfo(PsSharedPreferences.instance.getSelectedSound()));
      } else {
        list.add(AudioInfo("assets/audio/new_sms.mp3"));
      }
      if (Platform.isAndroid) {
        AudioManager.instance.audioList = list;
        AudioManager.instance.play();
      }
      Future.delayed(const Duration(milliseconds: 1000), () {
        stopRingTone();
      });
    } else {
      PsSharedPreferences.instance.futureShared.then((value) {
        if (PsSharedPreferences.instance.getSelectedSound() != null) {
          list.add(AudioInfo(PsSharedPreferences.instance.getSelectedSound()));
        } else {
          list.add(AudioInfo("assets/audio/new_sms.mp3"));
        }
        if (Platform.isAndroid) {
          AudioManager.instance.audioList = list;
          AudioManager.instance.play();
        }
        Future.delayed(const Duration(milliseconds: 1000), () {
          stopRingTone();
        });
      });
    }
  }

  static Map<String, String> convertImageToBase64String(
      String key, File imageFile) {
    Map<String, String> base64ImageMap = new Map();
    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    log(base64Image);
    base64ImageMap.putIfAbsent(
        key, () => "data:image/png;base64,${base64Image}");
    return base64ImageMap;
  }

  static bool validatePhoneNumbers(String phone) {
    if (phone != null && phone.isNotEmpty) {
      RegExp regExp = RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$');
      return regExp.hasMatch(phone);
    } else {
      return false;
    }
  }

  static BoxDecoration setInboundMessageBoxDecoration(String type) {
    if (type == MessageBoxDecorationType.TOP) {
      return BoxDecoration(
          color: CustomColors.bottomAppBarColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimens.space15.w),
            topRight: Radius.circular(Dimens.space15.w),
            bottomRight: Radius.circular(Dimens.space15.w),
          ));
    } else if (type == MessageBoxDecorationType.MIDDLE) {
      return BoxDecoration(
          color: CustomColors.bottomAppBarColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(Dimens.space15.w),
            bottomRight: Radius.circular(Dimens.space15.w),
          ));
    } else {
      return BoxDecoration(
          color: CustomColors.bottomAppBarColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(Dimens.space15.w),
              bottomLeft: Radius.circular(Dimens.space15.w),
              bottomRight: Radius.circular(Dimens.space15.w)));
    }
  }

  static BoxDecoration setOutBoundMessageBoxDecoration(String type) {
    if (type == MessageBoxDecorationType.TOP) {
      return BoxDecoration(
          color: CustomColors.mainColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimens.space15.w),
            topRight: Radius.circular(Dimens.space15.w),
            bottomLeft: Radius.circular(Dimens.space15.w),
          ));
    } else if (type == MessageBoxDecorationType.MIDDLE) {
      return BoxDecoration(
          color: CustomColors.mainColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimens.space15.w),
            bottomLeft: Radius.circular(Dimens.space15.w),
          ));
    } else {
      return BoxDecoration(
          color: CustomColors.mainColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimens.space15.w),
              bottomLeft: Radius.circular(Dimens.space15.w),
              bottomRight: Radius.circular(Dimens.space15.w)));
    }
  }

  static BoxDecoration setFailedMessageBoxDecoration(String type) {
    if (type == MessageBoxDecorationType.TOP) {
      return BoxDecoration(
          color: CustomColors.redButtonColor.withOpacity(0.2),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimens.space15.w),
            topRight: Radius.circular(Dimens.space15.w),
            bottomLeft: Radius.circular(Dimens.space15.w),
          ));
    } else if (type == MessageBoxDecorationType.MIDDLE) {
      return BoxDecoration(
          color: CustomColors.redButtonColor.withOpacity(0.2),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimens.space15.w),
            bottomLeft: Radius.circular(Dimens.space15.w),
          ));
    } else {
      return BoxDecoration(
          color: CustomColors.redButtonColor.withOpacity(0.2),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimens.space15.w),
              bottomLeft: Radius.circular(Dimens.space15.w),
              bottomRight: Radius.circular(Dimens.space15.w)));
    }
  }

  static EdgeInsets setMessageViewMarginByMessageDecorationType(String type) {
    if (type == MessageBoxDecorationType.TOP) {
      return EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space16.h, Dimens.space0.w, Dimens.space0.h);
    } else if (type == MessageBoxDecorationType.MIDDLE) {
      return EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space8.h, Dimens.space0.w, Dimens.space0.h);
    } else {
      return EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space8.h, Dimens.space0.w, Dimens.space0.h);
    }
  }

  static void customPrint(String object) async {
    int defaultPrintLength = 1020;
    if (object == null || object.toString().length <= defaultPrintLength) {
      print(object);
    } else {
      String log = object.toString();
      int start = 0;
      int endIndex = defaultPrintLength;
      int logLength = log.length;
      int tmpLogLength = log.length;
      while (endIndex < logLength) {
        print(log.substring(start, endIndex));
        endIndex += defaultPrintLength;
        start += defaultPrintLength;
        tmpLogLength -= defaultPrintLength;
      }
      if (tmpLogLength > 0) {
        print(log.substring(start, logLength));
      }
    }
  }

  static bool validEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }

  static String convertCamelCasing(String value) {
    return value
        .replaceAll(RegExp(' +'), ' ')
        .split(" ")
        .map((str) => convertCamelCasingFirst(str))
        .join(" ");
  }

  static String convertCamelCasingFirst(String value) {
    return value.length > 0
        ? '${value[0].toUpperCase()}${value.substring(1)}'
        : '';
  }

  static String convertDateToTime(String dateTime) {
    String time = "";
    if (dateTime != null) {
      try {
        var strToDateTime = DateTime.parse(dateTime);
        final convertLocal = strToDateTime.toLocal();
        time = DateFormat.jm().format(convertLocal);
        // time = DateFormat.jm().format(DateTime.parse(convertLocal));
      } catch (e) {
      }
    }
    return time;
  }

  static void removeKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
