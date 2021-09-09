/*
 * *
 *  * Created by Kedar on 7/8/21 10:57 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 6/29/21 7:52 AM
 *
 */

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/provider/common/ps_provider.dart';
import 'package:voice_example/repository/MyNumberRepository.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:voice_example/viewobject/model/numbers/Numbers.dart';

class MyNumberProvider extends Provider {
  MyNumberProvider(
      {@required MyNumberRepository myNumberRepository, int limit = 20})
      : super(myNumberRepository, limit) {
    this._myNumberRepository = myNumberRepository;

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    streamControllerNumbers =
        StreamController<Resources<List<Numbers>>>.broadcast();

    subscriptionNumbers = streamControllerNumbers.stream
        .listen((Resources<List<Numbers>> resource) {
      _numbers = resource;

      if (resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  MyNumberRepository _myNumberRepository;
  ValueHolder valueHolder;

  StreamController<Resources<List<Numbers>>> streamControllerNumbers;
  StreamSubscription<Resources<List<Numbers>>> subscriptionNumbers;

  Resources<List<Numbers>> _numbers =
      Resources<List<Numbers>>(Status.NO_ACTION, '', null);

  Resources<List<Numbers>> get numbers => _numbers;

  @override
  void dispose() {
    subscriptionNumbers.cancel();
    streamControllerNumbers.close();
    isDispose = true;
    super.dispose();
  }

  Future<dynamic> doGetMyNumbersListApiCall() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    Resources<List<Numbers>> resources = await _myNumberRepository.doGetMyNumbersListApiCall(
        limit, isConnectedToInternet, Status.PROGRESS_LOADING);
    streamControllerNumbers.sink.add(resources);
  }

  void doDbNumbersSearch(String text) async {
    Resources<List<Numbers>> resources = await _myNumberRepository.doSearchMyNumbersLocally(text);
    streamControllerNumbers.sink.add(resources);
  }


}
