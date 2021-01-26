import 'dart:async';
import 'dart:core';
import 'package:sembast/sembast.dart';
import 'package:voice_example/enum/StatusEnum.dart';
import 'package:voice_example/response/ResponseFormat.dart';
import 'package:voice_example/response/ResponseUni.dart';

import 'DaoDatabase.dart';

abstract class Dao<T extends ResponseUni<T>> {
  // dynamic dao;
  StoreRef<String, dynamic> dao;
  T obj;
  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get db async => await DaoDatabase.instance.database;

  void init(T obj) {
    // A Store with int keys and Map<String, dynamic> values.
    // This Store acts like a persistent map, values of which are Fruit objects converted to Map
    dao = stringMapStoreFactory.store(getStoreName());
    this.obj = obj;
  }

  String getStoreName();

  Filter getFilter(T object);

  Future<dynamic> insert(String primaryKey, T object) async {
    await deleteWithFinder(Finder(filter: Filter.equals(primaryKey, object.getPrimaryKey())));
    await dao.add(await db, obj.toMap(object));

    return true;
  }



  Future<dynamic> update(T object, {Finder finder}) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    finder ??= Finder(filter: getFilter(object));

    return await dao.update(await db, obj.toMap(object), finder: finder);
  }

  Future<dynamic> updateWithFinder(T object, Finder finder) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    await dao.update(
      await db,
      obj.toMap(object),
      finder: finder,
    );
  }

  Future<dynamic> deleteAll() async {
    await dao.delete(await db);
  }

  Future<dynamic> delete(T object, {Finder finder}) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    finder ??= Finder(filter: getFilter(object));

    //final Finder finder = Finder(filter: finder);
    await dao.delete(
      await db,
      finder: finder,
    );
  }

  Future<dynamic> deleteWithFinder(Finder finder) async {
    await dao.delete(
      await db,
      finder: finder,
    );
  }

  Future<ResponseFormat<List<T>>> getByKey(String key, String value, {List<SortOrder> sortOrderList, Status status = Status.SUCCESS}) async
  {
    final Finder finder = Finder(filter: Filter.equals(key, value));
    if (sortOrderList != null && sortOrderList.isNotEmpty)
    {
      finder.sortOrders = sortOrderList;
    }

    final dynamic recordSnapshots = await dao.find(
      await db,
      finder: finder,
    );
    final List<T> resultList = <T>[];
    recordSnapshots.forEach((dynamic snapshot) {
      resultList.add(obj.fromMap(snapshot.value));
    });

    return ResponseFormat<List<T>>(status, '', resultList);
  }

  Future<ResponseFormat<List<T>>> getAll(
      {Finder finder, Status status = Status.SUCCESS}) async {
    finder ??= Finder();
    final dynamic recordSnapshots = await dao.find(
      await db,
      finder: finder,
    );
    final List<T> resultList = <T>[];
    recordSnapshots.forEach((dynamic snapshot) {
      final T localObj = obj.fromMap(snapshot.value);
      localObj.key = snapshot.key;
      resultList.add(localObj);
    });

    return ResponseFormat<List<T>>(status, '', resultList);
  }

  Future<ResponseFormat<T>> getOne({Finder finder, Status status = Status.SUCCESS}) async {
    finder ??= Finder();
    final dynamic recordSnapshots = await dao.find(
      await db,
      finder: finder,
    );
    T result;

    for (dynamic snapshot in recordSnapshots) {
      final T localObj = obj.fromMap(snapshot.value);
      localObj.key = snapshot.key;
      result = localObj;
      break;
    }

    return ResponseFormat<T>(status, '', result);
  }
}
