import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static Future<void> setSharedPreferenceData(setKey, setValue) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(setKey, setValue); // Save string data
  }

  static Future<String> getSharedPreferenceData(setKey) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(setKey).toString(); // Save string data
  }

  static Future<void> clearSharedPreferenceData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> clearSharedPreferenceSpecificKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key); // Removes a specific key
  }

  static Future<void> changeSharedPreferenceSpecificKeyValue(
      String key, String newValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        key, newValue); // Change the value of the specific key
  }
}
