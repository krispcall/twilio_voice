
import 'ResponseUni.dart';

class ResponseLogin extends ResponseUni<ResponseLogin> {
  String accessToken;
  String tokenType;
  User user;
  String sessionId;

  ResponseLogin({this.accessToken, this.tokenType, this.sessionId, this.user});

  ResponseLogin.fromJson(Map<String, dynamic> json) {
    accessToken=(json['access_token']).toString();
    tokenType=json['token_type'];
    sessionId=(json['session_id']).toString();
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  @override
  ResponseLogin fromMap(dynamic dynamicData) {
    if (dynamicData != null)
    {
      return ResponseLogin(
        accessToken: dynamicData['access_token'],
        tokenType: dynamicData['token_type'],
        sessionId: dynamicData['session_id'],
        user:dynamicData['user']!=null?User.fromJson(dynamicData['user']):null,
      );
    }
    else
    {
      return null;
    }
  }

  @override
  String getPrimaryKey() {
    return '';
  }

  @override
  Map<String, dynamic> toMap(ResponseLogin object) {
    if (object != null)
    {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['access_token'] = object.accessToken;
      data['token_type'] = object.tokenType;
      data['session_id'] = object.sessionId;
      data['user'] = object.user!=null?object.user.toJson():null;
      return data;
    }
    else
    {
      return null;
    }
  }
}


class User {
  String id;
  String username;
  String email;
  String fullName;
  bool disabled;
  String assignedNumber;
  String role;
  String accountSid;
  String currentOnlineAgents;
  String sessions;
  String authKey;
  String voiceInboundUrl;
  String smsInboundUrl;
  String outboundApplicationSid;
  String voiceOutboundUrl;
  String password;

  User(
      {this.id,
        this.username,
        this.email,
        this.fullName,
        this.disabled,
        this.assignedNumber,
        this.role,
        this.accountSid,
        this.currentOnlineAgents,
        this.sessions,
        this.authKey,
        this.voiceInboundUrl,
        this.smsInboundUrl,
        this.outboundApplicationSid,
        this.voiceOutboundUrl,
        this.password});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    username = json['username'].toString();
    email = json['email'].toString();
    fullName = json['full_name'].toString();
    disabled = json['disabled'];
    assignedNumber = json['assigned_number'].toString();
    role = json['role'].toString();
    accountSid = json['account_sid'].toString();
    currentOnlineAgents = json['current_online_agents'].toString();
    sessions = json['sessions'].toString();
    authKey = json['auth_key'].toString();
    voiceInboundUrl = json['voice_inbound_url'].toString();
    smsInboundUrl = json['sms_inbound_url'].toString();
    outboundApplicationSid = json['outbound_application_sid'].toString();
    voiceOutboundUrl = json['voice_outbound_url'].toString();
    password = json['password'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['full_name'] = this.fullName;
    data['disabled'] = this.disabled;
    data['assigned_number'] = this.assignedNumber;
    data['role'] = this.role;
    data['account_sid'] = this.accountSid;
    data['current_online_agents'] = this.currentOnlineAgents;
    data['sessions'] = this.sessions;
    data['auth_key'] = this.authKey;
    data['voice_inbound_url'] = this.voiceInboundUrl;
    data['sms_inbound_url'] = this.smsInboundUrl;
    data['outbound_application_sid'] = this.outboundApplicationSid;
    data['voice_outbound_url'] = this.voiceOutboundUrl;
    data['password'] = this.password;
    return data;
  }
}