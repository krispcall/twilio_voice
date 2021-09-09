
import 'package:flutter/material.dart';
import 'package:voice_example/api/ApiService.dart';
import 'package:voice_example/repository/Common/Respository.dart';

class NotificationRepository extends Repository {
  NotificationRepository({@required ApiService service}) {
    apiService = service;
  }

  ApiService apiService;
}
