import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/provider/common/ps_provider.dart';
import 'package:voice_example/repository/AppInfoRepository.dart';
import 'package:voice_example/viewobject/model/appInfo/AppInfo.dart';
import 'package:voice_example/viewobject/model/appInfo/AppVersion.dart';

class AppInfoProvider extends Provider
{
  AppInfoProvider({
    @required AppInfoRepository appInfoRepository,
    this.valueHolder,
    int limit = 0
  }) : super(appInfoRepository, limit)
  {
    repository = appInfoRepository;
    isDispose = false;
  }

  AppInfoRepository repository;
  ValueHolder valueHolder;

  final Resources<AppInfo> appInfo = Resources<AppInfo>(Status.NO_ACTION, '', null);

  Resources<AppInfo> get categoryList => appInfo;

  @override
  void dispose()
  {
    isDispose = true;
    super.dispose();
  }

  Future<dynamic> doVersionApiCall() async
  {
    isLoading = true;

    final Resources<AppVersion> psAppInfo = await repository.doVersionApiCall();

    return psAppInfo;
  }
}
