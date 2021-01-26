


import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'SecureStorageRepository.dart';

class SecureStorageRepositoryImpl extends SecureStorageRepository {

  //Login Pref
  static const String STORAGE_KEY_TOKEN = "api_token";
  static const String STORAGE_KEY_LOGINID = "login_id";
  static const String STORAGE_KEY_NAME = "login_name";
  static const String STORAGE_KEY_EMAIL = "login_email";
  static const String STORAGE_KEY_MOBILENO = "login_mobileno";
  static const String STORAGE_KEY_ADDRESS = "login_address";
  static const String STORAGE_KEY_MOBILE_VERIFIED = "login_mobile_verified";
  static const String STORAGE_KEY_EMAIL_VERIFIED = "login_email_verified";
  static const String STORAGE_KEY_LATITUDE =  "latitude";
  static const String STORAGE_KEY_LONGITUDE =  "longitude";
  static const String STORAGE_KEY_LOCATION =  "location";
  static const String STORAGE_KEY_HOMEORRES =  "homeorres";
  static const String STORAGE_KEY_VEGORNON =  "vegornon";
  static const String STORAGE_KEY_SORT_TYPE =  "sort_type";
  static const String STORAGE_KEY_FEATURENAME =  "featurename";
  static const String STORAGE_KEY_LOCALITY =  "locality";
  static const String STORAGE_KEY_POSTALCODE =  "postal_code";
  static const String STORAGE_KEY_SUBLOCALITY =  "sub_locality";
  static const String STORAGE_KEY_SUBADMIN =  "sub_admin";
  static const String STORAGE_KEY_COUNTRY =  "country";
  static const String STORAGE_KEY_NOTIFICATIONCOUNT =  "0";

  final storage = FlutterSecureStorage();

  @override
  Future<void> saveApiToken(String value) async {
    return _saveApiToken(STORAGE_KEY_TOKEN, value);
  }

  Future<void> _saveApiToken(String key, String value) async {
    return storage.write(key: key, value: value);
  }

  @override
  Future<String> getApiToken() {
    return _getApiToken(STORAGE_KEY_TOKEN);
  }

  Future<String> _getApiToken(String key) async {
    return storage.read(key: key);
  }

  @override
  Future<void> deleteApiToken() {
    return _deleteApiToken(STORAGE_KEY_TOKEN);
  }

  Future<void> _deleteApiToken(String key) async {
    return storage.delete(key: key);
  }

  @override
  Future<void> saveLoginId(String value) async {
    return _saveLoginId(STORAGE_KEY_LOGINID, value);
  }

  Future<void> _saveLoginId(String key, String value) async {
    return storage.write(key: key, value: value);
  }

  @override
  Future<String> getLoginId() {
    return _getLoginId(STORAGE_KEY_LOGINID);
  }

  Future<String> _getLoginId(String key) async {
    return storage.read(key: key);
  }

  @override
  Future<void> deleteLoginId() {
    return _deleteLoginId(STORAGE_KEY_LOGINID);
  }

  Future<void> _deleteLoginId(String key) async {
    return storage.delete(key: key);
  }

  @override
  Future<void> saveLoginName(String value) async {
    return _saveLoginName(STORAGE_KEY_NAME, value);
  }

  Future<void> _saveLoginName(String key, String value) async {
    return storage.write(key: key, value: value);
  }

  @override
  Future<String> getLoginName() {
    return _getLoginName(STORAGE_KEY_NAME);
  }

  Future<String> _getLoginName(String key) async {
    return storage.read(key: key);
  }

  @override
  Future<void> deleteLoginName() {
    return _deleteLoginName(STORAGE_KEY_NAME);
  }

  Future<void> _deleteLoginName(String key) async {
    return storage.delete(key: key);
  }

  @override
  Future<void> saveLoginEmail(String value) async {
    return _saveLoginEmail(STORAGE_KEY_EMAIL, value);
  }

  Future<void> _saveLoginEmail(String key, String value) async {
    return storage.write(key: key, value: value);
  }

