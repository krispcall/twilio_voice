import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:voice_example/api/ApiService.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/constant/Constants.dart';
import 'package:voice_example/db/CallRecordingDao.dart';
import 'package:voice_example/db/MessageDetailsDao.dart';
import 'package:voice_example/repository/Common/Respository.dart';
import 'package:voice_example/ui/dashboard/DashboardView.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/holder/request_holder/conversationDetailRequestParamHolder/ConversationDetailRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/conversationDetailRequestParamHolder/ConversationDetailRequestParamHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/conversationDetailRequestParamHolder/SearchConversationRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/conversationDetailRequestParamHolder/SearchConversationRequestParamHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/sendMessageRequestParamHolder/SendMessageRequestHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/subscriptionConversationDetailRequestHolder/SubscriptionUpdateConversationDetailRequestHolder.dart';
import 'package:voice_example/viewobject/model/call/RecentConversationEdges.dart';
import 'package:voice_example/viewobject/model/call/RecentConversationNodes.dart';
import 'package:voice_example/viewobject/model/conversation_detail/ConversationDetailResponse.dart';
import 'package:voice_example/viewobject/model/pagination/PageInfo.dart';
import 'package:voice_example/viewobject/model/sendMessage/SendMessageResponse.dart';
import 'package:voice_example/viewobject/model/subscriptionConversationDetail/SubscriptionConversationDetailResponse.dart';
import 'package:sembast/sembast.dart';

class MessageDetailsRepository extends Repository {
  MessageDetailsRepository(
      {@required ApiService apiService,
      @required MessageDetailsDao messageDetailsDao,
      @required CallRecordingDao callRecordingDao}) {
    this.apiService = apiService;
    this.messageDetailsDao = messageDetailsDao;
    this.callRecordingDao = callRecordingDao;
  }

  String primaryKey = 'id';
  String mapKey = 'map_key';
  String collectionIdKey = 'collection_id';
  String mainProductIdKey = 'main_product_id';
  ApiService apiService;
  MessageDetailsDao messageDetailsDao;
  CallRecordingDao callRecordingDao;
  PageInfo pageInfo;

  void sinkConversationList(
      StreamController<Resources<List<MessageDetailsObjectWithType>>>
          streamControllerEdges,
      Resources<List<MessageDetailsObjectWithType>> resources) {
    if (!streamControllerEdges.isClosed) {
      streamControllerEdges.sink.add(resources);
    }
  }

