import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_simple/blocs/puzzle/puzzle_bloc.dart';
import 'package:puzzle_simple/l10n/l10n.dart';
import 'package:puzzle_simple/layout/breakpoints.dart';
import 'package:puzzle_simple/layout/puzzle_layout_delegate.dart';
import 'package:puzzle_simple/layout/responsive_layout_builder.dart';
import 'package:puzzle_simple/models/tile.dart';
import 'package:puzzle_simple/utils/static_variable.dart';

import '../blocs/theme/theme_bloc.dart';
import '../blocs/timer/timer_bloc.dart';
import '../themes/puzzle_theme_animations.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';

class SimplePuzzleLayoutDelegate extends PuzzleLayoutDelegate {
  const SimplePuzzleLayoutDelegate();

  @override
  Widget backgroundBuilder(PuzzleState state) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: ResponsiveLayoutBuilder(
        small: (_, __) => SizedBox(
          width: 184,
          height: 118,
          child: Image.asset(
            'assets/images/simple_dash_small.png',
            key: const Key('simple_puzzle_dash_small'),
          ),
        ),
        medium: (_, __) => SizedBox(
          width: 380.44,
          height: 214,
          child: Image.asset(
            'assets/images/simple_dash_medium.png',
            key: const Key('simple_puzzle_dash_medium'),
          ),
        ),
        large: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 53),
          child: SizedBox(
            width: 568.99,
            height: 320,
            child: Image.asset(
              'assets/images/simple_dash_large.png',
              key: const Key('simple_puzzle_dash_large'),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget boardBuilder(int size, List<Widget> tiles) {
    return Column(
      children: [
        ResponsiveLayoutBuilder(
          large: (_, __) => const SizedBox(height: 30),
          medium: (_, __) => const SizedBox(height: 50),
          small: (_, __) => const SizedBox(height: 90),
        ),
        ResponsiveLayoutBuilder(
          small: (_, __) => SizedBox.square(
            dimension: _BoardSize.small,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_small'),
              size: size,
              tiles: tiles,
              spacing: 5,
            ),
          ),
          medium: (_, __) => SizedBox.square(
            dimension: _BoardSize.medium,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_medium'),
              size: size,
              tiles: tiles,
            ),
          ),
          large: (_, __) => SizedBox.square(
            dimension: _BoardSize.large,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_large'),
              size: size,
              tiles: tiles,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget endSectionBuilder(PuzzleState state) {
    return ResponsiveLayoutBuilder(
        large: (_, child) => child!,
        medium: (_, child) => child!,
        small: (_, child) => child!,
        child: (_) => Column(
              children: [
                // NumberOfLinesTile(),
                SimpleShuffleButton(),
              ],
            ));
  }

  @override
  Widget startSectionBuilder(PuzzleState state) {
    return TimerCount();
  }

  @override
  Widget tileBuilder(Tile tile, PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_small'),
        tile: tile,
        tileFontSize: _TileFontSize.small,
        state: state,
      ),
      medium: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_medium'),
        tile: tile,
        tileFontSize: _TileFontSize.medium,
        state: state,
      ),
      large: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_large'),
        tile: tile,
        tileFontSize: _TileFontSize.large,
        state: state,
      ),
    );
  }

  @override
  Widget whitespaceTileBuilder() {
    return const SizedBox();
  }

  @override
  List<Object?> get props => [];
}

class TimerCount extends StatelessWidget {
  const TimerCount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final secondsElapsed =
        context.select((TimerBloc bloc) => bloc.state.secondsElapsed);
    final timeElapsed = Duration(seconds: secondsElapsed);
    return MultiBlocListener(
      listeners: [
        BlocListener<PuzzleBloc, PuzzleState>(
          listener: (context, state) {
            if (state.puzzleStatus == PuzzleStatus.incomplete) {}
          },
        ),
        BlocListener<TimerBloc, TimerState>(
          listener: (context, state) {},
        ),
      ],
      child: Text(
        _formatDuration(timeElapsed),
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w700
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }
}

class SimplePuzzleBoard extends StatelessWidget {
  /// {@macro simple_puzzle_board}
  const SimplePuzzleBoard({
    Key? key,
    required this.size,
    required this.tiles,
    this.spacing = 8,
  }) : super(key: key);

