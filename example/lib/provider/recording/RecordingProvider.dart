import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/provider/common/ps_provider.dart';
import 'package:voice_example/repository/RecordingRepository.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/model/recording/callRecords.dart';

class RecordingProvider extends Provider {
  RecordingRepository recordingRepository;

  StreamController<Resources> streamControllerRecordingConversation;
  StreamController<Resources> streamControllerRecordingPagination;

  ///Data
  Resources _listRecordingConversationDetails =
  Resources(Status.NO_ACTION, '', null);

  Resources get listRecordingConversationDetails =>
      _listRecordingConversationDetails;

  ///Pagination
  Resources _recordingConversationPagination =
  Resources(Status.NO_ACTION, '', null);

  Resources get recordingConversationPagination =>
      _recordingConversationPagination;

  RecordingProvider(
      {@required RecordingRepository recordingRepository, int limit = 0})
      : super(recordingRepository, limit) {
    this.recordingRepository = recordingRepository;
    isDispose = false;

    streamControllerRecordingConversation =
        StreamController<Resources>.broadcast();

    streamControllerRecordingPagination =
        StreamController<Resources>.broadcast();
  }

  @override
  void dispose() {
    streamControllerRecordingConversation.close();
    streamControllerRecordingPagination.close();

    isDispose = true;
    super.dispose();
  }

  Future<dynamic> doRecordingApiCall(String contactId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    Resources response = await recordingRepository.doRecordingApiCall(
        contactId,
        getDefaultChannel().id,
        isConnectedToInternet,
        1000,
        Status.PROGRESS_LOADING,
        isCallRecording: true);
    if (response.status == Status.SUCCESS) {
      checkPaginationAvailability(response.data);
      filter(response.data, false);
    } else {
      streamControllerRecordingConversation.sink
          .add(Resources(Status.ERROR, Utils.getString("serverError"), null));
    }
  }

  Future<dynamic> doNextRecordingApiCall(String contactId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();


    _listRecordingConversationDetails =
        Resources(Status.PROGRESS_LOADING, "", _listRecordingConversationDetails.data);
    streamControllerRecordingConversation.sink.add(_listRecordingConversationDetails);


    Resources response = await recordingRepository.doNextRecordingApiCall(
        contactId,
        getDefaultChannel().id,
        isConnectedToInternet,
        1000,
        Status.PROGRESS_LOADING,
        isCallRecording: true);

    if (response.status == Status.SUCCESS) {
      checkPaginationAvailability(response.data);
      filter(response.data, true);
    } else {
      streamControllerRecordingConversation.sink
          .add(Resources(Status.ERROR, Utils.getString("serverError"), null));
    }
  }

  checkPaginationAvailability(ClientRecordingsData data) {
    _recordingConversationPagination =
        Resources(Status.SUCCESS, "", data.pageInfo);
    streamControllerRecordingPagination.sink
        .add(_recordingConversationPagination);
  }

  filter(ClientRecordingsData data, bool appendData) {
    List<Content> callRecordingList = [];
    if (appendData) {
      callRecordingList
          .addAll(_listRecordingConversationDetails.data as List<Content>);
    }
    if (data.edges.length > 0) {
      data.edges.forEach((element) {
        // if (((element.node.content.body != null &&
        //         element.node.content.duration != null) ||
        //     (element.node.content.transferedAudio != null &&
        //         element.node.content.callDuration != null))){}

        callRecordingList.add(Content(
          sTypename: element.node.content.sTypename,
          body: element.node.content.body,
          transferedAudio: element.node.content.transferedAudio,
          duration: element.node.content.duration,
          callDuration: element.node.content.callDuration,
          advancedPlayer: AudioPlayer(),
          time: element.node.createdAt
        ));
      });
    }
    _listRecordingConversationDetails =
        Resources(Status.SUCCESS, "", callRecordingList);

    streamControllerRecordingConversation.sink
        .add(_listRecordingConversationDetails);
  }
}
