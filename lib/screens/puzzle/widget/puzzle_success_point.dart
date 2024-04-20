import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_simple/l10n/l10n.dart';
import 'package:puzzle_simple/screens/puzzle/widget/puzzle_success_dialog.dart';

import '../../../blocs/puzzle/puzzle_bloc.dart';
import '../../../blocs/theme/theme_bloc.dart';
import '../../../layout/responsive_layout_builder.dart';
import '../../../themes/puzzle_theme_animations.dart';
import '../../../utils/colors.dart';
import '../../../utils/text_styles.dart';

extension on AnimationController {
  void repeatEx({required int times}) {
    var count = 0;
    addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (++count < times) {
          reverse();
        }
      } else if (status == AnimationStatus.dismissed) {
        forward();
      }
    });
  }
}

class PuzzlePointSuccess extends StatefulWidget {
  const PuzzlePointSuccess({super.key});

  @override
  State<PuzzlePointSuccess> createState() => _PuzzlePointSuccessState();
}

class _PuzzlePointSuccessState extends State<PuzzlePointSuccess>
    with TickerProviderStateMixin {
  static const _smallImageOffset = Offset(124, 36);
  static const _mediumImageOffset = Offset(215, -47);
  static const _largeImageOffset = Offset(215, -47);
  int _pointProgress = 0;

  late final AnimationController _layoutAnimationController;
  late final AnimationController _resultCompleteAnimationController;
  late final Animation<Offset> _layoutOffset;

  final GlobalKey _rewardPointKey = GlobalKey();
  final List<GlobalKey> _starPointKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  final List<Offset> _starPointOffset = [
    Offset.zero,
    Offset.zero,
    Offset.zero,
  ];

  Offset? _rewardPointOffset;

  int _getPointProgress() {
    return 2;
  }

  @override
  void initState() {
    super.initState();
    _pointProgress = _getPointProgress();
    _layoutAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _resultCompleteAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _layoutAnimationController.addStatusListener(_animationStatusListener);
    _layoutOffset = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _layoutAnimationController,
        curve: const Interval(0, 0.6, curve: Curves.easeOut),
      ),
    );
    _layoutAnimationController.forward();
    Future.delayed(Duration(milliseconds: 2200 + _pointProgress * 1200))
        .then((value) {
      _resultCompleteAnimationController.forward();
    });
  }

  void _animationStatusListener(AnimationStatus listener) async {
    if (listener == AnimationStatus.completed) {
      setState(() {
        _rewardPointOffset =
            (_rewardPointKey.currentContext?.findRenderObject() as RenderBox)
                .localToGlobal(Offset.zero);
        for (var i = 0; i < _starPointOffset.length; i++) {
          _starPointOffset[i] =
              (_starPointKeys[i].currentContext?.findRenderObject() as RenderBox)
                  .localToGlobal(Offset.zero);
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _resultCompleteAnimationController.dispose();
    _layoutAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.watch<PuzzleBloc>().state;
    final l10n = context.l10n!;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _layoutAnimationController.drive(CurveTween(curve: Curves.easeOut)),
                child: ResponsiveLayoutBuilder(
                  small: (_, child) => child!,
                  medium: (_, child) => child!,
                  large: (_, child) => child!,
                  child: (currentSize) {
                    final height = currentSize == ResponsiveLayoutSize.small
                        ? 374.0
                        : 355.0;

                    final imageOffset =
                        currentSize == ResponsiveLayoutSize.large
                            ? _largeImageOffset
                            : (currentSize == ResponsiveLayoutSize.medium
                                ? _mediumImageOffset
                                : _smallImageOffset);

                    final imageHeight =
                        currentSize == ResponsiveLayoutSize.small
                            ? 374.0
                            : 437.0;

                    final completedTextWidth =
                        currentSize == ResponsiveLayoutSize.small
                            ? 160.0
                            : double.infinity;

                    final wellDoneTextStyle =
                        currentSize == ResponsiveLayoutSize.small
                            ? PuzzleTextStyle.headline4Soft
                            : PuzzleTextStyle.headline3;

                    final timerTextStyle =
                        currentSize == ResponsiveLayoutSize.small
                            ? PuzzleTextStyle.headline5
                            : PuzzleTextStyle.headline4;

                    final timerIconSize =
                        currentSize == ResponsiveLayoutSize.small
                            ? const Size(21, 21)
                            : const Size(28, 28);

                    final timerIconPadding =
                        currentSize == ResponsiveLayoutSize.small ? 4.0 : 6.0;

                    final numberOfMovesTextStyle =
                        currentSize == ResponsiveLayoutSize.small
                            ? PuzzleTextStyle.headline5
                            : PuzzleTextStyle.headline4;

                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Container(
                          key: const Key('dashatar_score'),
                          width: double.infinity,
                          height: height,
                          color: theme.backgroundColor,
                          child: Stack(
                            children: [
                              Positioned(
                                left: imageOffset.dx,
                                top: imageOffset.dy,
                                child: SlideTransition(
                                  position: _layoutOffset,
                                  child: Image.asset(
                                    theme.successThemeAsset,
                                    height: imageHeight,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    SizedBox(
                                      key:
                                          const Key('dashatar_score_completed'),
                                      width: completedTextWidth,
                                      child: AnimatedDefaultTextStyle(
                                        style:
                                            PuzzleTextStyle.headline5.copyWith(
                                          color: theme.defaultColor,
                                        ),
                                        duration: PuzzleThemeAnimationDuration
                                            .textStyle,
                                        child:
                                            Text(l10n.dashatarSuccessCompleted),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    SlideTransition(
                                      position: _layoutOffset,
                                      child: AnimatedDefaultTextStyle(
                                        key: const Key(
                                            'dashatar_score_well_done'),
                                        style: wellDoneTextStyle.copyWith(
                                          color: PuzzleColors.white,
                                        ),
                                        duration: PuzzleThemeAnimationDuration
                                            .textStyle,
                                        child:
                                            Text(l10n.dashatarSuccessWellDone),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    SlideTransition(
                                      position: _layoutOffset,
                                      child: AnimatedDefaultTextStyle(
                                        key: const Key('dashatar_score_score'),
                                        style:
                                            PuzzleTextStyle.headline5.copyWith(
                                          color: theme.defaultColor,
                                        ),
                                        duration: PuzzleThemeAnimationDuration
                                            .textStyle,
                                        child: Text(l10n.dashatarSuccessScore),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    DashatarTimer(
                                      textStyle: timerTextStyle,
                                      iconSize: timerIconSize,
                                      iconPadding: timerIconPadding,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    SlideTransition(
                                      position: _layoutOffset,
                                      child: AnimatedDefaultTextStyle(
                                        key: const Key(
                                            'dashatar_score_number_of_moves'),
                                        style: numberOfMovesTextStyle.copyWith(
                                          color: PuzzleColors.white,
                                        ),
                                        duration: PuzzleThemeAnimationDuration
                                            .textStyle,
                                        child: Text(
                                          l10n.dashatarSuccessNumberOfMoves(
                                            state.numberOfMoves.toString(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SlideTransition(
                position: _layoutOffset,
                child: FadeTransition(
                  opacity: _layoutAnimationController.drive(CurveTween(curve: Curves.easeOut)),
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.backgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(_starPointKeys.length, (index) {
                        return StarBackgroundPoint(
                          key: _starPointKeys[index],
                          index: index,
                          isActive: _pointProgress >= index + 1,
                        );
                      }),
                    ),
                  ),
                ),
              ),
              SlideTransition(
                position: _layoutOffset,
                child: FadeTransition(
                  opacity: _layoutAnimationController.drive(CurveTween(curve: Curves.easeOut)),
                  child: PointLevel(
                    levelKey: _rewardPointKey,
                    point: _pointProgress,
                  ),
                ),
              ),
              const Spacer(),
              FadeTransition(
                opacity: _resultCompleteAnimationController
                    .drive(CurveTween(curve: Curves.easeOut)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          PuzzleColors.white,
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 2,
                              color: PuzzleColors.bluePrimary,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      child: const SizedBox(
                        height: 56,
                        width: 120,
                        child: Center(
                          child: Text(
                            "Play again",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: PuzzleColors.bluePrimary,
                            ),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          PuzzleColors.bluePrimary,
                        ),
                      ),
                      child: const SizedBox(
                        height: 56,
                        width: 120,
                        child: Center(
                          child: Text(
                            "Continue",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
          ...List.generate(_starPointKeys.length, (index) {
            return StarPoint(
              isActive: _pointProgress >= index + 1,
              index: index,
              levelKeyOffset: _rewardPointOffset,
              offset: _starPointOffset[index],
            );
          }),
          Positioned(
            bottom: 106,
            left: MediaQuery.sizeOf(context).width / 4 - 70,
            child: FadeTransition(
              opacity:
                  _resultCompleteAnimationController.drive(CurveTween(curve: Curves.easeOut)),
              child: const AnimationToolbox(),
            ),
          )
        ],
      ),
    );
  }
}

class PointLevel extends StatefulWidget {
  final GlobalKey levelKey;
  final int point;

  const PointLevel({
    super.key,
    required this.levelKey,
    required this.point,
  });

  @override
  State<PointLevel> createState() => _PointLevelState();
}

class _PointLevelState extends State<PointLevel> with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _starAnimationScale;

  bool _isCountingReward = false;

  int _currentPoint = 2;

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..repeatEx(times: widget.point);
    _animationController.addStatusListener(_animationStatusListener);
    _starAnimationScale =
        Tween<double>(begin: 0.99, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
    ));
    Future.delayed(Duration(milliseconds: 3800 + widget.point * 100))
        .then((value) {
      _animationController.forward();
    });
  }

  void _animationStatusListener(AnimationStatus listener) async {
    if (listener == AnimationStatus.forward) {
      setState(() {
        _isCountingReward = true;
        _currentPoint += 1;
      });
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        _isCountingReward = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    return ScaleTransition(
      scale: _starAnimationScale,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: _isCountingReward
              ? PuzzleColors.bluePrimary.withOpacity(0.1)
              : theme.backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                const Text("REWARD PROCESS"),
                const Spacer(),
                SizedBox(
                  key: widget.levelKey,
                  width: 20,
                  height: 20,
                  child: Image.asset('assets/images/point/star.png'),
                ),
                const SizedBox(width: 8),
                Text("$_currentPoint/10"),
              ],
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 10,
                width: MediaQuery.sizeOf(context).width,
                child: Stack(
                  children: [
                    Container(
                      height: 10,
                      width: MediaQuery.sizeOf(context).width,
                      color: Colors.white,
                    ),
                    AnimatedContainer(
                      height: 10,
                      width: ((MediaQuery.sizeOf(context).width - 70) / 10) *
                          _currentPoint,
                      color: PuzzleColors.bluePrimary,
                      duration: const Duration(milliseconds: 200),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class StarBackgroundPoint extends StatefulWidget {
  final bool isActive;
  final int index;

  const StarBackgroundPoint({
    super.key,
    required this.isActive,
    required this.index,
  });

  @override
  State<StarBackgroundPoint> createState() => _StarBackgroundPointState();
}

class _StarBackgroundPointState extends State<StarBackgroundPoint>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _starAnimationScale;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _starAnimationScale = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
    ));
    if (widget.isActive) {
      Future.delayed(
        Duration(milliseconds: widget.index * 300),
        _animationController.forward,
      ).then((value) {
        Future.delayed(
          const Duration(milliseconds: 200),
          _animationController.reverse,
        );
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: ScaleTransition(
        scale: _starAnimationScale,
        child: SizedBox(
          width: 50,
          height: 50,
          child: Image.asset('assets/images/point/star.png'),
        ),
      ),
    );
  }
}

class StarPoint extends StatefulWidget {
  final bool isActive;
  final int index;
  final Offset? levelKeyOffset;
  final Offset? offset;

  const StarPoint({
    super.key,
    required this.isActive,
    required this.index,
    this.levelKeyOffset,
    this.offset,
  });

  @override
  State<StarPoint> createState() => _StarPointState();
}

class _StarPointState extends State<StarPoint> with TickerProviderStateMixin {
  late final AnimationController _pointController;
  late final AnimationController _rotateController;
  late Animation<double> _starPointScale;
  late Animation<double> _starRotate;

  @override
  void initState() {
    super.initState();
    _pointController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _starPointScale = CurvedAnimation(
      parent: _pointController,
      curve: Curves.elasticOut,
    );
    _starRotate = Tween<double>(begin: -1, end: -1.08).animate(CurvedAnimation(
      parent: _rotateController,
      curve: Curves.ease,
    ));
  }

  final StreamController<Offset> _controller = StreamController<Offset>();

  Stream<Offset> get _levelOffset => _controller.stream;

  @override
  void didUpdateWidget(covariant StarPoint oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.offset != Offset.zero) {
      _controller.add(widget.offset ?? Offset.zero);
      if (widget.isActive) {
        Future.delayed(Duration(milliseconds: (widget.index + 1) * 500))
            .then((value) {
          _pointController.forward();
        }).then((value) {
          _starPointScale =
              Tween<double>(begin: 1, end: 0.3).animate(CurvedAnimation(
            parent: _pointController,
            curve: Curves.ease,
          ));
          Future.delayed(const Duration(seconds: 1)).then((value) {
            Future.delayed(
              const Duration(seconds: 1),
              _rotateController.forward,
            ).then((value) {
              _controller.add(widget.levelKeyOffset ?? Offset.zero);
              _pointController.forward();
              _rotateController.reverse();
              Future.delayed(const Duration(milliseconds: 300), () {
                _controller.add(Offset.zero);
              });
            });
          });
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _rotateController.dispose();
    _pointController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Offset>(
      builder: (context, snap) {
        if (snap.hasData && snap.data != Offset.zero) {
          return AnimatedPositioned(
            top: (snap.data == widget.offset)
                ? snap.data!.dy - 5
                : snap.data!.dy - 20,
            left: (snap.data == widget.offset)
                ? snap.data!.dx - 5
                : snap.data!.dx - 19,
            duration: const Duration(milliseconds: 200),
            child: Visibility(
              visible: widget.isActive,
              child: ScaleTransition(
                key: widget.key,
                scale: _starPointScale,
                child: RotationTransition(
                  turns: _starRotate,
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: Image.asset(
                      'assets/images/point/star_outline.png',
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
      stream: _levelOffset,
    );
  }
}

class AnimationToolbox extends StatefulWidget {
  const AnimationToolbox({super.key});

  @override
  State<AnimationToolbox> createState() => _AnimationToolboxState();
}

class _AnimationToolboxState extends State<AnimationToolbox>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0, -0.1),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.ease,
  ));

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: SizedBox(
        height: 90,
        width: 150,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 70,
                width: 150,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.white38,
                      offset: Offset(0, 4),
                      blurRadius: 6,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: const Center(
                    child: Text("Play again and get a higher score?")),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 50,
                height: 30,
                color: Colors.transparent,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Image.asset("assets/images/point/arrow.png"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
