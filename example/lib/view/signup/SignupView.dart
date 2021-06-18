
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voice_example/Constants/Constants.dart';
import 'package:voice_example/base/BaseView.dart';
import 'package:voice_example/colors/colors.dart';
import 'package:voice_example/string/Strings.dart';
import 'package:voice_example/styles/CustomStyles.dart';
import 'package:voice_example/view/incoming/IncomingView.dart';
import 'package:voice_example/view/login/LoginView.dart';
import 'package:voice_example/view/splash/SplashView.dart';
import 'SignupPresenter.dart';
import 'SignupViewCallback.dart';

class SignUpView extends BaseView<SignUpState>
{
  @override
  SignUpState state() => SignUpState();
}

class SignUpState extends BaseState<SignUpPresenter, SignUpView> implements SignUpViewCallback {

  GlobalKey<FormState> formKey = new GlobalKey();
  TextEditingController controllerTo, controllerFrom;
  bool notificationsAllowed = false;
  MediaQueryData mediaQuery;

  bool delayLEDTests = false;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState()
  {
    requestRecordPermission();
    controllerTo = TextEditingController();
    controllerFrom = TextEditingController(text: "support_agent_+61480031300");
    AwesomeNotifications().createdStream.listen((receivedNotification) {
          String createdSourceText = AssertUtils.toSimpleEnumString(
              receivedNotification.createdSource);
          Fluttertoast.showToast(
              msg: '$createdSourceText notification created');
        }
    );

    AwesomeNotifications().displayedStream.listen((receivedNotification) {
      String createdSourceText = AssertUtils.toSimpleEnumString(
          receivedNotification.createdSource);
      Fluttertoast.showToast(msg: '$createdSourceText notification displayed');
    });

    AwesomeNotifications().dismissedStream.listen((receivedNotification) {
      String dismissedSourceText = AssertUtils.toSimpleEnumString(receivedNotification.dismissedLifeCycle);
      Fluttertoast.showToast(msg: 'Notification dismissed on $dismissedSourceText');
    }
    );

    AwesomeNotifications().actionStream.listen((receivedNotification) {
      if (!StringUtils.isNullOrEmpty(receivedNotification.buttonKeyInput))
      {
        processInputTextReceived(receivedNotification);
      }
      else
      {
        processDefaultActionReceived(receivedNotification);
      }
    }
    );

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      setState(() {
        notificationsAllowed = isAllowed;
      });

      if (!isAllowed) {
        requestUserPermission(isAllowed);
      }
    });
    super.initState();
  }

  @override
  void dispose()
  {
    controllerTo.dispose();
    controllerFrom.dispose();

    presenter.dispose();
    super.dispose();
  }

  @override
  Widget create(BuildContext context)
  {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.grey.shade400
    ));

    return WillPopScope(
      onWillPop: onHardWareBackPressed,
      child:Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title:Text(
            Strings.register,
            style: blackLabel16BoldTextStyle,
            maxLines: 1,
            textAlign: TextAlign.center,
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
            alignment: Alignment.center,
            color: Colors.white,
            child:SingleChildScrollView (
                child:Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                  child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          controller: controllerFrom,
                          decoration: InputDecoration(
                              labelText: 'Sender Identifier or Phone Number'),
                        ),
                        Divider(),
                        TextFormField(
                          controller: controllerTo,
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
                              await presenter.secureStorageRepo.getLoginId(),
                              controllerFrom.text,
                              controllerTo.text,
                              "joshan",
                            );
                          },
                        ),
                        RaisedButton(
                          child: Text("Hold"),
                          onPressed: () async
                          {
                            await voiceClient.hold();
                          },
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
  onBackPressed()
  {
    pop();
  }

  Future<bool> onHardWareBackPressed()
  {
    return onBackPressed();
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

  @override
  gotoSplashView() {
    push(SplashView());
  }

  @override
  gotoLoginView()
  {
    push(LoginView());
  }

  void processDefaultActionReceived(ReceivedAction receivedNotification) async
  {
    await AwesomeNotifications().cancel(Constants.NOTIFICATION_CALL_INCOMING);
    Fluttertoast.showToast(msg: 'Action received');

    // Avoid to reopen the media page if is already opened
    if(receivedNotification.buttonKeyPressed=='accept')
    {
      push(IncomingView(receivedNotification,false),withReplacement: false);
      voiceClient.acceptCall();
    }
    else if(receivedNotification.buttonKeyPressed=='decline')
    {
      push(IncomingView(receivedNotification,true),withReplacement: false);
      voiceClient.rejectCall();
    }
    else
    {
      push(IncomingView(receivedNotification,true),withReplacement: false);
    }
  }

  void processInputTextReceived(ReceivedAction receivedNotification)
  {
    Fluttertoast.showToast(msg: 'Msg: '+receivedNotification.buttonKeyInput, textColor: Colors.white);
  }

  void requestUserPermission(bool isAllowed) async {
    showDialog(
        context: context,
        builder: (_) =>
            NetworkGiffyDialog(
              buttonOkText: Text('Allow', style: TextStyle(color: Colors.white)),
              buttonCancelText: Text('Later', style: TextStyle(color: Colors.white)),
              buttonCancelColor: Colors.grey,
              buttonOkColor: Colors.deepPurple,
              buttonRadius: 0.0,
              image: Image.asset("assets/images/animated-bell.gif", fit: BoxFit.cover),
              title: Text('Get Notified!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600)
              ),
              description: Text('Allow Awesome Notifications to send you beautiful notifications!',
                textAlign: TextAlign.center,
              ),
              entryAnimation: EntryAnimation.DEFAULT,
              onCancelButtonPressed: () async {
                Navigator.of(context).pop();
                notificationsAllowed = await AwesomeNotifications().isNotificationAllowed();
                setState(() {
                  notificationsAllowed = notificationsAllowed;
                });
              },
              onOkButtonPressed: () async {
                Navigator.of(context).pop();
                await AwesomeNotifications().requestPermissionToSendNotifications();
                notificationsAllowed = await AwesomeNotifications().isNotificationAllowed();
                setState(() {
                  notificationsAllowed = notificationsAllowed;
                });
              },
            )
    );
  }

  Future<bool> requestRecordPermission() async
  {
    Map<Permission, PermissionStatus> permissionStatus  = await [
      Permission.microphone,
      Permission.accessMediaLocation,
      Permission.mediaLibrary,
      Permission.phone,
      Permission.storage,
      Permission.notification,
      Permission.camera,
    ].request();

    for(int i=0;i<permissionStatus.length;i++)
    {
      if (permissionStatus[i].isGranted)
      {
        return true;
      }
      else
      {
        return false;
      }
    }
    return true;
  }
}