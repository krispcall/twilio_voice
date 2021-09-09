/*
 * *
 *  * Created by Kedar on 7/29/21 11:47 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/29/21 11:47 AM
 *  
 */

import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/db/NumberDao.dart';
import 'package:voice_example/db/TeamDao.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/api/ApiService.dart';
import 'package:voice_example/repository/Common/Respository.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/model/numbers/NumberResponse.dart';
import 'package:voice_example/viewobject/model/numbers/Numbers.dart';
import 'package:voice_example/viewobject/model/teams/Teams.dart';
import 'package:voice_example/viewobject/model/teams/TeamsResponse.dart';
import 'package:sembast/sembast.dart';

class MyNumberRepository extends Repository {
  MyNumberRepository({
    @required ApiService apiService,
    @required NumberDao teamDao,
  }) {
    this.apiService = apiService;
    this._numbersDao = teamDao;
  }

  ApiService apiService;
  NumberDao _numbersDao;
  String primaryKey = 'id';

  Future<Resources<List<Numbers>>> doSearchMyNumbersLocally(String text) async {
    Finder finder = Finder(
        filter: Filter.or([
      Filter.matchesRegExp('name', RegExp('$text', caseSensitive: false)),
      Filter.matchesRegExp('number', RegExp('$text', caseSensitive: false))
    ]));
    Resources<List<Numbers>> listTags = await _numbersDao.getAll(finder: finder);
    return listTags;
  }

  doGetMyNumbersListApiCall(
      int limit, bool isConnectedToInternet, Status status) async {
    final Resources<NumberResponse> _resource = await apiService.getMyNumbers();

    if (_resource.data != null &&
        _resource.data.data != null &&
        _resource.data.data.status == 200) {
      if (_resource.data.data.error == null) {
        if (_resource.data.data.numbers != null) {
          _numbersDao.deleteAll();
          _numbersDao.insertAll(primaryKey, _resource.data.data.numbers);
          return await _numbersDao.getAll();
        } else {
          return await _numbersDao.getAll();
        }
      } else {
        return await _numbersDao.getAll();
      }
    } else {
      return await _numbersDao.getAll();
    }
  }
}
