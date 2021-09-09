import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:graphql/client.dart';
import 'package:voice_example/db/CallLogDao.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/holder/request_holder/callLogsRequestParamHolder/SearchInputRequestParamHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/contactPinUnpinRequestParamHolder/ContactPinUnpinRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/recentConversationRequestParamHolder/RecentConverstaionRequestParamHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/subscriptionConversationDetailRequestHolder/SubscriptionUpdateConversationDetailRequestHolder.dart';
import 'package:voice_example/viewobject/model/call/NewCountResponse.dart';
import 'package:voice_example/viewobject/model/call/RecentConversationEdges.dart';
import 'package:voice_example/viewobject/model/call/RecentConversationNodes.dart';
import 'package:voice_example/viewobject/model/call/RecentConversationResponse.dart';
import 'package:voice_example/viewobject/holder/request_holder/recentConversationRequestParamHolder/RecentConversationRequestHolder.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/api/ApiService.dart';
import 'package:voice_example/repository/Common/Respository.dart';
import 'package:voice_example/viewobject/model/pagination/PageInfo.dart';
import 'package:voice_example/viewobject/model/pinContact/PinContactResponse.dart';
import 'package:sembast/sembast.dart';

class CallLogRepository extends Repository {
  CallLogRepository(
      {@required ApiService apiService, @required CallLogDao callLogDao}) {
    this.apiService = apiService;
    this.callLogDao = callLogDao;
  }

  String primaryKey = 'id';
  ApiService apiService;
  CallLogDao callLogDao;
  PageInfo pageInfo;

