import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/provider/common/ps_provider.dart';
import 'package:voice_example/repository/LanguageRepository.dart';
import 'package:voice_example/viewobject/common/Language.dart';

class LanguageProvider extends Provider {



  LanguageProvider({
    @required LanguageRepository repo,
    int limit = 0
  }) : super(repo, limit)
  {
    _repo = repo;
    isDispose = false;
  }

  LanguageRepository _repo;

  List<Language> _languageList = <Language>[];
  List<Language> get languageList => _languageList;

  Language currentLanguage = Config.defaultLanguage;
  String currentCountryCode = '';
  String currentLanguageName = '';

  @override
  void dispose()
  {
    isDispose = true;
    super.dispose();
  }

  Future<dynamic> addLanguage(Language language) async {
    currentLanguage = language;
    return await _repo.addLanguage(language);
  }

  Language getLanguage() {
    currentLanguage = _repo.getLanguage();
    return currentLanguage;
  }

  List<dynamic> getLanguageList() {
    _languageList = Config.psSupportedLanguageList;
    return _languageList;
  }
}
