import 'dart:async';
import 'package:flutter/material.dart';
import 'package:voice_example/api/ApiService.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/db/CountryDao.dart';
import 'package:voice_example/repository/Common/Respository.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/model/country/CountryList.dart';

class CountryRepository extends Repository
{
  ApiService _apiService;
  CountryDao countryDao;
  String primaryKey = 'uid';

  CountryRepository({@required ApiService apiService, @required CountryDao countryDao})
  {
    this._apiService = apiService;
    this.countryDao = countryDao;
  }

  Future<dynamic>  doCountryListApiCall(bool isConnectedToInternet, int limit, int offset, Status status) async
  {
    if (isConnectedToInternet)
    {
      final Resources<CountryList> _resource = await _apiService.getAllCountries(limit, offset);
      if (_resource.status == Status.SUCCESS )
      {
        if(_resource.data.countryListData.error==null)
        {
          await countryDao.deleteAll();
          await countryDao.insertAll(primaryKey, _resource.data.countryListData.countryCode);
          return Resources(Status.SUCCESS, "", _resource.data.countryListData.countryCode);
        }
        else
        {
          return Resources(Status.ERROR, _resource.data.countryListData.error.message, null);
        }
      }
      else
      {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    }
  }

  Future<dynamic>  getCountryListFromDb(bool isConnectedToInternet, int limit, int offset, Status status) async
  {
    return await countryDao.getAll();
  }
}
