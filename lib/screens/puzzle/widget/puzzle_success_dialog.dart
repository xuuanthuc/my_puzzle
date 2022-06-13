import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_simple/l10n/l10n.dart';

import '../../../blocs/puzzle/puzzle_bloc.dart';
import '../../../blocs/theme/theme_bloc.dart';
import '../../../blocs/timer/timer_bloc.dart';
import '../../../components/app_logo.dart';
import '../../../layout/responsive_layout_builder.dart';
import '../../../themes/puzzle_theme_animations.dart';
import '../../../utils/colors.dart';
import '../../../utils/text_styles.dart';

class ShareDialog extends StatefulWidget {
  /// {@macro dashatar_share_dialog}
  const ShareDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<ShareDialog> createState() => _DashatarShareDialogState();
}

class _DashatarShareDialogState extends State<ShareDialog>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    Future.delayed(
      const Duration(milliseconds: 140),
      _controller.forward,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (currentSize) {
        final padding = currentSize == ResponsiveLayoutSize.large
            ? const EdgeInsets.fromLTRB(68, 82, 68, 73)
            : (currentSize == ResponsiveLayoutSize.medium
                ? const EdgeInsets.fromLTRB(48, 54, 48, 53)
                : const EdgeInsets.fromLTRB(20, 99, 20, 76));

        final closeIconOffset = currentSize == ResponsiveLayoutSize.large
            ? const Offset(44, 37)
            : (currentSize == ResponsiveLayoutSize.medium
                ? const Offset(25, 28)
                : const Offset(17, 63));

        final crossAxisAlignment = currentSize == ResponsiveLayoutSize.large
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center;

        return Stack(
          key: const Key('dashatar_share_dialog'),
          children: [
            SingleChildScrollView(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    child: Padding(
                      padding: padding,
                      child: DashatarShareDialogAnimatedBuilder(
                        animation: _controller,
                        builder: (context, child, animation) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: crossAxisAlignment,
                            children: [
                              SlideTransition(
                                position: animation.scoreOffset,
                                child: Opacity(
                                  opacity: animation.scoreOpacity.value,
                                  child: const DashatarScore(),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              DashatarShareYourScore(
                                animation: animation,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              right: closeIconOffset.dx,
              top: closeIconOffset.dy,
              child: IconButton(
                key: const Key('dashatar_share_dialog_close_button'),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                iconSize: 18,
                icon: const Icon(
                  Icons.close,
                  color: PuzzleColors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

/// The animation builder of [DashatarShareDialog].
class DashatarShareDialogAnimatedBuilder extends StatelessWidget {
  const DashatarShareDialogAnimatedBuilder({
    Key? key,
    required this.builder,
    required this.animation,
    this.child,
  }) : super(key: key);

  final MyTransitionBuilder builder;
  final Listenable animation;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return builder(
          context,
          child,
          DashatarShareDialogEnterAnimation(animation as AnimationController),
        );
      },
      child: child,
    );
  }
}

typedef MyTransitionBuilder = Widget Function(
  BuildContext context,
  Widget? child,
  DashatarShareDialogEnterAnimation animation,
);

class DashatarShareDialogEnterAnimation {
  DashatarShareDialogEnterAnimation(this.controller)
      : scoreOpacity = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0, 0.6, curve: Curves.easeOut),
          ),
        ),
        scoreOffset = Tween<Offset>(
          begin: const Offset(-0.3, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0, 0.6, curve: Curves.easeOut),
          ),
        ),
        shareYourScoreOpacity = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.25, 0.80, curve: Curves.easeOut),
          ),
        ),
        shareYourScoreOffset = Tween<Offset>(
          begin: const Offset(-0.065, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.25, 0.80, curve: Curves.easeOut),
          ),
        ),
        socialButtonsOpacity = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.42, 1, curve: Curves.easeOut),
          ),
        ),
        socialButtonsOffset = Tween<Offset>(
          begin: const Offset(-0.045, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.42, 1, curve: Curves.easeOut),
          ),
        );

  final AnimationController controller;
  final Animation<double> scoreOpacity;
  final Animation<Offset> scoreOffset;
  final Animation<double> shareYourScoreOpacity;
  final Animation<Offset> shareYourScoreOffset;
  final Animation<double> socialButtonsOpacity;
  final Animation<Offset> socialButtonsOffset;
}

