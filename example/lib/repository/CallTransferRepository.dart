import 'package:flutter/cupertino.dart';
import 'package:voice_example/api/ApiService.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/repository/Common/Respository.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/ResponseData.dart';

class CallTransferRepository extends Repository {
  CallTransferRepository({@required ApiService service}) {
    apiService = service;
  }

  ApiService apiService;

  Future<Resources<ResponseData>> callTransfer(
      String direction,
      String conversationId,
      String callerId,
      String destination,
      bool isConnectedToInternet,
      Status isloading) async {
    {

      final Resources<ResponseData> _resource = await apiService.transferCall(
          Map.from({
            "data":
            {
              "direction": "${direction}",
              "conversationId": "${conversationId}",
              "callerId": "${callerId}",
              "destination": "${destination}",
            }
          })
      );

      if (_resource.status == Status.SUCCESS)
      {
        if (_resource.data.error == null)
        {
          return Resources(Status.SUCCESS, "", _resource.data);
        }
        else
        {
          return Resources(Status.ERROR, _resource.data.error.message, null);
        }
      }
      else
      {
        return Resources(Status.ERROR, Utils.getString("Transfer Failed"), null);
      }
    }
  }
}
