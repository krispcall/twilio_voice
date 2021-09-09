/*
 * *
 *  * Created by Kedar on 7/8/21 10:57 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/8/21 10:41 AM
 *  * Refactored by Joshan
 *
 */

import 'package:audioplayers/audioplayers.dart';
import 'package:voice_example/viewobject/common/MapObject.dart';
import 'package:voice_example/viewobject/model/call/RecentConversationNodes.dart';

class RecentConversationEdges extends MapObject<RecentConversationEdges> {
  RecentConversationEdges({
    this.cursor,
    this.channelId,
    this.conversationType,
    this.recentConversationNodes,
    this.id,
    this.check,
    this.isPlay = false,
    this.isPlaySeekFinish = false,
    this.advancePlayDefault = true,
    this.advancedPlayer,
    this.seekData = "0",
    this.seekDataTotal = "0",
  });

  String id;
  String cursor;
  String channelId;
  String conversationType;
  RecentConversationNodes recentConversationNodes;
  bool check = false;
  bool isPlaySeekFinish;

  bool isPlay;
  bool advancePlayDefault;
  String seekData;
  String seekDataTotal;
  AudioPlayer advancedPlayer;

  @override
  String getPrimaryKey() {
    return cursor;
  }

  @override
  RecentConversationEdges fromMap(dynamic dynamicData)
  {
    if (dynamicData != null)
    {
      return RecentConversationEdges(
        cursor: dynamicData['cursor'],
        channelId: dynamicData['channelId'],
        conversationType: dynamicData['q'],
        recentConversationNodes:
            RecentConversationNodes().fromMap(dynamicData['node']),
        id: dynamicData['id'],
        check: false,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(RecentConversationEdges object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['cursor'] = object.cursor;
      data['channelId'] = object.channelId;
      data['q'] = object.conversationType;
      data['node'] = object.recentConversationNodes != null
          ? RecentConversationNodes().toMap(object.recentConversationNodes)
          : null;
      data['id'] = object.id;
      data['sorting'] = object.sorting;
      data['check'] = object.check;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<RecentConversationEdges> fromMapList(List<dynamic> dynamicDataList) {
    final List<RecentConversationEdges> basketList =
        <RecentConversationEdges>[];
    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          basketList.add(fromMap(dynamicData));
        }
      }
    }
    return basketList;
  }

  @override
  List<Map<String, dynamic>> toMapList(
      List<RecentConversationEdges> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (RecentConversationEdges data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }

  @override
  List<String> getIdList(List<dynamic> mapList) {
    final List<String> idList = <String>[];
    if (mapList != null) {
      for (dynamic messages in mapList) {
        if (messages != null) {
          idList.add(messages.cursor);
        }
      }
    }
    return idList;
  }

  @override
  List<String> getIdByKeyValue(List<dynamic> mapList, var key, var value) {
    final List<String> filterParamList = <String>[];
    if (mapList != null) {
      for (dynamic clientInfo in mapList) {
        if (RecentConversationEdges().toMap(clientInfo)["$key"] == value) {
          if (clientInfo != null) {
            filterParamList.add(clientInfo.id);
          }
        }
      }
    }
    return filterParamList;
  }
}
