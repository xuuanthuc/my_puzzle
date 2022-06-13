import 'package:flutter/material.dart';
import 'package:puzzle_simple/layout/responsive_layout_builder.dart';
import 'package:puzzle_simple/themes/puzzle_theme_animations.dart';
import 'package:puzzle_simple/utils/images.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    Key? key,
    this.height,
    this.isColored = true,
  }) : super(key: key);

  final bool isColored;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final assetName = isColored ? ImagePaths.logoColor : ImagePaths.logoWhite;

    return AnimatedSwitcher(
      duration: PuzzleThemeAnimationDuration.logoChange,
      child: height != null
          ? Image.asset(
              assetName,
              height: height,
            )
          : ResponsiveLayoutBuilder(
              key: Key(assetName),
              large: (_, __) => Image.asset(
                assetName,
                height: 24,
              ),
              medium: (_, __) => Image.asset(
                assetName,
                height: 29,
              ),
              small: (_, __) => Image.asset(
                assetName,
                height: 32,
              ),
            ),
    );
  }
}
