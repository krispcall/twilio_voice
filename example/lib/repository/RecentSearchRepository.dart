import 'package:flutter/material.dart';
import 'package:voice_example/db/RecentSearchDao.dart';
import 'package:voice_example/repository/Common/Respository.dart';
import 'package:voice_example/viewobject/model/recentSearch/RecentSearch.dart';
import 'package:sembast/sembast.dart';

class RecentSearchRepository extends Repository
{
  RecentSearchRepository({
    @required RecentSearchDao recentSearchDao,
  }) {
    this.recentSearchDao = recentSearchDao;
  }

  RecentSearchDao recentSearchDao;

  String primaryKey = '';

  Future<dynamic> getRecentSearchListFromDb() async
  {
    return recentSearchDao.getAll();
  }

  Future<dynamic> addRecentSearchToDb(RecentSearch value) async
  {
    Finder finder = Finder(filter: Filter.matches('recentSearch', value.recentSearch));

    await recentSearchDao.deleteWithFinder(finder);

    await recentSearchDao.insert(primaryKey, value);

    return recentSearchDao.getAll();
  }

  Future<dynamic> removeAllRecentSearchFromDb() async
  {
    await recentSearchDao.deleteAll();

    return recentSearchDao.getAll();
  }

  Future<dynamic> removeSearchKeywordFromDb(RecentSearch value) async
  {
    Finder finder = Finder(filter: Filter.matches('recentSearch', value.recentSearch));

    await recentSearchDao.deleteWithFinder(finder);

    return recentSearchDao.getAll();
  }
}
