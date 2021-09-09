import 'dart:convert';

import 'package:voice_example/db/common/ps_shared_preferences.dart';
import 'package:voice_example/viewobject/model/workspace/workspace_detail/WorkspaceChannel.dart';
import 'package:voice_example/viewobject/model/workspace/workspace_detail/WorkspaceDetail.dart';

class Repository {
  void loadValueHolder() {
    PsSharedPreferences.instance.loadValueHolder();
  }

  void replaceLoginUserId(String loginUserId) {
    PsSharedPreferences.instance.replaceLoginUserId(loginUserId);
  }

  String getLoginUserId() {
    return PsSharedPreferences.instance.getLoginUserId();
  }

  void replaceMemberId(String memberId) {
    PsSharedPreferences.instance.replaceMemberId(memberId);
  }

  String getMemberId() {
    return PsSharedPreferences.instance.getMemberId();
  }

  void replaceUserOnlineStatus(bool onlineStatus) {
    PsSharedPreferences.instance
        .replaceUserOnlineStatus(onlineStatus: onlineStatus);
  }

  bool getUserOnlineStatus() {
    return PsSharedPreferences.instance.getUserOnlineStatus();
  }

  void replaceUserName(String userName) {
    PsSharedPreferences.instance.replaceUserName(userName);
  }

  String getUserName() {
    return PsSharedPreferences.instance.getUserName();
  }

  void replaceUserEmail(String userEmail) {
    PsSharedPreferences.instance.replaceUserEmail(userEmail);
  }

  String getUserEmail() {
    return PsSharedPreferences.instance.getUserEmail();
  }

  void replaceUserPassword(String userPassword) {
    PsSharedPreferences.instance.replaceUserPassword(userPassword);
  }

  String getUserPassword() {
    return PsSharedPreferences.instance.getUserPassword();
  }

  void replaceApiToken(String apiToken) {
    PsSharedPreferences.instance.replaceApiToken(apiToken);
  }

  String getApiToken() {
    return PsSharedPreferences.instance.getApiToken();
  }

  void replaceCallAccessToken(String callAccessToken) {
    PsSharedPreferences.instance.replaceCallAccessToken(callAccessToken);
  }

  String getCallAccessToken() {
    return PsSharedPreferences.instance.getCallAccessToken();
  }

  void replaceNotificationToken(String notificationToken) {
    PsSharedPreferences.instance.replaceNotificationToken(notificationToken);
  }

  String getNotificationToken() {
    return PsSharedPreferences.instance.getNotificationToken();
  }

  void replaceAssignedNumber(String assignedNumber) {
    PsSharedPreferences.instance.replaceAssignedNumber(assignedNumber);
  }

  String getAssignedNumber() {
    return PsSharedPreferences.instance.getAssignedNumber();
  }

  void replaceDefaultCountryCode(String defaultDialCode) {
    PsSharedPreferences.instance.replaceDefaultCountryCode(defaultDialCode);
  }

  String getDefaultCountryCode() {
    return PsSharedPreferences.instance.getDefaultCountryCode();
  }

  void replaceIncomingCallNotificationSetting(bool notificationSetting) {
    PsSharedPreferences.instance
        .replaceIncomingCallNotificationSetting(notificationSetting);
  }

  bool getIncomingCallNotificationSetting() {
    return PsSharedPreferences.instance.getIncomingCallNotificationSetting();
  }

  void replaceSmsNotificationSetting(bool smsNotificationSetting) {
    PsSharedPreferences.instance
        .replaceSmsNotificationSetting(smsNotificationSetting);
  }

  bool getSmsNotificationSetting() {
    return PsSharedPreferences.instance.getSmsNotificationSetting();
  }

  void replaceDefaultWorkspace(String defaultWorkSpace) {
    PsSharedPreferences.instance.replaceDefaultWorkspace(defaultWorkSpace);
  }

  String getDefaultWorkspace() {
    return PsSharedPreferences.instance.getDefaultWorkspace();
  }

  void replaceWorkspaceDetail(String defaultWorkSpace) {
    PsSharedPreferences.instance.replaceWorkspaceDetail(defaultWorkSpace);
  }

  WorkspaceDetail getWorkspaceDetail() {
    if (PsSharedPreferences.instance.getWorkspaceDetail() != null &&
        PsSharedPreferences.instance.getWorkspaceDetail().isNotEmpty) {
      WorkspaceDetail workspaceDetail = WorkspaceDetail().fromMap(
          json.decode(PsSharedPreferences.instance.getWorkspaceDetail()));
      return workspaceDetail;
    } else {
      return null;
    }
  }

  void replaceDefaultChannel(String defaultChannel) {
    PsSharedPreferences.instance.replaceDefaultChannel(defaultChannel);
  }

  WorkspaceChannel getDefaultChannel() {
    if (PsSharedPreferences.instance.getDefaultChannel() != null &&
        PsSharedPreferences.instance.getDefaultChannel().isNotEmpty) {
      WorkspaceChannel defaultChannel = WorkspaceChannel.fromJson(
          json.decode(PsSharedPreferences.instance.getDefaultChannel()));
      return defaultChannel;
    } else {
      return null;
    }
  }

  void replaceChannelList(List<String> channelList) {
    PsSharedPreferences.instance.replaceChannelList(channelList);
  }

  List<WorkspaceChannel> getChannelList() {
    if (PsSharedPreferences.instance.getChannelList() != null &&
        PsSharedPreferences.instance.getChannelList().isNotEmpty) {
      List<WorkspaceChannel> listWorkspaceChannel = [];
      List<String> listString = PsSharedPreferences.instance.getChannelList();
      for (int i = 0; i < listString.length; i++) {
        listWorkspaceChannel
            .add(WorkspaceChannel.fromJson(json.decode(listString[i])));
      }
      return listWorkspaceChannel;
    } else {
      return null;
    }
  }

  void replaceVoiceToken(String voiceToken) {
    PsSharedPreferences.instance.replaceVoiceToken(voiceToken);
  }

  String getVoiceToken() {
    return PsSharedPreferences.instance.getVoiceToken();
  }

  void replaceDefaultLanguage(String defaultLanguage) {
    PsSharedPreferences.instance.replaceDefaultLanguage(defaultLanguage);
  }

  String getDefaultLanguage() {
    return PsSharedPreferences.instance.getDefaultLanguage();
  }

  void replaceUserProfilePicture(String defaultLanguage) {
    PsSharedPreferences.instance.replaceUserProfilePicture(defaultLanguage);
  }

  String getUserProfilePicture() {
    return PsSharedPreferences.instance.getUserProfilePicture();
  }

  void replaceSessionId(String sessionId) {
    PsSharedPreferences.instance.replaceSessionId(sessionId);
  }

  void replaceRefreshToken(String refreshToken) {
    PsSharedPreferences.instance.replaceRefreshToken(refreshToken);
  }

  void replaceSelectedSound(String selectedSound) {
    PsSharedPreferences.instance.replaceSelectedSound(selectedSound);
  }
}
