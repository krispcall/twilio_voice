import 'dart:async';
import 'dart:io';
import 'package:in_app_update/in_app_update.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/repository/UserRepository.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:voice_example/viewobject/model/appInfo/AppVersion.dart';
import 'package:provider/provider.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/constant/RoutePaths.dart';
import 'package:voice_example/provider/app_info/AppInfoProvider.dart';
import 'package:voice_example/repository/AppInfoRepository.dart';

class AppInfoView extends StatefulWidget {
  const AppInfoView({
    Key key,
  }) : super(key: key);

  @override
  AppInfoViewState createState() => AppInfoViewState();
}

class AppInfoViewState extends State<AppInfoView> with SingleTickerProviderStateMixin
{
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  AppInfoRepository appInfoRepository;
  AppInfoProvider appInfoProvider;
  UserRepository userRepository;

  ValueHolder valueHolder;

  AnimationController controller;
  Animation _offsetFloat;
  Animation sizeAnimation;

  @override
  void initState()
  {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _offsetFloat = Tween(begin: Offset(0.0, 0.10), end: Offset.zero).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _offsetFloat.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<ValueHolder>(context);
    appInfoRepository = Provider.of<AppInfoRepository>(context);
    userRepository = Provider.of<UserRepository>(context);

    return ChangeNotifierProvider<AppInfoProvider>(
      lazy: false,
      create: (BuildContext context)
      {
        appInfoProvider = AppInfoProvider(appInfoRepository: appInfoRepository, valueHolder: valueHolder);
        checkForNewVersion();
        return appInfoProvider;
      },
      child: Consumer<AppInfoProvider>(
        builder: (BuildContext context, AppInfoProvider clearAllDataProvider, Widget child)
        {
          return Scaffold(
            key: _scaffoldKey,
            body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: CustomColors.mainColor,
                child: SlideTransition(
                  position: _offsetFloat,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
                    alignment: Alignment.center,
                    child: PlainAssetImageHolder(
                      assetUrl: "assets/images/logo.png",
                      height: Dimens.space60,
                      width: Dimens.space180,
                      assetWidth: Dimens.space180,
                      assetHeight: Dimens.space60,
                      boxFit: BoxFit.contain,
                      iconUrl: CustomIcon.icon_person,
                      iconSize: Dimens.space10,
                      iconColor: CustomColors.mainColor,
                      boxDecorationColor: CustomColors.transparent,
                      outerCorner: Dimens.space0,
                      innerCorner: Dimens.space0,
                    ),
                  ),
                )
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> checkForNewVersion() async
  {
    if (await Utils.checkInternetConnectivity())
    {
      final Resources<AppVersion> _psAppInfo = await appInfoProvider.doVersionApiCall();

      if (_psAppInfo.status == Status.SUCCESS)
      {
        if(_psAppInfo.data!=null)
        {
          checkAppVersion(context, _psAppInfo.data, appInfoProvider);
        }
        else
        {
          checkIsLogin();
        }
      }
      else
      {
        checkIsLogin();
      }
    }
    else
    {
      checkIsLogin();
    }
  }

  dynamic checkAppVersion(BuildContext context, AppVersion psAppInfo, AppInfoProvider appInfoProvider) async
  {
    if (psAppInfo.versionForceUpdate!=null && psAppInfo.versionForceUpdate)
    {
      if(psAppInfo.versionNeedClearData!=null && psAppInfo.versionNeedClearData)
      {
        appInfoProvider.replaceLoginUserId("");
      }
      if (Platform.isIOS)
      {
        Utils.launchAppStoreURL(iOSAppId: Config.iOSAppStoreId);
      }
      else if (Platform.isAndroid)
      {
        startForceUpdate();
      }
    }
    else
    {
      if(psAppInfo.versionNeedClearData!=null && psAppInfo.versionNeedClearData)
      {
        appInfoProvider.replaceLoginUserId("");
      }
      if (Platform.isIOS)
      {
        Utils.launchAppStoreURL(iOSAppId: Config.iOSAppStoreId);
      }
      else if (Platform.isAndroid)
      {
        startFlexibleUpdate();
      }
    }
  }

  void startFlexibleUpdate() async
  {
    InAppUpdate.checkForUpdate().then((info)
    {
      if(info?.updateAvailability == UpdateAvailability.updateAvailable)
      {
        InAppUpdate.startFlexibleUpdate().then((value) => checkIsLogin()).catchError((e) => checkIsLogin());
      }
      else
      {
        checkIsLogin();
      }
    }).catchError((e)
    {
      checkIsLogin();
    });
  }

  void startForceUpdate() async
  {
    InAppUpdate.checkForUpdate().then((info)
    {
      if(info?.updateAvailability == UpdateAvailability.updateAvailable)
      {
        InAppUpdate.performImmediateUpdate().catchError((e) => checkIsLogin());
      }
      else
      {
        checkIsLogin();
      }
    }).catchError((e)
    {
      checkIsLogin();
    });
  }

  void checkIsLogin()
  {
    if (userRepository.getLoginUserId() == null || userRepository.getLoginUserId().isEmpty)
    {
      Navigator.of(context).pushNamedAndRemoveUntil(RoutePaths.getStarted, (Route<dynamic> route) => false);
    }
    else
    {
      Navigator.pushReplacementNamed(
        context,
        RoutePaths.home,
      );
    }
  }
}
