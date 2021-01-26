
abstract class SecureStorageRepository {


  //Login Details
  Future<void> saveApiToken(String value);
  Future<String> getApiToken();
  Future<void> deleteApiToken();

  Future<void> saveLoginId(String value);
  Future<String> getLoginId();
  Future<void> deleteLoginId();
}
