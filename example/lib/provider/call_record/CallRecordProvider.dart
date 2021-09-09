import 'package:flutter/material.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/provider/common/ps_provider.dart';
import 'package:voice_example/repository/CallRecordRepository.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/model/recording/callRecord.dart';

class CallRecordProvider extends Provider {
  CallRecordProvider(
      {@required CallRecordRepository callRecordRepository}) : super(callRecordRepository,0) {
    repository = callRecordRepository;
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
  }

  CallRecordRepository repository;


  @override
  void dispose() {
    isDispose = true;
    super.dispose();
  }


  Future<Resources<CallRecordResponse>> callRecord({String action,String callSid, String direction}) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return  await repository.callRecord(
        action,
        callSid,
        direction,
         isConnectedToInternet, Status.PROGRESS_LOADING);
  }
}
