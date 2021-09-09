/*
 * *
 *  * Created by Kedar on 7/29/21 11:47 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/29/21 11:47 AM
 *  
 */

import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/db/TeamDao.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/api/ApiService.dart';
import 'package:voice_example/repository/Common/Respository.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/model/teams/Teams.dart';
import 'package:voice_example/viewobject/model/teams/TeamsResponse.dart';
import 'package:voice_example/viewobject/model/teams/addTeams/AddTeamResponse.dart';
import 'package:sembast/sembast.dart';

class TeamRepository extends Repository {
  TeamRepository({
    @required ApiService apiService,
    @required TeamDao teamDao,
  }) {
    this.apiService = apiService;
    this._teamDao = teamDao;
  }

  ApiService apiService;
  TeamDao _teamDao;
  String primaryKey = 'id';

  Future<Resources<List<Teams>>> doGetTeamsApiCall(
      int limit, bool isConnectedToInternet, Status status) async {
    final Resources<TeamsResponse> _resource =
        await apiService.getTeamList(Map.from({}));

    if (_resource.data != null &&
        _resource.data.data != null &&
        _resource.data.data.status == 200) {
      if (_resource.data.data.error == null) {
        if (_resource.data.data.teams != null) {
          _teamDao.deleteAll();
          _teamDao.insertAll(primaryKey, _resource.data.data.teams);
          return await new Resources(
              Status.SUCCESS, "", _resource.data.data.teams);
        } else {
          return await _teamDao.getAll();
        }
      } else {
        return await _teamDao.getAll();
      }
    } else {
      return await _teamDao.getAll();
    }
  }

  Future<Resources<List<Teams>>> doSearchTeamsLocally(String text) async {
    Finder finder = Finder(
        filter: Filter.matchesRegExp(
            'name', RegExp('$text', caseSensitive: false)));
    Resources<List<Teams>> listTags = await _teamDao.getAll(finder: finder);
    return listTags;
  }

  Future<Resources<AddTeamResponse>> doAddNewTeamApiCall(
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      Status status) async {
    if (isConnectedToInternet) {
      Resources<AddTeamResponse> _resources =
          await apiService.doAddTeamApiCall(jsonMap);
      if (_resources.data != null && _resources.data.data != null) {
        if (_resources.data.data.error == null) {
          return Resources(Status.SUCCESS, "", _resources.data);
        } else {
          return Resources(
              Status.SUCCESS, _resources.data.data.error.message, null);
        }
      } else {
        return Future.value(
            Resources(Status.ERROR, Utils.getString("serverError"), null));
      }
    } else {
      return Future.value(
          Resources(Status.ERROR, Utils.getString("noInternet"), null));
    }
  }
}
