/*
 * *
 *  * Created by Kedar on 7/13/21 7:30 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/13/21 7:30 AM
 *  
 */

import 'package:voice_example/viewobject/model/allContact/Tags.dart';
import 'package:voice_example/viewobject/model/numbers/Numbers.dart';
import 'package:voice_example/viewobject/model/teams/Teams.dart';
import 'package:sembast/sembast.dart';
import 'package:voice_example/db/common/Dao.dart';

class NumberDao extends Dao<Numbers> {
  NumberDao._() {
    init(Numbers());
  }

  static const String TABLE_NAME = 'krispcallMvp_TMyNumbers';
  final String _primaryKey = 'id';

  // Singleton instance
  static final NumberDao _singleton = NumberDao._();

  // Singleton accessor
  static NumberDao get instance => _singleton;

  @override
  String getStoreName() {
    return TABLE_NAME;
  }

  @override
  String getPrimaryKey(Numbers object) {
    return object.id;
  }

  @override
  Filter getFilter(Numbers object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
