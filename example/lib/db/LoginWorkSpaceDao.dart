import 'package:voice_example/viewobject/model/login/LoginWorkspace.dart';
import 'package:sembast/sembast.dart';
import 'package:voice_example/db/common/Dao.dart';

class LoginWorkSpaceDao extends Dao<LoginWorkspace>
{
  LoginWorkSpaceDao._()
  {
    init(LoginWorkspace());
  }

  static const String STORE_NAME = 'krispcallMvp_LoginWorkspace';
  final String _primaryKey = 'id';

  // Singleton instance
  static final LoginWorkSpaceDao _singleton = LoginWorkSpaceDao._();

  // Singleton accessor
  static LoginWorkSpaceDao get instance => _singleton;

  @override
  String getPrimaryKey(LoginWorkspace object)
  {
    return object.id;
  }

  @override
  String getStoreName()
  {
    return STORE_NAME;
  }

  @override
  Filter getFilter(LoginWorkspace object)
  {
    return Filter.equals(_primaryKey, object.id);
  }
}
