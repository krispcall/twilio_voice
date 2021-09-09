/*
 * *
 *  * Created by Kedar on 7/20/21 2:24 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/20/21 2:24 PM
 *  
 */

import 'package:voice_example/viewobject/common/Object.dart';
import 'package:voice_example/viewobject/model/channel/ChannelData.dart';

class ChannelResponse extends Object<ChannelResponse> {
  ChannelResponse({
    this.channel,
  });

  ChannelData channel;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  ChannelResponse fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ChannelResponse(
          channel: ChannelData().fromMap(dynamicData['channels']));
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(ChannelResponse object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['channels'] = ChannelData().toMap(object.channel);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ChannelResponse> fromMapList(List<dynamic> dynamicDataList) {
    final List<ChannelResponse> userData = <ChannelResponse>[];
    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          userData.add(fromMap(dynamicData));
        }
      }
    }
    return userData;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<ChannelResponse> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (ChannelResponse data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
