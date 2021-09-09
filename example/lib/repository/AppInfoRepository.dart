import 'dart:async';
import 'package:flutter/material.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/api/ApiService.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/repository/Common/Respository.dart';
import 'package:voice_example/viewobject/model/appInfo/AppInfo.dart';
import 'package:voice_example/viewobject/model/appInfo/AppVersion.dart';

class AppInfoRepository extends Repository
{
  AppInfoRepository({@required ApiService service,})
  {
    apiService = service;
  }

  ApiService apiService;

  Future<Resources<AppVersion>> doVersionApiCall({bool isLoadFromServer = true}) async
  {
    final Resources<AppInfo> _resource = await apiService.doVersionApiCall();
    if (_resource.status == Status.SUCCESS)
    {
      if (_resource.data.appRegisterInfo.error != null)
      {
        return Resources(Status.SUCCESS, _resource.data.appRegisterInfo.error.message, null);
      }
      else
      {
        return Resources(Status.SUCCESS, "", _resource.data.appRegisterInfo .appVersion);
      }
    }
    else
    {
      AppVersion appInfo = AppVersion(
          versionForceUpdate: false,
          versionNeedClearData: false,
          versionNo: Config.appVersion,
      );
      return Resources(Status.SUCCESS, "", appInfo);
    }
  }
}
