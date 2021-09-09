import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/provider/common/ps_provider.dart';
import 'package:voice_example/repository/MessageDetailsRepository.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/holder/request_holder/sendMessageRequestParamHolder/SendMessageRequestContentHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/sendMessageRequestParamHolder/SendMessageRequestHolder.dart';
import 'package:voice_example/viewobject/model/call/RecentConversationEdges.dart';
import 'package:voice_example/viewobject/model/message/MessageDetails.dart';

class MessageDetailsProvider extends Provider {
  MessageDetailsProvider(
      {@required MessageDetailsRepository messageDetailsRepository,
        int limit = 0})
      : super(messageDetailsRepository, limit) {
    this.messageDetailsRepository = messageDetailsRepository;
    isDispose = false;

    streamControllerConversation = StreamController<
        Resources<List<MessageDetailsObjectWithType>>>.broadcast();

    subscriptionConversation = streamControllerConversation.stream
        .listen((Resources<List<MessageDetailsObjectWithType>> resource) {
      _listConversationDetails = resource;
      if (resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        isLoading = false;
      }
      if (!isDispose) {
        notifyListeners();
      }
    });

    streamControllerRecordingConversation =
    StreamController<Resources<List<RecentConversationEdges>>>.broadcast();

    subscriptionRecordingConversation = streamControllerRecordingConversation
        .stream
        .listen((Resources<List<RecentConversationEdges>> resource) {
      _listRecordingConversationDetails = resource;
      if (resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        isLoading = false;
      }
      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  MessageDetailsRepository messageDetailsRepository;

  StreamController<Resources<List<MessageDetailsObjectWithType>>>
  streamControllerConversation;
  StreamSubscription<Resources<List<MessageDetailsObjectWithType>>>
  subscriptionConversation;

  Resources<List<MessageDetailsObjectWithType>> _listConversationDetails =
  Resources<List<MessageDetailsObjectWithType>>(Status.NO_ACTION, '', null);

  Resources<List<MessageDetailsObjectWithType>> get listConversationDetails =>
      _listConversationDetails;

  StreamController<Resources<List<RecentConversationEdges>>>
  streamControllerRecordingConversation;
  StreamSubscription<Resources<List<RecentConversationEdges>>>
  subscriptionRecordingConversation;

  Resources<List<RecentConversationEdges>> _listRecordingConversationDetails =
  Resources<List<RecentConversationEdges>>(Status.NO_ACTION, '', null);

  Resources<List<RecentConversationEdges>>
  get listRecordingConversationDetails => _listRecordingConversationDetails;

  @override
  void dispose() {
    subscriptionConversation.cancel();
    streamControllerConversation.close();

    streamControllerRecordingConversation.close();
    subscriptionRecordingConversation.cancel();

    isDispose = true;
    super.dispose();
  }

  Future<dynamic> deleteMessage(MessageDetails messageDetails) async {
    isLoading = true;
    // return await _repo.deleteMessage(streamControllerConversation, messageDetails);
  }

  Future<dynamic> doConversationDetailByContactApiCall(String contactId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    Resources<List<RecentConversationEdges>> response =
    await messageDetailsRepository.doConversationDetailByContactApiCall(
      contactId,
      getDefaultChannel().id,
      isConnectedToInternet,
      limit,
      Status.PROGRESS_LOADING,
    );
    if (response.data != null && response.data.length != 0) {
      _listConversationDetails = Resources<List<MessageDetailsObjectWithType>>(
          Status.SUCCESS,
          "",
          messageDetailsRepository.prepareResponse(response.data));
      streamControllerConversation.sink.add(_listConversationDetails);
    } else {
      streamControllerConversation.sink
          .add(Resources(Status.ERROR, Utils.getString("serverError"), null));
    }
  }

  Future<dynamic> doRecordingConversationDetailByContactApiCall(
      String contactId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    Resources<List<RecentConversationEdges>> response =
    await messageDetailsRepository.doConversationDetailByContactApiCall(
        contactId,
        getDefaultChannel().id,
        isConnectedToInternet,
        100,
        Status.PROGRESS_LOADING,
        isCallRecording: true);

    if (response.data != null && response.data.isNotEmpty) {
      List<RecentConversationEdges> listData = [];
      for (RecentConversationEdges data in response.data) {
        var mData = data;
        mData.advancedPlayer = AudioPlayer();
        listData.add(mData);
      }

      _listRecordingConversationDetails =
          Resources<List<RecentConversationEdges>>(
              Status.SUCCESS, "", listData);
      streamControllerRecordingConversation.sink
          .add(_listRecordingConversationDetails);
    } else {
      streamControllerRecordingConversation.sink
          .add(Resources(Status.ERROR, Utils.getString("serverError"), null));
    }
  }

  Future<dynamic> doSearchConversationApiCall(String contactId,
      String keyword) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    Resources<List<RecentConversationEdges>> response =
    await messageDetailsRepository.doSearchConversationApiCall(
        contactId,
        getDefaultChannel().id,
        isConnectedToInternet,
        limit,
        Status.PROGRESS_LOADING,
        keyword);
    return response;
  }

  Future<dynamic> doSearchConversationWithCursorApiCall(String contactId,
      String startCursor, String endCursor) async {
    streamControllerConversation.sink.add(
        Resources<List<MessageDetailsObjectWithType>>(
            Status.NO_ACTION, '', null));
    super.isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    Resources<List<RecentConversationEdges>> response =
    await messageDetailsRepository.doSearchConversationWithCursorApiCall(
      contactId,
      getDefaultChannel().id,
      isConnectedToInternet,
      limit,
      Status.PROGRESS_LOADING,
      startCursor,
      endCursor,
    );
    if (response.status == Status.SUCCESS) {
      if (response.data != null && response.data.length != 0) {
        Resources<List<MessageDetailsObjectWithType>> toReturn = Resources(
            Status.SUCCESS,
            "",
            messageDetailsRepository.prepareResponse(response.data));
        _listConversationDetails = toReturn;
        streamControllerConversation.sink.add(_listConversationDetails);
      } else {
        Resources<List<MessageDetailsObjectWithType>> toReturn = Resources(
            Status.SUCCESS,
            "",
            messageDetailsRepository.prepareResponse(response.data));
        _listConversationDetails = toReturn;
        streamControllerConversation.sink.add(_listConversationDetails);
      }
    } else {
      Resources<List<MessageDetailsObjectWithType>> toReturn = Resources(
          Status.SUCCESS,
          "",
          messageDetailsRepository.prepareResponse(response.data));
      _listConversationDetails = toReturn;
      streamControllerConversation.sink.add(_listConversationDetails);
    }
  }

  Future<dynamic> doPreviousConversationDetailByContactApiCall(
      String contactId) async {
    streamControllerConversation.sink.add(
        Resources<List<MessageDetailsObjectWithType>>(
            Status.PROGRESS_LOADING, '', _listConversationDetails.data));
    super.isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    Resources<List<RecentConversationEdges>> response =
    await messageDetailsRepository
        .doPreviousConversationDetailByContactApiCall(
      contactId,
      getDefaultChannel().id,
      isConnectedToInternet,
      limit,
      Status.PROGRESS_LOADING,
    );
    if (response.status == Status.SUCCESS) {
      if (response.data != null && response.data.length != 0) {
        Resources<List<MessageDetailsObjectWithType>> toReturn = Resources(
            Status.SUCCESS,
            "",
            messageDetailsRepository.prepareResponse(response.data));
        _listConversationDetails = toReturn;
        streamControllerConversation.sink.add(_listConversationDetails);
      } else {
        Resources<List<MessageDetailsObjectWithType>> toReturn = Resources(
            Status.SUCCESS,
            "",
            messageDetailsRepository.prepareResponse(response.data));
        _listConversationDetails = toReturn;
        streamControllerConversation.sink.add(_listConversationDetails);
      }
    } else {
      Resources<List<MessageDetailsObjectWithType>> toReturn = Resources(
          Status.SUCCESS,
          "",
          messageDetailsRepository.prepareResponse(response.data));
      _listConversationDetails = toReturn;
      streamControllerConversation.sink.add(_listConversationDetails);
    }
  }

  Future<dynamic> doNextConversationDetailByContactApiCall(
      String contactId) async {
    streamControllerConversation.sink.add(
        Resources<List<MessageDetailsObjectWithType>>(
            Status.PROGRESS_LOADING, '', _listConversationDetails.data));
    super.isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    Resources<List<RecentConversationEdges>> response =
    await messageDetailsRepository
        .doPreviousConversationDetailByContactApiCall(
      contactId,
      getDefaultChannel().id,
      isConnectedToInternet,
      limit,
      Status.PROGRESS_LOADING,
    );
    if (response.status == Status.SUCCESS) {
      if (response.data != null && response.data.length != 0) {
        Resources<List<MessageDetailsObjectWithType>> toReturn = Resources(
            Status.SUCCESS,
            "",
            messageDetailsRepository.prepareResponse(response.data));
        _listConversationDetails = toReturn;
        streamControllerConversation.sink.add(_listConversationDetails);
      } else {
        Resources<List<MessageDetailsObjectWithType>> toReturn = Resources(
            Status.SUCCESS,
            "",
            messageDetailsRepository.prepareResponse(response.data));
        _listConversationDetails = toReturn;
        streamControllerConversation.sink.add(_listConversationDetails);
      }
    } else {
      Resources<List<MessageDetailsObjectWithType>> toReturn = Resources(
          Status.SUCCESS,
          "",
          messageDetailsRepository.prepareResponse(response.data));
      _listConversationDetails = toReturn;
      streamControllerConversation.sink.add(_listConversationDetails);
    }
  }

  Future<dynamic> doSendMessageApiCall(String text, String id) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    return await messageDetailsRepository.doSendMessageApiCall(
        SendMessageRequestHolder(
            conversationType: "Message",
            channel: getDefaultChannel().id,
            contact: id,
            content: SendMessageRequestContentHolder(body: text)),
        isConnectedToInternet,
        Status.PROGRESS_LOADING);
  }

  Future<dynamic> doSubscriptionUpdateConversationDetail(
      String contactNumber,{String channelId}) async {
    isLoading = false;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await messageDetailsRepository.doSubscriptionUpdateConversationDetail(
        streamControllerConversation,
        contactNumber,
        isConnectedToInternet,
        Status.PROGRESS_LOADING,
        channelId: channelId
    );
  }


}
