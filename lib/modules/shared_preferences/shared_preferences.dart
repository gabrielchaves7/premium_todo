import 'package:premium_todo/bootstrap.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DataSource {
  Future<bool> saveList(String key, List<String> value);
  List<String> getList(String key);
}

class SharedPreferencesDataSource implements DataSource {
  SharedPreferencesDataSource({SharedPreferences? prefs}) {
    _prefs = prefs ?? getIt<SharedPreferences>();
  }

  late final SharedPreferences _prefs;

  @override
  Future<bool> saveList(String key, List<String> value) async {
    return _prefs.setStringList(key, value);
  }

  @override
  List<String> getList(String key) {
    final result = _prefs.getStringList(key);
    return result ?? [];
  }
}
