import 'package:voice_example/viewobject/model/members/MemberEdges.dart';
import 'package:sembast/sembast.dart';
import 'package:voice_example/db/common/Dao.dart';

class MemberDao extends Dao<MemberEdges>
{
  MemberDao._()
  {
    init(MemberEdges());
  }
  static const String STORE_NAME = 'krispcallMvp_Member';
  final String _primaryKey = 'id';

  // Singleton instance
  static final MemberDao _singleton = MemberDao._();

  // Singleton accessor
  static MemberDao get instance => _singleton;

  @override
  String getStoreName()
  {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(MemberEdges object)
  {
    return object.members.id;
  }


  @override
  Filter getFilter(MemberEdges object)
  {
    return Filter.equals(_primaryKey, object.members.id);
  }
  
}