  /// The size of the board.
  final int size;

  /// The tiles to be displayed on the board.
  final List<Widget> tiles;

  /// The spacing between each tile from [tiles].
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: size,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      children: tiles,
    );
  }
}

class NumberOfLinesTile extends StatelessWidget {
  const NumberOfLinesTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => SizedBox(
        width: _BoardSize.small,
        child: child!,
      ),
      medium: (_, child) => SizedBox(
        width: _BoardSize.medium,
        child: child!,
      ),
      large: (_, child) => SizedBox(
        width: _BoardSize.medium,
        child: child!,
      ),
      child: (_) => Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Slider(
          value: StaticVariable.currentSize ?? 4,
          max: 7,
          min: 3,
          divisions: 4,
          label: StaticVariable.currentSize?.round().toString(),
          onChanged: (double value) {
            StaticVariable.currentSize = value;
            context
                .read<PuzzleBloc>()
                .add(PuzzleReset(int.tryParse(value.round().toString()) ?? 0));
          },
        ),
      ),
    );
  }
}

class SimpleShuffleButton extends StatelessWidget {
  const SimpleShuffleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);
    final stateTimer = context.select((TimerBloc bloc) => bloc.state);
    return ResponsiveLayoutBuilder(
      small: (_, child) => SizedBox(
        width: _BoardSize.small,
        child: child!,
      ),
      medium: (_, child) => SizedBox(
        width: _BoardSize.medium,
        child: child!,
      ),
      large: (_, child) => SizedBox(
        width: _BoardSize.medium,
        child: child!,
      ),
      child: (_) => Padding(
        padding: const EdgeInsets.all(30),
        child: TextButton(
          style: TextButton.styleFrom(
            primary: PuzzleColors.white,
            textStyle: PuzzleTextStyle.headline2.copyWith(
              fontSize: _TileFontSize.small,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
          ).copyWith(
            foregroundColor: MaterialStateProperty.all(PuzzleColors.white),
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (states) {
                if (states.contains(MaterialState.hovered)) {
                  return theme.hoverColor;
                } else {
                  return theme.pressedColor;
                }
              },
            ),
          ),
          onPressed: stateTimer.timerStatus == TimerStatus.notStarted
              ? () {
                  context.read<PuzzleBloc>().add(PuzzleStart());
                  context.read<TimerBloc>().add(TimerStarted());
                }
              : () {
                  context.read<PuzzleBloc>().add(
                        PuzzleReset(int.tryParse(StaticVariable.currentSize
                                    ?.round()
                                    .toString() ??
                                "4") ??
                            4),
                      );
                  context.read<TimerBloc>().add(TimerReset());
                },
          child: Text(
            stateTimer.timerStatus == TimerStatus.notStarted
                ? "Start"
                : "Reset",
            style: PuzzleTextStyle.bodySmall.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class SimplePuzzleTile extends StatefulWidget {
  /// {@macro simple_puzzle_tile}
  const SimplePuzzleTile({
    Key? key,
    required this.tile,
    required this.tileFontSize,
    required this.state,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  /// The font size of the tile to be displayed.
  final double tileFontSize;

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  State<SimplePuzzleTile> createState() => _SimplePuzzleTileState();
}

class _SimplePuzzleTileState extends State<SimplePuzzleTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: PuzzleThemeAnimationDuration.puzzleTileScale,
    );

    _scale = Tween<double>(begin: 1, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 1, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild');
    final size = widget.state.puzzle.getDimension();
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final stateTimer = context.select((TimerBloc bloc) => bloc.state);

    return AnimatedAlign(
      alignment: FractionalOffset(
        (widget.tile.currentPosition.x - 1) / (size - 1),
        (widget.tile.currentPosition.y - 1) / (size - 1),
      ),
      duration: const Duration(milliseconds: 8000),
      curve: Curves.easeInOut,
      child: ResponsiveLayoutBuilder(
        large: (_, child) => SizedBox.square(
          key: Key('dashatar_puzzle_tile_large_${widget.tile.value}'),
          dimension: _TileSize.large,
          child: child,
        ),
        small: (_, child) => SizedBox.square(
          key: Key('dashatar_puzzle_tile_small_${widget.tile.value}'),
          dimension: _TileSize.small,
          child: child,
        ),
        medium: (_, child) => SizedBox.square(
          key: Key('dashatar_puzzle_tile_medium_${widget.tile.value}'),
          dimension: _TileSize.medium,
          child: child,
        ),
        child: (_) => MouseRegion(
          onEnter: (_) {
            _controller.forward();
          },
          onExit: (_) {
            _controller.reverse();
          },
          child: ScaleTransition(
            key: Key('puzzle_tile_scale_${widget.tile.value}'),
            scale: _scale,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: widget.state.puzzleStatus == PuzzleStatus.incomplete &&
                      stateTimer.timerStatus == TimerStatus.started
                  ? () => context
                      .read<PuzzleBloc>()
                      .add(TileTapped(tile: widget.tile))
                  : null,
              icon: Image.asset(
                "${theme.assetsDirectory}${widget.tile.value}.png",
              ),
            ),
          ),
        ),
      ),
    );
  }
}

abstract class _TileFontSize {
  static double small = 36;
  static double medium = 50;
  static double large = 54;
}

abstract class _BoardSize {
  static double small = 312;
  static double medium = 424;
  static double large = 472;
}

abstract class _TileSize {
  static double small = 75;
  static double medium = 100;
  static double large = 112;
}

double switchFontSize(double sizeWidth) {
  double fontSize = 36;
  int currentSize = StaticVariable.currentSize?.round().toInt() ?? 4;
  if (sizeWidth <= PuzzleBreakpoints.small) {
    switch (currentSize) {
      case 4:
        break;
      case 5:
        fontSize = 28;
        break;
      case 6:
        fontSize = 24;
        break;
      case 7:
        fontSize = 18;
        break;
      case 8:
        fontSize = 12;
        break;
      case 9:
        fontSize = 10;
        break;
      case 10:
        fontSize = 8;
        break;
    }
  } else if (sizeWidth <= PuzzleBreakpoints.medium) {
    switch (currentSize) {
      case 4:
        break;
      case 5:
        fontSize = 32;
        break;
      case 6:
        fontSize = 28;
        break;
      case 7:
        fontSize = 22;
        break;
      case 8:
        fontSize = 18;
        break;
      case 9:
        fontSize = 14;
        break;
      case 10:
        fontSize = 12;
        break;
    }
  } else if (sizeWidth <= PuzzleBreakpoints.large) {
    switch (currentSize) {
      case 4:
        break;
      case 5:
        fontSize = 32;
        break;
      case 6:
        fontSize = 28;
        break;
      case 7:
        fontSize = 22;
        break;
      case 8:
        fontSize = 18;
        break;
      case 9:
        fontSize = 14;
        break;
      case 10:
        fontSize = 10;
        break;
    }
  } else {
    switch (currentSize) {
      case 4:
        break;
      case 5:
        fontSize = 32;
        break;
      case 6:
        fontSize = 28;
        break;
      case 7:
        fontSize = 22;
        break;
      case 8:
        fontSize = 18;
        break;
      case 9:
        fontSize = 18;
        break;
      case 10:
        fontSize = 14;
        break;
    }
  }

  return fontSize;
}