  @override
  Future<String> getLoginEmail() {
    return _getLoginEmail(STORAGE_KEY_EMAIL);
  }

  Future<String> _getLoginEmail(String key) async {
    return storage.read(key: key);
  }

  @override
  Future<void> deleteLoginEmail() {
    return _deleteLoginEmail(STORAGE_KEY_EMAIL);
  }

  Future<void> _deleteLoginEmail(String key) async {
    return storage.delete(key: key);
  }

  @override
  Future<void> saveLoginMobileno(String value) async {
    return _saveLoginMobileno(STORAGE_KEY_MOBILENO, value);
  }

  Future<void> _saveLoginMobileno(String key, String value) async {
    return storage.write(key: key, value: value);
  }

  @override
  Future<String> getLoginMobileno() {
    return _getLoginMobileno(STORAGE_KEY_MOBILENO);
  }

  Future<String> _getLoginMobileno(String key) async {
    return storage.read(key: key);
  }

  @override
  Future<void> deleteLoginMobileno() {
    return _deleteLoginMobileno(STORAGE_KEY_MOBILENO);
  }

  Future<void> _deleteLoginMobileno(String key) async {
    return storage.delete(key: key);
  }

  @override
  Future<void> saveLoginAddress(String value) async {
    return _saveLoginAddress(STORAGE_KEY_ADDRESS, value);
  }

  Future<void> _saveLoginAddress(String key, String value) async {
    return storage.write(key: key, value: value);
  }

  @override
  Future<String> getLoginAddress() {
    return _getLoginAddress(STORAGE_KEY_ADDRESS);
  }

  Future<String> _getLoginAddress(String key) async {
    return storage.read(key: key);
  }

  @override
  Future<void> deleteLoginAddress() {
    return _deleteLoginAddress(STORAGE_KEY_ADDRESS);
  }

  Future<void> _deleteLoginAddress(String key) async {
    return storage.delete(key: key);
  }

  @override
  Future<void> saveMobileVerified(String value) async {
    return _saveMobileVerified(STORAGE_KEY_MOBILE_VERIFIED, value);
  }

  Future<void> _saveMobileVerified(String key, String value) async {
    return storage.write(key: key, value: value);
  }

  @override
  Future<String> getMobileVerified() {
    return _getMobileVerified(STORAGE_KEY_MOBILE_VERIFIED);
  }

  Future<String> _getMobileVerified(String key) async {
    return storage.read(key: key);
  }

  @override
  Future<void> deleteMobileVerified() {
    return _deleteMobileVerified(STORAGE_KEY_MOBILE_VERIFIED);
  }

  Future<void> _deleteMobileVerified(String key) async {
    return storage.delete(key: key);
  }

  @override
  Future<void> saveEmailVerified(String value) async {
    return _saveEmailVerified(STORAGE_KEY_EMAIL_VERIFIED, value);
  }

  Future<void> _saveEmailVerified(String key, String value) async {
    return storage.write(key: key, value: value);
  }

  @override
  Future<String> getEmailVerified() {
    return _getEmailVerified(STORAGE_KEY_EMAIL_VERIFIED);
  }

  Future<String> _getEmailVerified(String key) async {
    return storage.read(key: key);
  }

  @override
  Future<void> deleteEmailVerified() {
    return _deleteEmailVerified(STORAGE_KEY_EMAIL_VERIFIED);
  }

  Future<void> _deleteEmailVerified(String key) async {
    return storage.delete(key: key);
  }

  @override
  Future<void> saveLatitude(String value) async {
    return _saveLatitude(STORAGE_KEY_LATITUDE,value);
  }

  Future<void> _saveLatitude(String key, String value) async {
    return storage.write(key: key, value: value);
  }

  @override
  Future<String> getLatitude() async{
    return _getLatitude(STORAGE_KEY_LATITUDE);
  }

  Future<String> _getLatitude(String key) async {
    return storage.read(key: key);
  }

  @override
  Future<void> deleteLatitude() {
    return _deleteLatitude(STORAGE_KEY_LATITUDE);
  }

