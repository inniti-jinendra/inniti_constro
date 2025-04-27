import 'package:shared_preferences/shared_preferences.dart';

import '../network/logger.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../network/logger.dart';

class SecureStorageUtil {
  static final _storage = FlutterSecureStorage();

  /// ✅ Save data securely
  static Future<void> writeSecureData(String key, String value) async {
    await _storage.write(key: key, value: value);
    AppLogger.info("🔐 SecureStorage - Set: [$key] = $value");
  }

  /// ✅ Read secure data
  static Future<String?> readSecureData(String key) async {
    return await _storage.read(key: key);
  }

  /// ✅ Delete specific secure data
  static Future<void> deleteSecureData(String key) async {
    await _storage.delete(key: key);
    AppLogger.warn("❌ SecureStorage - Removed Key: [$key]");
  }

  /// ✅ Clear all secure storage
  static Future<void> clearAll() async {
    await _storage.deleteAll();
    AppLogger.warn("❌❌ SecureStorage - Cleared All Data");
  }
}


class SharedPreferencesUtil {
  /// ✅ Save a string value
  static Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    AppLogger.info("🔹 SharedPreferences - Set String: [$key] = $value");
  }

  /// ✅ Get a string value (returns empty string if not found)
  static Future<String> getString(String key, {String defaultValue = ""}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? defaultValue;
  }

  /// ✅ Save a boolean value
  static Future<void> setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    AppLogger.info("🔹 SharedPreferences - Set Bool: [$key] = $value");
  }

  /// ✅ Get a boolean value (returns false if not found)
  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? defaultValue;
  }

  /// ✅ Save an integer value
  static Future<void> setInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  /// ✅ Get an integer value (returns 0 if not found)
  static Future<int> getInt(String key, {int defaultValue = 0}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? defaultValue;
  }

  /// ✅ Save a double value
  static Future<void> setDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  /// ✅ Get a double value (returns 0.0 if not found)
  static Future<double> getDouble(String key, {double defaultValue = 0.0}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key) ?? defaultValue;
  }

  /// ✅ Save a list of strings
  static Future<void> setStringList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, value);
  }

  /// ✅ Get a list of strings (returns empty list if not found)
  static Future<List<String>> getStringList(String key, {List<String> defaultValue = const []}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? defaultValue;
  }

  /// ✅ Remove a specific key
  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
    AppLogger.warn("❌ SharedPreferences - Removed Key: [$key]");
  }

  /// ✅ Clear all stored data (e.g., on logout)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    AppLogger.warn("❌❌ SharedPreferences - Cleared All Data");
  }
}


//🎯 Example

//✅ Saving Data
// await SharedPreferencesUtil.setString("CompanyCode", "CONSTRO");
// await SharedPreferencesUtil.setBool("isLoggedIn", true);
// await SharedPreferencesUtil.setInt("UserID", 12345);
// await SharedPreferencesUtil.setDouble("UserBalance", 99.99);
// await SharedPreferencesUtil.setStringList("Roles", ["Admin", "User"]);

// ✅ Retrieving Data

// String companyCode = await SharedPreferencesUtil.getString("CompanyCode");
// bool isLoggedIn = await SharedPreferencesUtil.getBool("isLoggedIn");
// int userId = await SharedPreferencesUtil.getInt("UserID");
// double balance = await SharedPreferencesUtil.getDouble("UserBalance");
// List<String> roles = await SharedPreferencesUtil.getStringList("Roles");

// ✅ Removing Data
// await SharedPreferencesUtil.remove("CompanyCode");

// ✅ Clearing All Data (on Logout)
// await SharedPreferencesUtil.clearAll();