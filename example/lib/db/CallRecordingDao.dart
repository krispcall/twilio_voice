import 'package:voice_example/viewobject/model/call/RecentConversationEdges.dart';
import 'package:sembast/sembast.dart';
import 'package:voice_example/db/common/Dao.dart';

class CallRecordingDao extends Dao<RecentConversationEdges> {
  CallRecordingDao._() {
    init(RecentConversationEdges());
  }
  static const String STORE_NAME = 'krispcallMvp_CallRecordingDao';
  final String _primaryKey = 'id';

  // Singleton instance
  static final CallRecordingDao _singleton = CallRecordingDao._();

  // Singleton accessor
  static CallRecordingDao get instance => _singleton;

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

