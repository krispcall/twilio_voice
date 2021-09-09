import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/viewobject/model/error/ResponseError.dart';

import 'Json.dart';

class ClientRecording {
  String sTypename;
  ClientRecordings clientRecordings;

  ClientRecording({this.sTypename, this.clientRecordings});

  ClientRecording.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      sTypename = json['__typename'];
      clientRecordings = json['clientRecordings'] != null
          ? new ClientRecordings.fromJson(json['clientRecordings'])
          : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    if (this.clientRecordings != null) {
      data['clientRecordings'] = this.clientRecordings.toJson();
    }
    return data;
  }
}

class ClientRecordings {
  String sTypename;
  int status;
  ClientRecordingsData data;
  ResponseError error;

  ClientRecordings({this.sTypename, this.status, this.data, this.error});

  ClientRecordings.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    status = json['status'];
    data = json['data'] != null
        ? new ClientRecordingsData.fromJson(json['data'])
        : null;
    error = json['error'] != null
        ? new ResponseError().fromMap(json['error'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['error'] = this.error;
    return data;
  }
}

class ClientRecordingsData {
  String sTypename;
  PageInfo pageInfo;
  List<Edges> edges;

  ClientRecordingsData({this.sTypename, this.pageInfo, this.edges});

  ClientRecordingsData.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    pageInfo = json['pageInfo'] != null
        ? new PageInfo.fromJson(json['pageInfo'])
        : null;
    if (json['edges'] != null) {
      edges = new List<Edges>();
      json['edges'].forEach((v) {
        edges.add(new Edges.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    if (this.pageInfo != null) {
      data['pageInfo'] = this.pageInfo.toJson();
    }
    if (this.edges != null) {
      data['edges'] = this.edges.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PageInfo {
  String sTypename;
  String startCursor;
  String endCursor;
  bool hasNextPage;
  bool hasPreviousPage;

  PageInfo(
      {this.sTypename,
      this.startCursor,
      this.endCursor,
      this.hasNextPage,
      this.hasPreviousPage});

  PageInfo.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    startCursor = json['startCursor'];
    endCursor = json['endCursor'];
    hasNextPage = json['hasNextPage'];
    hasPreviousPage = json['hasPreviousPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    data['startCursor'] = this.startCursor;
    data['endCursor'] = this.endCursor;
    data['hasNextPage'] = this.hasNextPage;
    data['hasPreviousPage'] = this.hasPreviousPage;
    return data;
  }
}

class Edges {
  String sTypename;
  String cursor;
  Node node;

  Edges({this.sTypename, this.cursor, this.node});

  Edges.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    cursor = json['cursor'];
    node = json['node'] != null ? new Node.fromJson(json['node']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    data['cursor'] = this.cursor;
    if (this.node != null) {
      data['node'] = this.node.toJson();
    }
    return data;
  }
}

class Node {
  String sTypename;
  String id;
  String createdAt;
  Content content;

  Node({this.sTypename, this.id, this.content});

  Node.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    createdAt = json['createdAt'];
    id = json['id'];
    content =
        json['content'] != null ? new Content.fromJson(json['content']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    data['createdAt'] = this.createdAt;
    data['id'] = this.id;
    if (this.content != null) {
      data['content'] = this.content.toJson();
    }
    return data;
  }
}

class Content {
  String sTypename;
  String body;
  String transferedAudio;
  String duration;
  String callDuration;

  bool isPlaySeekFinish;
  bool isPlay;
  bool advancePlayDefault;
  String seekData;
  String time;
  AudioPlayer advancedPlayer;

  Content({
    this.sTypename,
    this.body,
    this.transferedAudio,
    this.duration,
    this.callDuration,
    this.isPlay = false,
    this.isPlaySeekFinish = false,
    this.advancePlayDefault = true,
    this.advancedPlayer,
    this.time = "",
    this.seekData = "0",
  });

  Content.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    body = json['body'];
    transferedAudio = json['transferedAudio'];
    duration = json['duration'];
    callDuration = json['callDuration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    data['body'] = this.body;
    data['transferedAudio'] = this.transferedAudio;
    data['duration'] = this.duration;
    data['callDuration'] = this.callDuration;
    return data;
  }
}