  Future<dynamic> doCallLogsApiCall(String channelId, String callLogType,
      int limit, bool isConnectedToInternet, Status status,
      {bool isLoadFromServer = true}) async {
    RecentConversationRequestHolder callLogParamHolder =
        RecentConversationRequestHolder(
      channel: channelId,
      param: RecentConversationRequestParamHolder(
        conversationType: callLogType,
        first: limit,
      ),
    );

    if (isConnectedToInternet) {
      final Resources<RecentConversationResponse> _resource =
          await apiService.doCallLogsApiCall(callLogParamHolder);

      if (_resource.status == Status.SUCCESS) {
        if (_resource.data.recentConversationData.error == null) {
          await callLogDao.deleteAll();
          await callLogDao.insertAll(
              primaryKey,
              _resource.data.recentConversationData.recentConversation
                  .recentConversationEdges);
          pageInfo = _resource.data.recentConversationData.recentConversation
              .recentConversationPageInfo;
          return Resources(
              Status.SUCCESS,
              "",
              _resource.data.recentConversationData.recentConversation
                  .recentConversationEdges);
        } else {
          return Resources(Status.ERROR,
              _resource.data.recentConversationData.error.message, null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    }
  }

  Future<dynamic> doNextCallLogsApiCall(String channelId, String callLogType,
      int limit, bool isConnectedToInternet, Status status,
      {bool isLoadFromServer = true}) async {
    if (isConnectedToInternet) {
      if (pageInfo.hasNextPage) {
        RecentConversationRequestHolder callLogParamHolder =
            RecentConversationRequestHolder(
                channel: channelId,
                param: RecentConversationRequestParamHolder(
                  conversationType: callLogType,
                  first: limit,
                  after: pageInfo.endCursor,
                ));

        final Resources<RecentConversationResponse> _resource =
            await apiService.doCallLogsApiCall(callLogParamHolder);
        if (_resource.status == Status.SUCCESS) {
          if (_resource.data.recentConversationData.error == null) {
            await callLogDao.insertAll(
                primaryKey,
                _resource.data.recentConversationData.recentConversation
                    .recentConversationEdges);
            pageInfo = _resource.data.recentConversationData.recentConversation
                .recentConversationPageInfo;
            return Resources(
                Status.SUCCESS,
                "",
                _resource.data.recentConversationData.recentConversation
                    .recentConversationEdges);
          } else {
            return Resources(Status.ERROR,
                _resource.data.recentConversationData.error.message, null);
          }
        } else {
          return Resources(Status.ERROR, "", _resource.data);
        }
      } else {
        return Resources(Status.ERROR, "", null);
      }
    }
  }

  Future<dynamic> doCallLogsSmsOnlyApiCall(String channelId, String callLogType,
      int limit, bool isConnectedToInternet, Status status,
      {bool isLoadFromServer = true}) async {
    RecentConversationRequestHolder callLogParamHolder =
        RecentConversationRequestHolder(
            channel: channelId,
            param: RecentConversationRequestParamHolder(
                conversationType: callLogType,
                first: limit,
                search: SearchInputRequestParamHolder(
                  columns: [
                    "sms",
                  ],
                  value: "",
                )));

    if (isConnectedToInternet) {
      final Resources<RecentConversationResponse> _resource =
          await apiService.doCallLogsApiCall(callLogParamHolder);

      if (_resource.status == Status.SUCCESS) {
        if (_resource.data.recentConversationData.error == null) {
          await callLogDao.deleteAll();
          await callLogDao.insertAll(
              primaryKey,
              _resource.data.recentConversationData.recentConversation
                  .recentConversationEdges);
          pageInfo = _resource.data.recentConversationData.recentConversation
              .recentConversationPageInfo;
          return Resources(
              Status.SUCCESS,
              "",
              _resource.data.recentConversationData.recentConversation
                  .recentConversationEdges);
        } else {
          return Resources(Status.ERROR,
              _resource.data.recentConversationData.error.message, null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    }
  }

  Future<dynamic> doNextCallLogsSmsOnlyApiCall(String channelId,
      String callLogType, int limit, bool isConnectedToInternet, Status status,
      {bool isLoadFromServer = true}) async {
    if (isConnectedToInternet) {
      if (pageInfo.hasNextPage) {
        RecentConversationRequestHolder callLogParamHolder =
            RecentConversationRequestHolder(
                channel: channelId,
                param: RecentConversationRequestParamHolder(
                    conversationType: callLogType,
                    first: limit,
                    after: pageInfo.endCursor,
                    search: SearchInputRequestParamHolder(
                      columns: [
                        "sms",
                      ],
                      value: "",
                    )));

        final Resources<RecentConversationResponse> _resource =
            await apiService.doCallLogsApiCall(callLogParamHolder);
        if (_resource.status == Status.SUCCESS) {
          if (_resource.data.recentConversationData.error == null) {
            await callLogDao.insertAll(
                primaryKey,
                _resource.data.recentConversationData.recentConversation
                    .recentConversationEdges);
            pageInfo = _resource.data.recentConversationData.recentConversation
                .recentConversationPageInfo;
            return Resources(
                Status.SUCCESS,
                "",
                _resource.data.recentConversationData.recentConversation
                    .recentConversationEdges);
          } else {
            return Resources(Status.ERROR,
                _resource.data.recentConversationData.error.message, null);
          }
        } else {
          return Resources(Status.ERROR, "", _resource.data);
        }
      } else {
        return Resources(Status.ERROR, "", null);
      }
    }
  }

  Future<dynamic> doContactPinUnpinApiCall(ContactPinUnpinRequestHolder params,
      int limit, bool isConnectedToInternet, Status status,
      {bool isLoadFromServer = true}) async {
    if (isConnectedToInternet) {
      final Resources<PinContactResponse> _resource =
          await apiService.doContactPinUnpinApiCall(params);

      if (_resource.status == Status.SUCCESS) {
        if (_resource.data.pinContactData.error == null) {
          return Resources(Status.SUCCESS, "",
              _resource.data.pinContactData.pinContact.status);
        } else {
          return Resources(
              Status.ERROR, _resource.data.pinContactData.error.message, null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    }
  }

  Future<Resources<List<RecentConversationEdges>>>
      getAllCallLogsFromDb() async {
    Resources<List<RecentConversationEdges>> result = await callLogDao.getAll();
    return result;
  }

  Future<dynamic> doCallLogsSearchFromDb(
      String query, bool isConnectedToInternet, int limit, Status status,
      {bool isLoadFromServer = true}) async {
    Filter filterContact = Filter.matchesRegExp(
        'node.clientInfo.name', RegExp(query, caseSensitive: false));
    Filter filterSMS = Filter.matchesRegExp(
        'node.content.body', RegExp(query, caseSensitive: false));
    Finder finder = Finder(filter: Filter.or([filterContact, filterSMS]));
    Resources<List<RecentConversationEdges>> result =
        await callLogDao.getAll(finder: finder);
    return result;
  }

  getNewCounts(StreamController<Resources<int>> streamControllerNewCount,
      bool isConnectedToInternet, Map<String, dynamic> jsonMap) async {
    if (isConnectedToInternet) {
      final Resources<NewCountResponse> _resource =
          await apiService.getNewCountOfCallLog(jsonMap);
      if (_resource.status == Status.SUCCESS) {
        if (_resource.data.newCount != null &&
            _resource.data.newCount.error == null) {
          streamControllerNewCount.sink
              .add(Resources(Status.ERROR, "", _resource.data.newCount.data));
        } else {
          streamControllerNewCount.sink.add(Resources(
              Status.ERROR, _resource.data.newCount.error.message, 0));
        }
      } else {
        streamControllerNewCount.sink.add(
            Resources(Status.ERROR, _resource.data.newCount.error.message, 0));
      }
    }
  }

  doSubscriptionUpdateConversationDetail(
    StreamController<Resources<List<RecentConversationEdges>>>
        streamControllerCallLogs,
    bool isConnectedToInternet,
    Status status,
  ) async {
    SubscriptionUpdateConversationDetailRequestHolder
        subscriptionUpdateConversationDetailRequestHolder =
        SubscriptionUpdateConversationDetailRequestHolder(
      channelId: getDefaultChannel().id,
    );

    if (isConnectedToInternet) {
      final Stream<QueryResult> result =
          await apiService.doSubscriptionUpdateConversationDetail(
              subscriptionUpdateConversationDetailRequestHolder);
      result.listen(
          (event) async {
            if (event != null && event.data != null) {
              RecentConversationNodes recentConversationNodes =
                  RecentConversationNodes()
                      .fromMap(event.data["updateConversation"]["message"]);
              if (recentConversationNodes != null) {
                RecentConversationEdges recentConversationEdges =
                    RecentConversationEdges(
                  cursor: "",
                  recentConversationNodes: recentConversationNodes,
                  id: recentConversationNodes.id,
                  channelId: getDefaultChannel().id,
                  check: false,
                  advancedPlayer: AudioPlayer(),
                );

                Filter filter = Filter.matchesRegExp(
                    'node.clientNumber',
                    RegExp(
                        "\\" +
                            recentConversationEdges
                                .recentConversationNodes.clientNumber,
                        caseSensitive: false));
                Finder finder = Finder(filter: filter);
                Resources<RecentConversationEdges> toRemove =
                    await callLogDao.getOne(finder: finder);
                Resources<List<RecentConversationEdges>> resources =
                    await callLogDao.getAll();

                resources.data.removeWhere((item) =>
                    item.recentConversationNodes.clientNumber ==
                    toRemove.data.recentConversationNodes.clientNumber);
                resources.data.insert(0, recentConversationEdges);
                callLogDao.insertAll(primaryKey, resources.data);
                streamControllerCallLogs.add(resources);
              }
            }
          },

          onDone: () {
          },
          cancelOnError: true,
          onError: (error) {
          });
    }
  }
}
