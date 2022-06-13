import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_simple/blocs/theme/theme_bloc.dart';
import 'package:puzzle_simple/layout/responsive_layout_builder.dart';
import 'package:puzzle_simple/screens/puzzle/widget/puzzle_logo.dart';
import 'package:puzzle_simple/screens/puzzle/widget/puzzle_menu.dart';

class PuzzleHeader extends StatelessWidget {
  const PuzzleHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themes = context.select((ThemeBloc bloc) => bloc.state.themes);
    return SizedBox(
      height: 96,
      child: ResponsiveLayoutBuilder(
        small: (context, child) {
          return Stack(
            children: const [
              Align(child: PuzzleLogo()),
            ],
          );
        },
        large: (context, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                PuzzleLogo(),
                PuzzleMenu()
              ],
            ),
          );
        },
        medium: (context, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                PuzzleLogo(),
                PuzzleMenu()
              ],
            ),
          );
        },
      ),
    );
  }
}
