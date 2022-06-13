import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_simple/l10n/l10n.dart';

import '../../../blocs/theme/theme_bloc.dart';
import '../../../layout/responsive_layout_builder.dart';
import '../../../themes/puzzle_theme.dart';
import '../../../themes/puzzle_theme_animations.dart';
import '../../../utils/text_styles.dart';

class PuzzleMenu extends StatelessWidget {
  /// {@macro puzzle_menu}
  const PuzzleMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themes = context.select((ThemeBloc bloc) => bloc.state.themes);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(
          themes.length,
              (index) => PuzzleMenuItem(
            theme: themes[index],
            themeIndex: index,
          ),
        ),
        ResponsiveLayoutBuilder(
          small: (_, child) => const SizedBox(),
          medium: (_, child) => child!,
          large: (_, child) => child!,
          child: (currentSize) => Container(),
        ),
      ],
    );
  }
}

class PuzzleMenuItem extends StatelessWidget {
  /// {@macro puzzle_menu_item}
  const PuzzleMenuItem({
    Key? key,
    required this.theme,
    required this.themeIndex,
  }) : super(key: key);

  /// The theme corresponding to this menu item.
  final PuzzleTheme theme;

  /// The index of [theme] in [ThemeState.themes].
  final int themeIndex;

  @override
  Widget build(BuildContext context) {
    final currentTheme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final isCurrentTheme = theme == currentTheme;

    return ResponsiveLayoutBuilder(
      small: (_, child) => Column(
        children: [
          Container(
            width: 100,
            height: 40,
            decoration: isCurrentTheme
                ? BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 2,
                  color: currentTheme.menuUnderlineColor,
                ),
              ),
            )
                : null,
            child: child,
          ),
        ],
      ),
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (currentSize) {
        final leftPadding =
        themeIndex > 0 && currentSize != ResponsiveLayoutSize.small
            ? 40.0
            : 0.0;

        return Padding(
          padding: EdgeInsets.only(left: leftPadding),
          child: Tooltip(
            message:
            theme != currentTheme ? context.l10n.puzzleChangeTooltip : '',
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ).copyWith(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              onPressed: () {
                // Ignore if this theme is already selected.
                // if (theme == currentTheme) {
                //   return;
                // }
                //
                // // Update the currently selected theme.
                // context
                //     .read<ThemeBloc>()
                //     .add(ThemeChanged(themeIndex: themeIndex));
                //
                // // Reset the timer of the currently running puzzle.
                // context.read<TimerBloc>().add(const TimerReset());
                //
                // // Stop the Dashatar countdown if it has been started.
                // context.read<DashatarPuzzleBloc>().add(
                //   const DashatarCountdownStopped(),
                // );
                //
                // // Initialize the puzzle board for the newly selected theme.
                // context.read<PuzzleBloc>().add(
                //   PuzzleInitialized(
                //     shufflePuzzle: theme is SimpleTheme,
                //   ),
                // );
              },
              child: AnimatedDefaultTextStyle(
                duration: PuzzleThemeAnimationDuration.textStyle,
                style: PuzzleTextStyle.headline5.copyWith(
                  color: isCurrentTheme
                      ? currentTheme.menuActiveColor
                      : currentTheme.menuInactiveColor,
                ),
                child: Text(theme.name),
              ),
            ),
          ),
        );
      },
    );
  }
}