
import 'dart:ui';

import 'package:puzzle_simple/layout/puzzle_layout_delegate.dart';
import 'package:puzzle_simple/themes/puzzle_theme.dart';

import '../layout/simple_puzzle_layout_delegate.dart';
import '../utils/colors.dart';

class SimpleTheme extends PuzzleTheme{
  const SimpleTheme() : super();

  @override
  String get name => 'Simple';

  @override
  bool get hasTimer => false;

  @override
  Color get nameColor => PuzzleColors.grey1;

  @override
  Color get titleColor => PuzzleColors.primary1;

  @override
  Color get backgroundColor => PuzzleColors.blue90;

  @override
  Color get defaultColor => PuzzleColors.primary5;

  @override
  Color get buttonColor => PuzzleColors.primary6;

  @override
  Color get hoverColor => PuzzleColors.primary3;

  @override
  Color get pressedColor => PuzzleColors.primary7;

  @override
  bool get isLogoColored => true;

  @override
  Color get menuActiveColor => PuzzleColors.grey1;

  @override
  Color get menuUnderlineColor => PuzzleColors.primary6;

  @override
  Color get menuInactiveColor => PuzzleColors.grey2;

  @override
  PuzzleLayoutDelegate get layoutDelegate => const SimplePuzzleLayoutDelegate();

  @override
  String get assetsDirectory => 'assets/images/blue/';

  @override
  String get themeAsset => 'assets/images/gallery/blue.png';

  @override
  String get successThemeAsset => 'assets/images/blue.png';

  @override
  List<Object?> get props => [
    name,
    hasTimer,
    nameColor,
    titleColor,
    backgroundColor,
    defaultColor,
    buttonColor,
    hoverColor,
    pressedColor,
    isLogoColored,
    menuActiveColor,
    menuUnderlineColor,
    menuInactiveColor,
    layoutDelegate,
    assetsDirectory,
    themeAsset,
    successThemeAsset
  ];
}