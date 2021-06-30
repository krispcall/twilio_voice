
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voice/twiliovoice.dart';
import 'package:voice_example/Constants/Constants.dart';
import 'package:voice_example/base/BaseView.dart';
import 'package:voice_example/colors/colors.dart';
import 'package:voice_example/icons/CustomIcon.dart';
import 'package:voice_example/request/RequestLogin.dart';
import 'package:voice_example/string/Strings.dart';
import 'package:voice_example/styles/CustomStyles.dart';
import 'package:voice_example/validator/Validator.dart';
import 'package:voice_example/view/signup/SignupView.dart';
import 'package:voice_example/view/splash/SplashView.dart';
import 'LoginPresenter.dart';
import 'LoginViewCallback.dart';


final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
VoiceClient voiceClient;



class LoginView extends BaseView<LoginState> {
  @override
  LoginState state() => LoginState();
}

class LoginState extends BaseState<LoginPresenter, LoginView> implements LoginViewCallback {


  GlobalKey<FormState> formKey = new GlobalKey();
  bool formValidate = false;

  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerPassword = new TextEditingController();

  FocusNode focusEmail = FocusNode();
  FocusNode focusPassword = FocusNode();

  bool passwordVisible = true;
  bool loginVisibility =false;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState()
  {
    super.initState();
  }

  @override
  dispose()
  {
    controllerEmail.dispose();
    controllerPassword.dispose();

    focusEmail.dispose();
    focusPassword.dispose();

    presenter.dispose();
    super.dispose();
  }

  @override
  Widget create(BuildContext context)
  {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
        statusBarColor: Colors.grey.shade400
    ));

    return WillPopScope(
      onWillPop: onHardWareBackPressed,
      child:Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title:Text(
            Strings.login,
            style: blackLabel16BoldTextStyle,
            maxLines: 1,
            textAlign:TextAlign.center,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: CustomColor.themeGrey),
            onPressed: (){
              presenter.onBackPressed();
            },
          ),
          elevation: 0,
        ),
        body: SafeArea(
          child:Container(
            alignment: Alignment.topCenter,
            color: Colors.white,
            child:SingleChildScrollView (
                child:Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                  child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          height: 100,
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Center(
                            child: Image.asset(
                              "assets/images/logo.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                          child: Text(
                            Strings.welcome,
                            style: blackLabel20BoldTextStyle,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Text(
                            Strings.pleaseLogIn,
                            style: greyLabel16NormalTextStyle,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                          child: Form(
                            key: formKey,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    Strings.emailOrPhone,
                                    style: blackLabel16NormalTextStyle,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: TextFormField(
                                    validator: emailornumber_validator,
                                    controller: controllerEmail,
                                    textAlign: TextAlign.left,
                                    focusNode: focusEmail,
                                    style: greyLabel18BoldTextStyle,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.emailAddress,
                                    maxLines: 1,
                                    cursorColor: Colors.grey,
                                    cursorHeight: 22,
                                    decoration: InputDecoration(
                                      disabledBorder: InputBorder.none,
                                      isCollapsed: true,
                                      isDense: true,
                                      contentPadding:
                                      EdgeInsets.only(bottom: 0.5, top: 0.5),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                      suffixIcon: Icon(
                                        CustomIcon.ic_mail,
                                        color: CustomColor.themeGreen,
                                        size: 20,
                                      ),
                                      hintText: Strings.emailOrPhone,
                                      hintStyle: greyLabel18NormalTextStyle,
                                    ),
                                    onFieldSubmitted: (String val) {
                                      fieldFocusChange(
                                          context, focusEmail, focusPassword);
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    Strings.password,
                                    style: blackLabel16NormalTextStyle,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: TextFormField(
                                    validator: emailornumber_validator,
                                    controller: controllerPassword,
                                    textAlign: TextAlign.left,
                                    focusNode: focusPassword,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.emailAddress,
                                    maxLines: 1,
                                    style: greyLabel20BoldTextStyle,
                                    obscureText: passwordVisible,
                                    cursorColor: Colors.grey,
                                    decoration: InputDecoration(
                                      isCollapsed: true,
                                      contentPadding:
                                      EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.grey),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          passwordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: CustomColor.themeGreen,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            passwordVisible = !passwordVisible;
                                          });
                                        },
                                      ),
                                      hintText: Strings.enterPassword,
                                      hintStyle: greyLabel18NormalTextStyle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: RaisedButton(
                            elevation: 5.0,
                            onPressed: () {
                              if (formKey.currentState.validate())
                              {
                                formKey.currentState.save();
                                RequestLogin request = RequestLogin(
                                    email: controllerEmail.text,
                                    password: controllerPassword.text);
                                presenter.doLoginApiCall(request);
                              }
                              else
                              {
                                setState(()
                                {
                                  formValidate = true;
                                });
                              }
                            },
                            padding: EdgeInsets.all(15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            color: CustomColor.themeGreen,
                            child: Text(
                              Strings.loginToMyAccount.toUpperCase(),
                              style: whiteLabel16BoldTextStyle,
                            ),
                          ),
                        ),
                      ]),
                )
            ),
          ),
        ),
      ),
    );
  }

  @override
  gotoLandingScreen()
  {
    push(SignUpView(),withReplacement: true);
  }

  @override
  gotoSplashView() {
    push(SplashView());
  }

  @override
  configureNotification(String apiToken) async
  {
    voiceClient=VoiceClient(apiToken);
    voiceClient.registerForNotification(apiToken,  Platform.isAndroid? await FirebaseMessaging.instance.getToken(): await FirebaseMessaging.instance.getAPNSToken()).then((value)
    {
      print("token register $value");
    });
    _firebaseMessaging.setAutoInitEnabled(true);
    _firebaseMessaging.subscribeToTopic("com.flutter.twilio.voice_example");

    FirebaseMessaging.onMessage.listen((RemoteMessage message)
    {
      print("this is is on Message listen $message");
      if(message.data.containsKey("twi_account_sid"))
      {
        print('message contains twi account sid');
        voiceClient.handleMessage(message.data);
        showIncomingCallNotification(Constants.NOTIFICATION_CALL_INCOMING,NotificationImportance.Max,message.data);
      }
      else
      {

      }
    });

    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    print("FCM "+await FirebaseMessaging.instance.getToken());
    push(SignUpView(),withReplacement: false);
  }

  Future<bool> onHardWareBackPressed() {
    return onBackPressed();
  }

  onBackPressed()
  {
    pop();
  }

  fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus)
  {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  onCheckInternetComplete(bool isConnection)
  {
    setState(()
    {
      if (!isConnection)
      {
        scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text(Strings.noInternetConnection),
              duration: Duration(hours: 5),
              action: SnackBarAction(
                label: 'RETRY',
                textColor: CustomColor.themeGreen,
                onPressed: () => presenter.contentRepo.checkConnection(),
              ),
            )
        );
      }
      else
      {
        scaffoldKey.currentState.hideCurrentSnackBar();
      }
    });
  }
}

Future<dynamic> onMessage(Map<String, dynamic> message) async
{
  print('Main::onMessage => $message');

}

Future<dynamic> onBackgroundMessage(RemoteMessage message) async {
  print('Main::onBackgroundMessage => $message');
  await Firebase.initializeApp();
  voiceClient.handleMessage(message.data);
  showBackgroundCallNotification(Constants.NOTIFICATION_CALL_INCOMING,NotificationImportance.Max,message.data);
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
  String body=message['data']['twi_from']!=null?message['data']['twi_from']+" is calling.":"Someone is calling.";

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