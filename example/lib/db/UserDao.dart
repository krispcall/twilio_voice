import 'package:voice_example/viewobject/model/login/UserProfile.dart';
import 'package:sembast/sembast.dart';
import 'package:voice_example/db/common/Dao.dart';

class UserDao extends Dao<UserProfile>
{
  UserDao._()
  {
    init(UserProfile());
  }

  static const String STORE_NAME = 'krispcallMvp_User';
  final String _primaryKey = 'email';

  // Singleton instance
  static final UserDao _singleton = UserDao._();

  // Singleton accessor
  static UserDao get instance => _singleton;

  @override
  String getPrimaryKey(UserProfile object)
  {
    return "";
  }

  @override
  String getStoreName()
  {
    return STORE_NAME;
  }

  @override
  Filter getFilter(UserProfile object)
  {
    return Filter.equals(_primaryKey, object.email);
  }
}