class DashatarScore extends StatelessWidget {
  const DashatarScore({Key? key}) : super(key: key);

  static const _smallImageOffset = Offset(124, 36);
  static const _mediumImageOffset = Offset(215, -47);
  static const _largeImageOffset = Offset(215, -47);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.watch<PuzzleBloc>().state;
    final l10n = context.l10n;

    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (currentSize) {
        final height =
            currentSize == ResponsiveLayoutSize.small ? 374.0 : 355.0;

        final imageOffset = currentSize == ResponsiveLayoutSize.large
            ? _largeImageOffset
            : (currentSize == ResponsiveLayoutSize.medium
                ? _mediumImageOffset
                : _smallImageOffset);

        final imageHeight =
            currentSize == ResponsiveLayoutSize.small ? 374.0 : 437.0;

        final completedTextWidth =
            currentSize == ResponsiveLayoutSize.small ? 160.0 : double.infinity;

        final wellDoneTextStyle = currentSize == ResponsiveLayoutSize.small
            ? PuzzleTextStyle.headline4Soft
            : PuzzleTextStyle.headline3;

        final timerTextStyle = currentSize == ResponsiveLayoutSize.small
            ? PuzzleTextStyle.headline5
            : PuzzleTextStyle.headline4;

        final timerIconSize = currentSize == ResponsiveLayoutSize.small
            ? const Size(21, 21)
            : const Size(28, 28);

        final timerIconPadding =
            currentSize == ResponsiveLayoutSize.small ? 4.0 : 6.0;

        final numberOfMovesTextStyle = currentSize == ResponsiveLayoutSize.small
            ? PuzzleTextStyle.headline5
            : PuzzleTextStyle.headline4;

        return ClipRRect(
          key: const Key('dashatar_score'),
          borderRadius: BorderRadius.circular(22),
          child: Container(
            width: double.infinity,
            height: height,
            color: theme.backgroundColor,
            child: Stack(
              children: [
                Positioned(
                  left: imageOffset.dx,
                  top: imageOffset.dy,
                  child: Image.asset(
                    theme.successThemeAsset,
                    height: imageHeight,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppLogo(
                        height: 18,
                        isColored: false,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      SizedBox(
                        key: const Key('dashatar_score_completed'),
                        width: completedTextWidth,
                        child: AnimatedDefaultTextStyle(
                          style: PuzzleTextStyle.headline5.copyWith(
                            color: theme.defaultColor,
                          ),
                          duration: PuzzleThemeAnimationDuration.textStyle,
                          child: Text(l10n.dashatarSuccessCompleted),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      AnimatedDefaultTextStyle(
                        key: const Key('dashatar_score_well_done'),
                        style: wellDoneTextStyle.copyWith(
                          color: PuzzleColors.white,
                        ),
                        duration: PuzzleThemeAnimationDuration.textStyle,
                        child: Text(l10n.dashatarSuccessWellDone),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      AnimatedDefaultTextStyle(
                        key: const Key('dashatar_score_score'),
                        style: PuzzleTextStyle.headline5.copyWith(
                          color: theme.defaultColor,
                        ),
                        duration: PuzzleThemeAnimationDuration.textStyle,
                        child: Text(l10n.dashatarSuccessScore),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      DashatarTimer(
                        textStyle: timerTextStyle,
                        iconSize: timerIconSize,
                        iconPadding: timerIconPadding,
                        mainAxisAlignment: MainAxisAlignment.start,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      AnimatedDefaultTextStyle(
                        key: const Key('dashatar_score_number_of_moves'),
                        style: numberOfMovesTextStyle.copyWith(
                          color: PuzzleColors.white,
                        ),
                        duration: PuzzleThemeAnimationDuration.textStyle,
                        child: Text(
                          l10n.dashatarSuccessNumberOfMoves(state.numberOfMoves.toString(),),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DashatarTimer extends StatelessWidget {
  /// {@macro dashatar_timer}
  const DashatarTimer({
    Key? key,
    this.textStyle,
    this.iconSize,
    this.iconPadding,
    this.mainAxisAlignment,
  }) : super(key: key);

  /// The optional [TextStyle] of this timer.
  final TextStyle? textStyle;

  /// The optional icon [Size] of this timer.
  final Size? iconSize;

  /// The optional icon padding of this timer.
  final double? iconPadding;

  /// The optional [MainAxisAlignment] of this timer.
  /// Defaults to [MainAxisAlignment.center] if not provided.
  final MainAxisAlignment? mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final secondsElapsed =
    context.select((TimerBloc bloc) => bloc.state.secondsElapsed);

    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (currentSize) {
        final currentTextStyle = textStyle ??
            (currentSize == ResponsiveLayoutSize.small
                ? PuzzleTextStyle.headline4
                : PuzzleTextStyle.headline3);

        final currentIconSize = iconSize ??
            (currentSize == ResponsiveLayoutSize.small
                ? const Size(28, 28)
                : const Size(32, 32));

        final timeElapsed = Duration(seconds: secondsElapsed);

        return Row(
          key: const Key('dashatar_timer'),
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
          children: [
            AnimatedDefaultTextStyle(
              style: currentTextStyle.copyWith(
                color: PuzzleColors.white,
              ),
              duration: PuzzleThemeAnimationDuration.textStyle,
              child: Text(
                _formatDuration(timeElapsed),
                key: ValueKey(secondsElapsed),
                semanticsLabel: _getDurationLabel(timeElapsed, context),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  String _getDurationLabel(Duration duration, BuildContext context) {
    return context.l10n.dashatarPuzzleDurationLabelText(
      duration.inHours.toString(),
      duration.inMinutes.remainder(60).toString(),
      duration.inSeconds.remainder(60).toString(),
    );
  }
}


class DashatarShareYourScore extends StatelessWidget {
  /// {@macro dashatar_share_your_score}
  const DashatarShareYourScore({
    Key? key,
    required this.animation,
  }) : super(key: key);

  /// The entry animation of this widget.
  final DashatarShareDialogEnterAnimation animation;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (currentSize) {
        final titleTextStyle = currentSize == ResponsiveLayoutSize.small
            ? PuzzleTextStyle.headline4
            : PuzzleTextStyle.headline3;

        final messageTextStyle = currentSize == ResponsiveLayoutSize.small
            ? PuzzleTextStyle.bodyXSmall
            : PuzzleTextStyle.bodySmall;

        final titleAndMessageCrossAxisAlignment =
            currentSize == ResponsiveLayoutSize.large
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center;

        final textAlign = currentSize == ResponsiveLayoutSize.large
            ? TextAlign.left
            : TextAlign.center;

        final messageWidth = currentSize == ResponsiveLayoutSize.large
            ? double.infinity
            : (currentSize == ResponsiveLayoutSize.medium ? 434.0 : 307.0);

        final buttonsMainAxisAlignment =
            currentSize == ResponsiveLayoutSize.large
                ? MainAxisAlignment.start
                : MainAxisAlignment.center;

        return Column(
          key: const Key('dashatar_share_your_score'),
          crossAxisAlignment: titleAndMessageCrossAxisAlignment,
          children: [
            SlideTransition(
              position: animation.shareYourScoreOffset,
              child: Opacity(
                opacity: animation.shareYourScoreOpacity.value,
                child: Column(
                  crossAxisAlignment: titleAndMessageCrossAxisAlignment,
                  children: [
                    Text(
                      l10n.dashatarSuccessShareYourScoreTitle,
                      key: const Key('dashatar_share_your_score_title'),
                      textAlign: textAlign,
                      style: titleTextStyle.copyWith(
                        color: PuzzleColors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                      width: messageWidth,
                      child: Text(
                        l10n.dashatarSuccessShareYourScoreMessage,
                        key: const Key('dashatar_share_your_score_message'),
                        textAlign: textAlign,
                        style: messageTextStyle.copyWith(
                          color: PuzzleColors.grey1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            // SlideTransition(
            //   position: animation.socialButtonsOffset,
            //   child: Opacity(
            //     opacity: animation.socialButtonsOpacity.value,
            //     child: Row(
            //       mainAxisAlignment: buttonsMainAxisAlignment,
            //       children: const [
            //         DashatarTwitterButton(),
            //         Gap(16),
            //         DashatarFacebookButton(),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        );
      },
    );
  }
}
