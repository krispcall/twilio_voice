import 'dart:async';

import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/provider/common/ps_provider.dart';
import 'package:voice_example/repository/MemberRepository.dart';
import 'package:voice_example/repository/MessageDetailsRepository.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:voice_example/viewobject/model/members/MemberEdges.dart';

class MemberProvider extends Provider
{
  MemberProvider({
    @required MemberRepository memberRepository,
    int limit = 0
  }) : super(memberRepository, limit)
  {
    this.memberRepository = memberRepository;
    streamControllerMemberEdges = StreamController<Resources<List<MemberEdges>>>.broadcast();
    subscriptionMemberEdges = streamControllerMemberEdges.stream.listen((Resources<List<MemberEdges>> resource)
    {
      _memberEdges = resource;

      if (resource.status != Status.BLOCK_LOADING && resource.status != Status.PROGRESS_LOADING)
      {
        isLoading = false;
      }

      if (!isDispose)
      {
        notifyListeners();
      }
    });

  }

  MemberRepository memberRepository;
  StreamController<Resources<List<MemberEdges>>> streamControllerMemberEdges;
  StreamSubscription<Resources<List<MemberEdges>>> subscriptionMemberEdges;
  Resources<List<MemberEdges>> _memberEdges = Resources<List<MemberEdges>>(Status.NO_ACTION, '', null);
  Resources<List<MemberEdges>> get memberEdges => _memberEdges;
  Resources<List<MessageDetailsObjectWithType>> _listConversationDetails =
  Resources<List<MessageDetailsObjectWithType>>(Status.NO_ACTION, '', null);
  Resources<List<MessageDetailsObjectWithType>> get listConversationDetails =>
      _listConversationDetails;

  @override
  void dispose()
  {
    streamControllerMemberEdges.close();
    subscriptionMemberEdges.cancel();
    isDispose = true;
    super.dispose();
  }

  Future<dynamic> doGetAllWorkspaceMembersApiCall() async
  {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _memberEdges = await memberRepository.doGetAllWorkspaceMembersApiCall(isConnectedToInternet, limit, Status.PROGRESS_LOADING);

    if(memberEdges!=null){
      streamControllerMemberEdges.sink.add(_memberEdges);
    }
    return _memberEdges;
  }

  Future<dynamic> getAllMembersFromDb() async
  {
    Resources<List<MemberEdges>> result = await memberRepository.getAllMembersFromDb();
    _memberEdges.data.clear();
    _memberEdges.data.addAll(result.data);
    streamControllerMemberEdges.sink.add(_memberEdges);
    return _memberEdges.data;
  }

  Future<dynamic> doSearchMemberFromDb(String query) async
  {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    Resources<List<MemberEdges>> result = await memberRepository.doSearchMemberFromDb(query, isConnectedToInternet, limit, Status.PROGRESS_LOADING);
    if(_memberEdges!=null && _memberEdges.data!=null)
    {
      _memberEdges.data.clear();
      _memberEdges.data.addAll(result.data);
      streamControllerMemberEdges.sink.add(_memberEdges);
      return _memberEdges.data;
    }
    else
    {
      Resources<List<MemberEdges>> result = await memberRepository.getAllMembersFromDb();

      _memberEdges?.data?.clear();
      _memberEdges?.data?.addAll(result.data);
      streamControllerMemberEdges.sink.add(_memberEdges);
      return _memberEdges.data;
    }
  }

  Future<Resources> inviteUserToWorkSpace(Map<dynamic, dynamic> jsonMap) async{
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return  await  memberRepository.inviteUserToWorkSpace(jsonMap, isConnectedToInternet, Status.PROGRESS_LOADING);
  }

  Future<dynamic> doSubscriptionOnlineMemberStatusDetail(String workspace) async
  {
    isLoading = false;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    var _memberEdges = await memberRepository.doSubscriptionOnlineMemberStatus(streamControllerMemberEdges,workspace, isConnectedToInternet, Status.PROGRESS_LOADING);
    return _memberEdges;
  }



}
