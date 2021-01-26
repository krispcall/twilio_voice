
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voice_example/base/BaseView.dart';
import 'package:voice_example/colors/colors.dart';
import 'package:voice_example/string/Strings.dart';
import 'package:voice_example/view/login/LoginView.dart';
import 'SplashViewCallback.dart';
import 'SplashPresenter.dart';

class SplashView extends BaseView<SplashState>
{
  @override
  SplashState state() => SplashState();
}

class SplashState extends BaseState<SplashPresenter, SplashView> implements SplashViewCallback {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState()
  {
    super.initState();
  }

  @override
  void dispose()
  {
    presenter.dispose();
    super.dispose();
  }

  @override
  Widget create(BuildContext context)
  {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.grey.shade400
    ));

    return Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          child:Container(
            color: Colors.white,
            child: Center(
              child:SizedBox(
                height: 200,
                child: Image.asset("assets/images/logo.png",fit: BoxFit.fill,),
              ),
            ),
          )
        )
    );
  }

  @override
  onCheckInternetComplete(bool isConnection)
  {
    setState(()
    {
      if (isConnection)
      {
        push(LoginView(),withReplacement: true);
      }
      else
      {
        scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text(Strings.noInternetConnection),
              duration: Duration(hours: 5),
              action: SnackBarAction(
                label: 'RETRY',
                textColor: CustomColor.themeGreen,
                onPressed: () => presenter.checkConnection(),
              ),
            )
        );
      }
    });
  }
}
