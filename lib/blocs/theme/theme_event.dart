abstract class ThemeEvent {}

class DecideTheme extends ThemeEvent {}

class SystemTheme extends ThemeEvent {}

class LightTheme extends ThemeEvent {
  @override
  String toString() => 'LightTheme';
}

class DarkTheme extends ThemeEvent {
  @override
  String toString() => 'Dark Theme';
}
