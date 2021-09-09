import 'dart:async';
import 'package:flutter/material.dart';
import 'package:voice_example/api/ApiService.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/db/UserDao.dart';
import 'package:voice_example/repository/Common/Respository.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/model/checkDuplicateLogin/CheckDuplicateLogin.dart';
import 'package:voice_example/viewobject/model/login/LoginWorkspace.dart';
import 'package:voice_example/viewobject/model/login/User.dart';
import 'package:voice_example/viewobject/model/login/UserProfile.dart';
import 'package:voice_example/viewobject/model/onlineStatus/onlineStatusResponse.dart';
import 'package:voice_example/viewobject/model/profile/Profile.dart';

class UserRepository extends Repository
{
  UserRepository({
    @required ApiService service,
    @required UserDao userDao,
  }) {
    apiService = service;
    this.userDao = userDao;
  }

  ApiService apiService;
  UserDao userDao;
  final String primaryKey = 'id';

  Future<dynamic> insert(UserProfile user) async
  {
    return userDao.insert(primaryKey, user);
  }

  Future<dynamic> update(UserProfile user) async {
    return userDao.update(user);
  }

  Future<dynamic> delete(UserProfile user) async
  {
    return userDao.delete(user);
  }

  Future<Resources<User>> doUserLoginApiCall(Map<dynamic, dynamic> jsonMap, bool isConnectedToInternet, Status status, {bool isLoadFromServer = true}) async
  {
    final Resources<User> _resource = await apiService.doUserLoginApiCall(jsonMap);
    if (_resource.status == Status.SUCCESS )
    {
      if(_resource.data.login.error==null)
      {
        LoginWorkspace workspace=LoginWorkspace(
            memberId: "0",
            id: "0",
            title: "",
            role: "",
            photo: "",
        );

        replaceApiToken(_resource.data.login.data.token);
        replaceSessionId(_resource.data.login.data.details.id);
        replaceSmsNotificationSetting(true);
        replaceIncomingCallNotificationSetting(true);
        replaceUserEmail(_resource.data.login.data.details.userProfile.email);
        replaceUserName(_resource.data.login.data.details.userProfile.firstName + " " + _resource.data.login.data.details.userProfile.lastName);
        replaceUserOnlineStatus(_resource.data.login.data.details.userProfile.stayOnline);
        replaceLoginUserId(_resource.data.login.data.details.id);
        if(_resource.data.login.data.details.workspaces.length!=0)
        {
          if(_resource.data.login.data.details.userProfile.defaultWorkspace!=null && _resource.data.login.data.details.userProfile.defaultWorkspace.isNotEmpty)
          {
            for(int i=0;i<_resource.data.login.data.details.workspaces.length;i++)
            {
              if(_resource.data.login.data.details.workspaces[i].id==_resource.data.login.data.details.userProfile.defaultWorkspace)
              {
                replaceMemberId(_resource.data.login.data.details.workspaces[i].memberId);
              }
            }
          }
          else
          {
            replaceMemberId(_resource.data.login.data.details.workspaces[0].memberId);
          }
        }

        if(_resource.data.login.data.details.userProfile.defaultWorkspace!=null && _resource.data.login.data.details.userProfile.defaultWorkspace.isNotEmpty)
        {
          replaceDefaultWorkspace(_resource.data.login.data.details.userProfile.defaultWorkspace);
        }
        else
        {
          replaceDefaultWorkspace(_resource.data.login.data.details.workspaces[0].id);
        }
        // _resource.data.login.data.details.userProfile.defaultLanguage!=null?replaceDefaultLanguage(_resource.data.login.data.details.userProfile.defaultLanguage):replaceDefaultLanguage("en");

        // _resource.data.login.data.details.userProfile.profilePicture!=null?replaceUserProfilePicture(_resource.data.login.data.details.userProfile.profilePicture):replaceUserProfilePicture("");

        _resource.data.login.data.details.workspaces.add(workspace);

        userDao.deleteAll();
        userDao.insert(primaryKey, _resource.data.login.data.details.userProfile);
        return Resources(Status.SUCCESS, "", _resource.data);
      }
      else
      {
        return Resources(Status.ERROR, _resource.data.login.error.message, null);
      }
    }
    else
    {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  Future<Resources<CheckDuplicateLogin>> doCheckDuplicateLogin(Map<dynamic, dynamic> jsonMap, bool isConnectedToInternet, Status status, {bool isLoadFromServer = true}) async
  {
    final Resources<CheckDuplicateLogin> _resource = await apiService.doCheckDuplicateLogin(jsonMap);
    if (_resource.status == Status.SUCCESS )
    {
      if(_resource.data.clientDndResponseData.error==null)
      {
        return Resources(Status.SUCCESS, "", _resource.data);
      }
      else
      {
        return Resources(Status.ERROR, _resource.data.clientDndResponseData.error.message, null);
      }
    }
    else
    {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  Future<dynamic> getUserProfileDetails(bool isConnectedToInternet, Status status, {bool isLoadFromServer = true}) async
  {
    if (isConnectedToInternet)
    {
      final Resources<Profile> _resource = await apiService.getUserProfileDetails();

      if (_resource.status == Status.SUCCESS)
      {
        replaceUserEmail(_resource.data.profile.data.email);
        replaceUserName(_resource.data.profile.data.firstName + " " + _resource.data.profile.data.lastName);
        replaceDefaultWorkspace(_resource.data.profile.data.defaultWorkspace);
        replaceUserOnlineStatus(_resource.data.profile.data.stayOnline);
        // replaceDefaultLanguage(_resource.data.profile.data.defaultLanguage);
        // replaceUserProfilePicture(_resource.data.profile.data.profilePicture);
        userDao.update(_resource.data.profile.data);
        return Resources(Status.SUCCESS, "", _resource.data);
      }
      else
      {
        return Resources(Status.ERROR, _resource.data.profile.error.message, null);
      }
    }
  }

  Future<dynamic> onlineStatus(Map<dynamic, dynamic> jsonMap,bool isConnectedToInternet, Status status, {bool isLoadFromServer = true}) async
  {
    if (isConnectedToInternet)
    {
      final Resources<OnlineStatusResponse> _resource = await apiService.onlineStatus(jsonMap);

      if (_resource.status == Status.SUCCESS)
      {
        replaceUserOnlineStatus(_resource.data.data.data.onlineStatus);
        return Resources(Status.SUCCESS, "", _resource.data);
      }
      else
      {
        return Resources(Status.ERROR, _resource.data.data.error.message, null);
      }
    }
  }
}
