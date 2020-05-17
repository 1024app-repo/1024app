import 'package:communityfor1024/theme.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;

  ThemeState(this.themeMode);

  ThemeData getTheme({bool isDark: false}) {
    if (isDark) {
      return kDarkTheme;
    }
    return kLightTheme;
  }

  @override
  List<Object> get props => [themeMode];
}
