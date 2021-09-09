

import 'package:flutter/cupertino.dart';
import 'package:voice_example/api/ApiService.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/repository/Common/Respository.dart';
import 'package:voice_example/viewobject/model/recording/callRecord.dart';

class CallRecordRepository extends Repository {
  CallRecordRepository({@required ApiService service}) {
    apiService = service;
  }

  ApiService apiService;

  Future<Resources<CallRecordResponse>> callRecord(
      String action,
      String callSid,
      String direction,
      bool isConnectedToInternet,
      Status isloading) async {
    {
      final Resources<CallRecordResponse> _resource =
      await apiService.callRecord(Map.from({
        "action": "${action}",
        "call_sid": "${callSid}",
        "direction": "${direction}"
      }));

      if (_resource.status == Status.SUCCESS) {
        if (_resource.data.callRecord.error == null) {
          return Resources(Status.SUCCESS, "", _resource.data);
        } else {
          return Resources(Status.ERROR, _resource.data.callRecord.error.message, null);
        }
      } else {
        return Resources(Status.ERROR, _resource.data.callRecord.error.message, _resource.data);
      }
    }
  }
}
