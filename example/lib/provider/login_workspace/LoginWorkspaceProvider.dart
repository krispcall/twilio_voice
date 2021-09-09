import 'dart:async';
import 'package:flutter/material.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/provider/common/ps_provider.dart';
import 'package:voice_example/repository/LoginWorkspaceRepository.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/model/login/LoginWorkspace.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:voice_example/viewobject/model/overview/OverviewData.dart';
import 'package:voice_example/viewobject/model/workspace/addWorkspace/AddWorkSpaceResponse.dart';
import 'package:voice_example/viewobject/model/workspace/archive/ArchiveWorkSpaceResponse.dart';
import 'package:voice_example/viewobject/model/workspace/restore/RestoreWorkspaceResponse.dart';
import 'package:voice_example/viewobject/model/workspace/uploadImage/UploadWorkSpaceImageResponse.dart';
import 'package:voice_example/viewobject/model/workspace/workspace_detail/Workspace.dart';
import 'package:voice_example/viewobject/model/workspace/workspace_detail/WorkspaceData.dart';

class LoginWorkspaceProvider extends Provider {
  LoginWorkspaceProvider(
      {@required LoginWorkspaceRepository loginWorkspaceRepository,
      @required this.valueHolder,
      int limit = 0})
      : super(loginWorkspaceRepository, limit) {
    this.loginWorkspaceRepository = loginWorkspaceRepository;
    isDispose = false;
    loginWorkspaceListStream =
        StreamController<Resources<List<LoginWorkspace>>>.broadcast();
    loginWorkspaceListSubscription = loginWorkspaceListStream.stream
        .listen((Resources<List<LoginWorkspace>> resource) {
      if (resource != null && resource.data != null) {
        _loginWorkspace = Utils.removeDuplicateObj(resource);
      }

      if (resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });

    loginWorkspaceDetailStream =
        StreamController<Resources<Workspace>>.broadcast();
    loginWorkspaceDetailSubscription = loginWorkspaceDetailStream.stream
        .listen((Resources<Workspace> resource) {
      if (resource != null && resource.data != null) {
        _loginWorkspaceDetail = resource;
      }

      if (resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        isLoading = false;
      }
      if (!isDispose) {
        notifyListeners();
      }
    });

    overviewDataStream = StreamController<Resources<OverViewData>>.broadcast();
    overviewDataSubscription =
        overviewDataStream.stream.listen((Resources<OverViewData> resource) {
      if (resource != null && resource.data != null) {
        _overviewData = resource;
      }

      if (resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        isLoading = false;
      }
      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  LoginWorkspaceRepository loginWorkspaceRepository;
  ValueHolder valueHolder;

  StreamController<Resources<List<LoginWorkspace>>> loginWorkspaceListStream;
  StreamSubscription<Resources<List<LoginWorkspace>>>
      loginWorkspaceListSubscription;

  StreamController<Resources<Workspace>> loginWorkspaceDetailStream;
  StreamSubscription<Resources<Workspace>> loginWorkspaceDetailSubscription;

  StreamController<Resources<OverViewData>> overviewDataStream;
  StreamSubscription<Resources<OverViewData>> overviewDataSubscription;

  Resources<List<LoginWorkspace>> _loginWorkspace =
      Resources<List<LoginWorkspace>>(Status.NO_ACTION, '', null);

  Resources<List<LoginWorkspace>> get loginWorkspace => _loginWorkspace;

  Resources<Workspace> _loginWorkspaceDetail =
      Resources<Workspace>(Status.NO_ACTION, '', null);

  Resources<Workspace> get loginWorkspaceDetail => _loginWorkspaceDetail;

  Resources<OverViewData> _overviewData =
      Resources<OverViewData>(Status.NO_ACTION, '', null);

  Resources<OverViewData> get overviewData => _overviewData;

  LoginWorkspace activeWorkSpace;

  @override
  void dispose() {
    loginWorkspaceListSubscription.cancel();
    loginWorkspaceListStream.close();

    loginWorkspaceDetailSubscription.cancel();
    loginWorkspaceDetailStream.close();

    overviewDataSubscription.cancel();
    overviewDataStream.close();

    isDispose = true;
    super.dispose();
  }

  Future<dynamic> insertWorkspaceListIntoDb(
      List<LoginWorkspace> workspaces) async {
    await loginWorkspaceRepository.insertWorkspaceListIntoDb(workspaces);
  }

  Future<dynamic> getWorkspaceListFromDb() async {
    _loginWorkspace = await loginWorkspaceRepository.getWorkspaceListFromDb();

    loginWorkspaceListStream.sink.add(_loginWorkspace);

    return _loginWorkspace;
  }

  Future<dynamic> getWorkspaceDetailFromDb() async {
    isLoading = true;
    _loginWorkspaceDetail = await loginWorkspaceRepository.getWorkspaceDetailFromDb();
    loginWorkspaceDetailStream.sink.add(_loginWorkspaceDetail);
    return _loginWorkspaceDetail;
  }


  Future<dynamic> getDefaultWorkSpace() async {
    isLoading = true;
    _loginWorkspaceDetail = new Resources(
        Status.SUCCESS,
        "",
        Workspace(workspace: WorkspaceData(data: psRepository.getWorkspaceDetail())));
    loginWorkspaceDetailStream.sink.add(_loginWorkspaceDetail);
    return _loginWorkspaceDetail;
  }

  Future<dynamic> doLoginWorkSpaceDetailApiCall() async {
    if (getApiToken() != null && getApiToken().isNotEmpty) {
      isLoading = true;
      isConnectedToInternet = await Utils.checkInternetConnectivity();
      _loginWorkspaceDetail =
          await loginWorkspaceRepository.doLoginWorkSpaceDetailApiCall(
              isConnectedToInternet, limit, offset, Status.PROGRESS_LOADING);
      loginWorkspaceDetailStream.sink.add(_loginWorkspaceDetail);
      return _loginWorkspaceDetail;
    }
  }

  Future<dynamic> doChangeWorkspaceApiCall(Map<String, dynamic> jsonMap) async {
    if (getApiToken() != null && getApiToken().isNotEmpty) {
      isLoading = true;

      isConnectedToInternet = await Utils.checkInternetConnectivity();

      return await loginWorkspaceRepository.doChangeWorkspaceApiCall(jsonMap,
          isConnectedToInternet, limit, offset, Status.PROGRESS_LOADING);
    }
  }

  Future<dynamic> doWorkSpaceLogin(Map<dynamic, dynamic> jsonMap) async {
    if (getApiToken() != null && getApiToken().isNotEmpty) {
      isLoading = true;

      isConnectedToInternet = await Utils.checkInternetConnectivity();

      return await loginWorkspaceRepository.doWorkSpaceLogin(jsonMap,
          isConnectedToInternet, limit, offset, Status.PROGRESS_LOADING);
    }
  }

  Future<dynamic> doVoiceTokenApiCall(Map<String, dynamic> jsonMap) async {
    if (getApiToken() != null && getApiToken().isNotEmpty) {
      isLoading = true;

      isConnectedToInternet = await Utils.checkInternetConnectivity();
      return await loginWorkspaceRepository.doVoiceTokenApiCall(jsonMap,
          isConnectedToInternet, limit, offset, Status.PROGRESS_LOADING);
    }
  }

  Future<dynamic> doRefreshTokenApiCall() async {
    if (getApiToken() != null && getApiToken().isNotEmpty) {
      isLoading = true;

      isConnectedToInternet = await Utils.checkInternetConnectivity();
      return await loginWorkspaceRepository.doRefreshTokenApiCall();
    }
  }

  Future<dynamic> doDeviceRegisterApiCall(Map<dynamic, dynamic> jsonMap) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await loginWorkspaceRepository.doDeviceRegisterApiCall(
        jsonMap, isConnectedToInternet, Status.PROGRESS_LOADING);
  }

  Future<Resources> inviteUserToWorkSpace(Map<dynamic, dynamic> jsonMap) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return await loginWorkspaceRepository.inviteUserToWorkSpace(
        jsonMap, isConnectedToInternet, Status.PROGRESS_LOADING);
  }

  Future<Resources<OverViewData>> doCallWorkSpaceDetailApi() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    Resources<OverViewData> resources =
        await loginWorkspaceRepository.doOverViewDetailsApiCall(
            isConnectedToInternet, Status.PROGRESS_LOADING);
    overviewDataStream.sink.add(resources);
  }

  Future<Resources<AddWorkSpaceResponse>> doAddWorkSpaceApiCall(
      Map<String, dynamic> jsonMap) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return await loginWorkspaceRepository.doAddWorkSpaceApiCall(
        jsonMap, isConnectedToInternet, Status.PROGRESS_LOADING);
  }

