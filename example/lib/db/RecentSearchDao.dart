import 'package:voice_example/db/common/Dao.dart';
import 'package:voice_example/viewobject/model/recentSearch/RecentSearch.dart';
import 'package:sembast/sembast.dart';

class RecentSearchDao extends Dao<RecentSearch>
{
  RecentSearchDao._()
  {
    init(RecentSearch());
  }
  static const String TABLE_NAME = 'krispcallMvp_RecentSearch';
  final String _primaryKey = "";

  // Singleton instance
  static final RecentSearchDao _singleton = RecentSearchDao._();

  // Singleton accessor
  static RecentSearchDao get instance => _singleton;

  @override
  String getStoreName()
  {
    return TABLE_NAME;
  }

  @override
  String getPrimaryKey(RecentSearch object)
  {
    return "";
  }

  @override
  Filter getFilter(RecentSearch object)
  {
    return Filter.equals(_primaryKey, "");
  }
}
