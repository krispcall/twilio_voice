import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/repository/Common/Respository.dart';
import 'package:voice_example/viewobject/model/login/LoginWorkspace.dart';
import 'package:voice_example/viewobject/model/workspace/workspace_detail/WorkspaceChannel.dart';
import 'package:voice_example/viewobject/model/workspace/workspace_detail/WorkspaceDetail.dart';

class Provider extends ChangeNotifier {
  Provider(this.psRepository, int limit) {
    if (limit != 0) {
      this.limit = limit;
    }
  }

  bool isConnectedToInternet = false;
  bool isLoading = false;
  Repository psRepository;

  int offset = 0;
  int limit = Config.DEFAULT_LOADING_LIMIT;
  int _cacheDataLength = 0;
  int maxDataLoadingCount = 0;
  int maxDataLoadingCountLimit = 4;
  bool isReachMaxData = false;
  bool isDispose = false;

  void updateOffset(int dataLength) {
    if (offset == 0) {
      isReachMaxData = false;
      maxDataLoadingCount = 0;
    }
    if (dataLength == _cacheDataLength) {
      maxDataLoadingCount++;
      if (maxDataLoadingCount == maxDataLoadingCountLimit) {
        isReachMaxData = true;
      }
    } else {
      maxDataLoadingCount = 0;
    }

    offset = dataLength;
    _cacheDataLength = dataLength;
  }

  Future<void> loadValueHolder() async {
    psRepository.loadValueHolder();
  }

  Future<void> replaceLoginUserId(String loginUserId) async {
    psRepository.replaceLoginUserId(loginUserId);
  }

  String getLoginUserId() {
    return psRepository.getLoginUserId();
  }

  Future<void> replaceMemberId(String memberId) async {
    psRepository.replaceMemberId(memberId);
  }

  String getMemberId() {
    return psRepository.getMemberId();
  }

  Future<void> replaceUserOnlineStatus(bool onlineStatus) async {
    psRepository.replaceUserOnlineStatus(onlineStatus);
  }

  bool getUserOnlineStatus() {
    return psRepository.getUserOnlineStatus() != null
        ? psRepository.getUserOnlineStatus()
        : false;
  }

  Future<void> replaceUserName(String userName) async {
    psRepository.replaceUserName(userName);
  }

  String getUserName() {
    return psRepository.getUserName();
  }

  Future<void> replaceUserEmail(String userEmail) async {
    psRepository.replaceUserEmail(userEmail);
  }

  String getUserEmail() {
    return psRepository.getUserEmail();
  }

  Future<void> replaceUserPassword(String userPassword) async {
    psRepository.replaceUserPassword(userPassword);
  }

  String getUserPassword() {
    return psRepository.getUserPassword();
  }

  Future<void> replaceApiToken(String apiToken) async {
    psRepository.replaceApiToken(apiToken);
  }

  String getApiToken() {
    return psRepository.getApiToken();
  }

  Future<void> replaceCallAccessToken(String callAccessToken) async {
    psRepository.replaceCallAccessToken(callAccessToken);
  }

  String getCallAccessToken() {
    return psRepository.getCallAccessToken();
  }

  Future<void> replaceNotificationToken(String notificationToken) async {
    psRepository.replaceNotificationToken(notificationToken);
  }

  String getNotificationToken() {
    return psRepository.getNotificationToken();
  }

  Future<void> replaceAssignedNumber(String assignedNumber) async {
    psRepository.replaceAssignedNumber(assignedNumber);
  }

  String getAssignedNumber() {
    return psRepository.getAssignedNumber();
  }

  Future<void> replaceDefaultCountryCode(String defaultCountryCode) async {
    psRepository.replaceDefaultCountryCode(defaultCountryCode);
  }

  Future<void> replaceIncomingCallNotificationSetting(
      bool incomingCallNotificationSetting) async {
    psRepository.replaceIncomingCallNotificationSetting(
        incomingCallNotificationSetting);
  }

  bool getIncomingCallNotificationSetting() {
    return psRepository.getIncomingCallNotificationSetting();
  }

  Future<void> replaceSmsNotificationSetting(
      bool smsNotificationSetting) async {
    psRepository.replaceSmsNotificationSetting(smsNotificationSetting);
  }

  bool getSmsNotificationSetting() {
    return psRepository.getSmsNotificationSetting();
  }

  Future<void> replaceDefaultWorkspace(String defaultWorkSpace) async {
    psRepository.replaceDefaultWorkspace(defaultWorkSpace);
  }

  String getDefaultWorkspace() {
    return psRepository.getDefaultWorkspace();
  }

  Future<void> replaceWorkspaceDetail(LoginWorkspace workspaceDetail) async {
    psRepository.replaceWorkspaceDetail(
        json.encode(LoginWorkspace().toMap(workspaceDetail)));
  }

  WorkspaceDetail getWorkspaceDetail() {
    return psRepository.getWorkspaceDetail();
  }

  Future<void> replaceDefaultChannel(String defaultChannel) async {
    psRepository.replaceDefaultChannel(defaultChannel);
  }

  WorkspaceChannel getDefaultChannel() {
    return psRepository.getDefaultChannel();
  }

  Future<void> replaceChannelList(List<String> channelList) async {
    psRepository.replaceChannelList(channelList);
  }

  List<WorkspaceChannel> getChannelList() {
    return psRepository.getChannelList();
  }

  void replaceVoiceToken(String voiceToken) {
    psRepository.replaceVoiceToken(voiceToken);
  }

  String getVoiceToken() {
    return psRepository.getVoiceToken();
  }

  Future<void> replaceDefaultLanguage(String defaultLanguage) async {
    psRepository.replaceDefaultLanguage(defaultLanguage);
  }

  String getDefaultLanguage() {
    return psRepository.getDefaultLanguage();
  }

  Future<void> replaceUserProfilePicture(String defaultLanguage) async {
    psRepository.replaceUserProfilePicture(defaultLanguage);
  }

  String getUserProfilePicture() {
    return psRepository.getUserProfilePicture();
  }

  void replaceSessionId(String sessionId) {
    psRepository.replaceSessionId(sessionId);
  }

  void replaceRefreshToken(String refreshToken) {
    psRepository.replaceRefreshToken(refreshToken);
  }

  void replaceSelectedSound(String selectedSound) {
    psRepository.replaceSelectedSound(selectedSound);
  }
}
