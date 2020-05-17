import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class SpHelper {
  // 需要在 main.dart 初始化
  static SharedPreferences sp;

  // T 用于区分存储类型
  static void putObject<T>(String key, Object value) {
    switch (T) {
      case int:
        sp.setInt(key, value);
        break;
      case double:
        sp.setDouble(key, value);
        break;
      case bool:
        sp.setBool(key, value);
        break;
      case String:
        sp.setString(key, value);
        break;
      case List:
        sp.setStringList(key, value);
        break;
      default:
        sp.setString(key, value == null ? "" : json.encode(value));
        break;
    }
  }

  static ThemeMode getThemeMode() {
    String value = sp.getString(SP_THEME_MODE);
    switch (value) {
      case THEME_MODE_LIGHT:
        return ThemeMode.light;
      case THEME_MODE_DARK:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static bool isImageOptimizeEnabled() {
    bool value = sp.getBool(SP_IMAGE_OPTIMIZE_MODE);
    if (value == null || value) {
      return true;
    }
    return false;
  }
}
