import 'dart:async';
import 'package:flutter/material.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/constant/Constants.dart';
import 'package:voice_example/db/common/ps_shared_preferences.dart';
import 'package:voice_example/repository/Common/Respository.dart';
import 'package:voice_example/viewobject/common/Language.dart';
import 'package:voice_example/viewobject/common/LanguageValueHolder.dart';

class LanguageRepository extends Repository
{
  LanguageRepository({@required PsSharedPreferences psSharedPreferences})
  {
    _psSharedPreferences = psSharedPreferences;
  }




  final StreamController<LanguageValueHolder> _valueController = StreamController<LanguageValueHolder>();
  Stream<LanguageValueHolder> get valueHolder => _valueController.stream;

  PsSharedPreferences _psSharedPreferences;

  void loadLanguageValueHolder() {
    final String _languageCodeKey = _psSharedPreferences.shared
        .getString(Const.LANGUAGE_LANGUAGE_CODE_KEY);
    final String _countryCodeKey = _psSharedPreferences.shared
        .getString(Const.LANGUAGE_COUNTRY_CODE_KEY);
    final String _languageNameKey = _psSharedPreferences.shared
        .getString(Const.LANGUAGE_LANGUAGE_NAME_KEY);

    _valueController.add(LanguageValueHolder(
      languageCode: _languageCodeKey,
      countryCode: _countryCodeKey,
      name: _languageNameKey,
    ));
  }

  Future<void> addLanguage(Language language) async {
    await _psSharedPreferences.shared
        .setString(Const.LANGUAGE_LANGUAGE_CODE_KEY, language.languageCode);
    await _psSharedPreferences.shared
        .setString(Const.LANGUAGE_COUNTRY_CODE_KEY, language.countryCode);
    await _psSharedPreferences.shared
        .setString(Const.LANGUAGE_LANGUAGE_NAME_KEY, language.name);
    await _psSharedPreferences.shared.setString('locale',
        Locale(language.languageCode, language.countryCode).toString());
    loadLanguageValueHolder();
  }

  Language getLanguage()
  {
    final String languageCode = _psSharedPreferences.shared.getString(Const.LANGUAGE_LANGUAGE_CODE_KEY) ??
        Config.defaultLanguage.languageCode;
    final String countryCode = _psSharedPreferences.shared
            .getString(Const.LANGUAGE_COUNTRY_CODE_KEY) ??
        Config.defaultLanguage.countryCode;
    final String languageName = _psSharedPreferences.shared
            .getString(Const.LANGUAGE_LANGUAGE_NAME_KEY) ??
        Config.defaultLanguage.name;

    return Language(
        languageCode: languageCode,
        countryCode: countryCode,
        name: languageName);
  }
}
