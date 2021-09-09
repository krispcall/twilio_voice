import 'package:flutter/material.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/provider/common/ps_provider.dart';
import 'package:voice_example/repository/CallTransferRepository.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/ResponseData.dart';

class CallTransferProvider extends Provider
{
  CallTransferProvider({@required CallTransferRepository callTransferRepository}) : super(callTransferRepository,0)
  {
    repository = callTransferRepository;
    Utils.checkInternetConnectivity().then((bool onValue)
    {
      isConnectedToInternet = onValue;
    });
  }

  CallTransferRepository repository;


  @override
  void dispose() {
    isDispose = true;
    super.dispose();
  }


  Future<Resources<ResponseData>> callTransfer({ String direction, String conversationId, String callerId, String destination,}) async
  {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return  await repository.callTransfer(direction, conversationId, callerId, destination, isConnectedToInternet, Status.PROGRESS_LOADING);
  }
}