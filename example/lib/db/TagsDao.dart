import 'package:voice_example/viewobject/model/allContact/Tags.dart';
import 'package:sembast/sembast.dart';
import 'package:voice_example/db/common/Dao.dart';
/*
 * *
 *  * Created by Kedar on 7/13/21 7:30 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/13/21 7:30 AM
 *  
 */

class TagsDao extends Dao<Tags>
{
  TagsDao._() {
    init(Tags());
  }

  static const String TABLE_NAME = 'krispcallMvp_Tags';
  final String _primaryKey = 'id';

  // Singleton instance
  static final TagsDao _singleton = TagsDao._();

  // Singleton accessor
  static TagsDao get instance => _singleton;

  @override
  String getStoreName()
  {
    return TABLE_NAME;
  }

  @override
  String getPrimaryKey(Tags object)
  {
    return object.id;
  }

  @override
  Filter getFilter(Tags object)
  {
    return Filter.equals(_primaryKey, object.id);
  }
}
