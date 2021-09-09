import 'package:voice_example/db/common/Dao.dart';
import 'package:voice_example/viewobject/model/call/RecentConversationEdges.dart';
import 'package:sembast/sembast.dart';

class CallLogDao extends Dao<RecentConversationEdges>
{
  CallLogDao._()
  {
    init(RecentConversationEdges());
  }
  static const String TABLE_NAME = 'krispcallMvp_RecentConversation';
  final String _primaryKey = 'id';

  // Singleton instance
  static final CallLogDao _singleton = CallLogDao._();

  // Singleton accessor
  static CallLogDao get instance => _singleton;

  @override
  String getStoreName() {
    return TABLE_NAME;
  }

  @override
  String getPrimaryKey(RecentConversationEdges object)
  {
    return object.recentConversationNodes.id;
  }

  @override
  Filter getFilter(RecentConversationEdges object)
  {
    return Filter.equals(_primaryKey, object.recentConversationNodes.id);
  }
}
