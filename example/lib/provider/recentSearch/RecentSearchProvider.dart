import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/provider/common/ps_provider.dart';
import 'package:voice_example/repository/RecentSearchRepository.dart';
import 'package:voice_example/viewobject/model/recentSearch/RecentSearch.dart';

class RecentSearchProvider extends Provider
{
  RecentSearchProvider({
    @required RecentSearchRepository recentSearchRepository,
    int limit = 0
  }) : super(recentSearchRepository, limit)
  {
    this.recentSearchRepository = recentSearchRepository;
    isDispose = false;

    streamControllerRecentSearch = StreamController<Resources<List<RecentSearch>>>.broadcast();
    subscriptionRecentSearch = streamControllerRecentSearch.stream.listen((Resources<List<RecentSearch>> resource)
    {
      if (resource != null && resource.data != null)
      {
        _recentSearch = resource;
      }

      if (resource.status != Status.BLOCK_LOADING && resource.status != Status.PROGRESS_LOADING)
      {
        isLoading = false;
      }

      if (!isDispose)
      {
        notifyListeners();
      }
    });
  }

  RecentSearchRepository recentSearchRepository;

  Resources<List<RecentSearch>> _recentSearch = Resources<List<RecentSearch>>(Status.NO_ACTION, '', null);
  Resources<List<RecentSearch>> get recentSearch => _recentSearch;

  StreamSubscription<Resources<List<RecentSearch>>> subscriptionRecentSearch;
  StreamController<Resources<List<RecentSearch>>> streamControllerRecentSearch;

  @override
  void dispose()
  {
    subscriptionRecentSearch.cancel();
    streamControllerRecentSearch.close();

    isDispose = true;
    super.dispose();
  }

  Future<dynamic>  getRecentSearchListFromDb() async
  {
    isLoading = true;

    _recentSearch = await recentSearchRepository.getRecentSearchListFromDb();

    Resources<List<RecentSearch>> reversed = Resources<List<RecentSearch>>(Status.SUCCESS,"",_recentSearch.data.reversed.toList());
    streamControllerRecentSearch.sink.add(reversed);
    return reversed;
  }

  Future<dynamic> addRecentSearchToDb(RecentSearch value) async
  {
    _recentSearch = await recentSearchRepository.addRecentSearchToDb(value);
    Resources<List<RecentSearch>> reversed = Resources<List<RecentSearch>>(Status.SUCCESS,"",_recentSearch.data.reversed.toList());
    streamControllerRecentSearch.sink.add(reversed);
    return reversed;
  }

  Future<dynamic>  removeAllRecentSearchFromDb() async
  {
    isLoading = true;

    _recentSearch = await recentSearchRepository.removeAllRecentSearchFromDb();

    Resources<List<RecentSearch>> reversed = Resources<List<RecentSearch>>(Status.SUCCESS,"",_recentSearch.data.reversed.toList());
    streamControllerRecentSearch.sink.add(reversed);
    return reversed;
  }

  Future<dynamic>  removeSearchKeywordFromDb(RecentSearch keyword) async
  {
    isLoading = true;

    _recentSearch = await recentSearchRepository.removeSearchKeywordFromDb(keyword);

    Resources<List<RecentSearch>> reversed = Resources<List<RecentSearch>>(Status.SUCCESS,"",_recentSearch.data.reversed.toList());
    streamControllerRecentSearch.sink.add(reversed);
    return reversed;
  }
}