  Future<dynamic> doConversationDetailByContactApiCall(String clientId,
      String channelId, bool isConnectedToInternet, int limit, Status status,
      {bool isCallRecording = false}) async {
    ConversationDetailRequestHolder recentConversationRequestHolder =
        ConversationDetailRequestHolder(
            contact: clientId,
            channel: channelId,
            param: ConversationDetailRequestParamHolder(first: limit));
    Finder finder = Finder(sortOrders: [SortOrder("node.createdAt", true)]);

    if (isConnectedToInternet) {
      final Resources<ConversationDetailResponse> _resource =
          await apiService.doConversationDetailByContactApiCall(
              recentConversationRequestHolder);

      if (_resource.status == Status.SUCCESS) {
        if (_resource.data.conversationData.error == null) {
          await messageDetailsDao.deleteAll();
          await callRecordingDao.deleteAll();
          List<RecentConversationEdges> list = [];
          List<RecentConversationEdges> callRecordingList = [];
          _resource
              .data.conversationData.recentConversation.recentConversationEdges
              .forEach((element) {
            list.add(RecentConversationEdges(
              cursor: "",
              recentConversationNodes: element.recentConversationNodes,
              id: element.recentConversationNodes.id,
              channelId: getDefaultChannel().id,
              check: false,
              advancedPlayer: AudioPlayer(),
            ));

            ///CallRecording
            var callRecordData = filterCallRecordingData(element);
            if (callRecordData != null) {
              callRecordingList.add(callRecordData);
            }
          });
          await messageDetailsDao.insertAll(primaryKey, list.reversed.toList());
          if (callRecordingList.isNotEmpty) {
            await callRecordingDao.insertAll(
                primaryKey, callRecordingList.reversed.toList());
          }
          pageInfo = _resource.data.conversationData.recentConversation
              .recentConversationPageInfo;

          if (isCallRecording) {
            return await callRecordingDao.getAll(finder: finder);
          } else {
            return await messageDetailsDao.getAll(finder: finder);
          }
        } else {
          return Resources(Status.ERROR,
              _resource.data.conversationData.error.message, null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    }
  }

  ///CallRecording filtering
  RecentConversationEdges filterCallRecordingData(
      RecentConversationEdges element) {
    RecentConversationEdges callRecordingList;
    if (element.recentConversationNodes.conversationType == "Call") {
      if (element.recentConversationNodes.conversationStatus == "COMPLETED") {
        if (element.recentConversationNodes.content.body != null ||
            element.recentConversationNodes.content.transferredAudio != null) {
          var audioPlayer = AudioPlayer();
          var seekDataTotal = "0";
          if (element.recentConversationNodes.content.body != null) {
            audioPlayer.setUrl(element.recentConversationNodes.content.body);
            audioPlayer.onDurationChanged.listen((event) {
              seekDataTotal = event.inSeconds.toString();
            });
          } else if (element.recentConversationNodes.content.transferredAudio !=
              null) {
            audioPlayer.setUrl(
                element.recentConversationNodes.content.transferredAudio);
            audioPlayer.onDurationChanged.listen((event) {
              seekDataTotal = event.inSeconds.toString();
            });
          }

          callRecordingList = RecentConversationEdges(
              cursor: "",
              recentConversationNodes: element.recentConversationNodes,
              id: element.recentConversationNodes.id,
              channelId: getDefaultChannel().id,
              check: false,
              advancedPlayer: AudioPlayer(),
              seekDataTotal: seekDataTotal);
        }
      }
    }
    return callRecordingList;
  }

  Future<dynamic> doPreviousConversationDetailByContactApiCall(String clientId,
      String channelId, bool isConnectedToInternet, int limit, Status status,
      {bool isCallRecording = false}) async {
    if (isConnectedToInternet) {
      Finder finder = Finder(sortOrders: [SortOrder("node.createdAt", true)]);

      if (pageInfo.hasNextPage) {
        ConversationDetailRequestHolder recentConversationRequestHolder =
            ConversationDetailRequestHolder(
                contact: clientId,
                channel: channelId,
                param: ConversationDetailRequestParamHolder(
                  first: limit,
                  after: pageInfo.endCursor,
                ));

        final Resources<ConversationDetailResponse> _resource =
            await apiService.doConversationDetailByContactApiCall(
                recentConversationRequestHolder);

        if (_resource.status == Status.SUCCESS) {
          if (_resource.data.conversationData.error == null) {
            List<RecentConversationEdges> list = [];
            List<RecentConversationEdges> callRecordingList = [];

            _resource.data.conversationData.recentConversation
                .recentConversationEdges
                .forEach((element) {
              list.add(RecentConversationEdges(
                cursor: "",
                recentConversationNodes: element.recentConversationNodes,
                id: element.recentConversationNodes.id,
                channelId: getDefaultChannel().id,
                check: false,
                advancedPlayer: AudioPlayer(),
              ));

              ///call recording
              var callRecordData = filterCallRecordingData(element);
              if (callRecordData != null) {
                callRecordingList.add(callRecordData);
              }
            });

            await messageDetailsDao.insertAll(
                primaryKey, list.reversed.toList());

            //todo call recording list
            if (callRecordingList.isNotEmpty) {
              await callRecordingDao.insertAll(
                  primaryKey, callRecordingList.reversed.toList());
            }

            pageInfo = pageInfo = PageInfo(
                startCursor: pageInfo.startCursor,
                endCursor: _resource.data.conversationData.recentConversation
                    .recentConversationPageInfo.endCursor,
                hasNextPage: _resource.data.conversationData.recentConversation
                    .recentConversationPageInfo.hasNextPage,
                hasPreviousPage: _resource
                    .data
                    .conversationData
                    .recentConversation
                    .recentConversationPageInfo
                    .hasPreviousPage);

            if (isCallRecording) {
              return await callRecordingDao.getAll(finder: finder);
            } else {
              return await messageDetailsDao.getAll(finder: finder);
            }
          } else {
            if (isCallRecording) {
              return await callRecordingDao.getAll(finder: finder);
            } else {
              return await messageDetailsDao.getAll(finder: finder);
            }
          }
        } else {
          if (isCallRecording) {
            return await callRecordingDao.getAll(finder: finder);
          } else {
            return await messageDetailsDao.getAll(finder: finder);
          }
        }
      } else {
        if (isCallRecording) {
          return await callRecordingDao.getAll(finder: finder);
        } else {
          return await messageDetailsDao.getAll(finder: finder);
        }
      }
    }
  }

  Future<dynamic> doNextConversationDetailByContactApiCall(
      String clientId,
      String channelId,
      bool isConnectedToInternet,
      int limit,
      Status status) async {
    if (isConnectedToInternet) {
      Finder finder = Finder(sortOrders: [SortOrder("node.createdAt", true)]);

      // if (pageInfo.hasPreviousPage) {
      //   ConversationDetailRequestHolder recentConversationRequestHolder =
      //   ConversationDetailRequestHolder(
      //       contact: clientId,
      //       channel: channelId,
      //       param: ConversationDetailRequestParamHolder(
      //         first: limit,
      //         before: pageInfo.startCursor,
      //       ));
      //
      //   final Resources<ConversationDetailResponse> _resource =
      //   await apiService.doConversationDetailByContactApiCall(
      //       recentConversationRequestHolder);
      //
      //   if (_resource.status == Status.SUCCESS) {
      //     if (_resource.data.conversationData.error == null) {
      //       List<RecentConversationEdges> list = [];
      //
      //       _resource.data.conversationData.recentConversation
      //           .recentConversationEdges
      //           .forEach((element) {
      //
      //         list.add(RecentConversationEdges(
      //           cursor: "",
      //           recentConversationNodes: element.recentConversationNodes,
      //           id: element.recentConversationNodes.id,
      //           channelId: getDefaultChannel().id,
      //           check: false,
      //           advancedPlayer: AudioPlayer(),
      //         ));
      //       });
      //
      //       await messageDetailsDao.insertAll(
      //           primaryKey, list.reversed.toList());
      //
      //       pageInfo = _resource.data.conversationData.recentConversation
      //           .recentConversationPageInfo;
      //
      //       return await messageDetailsDao.getAll(finder: finder);
      //     } else {
      //       return await messageDetailsDao.getAll(finder: finder);
      //     }
      //   } else {
      //     return await messageDetailsDao.getAll(finder: finder);
      //   }
      // } else {
      //   return await messageDetailsDao.getAll(finder: finder);
      // }
    }
  }

  Future<dynamic> doSendMessageApiCall(SendMessageRequestHolder param,
      bool isConnectedToInternet, Status status) async {
    final Resources<SendMessageResponse> _resource =
        await apiService.doSendMessageApiCall(param);

    if (_resource.status == Status.SUCCESS) {
      if (_resource.data.sendMessage.error == null) {
        DashboardView.ebTransferData.fire(null);
        return Resources(
            Status.SUCCESS, "", _resource.data.sendMessage.messages);
      } else {
        return Resources(
            Status.ERROR, _resource.data.sendMessage.error.message, null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  doSubscriptionUpdateConversationDetail(
      StreamController<Resources<List<MessageDetailsObjectWithType>>>
          streamControllerConversation,
      String clientNumber,
      bool isConnectedToInternet,
      Status status,
      {String channelId}) async {
    SubscriptionUpdateConversationDetailRequestHolder
        subscriptionUpdateConversationDetailRequestHolder =
        SubscriptionUpdateConversationDetailRequestHolder(
      channelId: channelId ?? getDefaultChannel().id,
    );

    if (isConnectedToInternet) {
      final Stream<QueryResult> result =
          await apiService.doSubscriptionUpdateConversationDetail(
              subscriptionUpdateConversationDetailRequestHolder);
      result.listen(
          (event) async {
            DashboardView.ebTransferData.fire(null);
            if (event.data != null) {
              SubscriptionConversationDetailResponse
                  subscriptionConversationDetailResponse =
                  SubscriptionConversationDetailResponse()
                      .fromMap(event.data['updateConversation']);

              if (subscriptionConversationDetailResponse.message.clientNumber ==
                  clientNumber) {
                await messageDetailsDao.updateOrInsert(
                    subscriptionConversationDetailResponse.message.id,
                    RecentConversationEdges().toMap(RecentConversationEdges(
                        cursor: "",
                        recentConversationNodes:
                            subscriptionConversationDetailResponse.message,
                        id: subscriptionConversationDetailResponse.message.id,
                        channelId: channelId ?? getDefaultChannel().id,
                        check: false,
                        advancedPlayer: AudioPlayer())));

                Resources<List<RecentConversationEdges>> list =
                    await messageDetailsDao.getAll(
                        finder: Finder(
                            sortOrders: [SortOrder("node.createdAt", true)]));

                sinkConversationList(streamControllerConversation,
                    Resources(Status.SUCCESS, "", prepareResponse(list.data)));
              } else {
                Resources<List<RecentConversationEdges>> list =
                    await messageDetailsDao.getAll(
                        finder: Finder(
                            sortOrders: [SortOrder("node.createdAt", true)]));

                sinkConversationList(streamControllerConversation,
                    Resources(Status.SUCCESS, "", prepareResponse(list.data)));
              }
            } else {
            }
          },
          onDone: () {

          },
          cancelOnError: true,
          onError: (error) {

          });
    }
  }

  Future<dynamic> doSearchConversationApiCall(
      String clientId,
      String channelId,
      bool isConnectedToInternet,
      int limit,
      Status status,
      String keyword) async {
    SearchConversationRequestHolder searchConversationRequestHolder =
        SearchConversationRequestHolder(
            channel: channelId,
            contact: clientId,
            param: SearchConversationRequestParamHolder(
              first: limit,
              search: Search(columns: ["sms"], value: keyword),
            ));

    if (isConnectedToInternet) {
      final Resources<ConversationDetailResponse> _resource = await apiService
          .searchConversationApiCall(searchConversationRequestHolder);

      if (_resource.status == Status.SUCCESS) {
        if (_resource.data.conversationData.error == null) {
          // await messageDetailsDao.deleteAll();
          // await messageDetailsDao.insertAll(
          //     primaryKey,
          //     _resource.data.conversationData.recentConversation
          //         .recentConversationEdges.reversed
          //         .toList());
          // pageInfo = _resource.data.conversationData.recentConversation
          //     .recentConversationPageInfo;
          // return await messageDetailsDao.getAll();
          return Resources(
              Status.SUCCESS,
              "",
              _resource.data.conversationData.recentConversation
                  .recentConversationEdges);
        } else {
          return Resources(Status.ERROR,
              _resource.data.conversationData.error.message, null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    }
  }

  Future<dynamic> doSearchConversationWithCursorApiCall(
    String clientId,
    String channelId,
    bool isConnectedToInternet,
    int limit,
    Status status,
    String startCursor,
    String endCursor,
  ) async {
    ConversationDetailRequestHolder conversationDetailRequestHolder =
        ConversationDetailRequestHolder(
            contact: clientId,
            channel: channelId,
            param: ConversationDetailRequestParamHolder(
              last: 1000,
              beforeWith: startCursor,
              afterWith: endCursor,
            ));
    // ConversationDetailUsingCursorRequestHolder conversationDetailUsingCursorRequestHolder =
    // ConversationDetailUsingCursorRequestHolder(
    //     channel: channelId,
    //     contact: clientId,
    //     param: SearchConversationUsingCursorRequestParamHolder(
    //      last: limit,
    //       beforeWith: cursor,
    //     ));

    if (isConnectedToInternet) {
      final Resources<ConversationDetailResponse> _resource = await apiService
          .searchConversationWithCursorApiCall(conversationDetailRequestHolder);

      if (_resource.status == Status.SUCCESS) {
        if (_resource.data.conversationData.error == null) {
          await messageDetailsDao.deleteAll();
          await messageDetailsDao.insertAll(
              primaryKey,
              _resource.data.conversationData.recentConversation
                  .recentConversationEdges);
          pageInfo = PageInfo(
              startCursor: _resource.data.conversationData.recentConversation
                  .recentConversationPageInfo.endCursor,
              endCursor: _resource.data.conversationData.recentConversation
                  .recentConversationPageInfo.startCursor,
              hasNextPage: _resource.data.conversationData.recentConversation
                  .recentConversationPageInfo.hasNextPage,
              hasPreviousPage: _resource
                  .data
                  .conversationData
                  .recentConversation
                  .recentConversationPageInfo
                  .hasPreviousPage);
          return await messageDetailsDao.getAll();
          // return Resources<List<MessageDetailsObjectWithType>>(Status.SUCCESS,"",prepareResponse(_resource.data.conversationData.recentConversation
          //     .recentConversationEdges.reversed
          //     .toList()));
          //
          //   _resource.data.conversationData.recentConversation
          //     .recentConversationEdges.reversed
          //     .toList();
        } else {
          return Resources(Status.ERROR,
              _resource.data.conversationData.error.message, null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    }
  }

  List<MessageDetailsObjectWithType> prepareResponse(
      List<RecentConversationEdges> listConversationEdges) {
    List<MessageDetailsObjectWithType> listCallLogs =
        <MessageDetailsObjectWithType>[];
    int i = 0;
    String initialTime;
    String prevConversationType;
    String prevConversationDirection;

    for (RecentConversationEdges data in listConversationEdges) {
      if (initialTime == null) {
        initialTime = DateFormat("yyyy-MM-dd").format(DateFormat("yyyy-MM-dd")
            .parse(data.recentConversationNodes.createdAt.split("T")[0]));

        /*
        *Add initial data to list*/

        listCallLogs.add(MessageDetailsObjectWithType(
            type: "time", time: data.recentConversationNodes.createdAt));
        listCallLogs.add(MessageDetailsObjectWithType(
            type: "",
            messageBoxDecorationType: MessageBoxDecorationType.TOP,
            edges: RecentConversationEdges(
              id: data.recentConversationNodes.id,
              cursor: data.cursor,
              check: false,
              recentConversationNodes: RecentConversationNodes().fromMap(
                  RecentConversationNodes()
                      .toMap(data.recentConversationNodes)),
              advancedPlayer: AudioPlayer(),
            )));

        /*set initial conversation details*/
        prevConversationType = data.recentConversationNodes.conversationType;
        prevConversationDirection = data.recentConversationNodes.direction;
      } else {
        if (data.recentConversationNodes.conversationType == "Message") {
          if (prevConversationType ==
              data.recentConversationNodes.conversationType) {
            if (prevConversationDirection ==
                data.recentConversationNodes.direction) {
              if (initialTime ==
                  DateFormat("yyyy-MM-dd").format(DateFormat("yyyy-MM-dd")
                      .parse(data.recentConversationNodes.createdAt
                          .split("T")[0]))) {
                if (listConversationEdges.length - 1 == i) {
                  listCallLogs.add(MessageDetailsObjectWithType(
                      type: "",
                      messageBoxDecorationType: MessageBoxDecorationType.BOTTOM,
                      edges: RecentConversationEdges(
                        id: data.recentConversationNodes.id,
                        cursor: data.cursor,
                        check: false,
                        recentConversationNodes: RecentConversationNodes()
                            .fromMap(RecentConversationNodes()
                                .toMap(data.recentConversationNodes)),
                        advancedPlayer: AudioPlayer(),
                      )));
                } else {
                  listCallLogs.add(MessageDetailsObjectWithType(
                      type: "",
                      messageBoxDecorationType: MessageBoxDecorationType.MIDDLE,
                      edges: RecentConversationEdges(
                        id: data.recentConversationNodes.id,
                        cursor: data.cursor,
                        check: false,
                        recentConversationNodes: RecentConversationNodes()
                            .fromMap(RecentConversationNodes()
                                .toMap(data.recentConversationNodes)),
                        advancedPlayer: AudioPlayer(),
                      )));
                }
              } else {
                /*hold temp index*/
                int j = i;
                try {
                  /*
                  * Change the background
                  * of preceeding message
                  * checking conversationtype
                  */
                  if (listConversationEdges.length > 0) {
                    if (listConversationEdges[j - 1]
                            .recentConversationNodes
                            .conversationType ==
                        "Message") {
                      if (listCallLogs.length > 0) {
                        listCallLogs[listCallLogs.length - 1]
                                .messageBoxDecorationType =
                            MessageBoxDecorationType.BOTTOM;
                      }
                    }
                  }
                } catch (e) {
                }
                initialTime = DateFormat("yyyy-MM-dd").format(
                    DateFormat("yyyy-MM-dd").parse(
                        data.recentConversationNodes.createdAt.split("T")[0]));
                listCallLogs.add(MessageDetailsObjectWithType(
                    type: "time",
                    time: data.recentConversationNodes.createdAt));

                listCallLogs.add(MessageDetailsObjectWithType(
                    type: "",
                    messageBoxDecorationType: MessageBoxDecorationType.TOP,
                    edges: RecentConversationEdges(
                      id: data.recentConversationNodes.id,
                      cursor: data.cursor,
                      check: false,
                      recentConversationNodes: RecentConversationNodes()
                          .fromMap(RecentConversationNodes()
                              .toMap(data.recentConversationNodes)),
                      advancedPlayer: AudioPlayer(),
                    )));
              }
            } else {
              /*hold index*/
              int j = i;
              /*change the decorationType of text
              Message depending
              on two conversation type
              of two text messages (if two preccding item has
              conversation type message
              then decoration type will be set as
              bottom
              else top)
               of item*/

              try {
                if (listConversationEdges[j - 1]
                        .recentConversationNodes
                        .conversationType ==
                    "Message") {
                  if (listConversationEdges.length > 1) {
                    if (listConversationEdges[j - 2]
                            .recentConversationNodes
                            .conversationType ==
                        "Message") {
                      listCallLogs[listCallLogs.length - 1]
                              .messageBoxDecorationType =
                          MessageBoxDecorationType.BOTTOM;
                    } else {
                      listCallLogs[listCallLogs.length - 1]
                              .messageBoxDecorationType =
                          MessageBoxDecorationType.TOP;
                    }
                  }
                }
              } catch (e) {
              }

              /*add time to dynamic list
              * if not equal*/
              if (initialTime !=
                  DateFormat("yyyy-MM-dd").format(DateFormat("yyyy-MM-dd")
                      .parse(data.recentConversationNodes.createdAt
                          .split("T")[0]))) {
                initialTime = DateFormat("yyyy-MM-dd").format(
                    DateFormat("yyyy-MM-dd").parse(
                        data.recentConversationNodes.createdAt.split("T")[0]));

                listCallLogs.add(MessageDetailsObjectWithType(
                    type: "time",
                    time: data.recentConversationNodes.createdAt));
              }

              listCallLogs.add(MessageDetailsObjectWithType(
                  type: "",
                  messageBoxDecorationType: MessageBoxDecorationType.TOP,
                  edges: RecentConversationEdges(
                    id: data.recentConversationNodes.id,
                    cursor: data.cursor,
                    check: false,
                    recentConversationNodes: RecentConversationNodes().fromMap(
                        RecentConversationNodes()
                            .toMap(data.recentConversationNodes)),
                    advancedPlayer: AudioPlayer(),
                  )));
            }
            prevConversationType =
                data.recentConversationNodes.conversationType;
            prevConversationDirection = data.recentConversationNodes.direction;
          } else {
            /*check prev time with current time of value
            * and seperate the message backgroud
            * according to condition*/

            if (initialTime ==
                DateFormat("yyyy-MM-dd").format(DateFormat("yyyy-MM-dd").parse(
                    data.recentConversationNodes.createdAt.split("T")[0]))) {
              listCallLogs.add(MessageDetailsObjectWithType(
                  type: "",
                  messageBoxDecorationType: MessageBoxDecorationType.TOP,
                  edges: RecentConversationEdges(
                    id: data.recentConversationNodes.id,
                    cursor: data.cursor,
                    check: false,
                    recentConversationNodes: RecentConversationNodes().fromMap(
                        RecentConversationNodes()
                            .toMap(data.recentConversationNodes)),
                    advancedPlayer: AudioPlayer(),
                  )));
            } else {
              /*
              * seperate and add time to
              * dynamic list*/

              initialTime = DateFormat("yyyy-MM-dd").format(
                  DateFormat("yyyy-MM-dd").parse(
                      data.recentConversationNodes.createdAt.split("T")[0]));
              listCallLogs.add(MessageDetailsObjectWithType(
                  type: "time", time: data.recentConversationNodes.createdAt));

              listCallLogs.add(MessageDetailsObjectWithType(
                  type: "",
                  messageBoxDecorationType: MessageBoxDecorationType.TOP,
                  edges: RecentConversationEdges(
                    id: data.recentConversationNodes.id,
                    cursor: data.cursor,
                    check: false,
                    recentConversationNodes: RecentConversationNodes().fromMap(
                        RecentConversationNodes()
                            .toMap(data.recentConversationNodes)),
                    advancedPlayer: AudioPlayer(),
                  )));
            }

            /*set conversation type*/
            prevConversationType =
                data.recentConversationNodes.conversationType;
            prevConversationDirection = data.recentConversationNodes.direction;
          }
        } else {
          /*check the conversationtype of two precceding details
            * and change background type
            * accordint to condition*/
          if (prevConversationType == "Message") {
            if (listCallLogs.length > 1) {
              if (listCallLogs[listCallLogs.length - 2].edges != null &&
                  listCallLogs[listCallLogs.length - 2]
                          .edges
                          .recentConversationNodes
                          .conversationType ==
                      "Message") {
                listCallLogs[listCallLogs.length - 1].messageBoxDecorationType =
                    MessageBoxDecorationType.BOTTOM;
              } else {
                listCallLogs[listCallLogs.length - 1].messageBoxDecorationType =
                    MessageBoxDecorationType.TOP;
              }
            }
          }

          /*check prev time with current time of value
            * and seperate the message backgroud
            * accordint to contition*/

          if (initialTime ==
              DateFormat("yyyy-MM-dd").format(DateFormat("yyyy-MM-dd").parse(
                  data.recentConversationNodes.createdAt.split("T")[0]))) {
            listCallLogs.add(MessageDetailsObjectWithType(
                type: "",
                edges: RecentConversationEdges(
                  id: data.recentConversationNodes.id,
                  cursor: data.cursor,
                  check: false,
                  recentConversationNodes: RecentConversationNodes().fromMap(
                      RecentConversationNodes()
                          .toMap(data.recentConversationNodes)),
                  advancedPlayer: AudioPlayer(),
                )));
          } else {
            /*
              * seperate and add time to
              * dynamic list*/

            initialTime = DateFormat("yyyy-MM-dd").format(
                DateFormat("yyyy-MM-dd").parse(
                    data.recentConversationNodes.createdAt.split("T")[0]));

            listCallLogs.add(MessageDetailsObjectWithType(
                type: "time", time: data.recentConversationNodes.createdAt));

            listCallLogs.add(
                MessageDetailsObjectWithType(
                    type: "",
                    edges: RecentConversationEdges(
                      id: data.recentConversationNodes.id,
                      cursor: data.cursor,
                      check: false,
                      recentConversationNodes: RecentConversationNodes().fromMap(
                          RecentConversationNodes()
                              .toMap(data.recentConversationNodes)),
                      advancedPlayer: AudioPlayer(),
                    )
                )
            );
          }

          /*set conversation type*/
          prevConversationType = data.recentConversationNodes.conversationType;
          prevConversationDirection = data.recentConversationNodes.direction;
        }
      }
      i++;
    }

    return listCallLogs;
  }
}

class MessageDetailsObjectWithType {
  String type;
  RecentConversationEdges edges;
  String time;
  String messageBoxDecorationType;

  MessageDetailsObjectWithType({this.type, this.edges, this.time, this.messageBoxDecorationType});
}
