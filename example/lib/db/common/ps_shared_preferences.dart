import 'dart:async';
import 'package:voice_example/constant/Constants.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PsSharedPreferences {
  PsSharedPreferences() {
    futureShared = SharedPreferences.getInstance();
    futureShared.then((SharedPreferences shared) {
      this.shared = shared;
      loadValueHolder();
    });
  }

  Future<SharedPreferences> futureShared;
  SharedPreferences shared;

// Singleton instance
  static final PsSharedPreferences _singleton = PsSharedPreferences();

  // Singleton accessor
  static PsSharedPreferences get instance => _singleton;

  final StreamController<ValueHolder> _valueController =
      StreamController<ValueHolder>();

  Stream<ValueHolder> get valueHolder => _valueController.stream;

  void loadValueHolder() {
    final String loginUserId = shared.getString(Const.VALUE_HOLDER_USER_ID);
    final String memberId = shared.getString(Const.VALUE_HOLDER_MEMBER_ID);
    final String apiToken = shared.getString(Const.VALUE_HOLDER_API_TOKEN);
    final String refreshToken =
        shared.getString(Const.VALUE_HOLDER_REFRESH_TOKEN);
    final String callAccessToken =
        shared.getString(Const.VALUE_HOLDER_CALL_ACCESS_TOKEN);
    final String assignedNumber =
        shared.getString(Const.VALUE_HOLDER_ASSIGNED_NUMBER);
    final String defaultCountryCode =
        shared.getString(Const.VALUE_HOLDER_DEFAULT_COUNTRY_CODE);
    final String defaultWorkSpace =
        shared.getString(Const.VALUE_HOLDER_DEFAULT_WORKSPACE);
    final String workspaceDetail =
        shared.getString(Const.VALUE_HOLDER_WORKSPACE_DETAIL);
    final String defaultChannel =
        shared.getString(Const.VALUE_HOLDER_DEFAULT_CHANNEL);
    final List<String> channelList =
        shared.getStringList(Const.VALUE_HOLDER_CHANNEL_LIST);
    final String defaultLanguage =
        shared.getString(Const.VALUE_HOLDER_DEFAULT_LANGUAGE);

    final String userName = shared.getString(Const.VALUE_HOLDER_USER_NAME);
    final String userEmail = shared.getString(Const.VALUE_HOLDER_USER_EMAIL);
    final String userPassword =
        shared.getString(Const.VALUE_HOLDER_USER_PASSWORD);
    final String notificationToken =
        shared.getString(Const.VALUE_HOLDER_NOTIFICATION_TOKEN);
    final String sessionId = shared.getString(Const.VALUE_HOLDER_SESSION_ID);
    final String selectedSound =
        shared.getString(Const.VALUE_HOLDER_SELECTED_SOUND);
    final String userProfilePicture =
        shared.getString(Const.VALUE_HOLDER_PROFILE_PICTURE);
    final String voiceToken = shared.getString(Const.VALUE_HOLDER_VOICE_TOKEN);

    final bool incomingCallNotificationSetting =
        shared.getBool(Const.VALUE_HOLDER_INCOMING_CALL_NOTIFICATION_SETTING);
    final bool smsNotificationSetting =
        shared.getBool(Const.VALUE_HOLDER_SMS_NOTIFICATION_SETTING);
    final bool noticeNotificationSetting =
        shared.getBool(Const.VALUE_HOLDER_NOTICE_NOTIFICATION_SETTING);

    final bool userOnlineStatus = shared.getBool(Const.VALUE_HOLDER_USER_ONLINE_STATUS);

    final ValueHolder _valueHolder = ValueHolder(
      loginUserId: loginUserId,
      memberId: memberId,
      apiToken: apiToken,
      refreshToken: refreshToken,
      callAccessToken: callAccessToken,
      assignedNumber: assignedNumber,
      defaultWorkSpace: defaultWorkSpace,
      workspaceDetail: workspaceDetail,
      defaultChannel: defaultChannel,
      channelList: channelList,
      defaultLanguage: defaultLanguage,
      defaultCountryCode: defaultCountryCode,
      userName: userName,
      userEmail: userEmail,
      userPassword: userPassword,
      fcmToken: notificationToken,
      sessionId: sessionId,
      selectedSound: selectedSound,
      userProfilePicture: userProfilePicture,
      voiceToken: voiceToken,
      incomingCallNotificationSetting: incomingCallNotificationSetting,
      smsNotificationSetting: smsNotificationSetting,
      noticeNotificationSetting: noticeNotificationSetting,
      userOnlineStatus: userOnlineStatus,
    );

    _valueController.add(_valueHolder);
  }

  Future<dynamic> replaceLoginUserId(String loginUserId) async {
    await shared.setString(Const.VALUE_HOLDER_USER_ID, loginUserId);

    loadValueHolder();
  }

  String getLoginUserId() {
    return shared.getString(Const.VALUE_HOLDER_USER_ID);
  }

  Future<dynamic> replaceMemberId(String memberId) async {
    await shared.setString(Const.VALUE_HOLDER_MEMBER_ID, memberId);

    loadValueHolder();
  }

  String getMemberId() {
    return shared.getString(Const.VALUE_HOLDER_MEMBER_ID);
  }

  Future<void> replaceUserOnlineStatus({bool onlineStatus=false}) async{
    if(onlineStatus!=null){
      await shared.setBool(Const.VALUE_HOLDER_USER_ONLINE_STATUS, onlineStatus);
      loadValueHolder();
    }
  }

  bool getUserOnlineStatus() {
    return shared.getBool(Const.VALUE_HOLDER_USER_ONLINE_STATUS);
  }

  Future<dynamic> replaceUserName(String userName) async {
    await shared.setString(Const.VALUE_HOLDER_USER_NAME, userName);

    loadValueHolder();
  }

  String getUserName() {
    return shared.getString(Const.VALUE_HOLDER_USER_NAME);
  }

  Future<dynamic> replaceUserEmail(String userEmail) async {
    await shared.setString(Const.VALUE_HOLDER_USER_EMAIL, userEmail);

    loadValueHolder();
  }

  String getUserEmail() {
    return shared.getString(Const.VALUE_HOLDER_USER_EMAIL);
  }

  Future<dynamic> replaceUserPassword(String userPassword) async {
    await shared.setString(Const.VALUE_HOLDER_USER_PASSWORD, userPassword);

    loadValueHolder();
  }

  String getUserPassword() {
    return shared.getString(Const.VALUE_HOLDER_USER_PASSWORD);
  }

  Future<dynamic> replaceApiToken(String apiToken) async {
    await shared.setString(Const.VALUE_HOLDER_API_TOKEN, apiToken);

    loadValueHolder();
  }

  String getApiToken() {
    return shared.getString(Const.VALUE_HOLDER_API_TOKEN);
  }

  Future<dynamic> replaceCallAccessToken(String callAccessToken) async {
    await shared.setString(
        Const.VALUE_HOLDER_CALL_ACCESS_TOKEN, callAccessToken);

    loadValueHolder();
  }

  String getCallAccessToken() {
    return shared.getString(Const.VALUE_HOLDER_CALL_ACCESS_TOKEN);
  }

  Future<dynamic> replaceNotificationToken(String notificationToken) async {
    await shared.setString(
        Const.VALUE_HOLDER_NOTIFICATION_TOKEN, notificationToken);

    loadValueHolder();
  }

  String getNotificationToken() {
    return shared.getString(Const.VALUE_HOLDER_NOTIFICATION_TOKEN);
  }

  Future<dynamic> replaceAssignedNumber(String assignedNumber) async {
    await shared.setString(Const.VALUE_HOLDER_ASSIGNED_NUMBER, assignedNumber);

    loadValueHolder();
  }

  String getAssignedNumber() {
    return shared.getString(Const.VALUE_HOLDER_ASSIGNED_NUMBER);
  }

  Future<dynamic> replaceDefaultCountryCode(String defaultCountryCode) async {
    await shared.setString(
        Const.VALUE_HOLDER_DEFAULT_COUNTRY_CODE, defaultCountryCode);

    loadValueHolder();
  }

  String getDefaultCountryCode() {
    return shared.getString(Const.VALUE_HOLDER_DEFAULT_COUNTRY_CODE);
  }

  Future<dynamic> replaceIncomingCallNotificationSetting(
      bool incomingCallNotificationSetting) async {
    await shared.setBool(Const.VALUE_HOLDER_INCOMING_CALL_NOTIFICATION_SETTING,
        incomingCallNotificationSetting);

    loadValueHolder();
  }

  bool getIncomingCallNotificationSetting() {
    return shared
        .getBool(Const.VALUE_HOLDER_INCOMING_CALL_NOTIFICATION_SETTING);
  }

  Future<dynamic> replaceSmsNotificationSetting(
      bool smsNotificationSetting) async {
    await shared.setBool(
        Const.VALUE_HOLDER_SMS_NOTIFICATION_SETTING, smsNotificationSetting);

    loadValueHolder();
  }

  bool getSmsNotificationSetting() {
    return shared.getBool(Const.VALUE_HOLDER_SMS_NOTIFICATION_SETTING);
  }

  Future<dynamic> replaceNoticeNotificationSetting(
      bool noticeNotificationSetting) async {
    await shared.setBool(Const.VALUE_HOLDER_NOTICE_NOTIFICATION_SETTING,
        noticeNotificationSetting);

    loadValueHolder();
  }

  bool getNoticeNotificationSetting() {
    return shared.getBool(Const.VALUE_HOLDER_NOTICE_NOTIFICATION_SETTING);
  }

  Future<dynamic> replaceDefaultWorkspace(String defaultWorkSpace) async {
    await shared.setString(Const.VALUE_HOLDER_DEFAULT_WORKSPACE, defaultWorkSpace);

    loadValueHolder();
  }

  String getDefaultWorkspace() {
    return shared.getString(Const.VALUE_HOLDER_DEFAULT_WORKSPACE);
  }

  Future<dynamic> replaceWorkspaceDetail(String workspaceDetail) async {
    if (workspaceDetail != null) {
      await shared.setString(
          Const.VALUE_HOLDER_WORKSPACE_DETAIL, workspaceDetail);
      loadValueHolder();
    }
  }

  String getWorkspaceDetail() {
    return shared.getString(Const.VALUE_HOLDER_WORKSPACE_DETAIL);
  }

  Future<dynamic> replaceDefaultChannel(String defaultChannel) async {
    if (defaultChannel != null) {
      await shared.setString(
          Const.VALUE_HOLDER_DEFAULT_CHANNEL, defaultChannel);
      loadValueHolder();
    }
  }

  String getDefaultChannel() {
    return shared.getString(Const.VALUE_HOLDER_DEFAULT_CHANNEL);
  }

  Future<dynamic> replaceChannelList(List<String> channelList) async {
    await shared.setStringList(Const.VALUE_HOLDER_CHANNEL_LIST, channelList);

    loadValueHolder();
  }

  List<String> getChannelList() {
    return shared.getStringList(Const.VALUE_HOLDER_CHANNEL_LIST);
  }

  Future<dynamic> replaceVoiceToken(String defaultChannel) async {
    await shared.setString(Const.VALUE_HOLDER_VOICE_TOKEN, defaultChannel);

    loadValueHolder();
  }

  String getVoiceToken() {
    return shared.getString(Const.VALUE_HOLDER_VOICE_TOKEN);
  }

  Future<dynamic> replaceDefaultLanguage(String defaultLanguage) async {
    await shared.setString(
        Const.VALUE_HOLDER_DEFAULT_LANGUAGE, defaultLanguage);

    loadValueHolder();
  }

  String getDefaultLanguage() {
    return shared.getString(Const.VALUE_HOLDER_DEFAULT_LANGUAGE);
  }

  Future<dynamic> replaceUserProfilePicture(String defaultWorkSpace) async {
    await shared.setString(Const.VALUE_HOLDER_PROFILE_PICTURE, defaultWorkSpace);

    loadValueHolder();
  }

  String getUserProfilePicture() {
    return shared.getString(Const.VALUE_HOLDER_PROFILE_PICTURE);
  }

  Future<dynamic> replaceSessionId(String sessionId) async {
    await shared.setString(Const.VALUE_HOLDER_SESSION_ID, sessionId);

    loadValueHolder();
  }

  String getSessionId() {
    return shared.getString(Const.VALUE_HOLDER_SESSION_ID);
  }

  Future<dynamic> replaceRefreshToken(String token) async {
    await shared.setString(Const.VALUE_HOLDER_REFRESH_TOKEN, token);
    loadValueHolder();
  }

  String getRefreshToken() {
    return shared.getString(Const.VALUE_HOLDER_REFRESH_TOKEN);
  }

  Future<dynamic> replaceSelectedSound(String selectedSound) async {
    await shared.setString(Const.VALUE_HOLDER_SELECTED_SOUND, selectedSound);
    loadValueHolder();
  }

  String getSelectedSound() {
    return shared.getString(Const.VALUE_HOLDER_SELECTED_SOUND);
  }
}