  Future<void> _deleteLatitude(String key) async {
    return storage.delete(key: key);
  }

  @override
  Future<void> saveLongitude(String value) async {
    return _saveLongitude(STORAGE_KEY_LONGITUDE, value);
  }

  Future<void> _saveLongitude(String key, String value) async {
    return storage.write(key: key, value: value);
  }

  @override
  Future<String> getLongitude() async{
    return _getLongitude(STORAGE_KEY_LONGITUDE);
  }

  Future<String> _getLongitude(String key) async {
    return storage.read(key: key);
  }

  @override
  Future<void> deleteLongitude() {
    return _deleteLongitude(STORAGE_KEY_LONGITUDE);
  }

  Future<void> _deleteLongitude(String key) async {
    return storage.delete(key: key);
  }

  @override
  Future<void> saveLocation(String value) async {
    return _saveLocation(STORAGE_KEY_LOCATION, value);
  }

  Future<void> _saveLocation(String key, String value) async {
    return storage.write(key: key, value: value);
  }

  @override
  Future<String> getLocation() {
    return _getLocation(STORAGE_KEY_LOCATION);
  }

  Future<String> _getLocation(String key) async {
    return storage.read(key: key);
  }

  @override
  Future<void> deleteLocation() {
    return _deleteLocation(STORAGE_KEY_LOCATION);
  }

  Future<void> _deleteLocation(String key) async {
    return storage.delete(key: key);
  }

  @override
  Future<void> saveHomeorRes(String value) async {
    return _saveHomeorRes(STORAGE_KEY_HOMEORRES, value);
  }

  Future<void> _saveHomeorRes(String key, String value) async {
    return storage.write(key: key, value: value);
  }

  @override
  Future<String> getHomeorRes() {
    return _getHomeorRes(STORAGE_KEY_HOMEORRES);
  }

  Future<String> _getHomeorRes(String key) async {
    return storage.read(key: key);
  }

  @override
  Future<void> deleteHomeorRes() {
    return _deleteHomeorRes(STORAGE_KEY_LOCATION);
  }

  Future<void> _deleteHomeorRes(String key) async {
    return storage.delete(key: key);
  }

  Future<void> saveVegorNon(String value) async {
    return _saveVegorNon(STORAGE_KEY_VEGORNON, value);
  }

  Future<void> _saveVegorNon(String key, String value) async {
    return storage.write(key: key, value: value);
  }

  @override
  Future<String> getVegorNon() {
    return _getVegorNon(STORAGE_KEY_VEGORNON);
  }

  Future<String> _getVegorNon(String key) async {
    return storage.read(key: key);
  }

  @override
  Future<void> deleteVegorNon() {
    return _deleteVegorNon(STORAGE_KEY_VEGORNON);
  }

  Future<void> _deleteVegorNon(String key) async {
    return storage.delete(key: key);
  }

  Future<void> saveSortType(String value) async {
    return storage.write(key: STORAGE_KEY_SORT_TYPE, value: value);
  }

  @override
  Future<String> getSortType() {
    return storage.read(key: STORAGE_KEY_SORT_TYPE);
  }

  @override
  Future<void> deleteSortType() {
    return storage.delete(key: STORAGE_KEY_SORT_TYPE);
  }

  Future<void> saveFeatureName(String value) async {
    return _saveFeatureName(STORAGE_KEY_FEATURENAME, value);
  }

  Future<void> _saveFeatureName(String key, String value) async {
    return storage.write(key: key, value: value);
  }

  @override
  Future<String> getFeatureName() {
    return _getFeatureName(STORAGE_KEY_FEATURENAME);
  }

  Future<String> _getFeatureName(String key) async {
    return storage.read(key: key);
  }

  @override
  Future<void> deleteFeatureName() {
    return _deleteFeatureName(STORAGE_KEY_FEATURENAME);
  }

  Future<void> _deleteFeatureName(String key) async {
    return storage.delete(key: key);
  }

  Future<void> saveLocality(String value) async {
    return _saveLocality(STORAGE_KEY_LOCALITY, value);
  }

