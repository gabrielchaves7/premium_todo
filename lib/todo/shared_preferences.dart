// Obtain shared preferences.
import 'dart:convert';

import 'package:premium_todo/bootstrap.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DataSource {
  Future<bool> saveMap(String key, Map<String, dynamic> value);
  Future<Map<String, dynamic>> getMap(String key);
}

class SharedPreferencesDataSource implements DataSource {
  SharedPreferencesDataSource({SharedPreferences? prefs}) {
    _prefs = prefs ?? getIt<SharedPreferences>();
  }

  late final SharedPreferences _prefs;

  @override
  Future<bool> saveMap(String key, Map<String, dynamic> value) async {
    return _prefs.setString(key, json.encode(value));
  }

  @override
  Future<Map<String, dynamic>> getMap(String key) async {
    final jsonStr = _prefs.getString(key);
    return json.decode(jsonStr!) as Map<String, dynamic>;
  }
}
