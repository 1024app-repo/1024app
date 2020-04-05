//https://github.com/EdvaldoMartins/avatar_letter
library avatar_letter;

import 'dart:math';

import 'package:flutter/material.dart';

enum LetterType { Rectangle, Circular, None }

var colourCache = Map<String, List<int>>();

// ignore: must_be_immutable
class AvatarLetter extends StatelessWidget {
  LetterType letterType;
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final String fontFamily;
  double size;
  final int numberLetters;
  final bool upperCase;

  AvatarLetter(
      {Key key,
      this.letterType,
      @required this.text,
      this.size,
      this.numberLetters = 1,
      this.fontWeight = FontWeight.bold,
      this.fontFamily,
      this.fontSize = 16,
      this.upperCase = false}) {
    assert(numberLetters > 0);
  }

  @override
  Widget build(BuildContext context) {
    letterType = (letterType == null) ? LetterType.Rectangle : letterType;
    return _leeterView();
  }

  Color _colorBackgroundConfig() {
    List<int> _color;

    if (colourCache.containsKey(text)) {
      _color = colourCache[text];
    } else {
      _color = this._getPastelColour(lighten: 50);
      colourCache[text] = _color;
    }
    return Color.fromARGB(
      255,
      _color[0],
      _color[1],
      _color[2],
    );
  }

  String _runeString({String value}) {
    return String.fromCharCodes(value.runes.toList());
  }

  String _textConfig() {
    var newText = text == null ? '?' : _runeString(value: text);
    newText = upperCase ? newText.toUpperCase() : newText;
    var arrayLeeters = newText.trim().split(' ');
    if (arrayLeeters != null) {
      if (arrayLeeters.length > 1 && arrayLeeters.length == numberLetters) {
        return '${arrayLeeters[0][0].trim()}${arrayLeeters[1][0].trim()}';
      }
      return '${newText[0]}';
    }
  }

  Widget _buildText() {
    return Text(
      _textConfig(),
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
      ),
    );
  }

  _buildTypeLeeter() {
    switch (letterType) {
      case LetterType.Rectangle:
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        );
      case LetterType.Circular:
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size / 2),
        );
      case LetterType.None:
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        );
    }
  }

  List<int> _getPastelColour({int lighten = 127}) {
    var r = () => Random().nextInt(128) + lighten;
    return [r(), r(), r()];
  }

  Widget _leeterView() {
    return Material(
      shape: _buildTypeLeeter(),
      color: _colorBackgroundConfig(),
      child: Container(
        height: size,
        width: size,
        child: Center(
          child: _buildText(),
        ),
      ),
    );
  }
}
