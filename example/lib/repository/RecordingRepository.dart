import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/api/ApiService.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/db/CallRecordingDao.dart';
import 'package:voice_example/repository/Common/Respository.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/holder/request_holder/conversationDetailRequestParamHolder/ConversationDetailRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/conversationDetailRequestParamHolder/ConversationDetailRequestParamHolder.dart';
import 'package:voice_example/viewobject/model/recording/callRecords.dart';

class RecordingRepository extends Repository {
  String primaryKey = 'id';
  String mapKey = 'map_key';
  String collectionIdKey = 'collection_id';
  String mainProductIdKey = 'main_product_id';
  ApiService apiService;
  CallRecordingDao callRecordingDao;
  PageInfo pageInfo;

  RecordingRepository(
      {@required ApiService apiService,
      @required CallRecordingDao callRecordingDao}) {
    this.apiService = apiService;
    this.callRecordingDao = callRecordingDao;
  }

  Future<dynamic> doRecordingApiCall(String clientId, String channelId,
      bool isConnectedToInternet, int limit, Status status,
      {bool isCallRecording = false}) async {
    if (isConnectedToInternet) {
      ConversationDetailRequestHolder recentConversationRequestHolder =
          ConversationDetailRequestHolder(
              contact: clientId,
              channel: channelId,
              param: ConversationDetailRequestParamHolder(first: limit));
      final Resources _resource =
          await apiService.doRecordingApiCall(recentConversationRequestHolder);
      ClientRecording data = ClientRecording.fromJson(_resource.data);

      if (_resource.status == Status.SUCCESS) {
        if (data.clientRecordings.error == null) {
          pageInfo = data.clientRecordings.data.pageInfo;
          await callRecordingDao.deleteAll();
          return await Resources(
              Status.SUCCESS, "", data.clientRecordings.data);
        } else {
          return Resources(
              Status.ERROR, data.clientRecordings.error.message, null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    }
  }

  Future<dynamic> doNextRecordingApiCall(String clientId, String channelId,
      bool isConnectedToInternet, int limit, Status status,
      {bool isCallRecording = false}) async {
    if(pageInfo.hasNextPage){
      if (isConnectedToInternet) {
        ConversationDetailRequestHolder recentConversationRequestHolder =
        ConversationDetailRequestHolder(
            contact: clientId,
            channel: channelId,
            param: ConversationDetailRequestParamHolder(
              first: limit,
              after: pageInfo.endCursor,
            ));
        final Resources _resource =
        await apiService.doRecordingApiCall(recentConversationRequestHolder);
        ClientRecording data = ClientRecording.fromJson(_resource.data);
        if (_resource.status == Status.SUCCESS) {
          if (data.clientRecordings.error == null) {
            pageInfo = data.clientRecordings.data.pageInfo;
            return await Resources(
                Status.SUCCESS, "", data.clientRecordings.data);
          } else {
            return Resources(
                Status.ERROR, data.clientRecordings.error.message, null);
          }
        } else {
          return Resources(Status.ERROR, Utils.getString("serverError"), null);
        }
      }
    }
  }
}
