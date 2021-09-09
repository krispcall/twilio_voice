import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:voice_example/api/ApiService.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/db/LoginWorkSpaceDao.dart';
import 'package:voice_example/db/TeamDao.dart';
import 'package:voice_example/db/UserDao.dart';
import 'package:voice_example/db/WorkSpaceDetailDao.dart';
import 'package:voice_example/repository/Common/Respository.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/model/deviceInfo/DeviceInfoResponse.dart';
import 'package:voice_example/viewobject/model/invite/InviteMemberResponse.dart';
import 'package:voice_example/viewobject/model/login/LoginWorkspace.dart';
import 'package:voice_example/viewobject/model/memberLogin/Member.dart';
import 'package:voice_example/viewobject/model/overview/OverViewResponse.dart';
import 'package:voice_example/viewobject/model/overview/OverviewData.dart';
import 'package:voice_example/viewobject/model/refreshToken/RefreshTokenResponse.dart';
import 'package:voice_example/viewobject/model/teams/Teams.dart';
import 'package:voice_example/viewobject/model/voiceToken/VoiceTokenResponse.dart';
import 'package:voice_example/viewobject/model/workspace/addWorkspace/AddWorkSpaceResponse.dart';
import 'package:voice_example/viewobject/model/workspace/archive/ArchiveWorkSpaceResponse.dart';
import 'package:voice_example/viewobject/model/workspace/restore/RestoreWorkspaceResponse.dart';
import 'package:voice_example/viewobject/model/workspace/uploadImage/UploadWorkSpaceImageResponse.dart';
import 'package:voice_example/viewobject/model/workspace/workspace_detail/Workspace.dart';
import 'package:voice_example/viewobject/model/workspace/workspace_detail/WorkspaceChannel.dart';
import 'package:voice_example/viewobject/model/workspace/workspacelist/WorkspaceListResponse.dart';
import 'package:voice_example/viewobject/model/workspace_switch/WorkspaceSwitch.dart';
import 'package:sembast/sembast.dart';

class LoginWorkspaceRepository extends Repository {
  LoginWorkspaceRepository({
    @required ApiService apiService,
    @required UserDao userDao,
    @required LoginWorkSpaceDao workSpaceDao,
    @required TeamDao teamDao,
    @required WorkspaceDetailDao workspaceDetailDao,
  }) {
    this.apiService = apiService;
    this.userDao = userDao;
    this.workSpaceDao = workSpaceDao;
    this.teamDao = teamDao;
    this.workspaceDetailDao = workspaceDetailDao;
  }

  ApiService apiService;
  UserDao userDao;
  LoginWorkSpaceDao workSpaceDao;
  TeamDao teamDao;
  WorkspaceDetailDao workspaceDetailDao;

  final String _userPrimaryKey = 'id';

  Future<dynamic> insert(LoginWorkspace loginWorkspace) async {
    return workSpaceDao.insert(_userPrimaryKey, loginWorkspace);
  }

  Future<dynamic> update(LoginWorkspace loginWorkspace) async {
    return workSpaceDao.update(loginWorkspace);
  }

  Future<dynamic> delete(LoginWorkspace loginWorkspace) async {
    return workSpaceDao.delete(loginWorkspace);
  }

  Future<dynamic> insertWorkspaceListIntoDb(
      List<LoginWorkspace> workspaces) async {
    workspaces.add(LoginWorkspace(
        memberId: "0",
        id: "0",
        title: "",
        role: "",
        photo: null,
        status: "Inactive"));
    workSpaceDao.deleteAll();


    workSpaceDao.insertAll(_userPrimaryKey, workspaces);

    Resources<List<LoginWorkspace>> workspaceList = await workSpaceDao.getAll();
  }

  Future<dynamic> getWorkspaceListFromDb() async {
    return await workSpaceDao.getAll();
  }

  Future<dynamic> getWorkspaceDetailFromDb() async {
    return await workspaceDetailDao.getOne();
  }

