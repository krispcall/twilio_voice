import 'dart:async';

import 'package:graphql/client.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/db/MemberDao.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/api/ApiService.dart';
import 'package:voice_example/repository/Common/Respository.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/holder/request_holder/callLogsRequestParamHolder/PageRequestParamHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/pageRequestParamHolder/PageRequestHolder.dart';
import 'package:voice_example/viewobject/model/invite/InviteMemberResponse.dart';
import 'package:voice_example/viewobject/model/members/MemberEdges.dart';
import 'package:voice_example/viewobject/model/members/MembersResponse.dart';
import 'package:voice_example/viewobject/model/members/SubscriptionOnlineMemberStatus.dart';
import 'package:sembast/sembast.dart';

class MemberRepository extends Repository {
  MemberRepository({
    @required ApiService apiService,
    @required MemberDao memberDao,
  }) {
    this.apiService = apiService;
    this.memberDao = memberDao;
  }

  ApiService apiService;
  MemberDao memberDao;

  String primaryKey = "id";

  Future<dynamic> doGetAllWorkspaceMembersApiCall(
      bool isConnectedToInternet, int limit, Status status,
      {bool isLoadFromServer = true}) async {
    if (isConnectedToInternet) {
      PageRequestHolder pageRequestHolder = PageRequestHolder(
          param: PageRequestParamHolder(
        //TODO static limit no paging for member
        first: 1000,
        order: "asc",
      ));
      final Resources<MembersResponse> _resource =
          await apiService.doGetAllWorkspaceMembersApiCall(pageRequestHolder);

      if (_resource.status == Status.SUCCESS) {
        if (_resource.data.memberResponseData.error == null) {
          await memberDao.deleteAll();
          await memberDao.insertAll(primaryKey,
              _resource.data.memberResponseData.memberData.memberEdges);
          return Resources(Status.SUCCESS, "",
              _resource.data.memberResponseData.memberData.memberEdges);
        } else {
          return Resources(
              Status.ERROR,
              _resource.data.memberResponseData.error.message,
              []);
        }
      } else {
        return Resources(
            Status.ERROR,
            _resource.data.memberResponseData.error.message,
            []);
      }
    } else {
      return Resources(
          Status.ERROR,
          '',
          []);
    }
  }

  Future<Resources<List<MemberEdges>>> getAllMembersFromDb() async {
    Resources<List<MemberEdges>> result = await memberDao.getAll();
    return result;
  }

  Future<dynamic> doSearchMemberFromDb(
      String query, bool isConnectedToInternet, int limit, Status status,
      {bool isLoadFromServer = true}) async {
    Filter filterFirstName = Filter.matchesRegExp(
        'node.firstname', RegExp(query, caseSensitive: false));
    Filter filterLastName = Filter.matchesRegExp(
        'node.lastname', RegExp(query, caseSensitive: false));

    Finder finder =
        Finder(filter: Filter.or([filterFirstName, filterLastName]));
    Resources<List<MemberEdges>> result =
        await memberDao.getAll(finder: finder);
    return result;
  }

  Future<Resources> inviteUserToWorkSpace(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, Status progress_loading) async {
    final Resources<InviteMemberResponse> _resource =
        await apiService.inviteUserToWorkSpace(jsonMap);
    if (_resource.data != null && _resource.data.data != null) {
      if (_resource.data.data.error == null) {
        if (_resource.data != null && _resource.data.data != null) {
          return Resources(Status.SUCCESS, _resource.data.data.data['message'],
              _resource.data);
        } else {
          return Resources(
              Status.ERROR, _resource.data.data.error.message, null);
        }
      } else {
        return Resources(Status.ERROR, _resource.data.data.error.message, null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  doSubscriptionOnlineMemberStatus(
    StreamController<Resources<List<MemberEdges>>>
        streamController,
    String workspace,
    bool isConnectedToInternet,
    Status status,
  ) async {
    if (isConnectedToInternet) {
      MemberEdges filterMember = MemberEdges();
      final Stream<QueryResult> result =
          await apiService.doSubscriptionOnlineMemberStatus(workspace);
      result.listen(
          (event) async {
            if (event.data != null) {
              Resources<List<MemberEdges>> result = await memberDao.getAll();
              SubscriptionOnlineMemberStatusResponse
                  subscriptionOnlineMemberStatusResponse =
                  SubscriptionOnlineMemberStatusResponse()
                      .fromMap(event.data['onlineMemberStatus']);

              List<MemberEdges> filterList = result.data.where((data) {
                if (data.members.id ==
                    subscriptionOnlineMemberStatusResponse.message.id) {
                  return true;
                } else {
                  return false;
                }
              }).toList();
              if(filterList.length > 0){
                filterMember = filterList.first;
                filterMember.members.online =
                    subscriptionOnlineMemberStatusResponse.message.online;
                await memberDao.update(filterMember,
                    finder: Finder(
                        filter: Filter.matchesRegExp(
                            'node.id',
                            RegExp(
                                subscriptionOnlineMemberStatusResponse.message.id,
                                caseSensitive: false))));
                Resources<List<MemberEdges>> updatedResources = await memberDao.getAll();
                if (!streamController.isClosed) {
                  streamController.sink.add(Resources(Status.SUCCESS, "",updatedResources.data));
                }
                return Resources(Status.SUCCESS, "",updatedResources.data);
              }else{
                Resources(Status.ERROR, "",[]);
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


}
