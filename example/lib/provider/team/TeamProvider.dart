/*
 * *
 *  * Created by Kedar on 7/8/21 10:57 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 6/29/21 7:52 AM
 *
 */

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/provider/common/ps_provider.dart';
import 'package:voice_example/repository/TeamsRepository.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:voice_example/viewobject/model/teams/Teams.dart';
import 'package:voice_example/viewobject/model/teams/addTeams/AddTeamResponse.dart';

class TeamProvider extends Provider {
  TeamProvider({@required TeamRepository teamRepository, int limit = 20})
      : super(teamRepository, limit) {
    this._teamRepository = teamRepository;

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    streamControllerTeams =
        StreamController<Resources<List<Teams>>>.broadcast();
    subscriptionTeams =
        streamControllerTeams.stream.listen((Resources<List<Teams>> resource) {
      _teams = resource;
      if (resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  TeamRepository _teamRepository;
  ValueHolder valueHolder;

  StreamController<Resources<List<Teams>>> streamControllerTeams;
  StreamSubscription<Resources<List<Teams>>> subscriptionTeams;

  Resources<List<Teams>> _teams =
      Resources<List<Teams>>(Status.NO_ACTION, '', null);

  Resources<List<Teams>> get teams => _teams;

  @override
  void dispose() {
    subscriptionTeams.cancel();
    streamControllerTeams.close();
    isDispose = true;
    super.dispose();
  }

  Future<dynamic> doGetTeamsListApiCall() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    Resources<List<Teams>> resources = await _teamRepository.doGetTeamsApiCall(
        limit, isConnectedToInternet, Status.PROGRESS_LOADING);
    streamControllerTeams.sink.add(resources);
    return resources;
  }

  void doDbTeamsSearch(String text) async{
    Resources<List<Teams>> resources = await _teamRepository.doSearchTeamsLocally(text);
    streamControllerTeams.sink.add(resources);
  }


  Future<Resources<AddTeamResponse>> doAddNewTeamApiCall(Map<dynamic, dynamic> jsonMap) async{
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return  await  _teamRepository.doAddNewTeamApiCall(jsonMap, isConnectedToInternet, Status.PROGRESS_LOADING);
  }

}
