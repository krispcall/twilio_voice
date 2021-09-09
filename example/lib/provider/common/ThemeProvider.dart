import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/provider/common/ps_provider.dart';
import 'package:voice_example/repository/ThemeRepository.dart';

class ThemeProvider extends Provider {
  ThemeProvider({@required PsThemeRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
  }
  PsThemeRepository _repo;

  Future<dynamic> updateTheme(bool isDarkTheme) {
    return _repo.updateTheme(isDarkTheme);
  }

  ThemeData getTheme() {
    return _repo.getTheme();
  }
}
