import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/provider/common/ps_provider.dart';
import 'package:voice_example/repository/CountryListRepository.dart';
import 'package:voice_example/utils/utils.dart';
import 'package:voice_example/viewobject/model/country/CountryCode.dart';

class CountryListProvider extends Provider
{
  CountryListProvider({
    @required CountryRepository countryListRepository,
    int limit
  }) : super(countryListRepository, limit)
  {
    streamControllerCountryCodeList = StreamController<Resources<List<CountryCode>>>.broadcast();
    this.countryListRepository = countryListRepository;

    subscriptionCountryCodeList = streamControllerCountryCodeList.stream.listen((Resources<List<CountryCode>> resource)
    {
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

  CountryRepository countryListRepository;
  StreamController<Resources<List<CountryCode>>> streamControllerCountryCodeList;
  StreamSubscription<Resources<List<CountryCode>>> subscriptionCountryCodeList;

  Resources<List<CountryCode>> _countryList = Resources<List<CountryCode>>(Status.NO_ACTION, '', <CountryCode>[]);
  Resources<List<CountryCode>> get countryList => _countryList;

  @override
  void dispose()
  {
    streamControllerCountryCodeList.close();
    subscriptionCountryCodeList.cancel();

    isDispose = true;

    super.dispose();
  }

  Future<dynamic> doCountryListApiCall() async
  {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    _countryList = await countryListRepository.doCountryListApiCall(isConnectedToInternet, limit, offset, Status.PROGRESS_LOADING);
    streamControllerCountryCodeList.sink.add(_countryList);
    return _countryList;
  }

  Future<dynamic> getCountryListFromDb() async
  {
    isLoading = true;
    _countryList = await countryListRepository.getCountryListFromDb(isConnectedToInternet, limit, offset, Status.PROGRESS_LOADING);
    streamControllerCountryCodeList.sink.add(_countryList);
    return _countryList.data;
  }

  Future<dynamic> replaceDefaultCountryCode(String countryCode) async
  {
    isLoading = true;
    _countryList = await countryListRepository.getCountryListFromDb(isConnectedToInternet, limit, offset, Status.PROGRESS_LOADING);
    for(int i=0;i<_countryList.data.length;i++)
    {
      if(countryCode.contains(_countryList.data[i].dialCode))
      {
        countryListRepository.replaceDefaultCountryCode(json.encode(_countryList.data[i].toJson()));
        break;
      }
      else
      {
        countryListRepository.replaceDefaultCountryCode(json.encode(_countryList.data[i].toJson()));
      }
    }
  }

  CountryCode getDefaultCountryCode()
  {
    isLoading = true;
    CountryCode countryCode = CountryCode.fromJson(json.decode(countryListRepository.getDefaultCountryCode()));
    return countryCode;
  }

  void searchCountries(String text) {}
}
