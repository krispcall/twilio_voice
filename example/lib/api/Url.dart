
class Url {

  Url._();

  static const String post_user_login = 'token';
  static const String  refresh_token ='refresh';

  static const String get_call_access_token = 'call_access_token_mobile';

  static const String post_fcm = 'add-fcm-token';

  /*Contacts*/
  static const String get_all_contacts = 'contacts';
  static const String search_contacts = 'search/contacts';
  static const String post_add_contacts = 'contact';
  static const String put_edit_contact = 'contact/';

  static const String version = 'version';

  /*Call logs*/
  static const String get_all_call_logs = 'mobile/calls/list';
  static const String get_all_searchded_call_logs = 'call/list';
  static const String delete_call_log = 'call/delete';

  /*messages*/
  static const String get_all_messages = 'viewmessages';
  static const String load_sms = 'sms/load';
  static const String send_sms = 'sendsms';
  static const String post_delete_message = 'sms/deletemessages';

  /*users */
  static const String update_username_url = 'change_name';
  static const String user_info = 'userinfo';
  static const String change_password_url = 'change_password';

  static const String ps_user_url = 'rest/users/get';
  static const String ps_userinfo_url = 'userinfo';

}
