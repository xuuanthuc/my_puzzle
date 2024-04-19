import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_simple/blocs/puzzle/puzzle_bloc.dart';
import 'package:puzzle_simple/blocs/theme/theme_bloc.dart';
import 'package:puzzle_simple/blocs/timer/timer_bloc.dart';
import 'package:puzzle_simple/models/ticker.dart';
import 'package:puzzle_simple/screens/puzzle/widget/puzzle_header.dart';
import 'package:puzzle_simple/screens/puzzle/widget/puzzle_section.dart';
import 'package:puzzle_simple/screens/puzzle/widget/puzzle_success_point.dart';
import 'package:puzzle_simple/themes/puzzle_theme_animations.dart';
import 'package:puzzle_simple/themes/simple_puzzle_theme.dart';

class PuzzleScreen extends StatelessWidget {
  const PuzzleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TimerBloc(ticker: const Ticker()),
        ),
        BlocProvider(
          create: (context) => ThemeBloc(
            initialThemes: [
              const SimpleTheme(),
            ],
          ),
        ),
      ],
      child: const PuzzlePointSuccess(),
    );
  }
}

class PuzzleView extends StatelessWidget {
  const PuzzleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    /// Shuffle only if the current theme is Simple.
    final shufflePuzzle = theme is SimpleTheme;

    return Scaffold(
      body: AnimatedContainer(
        duration: PuzzleThemeAnimationDuration.backgroundColorChange,
        decoration: BoxDecoration(color: theme.backgroundColor),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => PuzzleBloc()
                ..add(
                  PuzzleInitialized(shufflePuzzle: shufflePuzzle, size: 4),
                ),
            ),
          ],
          child: const _Puzzle(
            key: Key("puzzle_vew_puzzle"),
          ),
        ),
      ),
    );
  }
}

class _Puzzle extends StatelessWidget {
  const _Puzzle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: const Column(
                  children: [
                    PuzzleHeader(),
                    PuzzleSections()
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