  refreshWorkSpaceList() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await loginWorkspaceRepository.doGetWorkSpaceApiCall(
        loginWorkspaceListStream,
        isConnectedToInternet,
        Status.PROGRESS_LOADING);
  }

  Future<Resources<ArchiveWorkSpaceResponse>>
      doArchiveWorkSpaceApiCall() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return await loginWorkspaceRepository.doArchiveWorkspaceApiCall(
        isConnectedToInternet,
        Status.PROGRESS_LOADING,
        Map.from({"id": psRepository.getWorkspaceDetail().id}));
  }

  Future<Resources<RestoreWorkspaceResponse>> doRestoreWorkSpaceApiCall(
      String id) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return await loginWorkspaceRepository.doRestoreWorkSpaceApiCall(
        isConnectedToInternet, Status.PROGRESS_LOADING, Map.from({"id": id}));
  }

  Future<Resources<List<LoginWorkspace>>> checkActiveWorkSpaceAvailabe() async {
    return await loginWorkspaceRepository.getWorkspaceListFromDb();
  }

  Future<Resources<UploadWorkSpaceImageResponse>>
      doUploadWorkSppaceImageApiCall(Map<String, String> jsonMap) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return await loginWorkspaceRepository.doUploadWorkspaceImageApiCall(
        jsonMap, isConnectedToInternet, Status.PROGRESS_LOADING);
  }

  void saveWorkSpaceDetils(Workspace loginWorkspaceDetail) async {
    loginWorkspaceRepository.updateWorkSpaceDetailsToDb(loginWorkspaceDetail);
  }


}
