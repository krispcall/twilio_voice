
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voice_example/base/BaseView.dart';
import 'package:voice_example/colors/colors.dart';
import 'package:voice_example/string/Strings.dart';
import 'package:voice_example/styles/CustomStyles.dart';
import 'package:voice_example/view/login/LoginView.dart';
import 'package:voice_example/view/signup/SignupView.dart';
import 'package:voice_example/view/splash/SplashView.dart';
import 'IncomingPresenter.dart';
import 'IncomingViewCallback.dart';

class IncomingView extends BaseView<IncomingState>
{
  String get results => receivedNotification.toString();
  final ReceivedNotification receivedNotification;
  bool isConnected=true;
  IncomingView(this.receivedNotification,this.isConnected);
  @override
  IncomingState state() => IncomingState();
}

class IncomingState extends BaseState<IncomingPresenter, IncomingView> implements IncomingViewCallback {


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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
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
                          child: Text(
                            widget.receivedNotification.displayedDate,
                          ),
                        ),
                        Container(
                          child: Text(
                            widget.receivedNotification.title,
                          ),
                        ),
                        Container(
                          child: Text(
                            widget.receivedNotification.body,
                          ),
                        ),
                        widget.isConnected?
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              child: RaisedButton(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  side: BorderSide(color: Colors.red),
                                ),
                                color: Colors.red,
                                onPressed:()
                                {
                                  voiceClient.rejectCall();
                                  pop();
                                },
                                child: Icon(
                                  Icons.clear_rounded,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 50,
                              child: RaisedButton(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  side: BorderSide(color: Colors.green),
                                ),
                                color: Colors.green,
                                onPressed:()
                                {
                                  voiceClient.acceptCall();
                                  setState(() {
                                    widget.isConnected=false;
                                  });
                                },
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ):
                        Container(
                          height: 50,
                          width: 50,
                          child: RaisedButton(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0),
                              side: BorderSide(color: Colors.red),
                            ),
                            color: Colors.red,
                            onPressed:()
                            {
                              voiceClient.rejectCall();
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                              Icons.clear_rounded,
                              color: Colors.white,
                              size: 30,
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

  Future<bool> onHardWareBackPressed() {
    return onBackPressed();
  }

  onBackPressed()
  {
    pop();
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
                onPressed: () => presenter..contentRepo.checkConnection(),
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