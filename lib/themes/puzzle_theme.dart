import 'dart:ui';

import 'package:equatable/equatable.dart';

import '../layout/puzzle_layout_delegate.dart';

abstract class PuzzleTheme extends Equatable {
  const PuzzleTheme();

  String get name;

  bool get hasTimer;

  Color get nameColor;

  Color get titleColor;

  Color get backgroundColor;

  Color get defaultColor;

  Color get buttonColor;

  Color get hoverColor;

  Color get pressedColor;

  bool get isLogoColored;

  Color get menuActiveColor;

  Color get menuUnderlineColor;

  Color get menuInactiveColor;

  String get assetsDirectory;

  String get themeAsset;

  String get successThemeAsset;

  PuzzleLayoutDelegate get layoutDelegate;
}
