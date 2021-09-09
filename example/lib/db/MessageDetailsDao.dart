import 'package:voice_example/viewobject/model/call/RecentConversationEdges.dart';
import 'package:sembast/sembast.dart';
import 'package:voice_example/db/common/Dao.dart';

class MessageDetailsDao extends Dao<RecentConversationEdges> {
  MessageDetailsDao._() {
    init(RecentConversationEdges());
  }
  static const String STORE_NAME = 'krispcallMvp_ConversationDetails';
  final String _primaryKey = 'id';

  // Singleton instance
  static final MessageDetailsDao _singleton = MessageDetailsDao._();

  // Singleton accessor
  static MessageDetailsDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(RecentConversationEdges object)
  {
    return object.id;
  }

  @override
  Filter getFilter(RecentConversationEdges object)
  {
    return Filter.equals(_primaryKey, object.id);
  }

}

