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
import 'package:voice_example/repository/CallLogRepository.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/contactPinUnpinRequestParamHolder/ContactPinUnpinRequestHolder.dart';
import 'package:voice_example/viewobject/model/call/RecentConversationEdges.dart';

class CallLogProvider extends Provider {
  CallLogProvider(
      {@required CallLogRepository callLogRepository, int limit = 20})
      : super(callLogRepository, limit) {
    this.callLogRepository = callLogRepository;

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    streamControllerCallLogs =
    StreamController<Resources<List<RecentConversationEdges>>>.broadcast();
    subscriptionCallLogs = streamControllerCallLogs.stream
        .listen((Resources<List<RecentConversationEdges>> resource) {
      _callLogs = resource;

      if (resource!=null&&resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });

    streamControllerNewCount = StreamController<Resources<int>>.broadcast();
    subscriptionNewCount = streamControllerNewCount.stream
        .listen((Resources<int> resource) {
      _newCount = resource;
      if (resource!=null&&resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        isLoading = false;
      }
      if (!isDispose) {
        notifyListeners();
      }
    });

  }

  CallLogRepository callLogRepository;
  ValueHolder valueHolder;

  StreamController<Resources<List<RecentConversationEdges>>>
  streamControllerCallLogs;
  StreamSubscription<Resources<List<RecentConversationEdges>>>
  subscriptionCallLogs;

  Resources<List<RecentConversationEdges>> _callLogs = Resources<List<RecentConversationEdges>>(Status.NO_ACTION, '', null);

  Resources<List<RecentConversationEdges>> get callLogs => _callLogs;



  StreamController<Resources<int>> streamControllerNewCount;
  StreamSubscription<Resources<int>> subscriptionNewCount;

  Resources<int> _newCount = Resources<int>(Status.NO_ACTION, '', 0);

  Resources<int> get newCount => _newCount;




  @override
  void dispose() {
    subscriptionCallLogs.cancel();
    streamControllerCallLogs.close();
    isDispose = true;
    super.dispose();
  }

  // CallLog Type  all, missed, new
  Future<dynamic> doCallLogsApiCall(String callLogType) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _callLogs = await callLogRepository.doCallLogsApiCall(
        getDefaultChannel().id,
        callLogType,
        limit,
        isConnectedToInternet,
        Status.PROGRESS_LOADING);
    if (!streamControllerCallLogs.isClosed) {
      streamControllerCallLogs.sink.add(_callLogs);
    }
  }

  Future<dynamic> doNextCallLogsApiCall(String callLogType) async {
    streamControllerCallLogs.sink.add(Resources<List<RecentConversationEdges>>(
        Status.PROGRESS_LOADING, '', _callLogs.data));

    super.isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    Resources<List<RecentConversationEdges>> next =
    await callLogRepository.doNextCallLogsApiCall(getDefaultChannel().id,
        callLogType, limit, isConnectedToInternet, Status.PROGRESS_LOADING);
    if (next.status == Status.SUCCESS) {
      if (next.data != null && next.data.length != 0) {
        _callLogs.data.addAll(next.data);
        streamControllerCallLogs.sink.add(
            Resources<List<RecentConversationEdges>>(
                Status.SUCCESS, '', _callLogs.data));
      } else {
        streamControllerCallLogs.sink.add(
            Resources<List<RecentConversationEdges>>(
                Status.SUCCESS, '', _callLogs.data));
      }
    } else {
      streamControllerCallLogs.sink.add(
          Resources<List<RecentConversationEdges>>(
              Status.SUCCESS, '', _callLogs.data));
    }
  }




  Future<dynamic> doCallLogsSmsOnlyApiCall(String callLogType) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _callLogs = await callLogRepository.doCallLogsSmsOnlyApiCall(
        getDefaultChannel().id,
        callLogType,
        limit,
        isConnectedToInternet,
        Status.PROGRESS_LOADING);

    streamControllerCallLogs.sink.add(_callLogs);
  }

  Future<dynamic> doNextCallLogsSmsOnlyApiCall(String callLogType) async {
    streamControllerCallLogs.sink.add(Resources<List<RecentConversationEdges>>(
        Status.PROGRESS_LOADING, '', _callLogs.data));

    super.isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    Resources<List<RecentConversationEdges>> next =
    await callLogRepository.doNextCallLogsApiCall(getDefaultChannel().id,
        callLogType, limit, isConnectedToInternet, Status.PROGRESS_LOADING);
    if (next.status == Status.SUCCESS) {
      if (next.data != null && next.data.length != 0) {
        _callLogs.data.addAll(next.data);
        streamControllerCallLogs.sink.add(
            Resources<List<RecentConversationEdges>>(
                Status.SUCCESS, '', _callLogs.data));
      } else {
        streamControllerCallLogs.sink.add(
            Resources<List<RecentConversationEdges>>(
                Status.SUCCESS, '', _callLogs.data));
      }
    } else {
      streamControllerCallLogs.sink.add(
          Resources<List<RecentConversationEdges>>(
              Status.SUCCESS, '', _callLogs.data));
    }
  }

  Future<dynamic> doContactPinUnpinApiCall(
      ContactPinUnpinRequestHolder params) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    return await callLogRepository.doContactPinUnpinApiCall(
        params, limit, isConnectedToInternet, Status.PROGRESS_LOADING);
  }

  Future<dynamic> getAllCallLogsFromDb() async {
    Resources<List<RecentConversationEdges>> result =
    await callLogRepository.getAllCallLogsFromDb();

    _callLogs.data.clear();
    _callLogs.data.addAll(result.data);
    streamControllerCallLogs.sink.add(_callLogs);
    return _callLogs.data;
  }

  Future<dynamic> doCallLogsSearchFromDb(String query) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    Resources<List<RecentConversationEdges>> result =
    await callLogRepository.doCallLogsSearchFromDb(
        query, isConnectedToInternet, limit, Status.PROGRESS_LOADING);
    if (_callLogs != null && _callLogs.data != null) {
      _callLogs.data.clear();
      _callLogs.data.addAll(result.data);
      streamControllerCallLogs.sink.add(_callLogs);
      return _callLogs.data;
    } else {
      Resources<List<RecentConversationEdges>> result =
      await callLogRepository.getAllCallLogsFromDb();

      _callLogs.data.clear();
      _callLogs.data.addAll(result.data);
      streamControllerCallLogs.sink.add(_callLogs);
      return _callLogs.data;
    }
  }


  getTotalNewCallLogsCount() async{
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await callLogRepository.getNewCounts(streamControllerNewCount,isConnectedToInternet,Map.from({"channel":getDefaultChannel().id}));
  }

  Future<dynamic> doSubscriptionUpdateConversationDetail() async
  {
    isLoading = false;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await callLogRepository.doSubscriptionUpdateConversationDetail(
      streamControllerCallLogs,
      isConnectedToInternet,
      Status.PROGRESS_LOADING,
    );
  }
}