  Future<dynamic> doWorkSpaceDetailApiCall(
      bool isConnectedToInternet, int limit, int offset, Status status,
      {bool isLoadFromServer = true}) async {
    final Resources<Workspace> _resource =
        await apiService.doLoginWorkSpaceDetailApiCall();
    if (_resource.status == Status.SUCCESS) {
      if (_resource.data.workspace.error == null) {
        workspaceDetailDao.deleteAll();
        workspaceDetailDao.insert(_userPrimaryKey, _resource.data);
        WorkspaceChannel workspaceChannel = getDefaultChannel();
        replaceWorkspaceDetail(
            json.encode(_resource.data.workspace.data.toJson()));
        _updateTeamList(_resource.data);
        if (_resource.data.workspace.data.workspaceChannel != null &&
            _resource.data.workspace.data.workspaceChannel.length != 0) {
          List<String> listChannel = [];
          for (int i = 0;
              i < _resource.data.workspace.data.workspaceChannel.length;
              i++) {
            listChannel.add(json.encode(
                _resource.data.workspace.data.workspaceChannel[i].toJson()));
          }
          replaceChannelList(listChannel);
          if (workspaceChannel.id != null && workspaceChannel.id.isNotEmpty) {
            for (int i = 0;
                i < _resource.data.workspace.data.workspaceChannel.length;
                i++) {
              if (_resource.data.workspace.data.workspaceChannel[i].id ==
                  workspaceChannel.id) {
                replaceDefaultChannel(json.encode(_resource
                    .data.workspace.data.workspaceChannel[i]
                    .toJson()));
                break;
              } else {
                replaceDefaultChannel(json.encode(_resource
                    .data.workspace.data.workspaceChannel[i]
                    .toJson()));
              }
            }
          } else {
            replaceDefaultChannel(json.encode(
                _resource.data.workspace.data.workspaceChannel[0].toJson()));
          }
        } else {
          WorkspaceChannel workspaceChannel = WorkspaceChannel(
            id: "",
            name: Utils.getString("appName"),
            countryCode: Utils.getString("appName"),
            countryLogo: "",
            number: Utils.getString("appName"),
            unseenMessageCount: 0,
          );

          replaceWorkspaceDetail(null);
          replaceDefaultChannel(null);
          List<String> listChannel = [];
          listChannel.add(json.encode(workspaceChannel.toJson()));
          replaceChannelList(listChannel);
        }
        return Resources(Status.SUCCESS, "", _resource.data);
      } else {
        WorkspaceChannel workspaceChannel = WorkspaceChannel(
          id: "",
          name: Utils.getString("appName"),
          countryCode: Utils.getString("appName"),
          countryLogo: "",
          number: Utils.getString("appName"),
          unseenMessageCount: 0,
        );
        replaceWorkspaceDetail(null);
        replaceDefaultChannel(json.encode(workspaceChannel.toJson()));
        List<String> listChannel = [];
        listChannel.add(json.encode(workspaceChannel.toJson()));
        replaceChannelList(listChannel);
        return Resources(
            Status.ERROR, _resource.data.workspace.error.message, null);
      }
    } else {
      WorkspaceChannel workspaceChannel = WorkspaceChannel(
        id: "",
        name: Utils.getString("appName"),
        countryCode: Utils.getString("appName"),
        countryLogo: "",
        number: Utils.getString("appName"),
        unseenMessageCount: 0,
      );
      replaceWorkspaceDetail(null);
      replaceDefaultChannel(null);
      List<String> listChannel = [];
      listChannel.add(json.encode(workspaceChannel.toJson()));
      replaceChannelList(listChannel);
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  Future<dynamic> doLoginWorkSpaceDetailApiCall(
      bool isConnectedToInternet, int limit, int offset, Status status,
      {bool isLoadFromServer = true}) async {
    final Resources<Workspace> _resource =
        await apiService.doLoginWorkSpaceDetailApiCall();
    if (_resource.status == Status.SUCCESS) {
      if (_resource.data.workspace.error == null) {
        workspaceDetailDao.deleteAll();
        workspaceDetailDao.insert(_userPrimaryKey, _resource.data);
        replaceWorkspaceDetail(json.encode(_resource.data.workspace.data.toJson()));
        _updateTeamList(_resource.data);
        if (_resource.data.workspace.data.workspaceChannel != null &&
            _resource.data.workspace.data.workspaceChannel.isNotEmpty) {

          replaceDefaultChannel(json.encode(
              _resource.data.workspace.data.workspaceChannel[0].toJson()));
          List<String> listChannel = [];
          for (int i = 0;
              i < _resource.data.workspace.data.workspaceChannel.length;
              i++) {
            listChannel.add(json.encode(
                _resource.data.workspace.data.workspaceChannel[i].toJson()));
          }
          replaceChannelList(listChannel);
          return Resources(Status.SUCCESS, "", _resource.data);
        } else {
          WorkspaceChannel workspaceChannel = WorkspaceChannel(
            id: "",
            name: Utils.getString("appName"),
            countryCode: Utils.getString("appName"),
            countryLogo: "",
            number: Utils.getString("appName"),
            unseenMessageCount: 0,
          );
          replaceDefaultChannel(json.encode(workspaceChannel.toJson()));
          List<String> listChannel = [];
          listChannel.add(json.encode(workspaceChannel.toJson()));
          replaceChannelList(listChannel);
          return Resources(Status.SUCCESS, "", _resource.data);
        }
      } else {
        replaceWorkspaceDetail(null);
        WorkspaceChannel workspaceChannel = WorkspaceChannel(
          id: "",
          name: Utils.getString("appName"),
          countryCode: Utils.getString("appName"),
          countryLogo: "",
          number: Utils.getString("appName"),
          unseenMessageCount: 0,
        );
        replaceWorkspaceDetail(null);
        replaceDefaultChannel(null);
        List<String> listChannel = [];
        listChannel.add(json.encode(workspaceChannel.toJson()));
        replaceChannelList(listChannel);
        return Resources(
            Status.ERROR, _resource.data.workspace.error.message, null);
      }
    } else {
      WorkspaceChannel workspaceChannel = WorkspaceChannel(
        id: "",
        name: Utils.getString("appName"),
        countryCode: Utils.getString("appName"),
        countryLogo: "",
        number: Utils.getString("appName"),
        unseenMessageCount: 0,
      );
      replaceWorkspaceDetail(null);
      replaceDefaultChannel(null);
      List<String> listChannel = [];
      listChannel.add(json.encode(workspaceChannel.toJson()));
      replaceChannelList(listChannel);
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  Future<dynamic> doChangeWorkspaceApiCall(Map<String, dynamic> jsonMap,
      bool isConnectedToInternet, int limit, int offset, Status status,
      {bool isLoadFromServer = true}) async {
    final Resources<WorkspaceSwitch> _resource =
        await apiService.doChangeWorkspaceApiCall(jsonMap);
    if (_resource.status == Status.SUCCESS) {
      if (_resource.data.workspaceSwitch.error == null) {
        userDao.update(_resource.data.workspaceSwitch.data);
        return Resources(Status.SUCCESS, "", _resource.data);
      } else {
        return Resources(
            Status.ERROR, _resource.data.workspaceSwitch.error.message, null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  Future<dynamic> doWorkSpaceLogin(Map<String, dynamic> jsonMap,
      bool isConnectedToInternet, int limit, int offset, Status status,
      {bool isLoadFromServer = true}) async {
    final Resources<Member> _resource =
        await apiService.doWorkSpaceLoginApiCall(jsonMap);
    if (_resource.status == Status.SUCCESS) {
      if (_resource.data.data.error == null) {
        replaceCallAccessToken(_resource.data.data.data.accessToken);
        replaceRefreshToken(_resource.data.data.data.refreshToken);
        return Resources(Status.SUCCESS, "", _resource.data);
      } else {
        return Resources(Status.ERROR, _resource.data.data.error.message, null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  Future<dynamic> doVoiceTokenApiCall(Map<String, dynamic> jsonMap,
      bool isConnectedToInternet, int limit, int offset, Status status,
      {bool isLoadFromServer = true}) async {
    final Resources<VoiceTokenResponse> _resource =
        await apiService.doVoiceTokenApiCall(jsonMap);
    if (_resource.status == Status.SUCCESS) {
      if (_resource.data.voiceTokenData.error == null) {
        if (_resource.data.voiceTokenData.voiceToken.voiceToken != null) {
          replaceVoiceToken(
              _resource.data.voiceTokenData.voiceToken.voiceToken);
          return Resources(Status.SUCCESS, "",
              _resource.data.voiceTokenData.voiceToken.voiceToken);
        } else {
          replaceVoiceToken("");
          return Resources(Status.SUCCESS,
              _resource.data.voiceTokenData.error.message, null);
        }
      } else {
        return Resources(
            Status.ERROR, _resource.data.voiceTokenData.error.message, null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  Future<dynamic> doRefreshTokenApiCall({bool isLoadFromServer = true}) async {
    final Resources<RefreshTokenResponse> _resource =
        await apiService.doRefreshTokenApiCall();
    if (_resource.status == Status.SUCCESS) {
      if (_resource.data.refreshTokenResponseData.error == null) {
        if (_resource.data.refreshTokenResponseData.data.accessToken != null) {
          replaceCallAccessToken(
              _resource.data.refreshTokenResponseData.data.accessToken);
          return Resources(Status.SUCCESS, "",
              _resource.data.refreshTokenResponseData.data.accessToken);
        } else {
          return Resources(Status.ERROR,
              _resource.data.refreshTokenResponseData.error.message, null);
        }
      } else {
        return Resources(Status.ERROR,
            _resource.data.refreshTokenResponseData.error.message, null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  Future<Resources<DeviceInfoResponse>> doDeviceRegisterApiCall(
      Map<dynamic, dynamic> jsonMap, bool isConnectedToInternet, Status status,
      {bool isLoadFromServer = true}) async {
    final Resources<DeviceInfoResponse> _resource =
        await apiService.doDeviceRegisterApiCall(jsonMap);
    if (_resource.status == Status.SUCCESS) {
      if (_resource.data.deviceInfoData.error == null) {
        return Resources(Status.SUCCESS, "", _resource.data);
      } else {
        return Resources(
            Status.ERROR, _resource.data.deviceInfoData.error.message, null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
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

  Future<Resources<AddWorkSpaceResponse>> doAddWorkSpaceApiCall(
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      Status status) async {
    final Resources<AddWorkSpaceResponse> _resource =
        await apiService.doAddWorkSpaceApiCall(jsonMap);

    if (_resource.data != null && _resource.data.data != null) {
      if (_resource.data.data.error == null) {
        return Future.value(Resources(Status.SUCCESS, "", _resource.data));
      } else {
        return Future.value(
            Resources(Status.ERROR, _resource.data.data.error.message, null));
      }
    } else {
      return Future.value(
          Resources(Status.ERROR, Utils.getString("serverError"), null));
    }
  }

  Future<Resources<OverViewData>> doOverViewDetailsApiCall(
      bool isConnectedToInternet, Status sttus) async {
    final Resources<OverviewResponse> _resource =
        await apiService.doOverViewDetailsApiCall();
    if (_resource.data != null && _resource.data.data != null) {
      if (_resource.data.data.error == null) {
        if (_resource.data != null &&
            _resource.data.data != null &&
            _resource.data.data.overviewData != null) {
          return Resources(Status.SUCCESS, "", _resource.data.data.overviewData);
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

  doGetWorkSpaceApiCall(
      StreamController<Resources<List<LoginWorkspace>>>
          loginWorkspaceListStream,
      bool isConnected,
      Status status) async {
    _sinkWorkspaceStream(loginWorkspaceListStream, await workSpaceDao.getAll());

    _sinkWorkspaceStream(loginWorkspaceListStream, await workSpaceDao.getAll());

    if (isConnected) {
      Resources<WorkspaceListResponse> resources =
          await apiService.getWorkSpaceList();
      if (resources != null &&
          resources.data != null &&
          resources.data.data != null &&
          resources.data.data.data != null) {
        List<LoginWorkspace> workspaceList = [];
        workspaceList.addAll(resources.data.data.data);
        workspaceList.add(LoginWorkspace(
            memberId: "0",
            id: "0",
            title: "",
            role: "",
            photo: null,
            status: "Inactive"));
        workSpaceDao.deleteAll();
        workSpaceDao.insertAll(_userPrimaryKey, workspaceList);
        _sinkWorkspaceStream(loginWorkspaceListStream,
            Resources(Status.SUCCESS, "", workspaceList));
      } else {
        _sinkWorkspaceStream(
            loginWorkspaceListStream, await workSpaceDao.getAll());
      }
    } else {
      _sinkWorkspaceStream(
          loginWorkspaceListStream, await workSpaceDao.getAll());
    }
  }

  _sinkWorkspaceStream(
      StreamController<Resources<List<LoginWorkspace>>>
          loginWorkspaceListStream,
      Resources<List<LoginWorkspace>> resources) {
    if (resources.data != null && resources.data.length > 0) {
      loginWorkspaceListStream.sink.add(resources);
    }
  }

  void _updateTeamList(Workspace data) {
    if (data != null &&
        data.workspace != null &&
        data.workspace.data != null &&
        data.workspace.data.workspaceTeam != null) {
      teamDao.deleteAll();
      if (data.workspace.data.workspaceTeam.isNotEmpty) {
        List<Teams> list = data.workspace.data.workspaceTeam
            .map((entry) => Teams(
                id: entry.id,
                name: entry.name,
                online: entry.online,
                total: entry.total,
                picture: entry.picture,
                members: []))
            .toList();
        teamDao.insertAll(_userPrimaryKey, list);
      } else {
        teamDao.deleteAll();
      }
    } else {
      teamDao.deleteAll();
    }
  }

  Future<Resources<ArchiveWorkSpaceResponse>> doArchiveWorkspaceApiCall(
      bool isConnectedToInternet,
      Status status,
      Map<String, dynamic> map) async {
    final Resources<ArchiveWorkSpaceResponse> _resource =
        await apiService.doArchiveWorkSpaceApiCall(map);
    if (_resource.data != null && _resource.data.data != null) {
      if (_resource.data.data.error == null) {
        workSpaceDao.update(_resource.data.data.data,
            finder: Finder(
                filter: new Filter.matches("id", _resource.data.data.data.id)));
        return Resources(Status.SUCCESS, "", _resource.data);
      } else {
        return Resources(Status.ERROR, _resource.data.data.error.message, null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  Future<Resources<RestoreWorkspaceResponse>> doRestoreWorkSpaceApiCall(
      bool isConnectedToInternet,
      Status status,
      Map<String, dynamic> map) async {
    final Resources<RestoreWorkspaceResponse> _resource =
        await apiService.doRestoreWorkSpaceApiCall(map);
    if (_resource.data != null && _resource.data.data != null) {
      if (_resource.data.data.error == null) {
        workSpaceDao.update(_resource.data.data.data,
            finder: Finder(
                filter: new Filter.matches("id", _resource.data.data.data.id)));
        return Resources(Status.SUCCESS, "", _resource.data);
      } else {
        return Resources(Status.ERROR, _resource.data.data.error.message, null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  Future<Resources<UploadWorkSpaceImageResponse>> doUploadWorkspaceImageApiCall(
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      Status status) async {
    if (isConnectedToInternet) {
      Resources<UploadWorkSpaceImageResponse> _resources =
          await apiService.doUploadWorkSpaceImageApiCall(jsonMap);
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

  void updateWorkSpaceDetailsToDb(Workspace loginWorkspaceDetail) async {
    workspaceDetailDao.insert(_userPrimaryKey, loginWorkspaceDetail);
  }
}
