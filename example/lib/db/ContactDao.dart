import 'package:voice_example/db/common/Dao.dart';
import 'package:voice_example/viewobject/model/allContact/AllContactEdges.dart';
import 'package:sembast/sembast.dart';

class ContactDao extends Dao<AllContactEdges> {
  ContactDao._() {
    init(AllContactEdges());
  }

  static const String STORE_NAME = 'krispcallMvp_Contacts';
  final String _primaryKey = 'id';

  // Singleton instance
  static final ContactDao _singleton = ContactDao._();

  // Singleton accessor
  static ContactDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(AllContactEdges object) {
    return obj.id;
  }

  @override
  Filter getFilter(AllContactEdges object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
