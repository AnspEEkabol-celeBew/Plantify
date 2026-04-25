import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> savePreferencesOnBool(String key, bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(key, value);
}

Future<bool> loadPreferencesOnBool(String key, bool defaultIfNull) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(key) ?? defaultIfNull;
}

Future<void> savePreferencesOnString(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future<String> loadPreferencesOnString(String key, String defaultIfNull) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key) ?? defaultIfNull;
}

Future<void> savePreferencesOnMap(String key, Map<String, dynamic> value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, jsonEncode(value));
}

Future<Map<String, dynamic>> loadPreferencesOnMap(String key, Map<String, dynamic> defaultIfNull) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString(key);
  debugPrint(jsonString);
  if (jsonString == null) return defaultIfNull;
  return jsonDecode(jsonString) as Map<String, dynamic>;
}

Future<String> loadJustOnlyPreferencesOnMap(String key, String mapKey, String defaultIfNull) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString(key);
  if (jsonString == null) return defaultIfNull;
  Map<String, dynamic> mapTemp = jsonDecode(jsonString) as Map<String, dynamic>;
  return mapTemp[mapKey];
}

Future<void> deletePreferences(String key) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(key);
}