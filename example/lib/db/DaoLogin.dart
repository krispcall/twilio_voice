import 'package:sembast/sembast.dart';
import 'package:voice_example/response/ResponseLogin.dart';

import 'Dao.dart';

class DaoLogin extends Dao<ResponseLogin> {
  DaoLogin(){
    init(ResponseLogin());
  }
  static const String STORE_NAME = 'krispcalllogin';
  final String _primaryKey = 'id';

  // Singleton instance
  static final DaoLogin _singleton = DaoLogin();

  // Singleton accessor
  static DaoLogin get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  Filter getFilter(ResponseLogin object)
  {
    return Filter.equals(_primaryKey, object.user.id);
  }
}