  Future<void> _saveLocality(String key, String value) async {
    return storage.write(key: key, value: value);
  }

  @override
  Future<String> getLocality() {
    return _getLocality(STORAGE_KEY_LOCALITY);
  }

  Future<String> _getLocality(String key) async {
    return storage.read(key: key);
  }

  @override
  Future<void> deleteLocality() {
    return _deleteLocality(STORAGE_KEY_LOCALITY);
  }

  Future<void> _deleteLocality(String key) async {
    return storage.delete(key: key);
  }

  Future<void> savePostalCode(String value) async {
    return _savePostalCode(STORAGE_KEY_POSTALCODE, value);
  }

  Future<void> _savePostalCode(String key, String value) async {
    return storage.write(key: key, value: value);
  }

  @override
  Future<String> getPostalCode() {
    return _getPostalCode(STORAGE_KEY_POSTALCODE);
  }

  Future<String> _getPostalCode(String key) async {
    return storage.read(key: key);
  }

  @override
  Future<void> deletePostalCode() {
    return _deletePostalCode(STORAGE_KEY_POSTALCODE);
  }

  Future<void> _deletePostalCode(String key) async {
    return storage.delete(key: key);
  }

  Future<void> saveSubLocality(String value) async {
    return _saveSubLocality(STORAGE_KEY_SUBLOCALITY, value);
  }

  Future<void> _saveSubLocality(String key, String value) async {
    return storage.write(key: key, value: value);
  }

  @override
  Future<String> getSubLocality() {
    return _getSubLocality(STORAGE_KEY_SUBLOCALITY);
  }

  Future<String> _getSubLocality(String key) async {
    return storage.read(key: key);
  }

  @override
  Future<void> deleteSubLocality() {
    return _deleteSubLocality(STORAGE_KEY_SUBLOCALITY);
  }

  Future<void> _deleteSubLocality(String key) async {
    return storage.delete(key: key);
  }

  Future<void> saveSubAdmin(String value) async {
    return _saveSubAdmin(STORAGE_KEY_SUBADMIN, value);
  }

  Future<void> _saveSubAdmin(String key, String value) async {
    return storage.write(key: key, value: value);
  }

  @override
  Future<String> getSubAdmin() {
    return _getSubAdmin(STORAGE_KEY_SUBADMIN);
  }

  Future<String> _getSubAdmin(String key) async {
    return storage.read(key: key);
  }

  @override
  Future<void> deleteSubAdmin() {
    return _deleteSubAdmin(STORAGE_KEY_SUBADMIN);
  }

  Future<void> _deleteSubAdmin(String key) async {
    return storage.delete(key: key);
  }

  Future<void> saveCountryName(String value) async {
    return _saveCountryName(STORAGE_KEY_COUNTRY, value);
  }

  Future<void> _saveCountryName(String key, String value) async {
    return storage.write(key: key, value: value);
  }

  @override
  Future<String> getCountryName() {
    return _getCountryName(STORAGE_KEY_COUNTRY);
  }

  Future<String> _getCountryName(String key) async {
    return storage.read(key: key);
  }

  @override
  Future<void> deleteCountryName() {
    return _deleteCountryName(STORAGE_KEY_COUNTRY);
  }

  Future<void> _deleteCountryName(String key) async {
    return storage.delete(key: key);
  }

  Future<void> saveNotificationCount(String value) async {
    return _saveNotificationCount(STORAGE_KEY_NOTIFICATIONCOUNT, value);
  }

  Future<void> _saveNotificationCount(String key, String value) async {
    return storage.write(key: key, value: value);
  }

  @override
  Future<String> getNotificationCount() {
    return _getNotificationCount(STORAGE_KEY_NOTIFICATIONCOUNT);
  }

  Future<String> _getNotificationCount(String key) async {
    return storage.read(key: key);
  }

  @override
  Future<void> deleteNotificationCount() {
    return _deleteNotificationCount(STORAGE_KEY_NOTIFICATIONCOUNT);
  }

  Future<void> _deleteNotificationCount(String key) async {
    return storage.delete(key: key);
  }

}
