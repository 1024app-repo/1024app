import 'package:bloc/bloc.dart';
import 'package:communityfor1024/util/constants.dart';
import 'package:communityfor1024/util/sp_helper.dart';
import 'package:flutter/material.dart';

import 'bloc.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  @override
  ThemeState get initialState => ThemeState(ThemeMode.system);

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    if (event is DecideTheme) {
      print('inside Theme decision body');
      ThemeMode mode = SpHelper.getThemeMode();
      yield ThemeState(mode);
    }

    if (event is SystemTheme) {
      print(ThemeMode.system);
      yield ThemeState(ThemeMode.system);
      SpHelper.sp.setString(SP_THEME_MODE, THEME_MODE_SYSTEM);
    }

    if (event is DarkTheme) {
      print('inside darktheme body');

      yield ThemeState(ThemeMode.dark);
      SpHelper.sp.setString(SP_THEME_MODE, THEME_MODE_DARK);
    }
    if (event is LightTheme) {
      print('inside LightTheme body');

      yield ThemeState(ThemeMode.light);
      SpHelper.sp.setString(SP_THEME_MODE, THEME_MODE_LIGHT);
    }
  }
}
