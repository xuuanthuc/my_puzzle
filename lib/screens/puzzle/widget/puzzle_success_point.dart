import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_simple/screens/puzzle/widget/puzzle_success_dialog.dart';

import '../../../blocs/puzzle/puzzle_bloc.dart';
import '../../../blocs/theme/theme_bloc.dart';
import '../../../components/app_logo.dart';
import '../../../layout/responsive_layout_builder.dart';
import '../../../themes/puzzle_theme_animations.dart';
import '../../../utils/colors.dart';
import '../../../utils/text_styles.dart';

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

  late final AnimationController _controller;
  late final Animation<Offset> _scoreOffset;

  final GlobalKey _levelStarPoint = GlobalKey();
  final List<GlobalKey> _keys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  final List<Offset> _keysOffset = [
    Offset.zero,
    Offset.zero,
    Offset.zero,
  ];

  Offset? _levelStarPointOffset;

  int _getPointProgress() {
    return 2;
  }

  @override
  void initState() {
    super.initState();
    _pointProgress = _getPointProgress();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _controller.addStatusListener(_animationStatusListener);
    _scoreOffset = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.6, curve: Curves.easeOut),
      ),
    );
    _controller.forward();
  }

  void _animationStatusListener(AnimationStatus listener) async {
    if (listener == AnimationStatus.completed) {
      setState(() {
        _levelStarPointOffset =
            (_levelStarPoint.currentContext?.findRenderObject() as RenderBox)
                .localToGlobal(Offset.zero);
        for (var i = 0; i < _keysOffset.length; i++) {
          _keysOffset[i] =
              (_keys[i].currentContext?.findRenderObject() as RenderBox)
                  .localToGlobal(Offset.zero);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _controller.drive(CurveTween(curve: Curves.easeOut)),
                child: ResponsiveLayoutBuilder(
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
                                  position: _scoreOffset,
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
                                      key: const Key('dashatar_score_completed'),
                                      width: completedTextWidth,
                                      child: AnimatedDefaultTextStyle(
                                        style: PuzzleTextStyle.headline5.copyWith(
                                          color: theme.defaultColor,
                                        ),
                                        duration: PuzzleThemeAnimationDuration
                                            .textStyle,
                                        child: Text("dashatarSuccessCompleted"),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    SlideTransition(
                                      position: _scoreOffset,
                                      child: AnimatedDefaultTextStyle(
                                        key: const Key('dashatar_score_well_done'),
                                        style: wellDoneTextStyle.copyWith(
                                          color: PuzzleColors.white,
                                        ),
                                        duration:
                                            PuzzleThemeAnimationDuration.textStyle,
                                        child: Text("dashatarSuccessWellDone"),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    SlideTransition(
                                      position: _scoreOffset,
                                      child: AnimatedDefaultTextStyle(
                                        key: const Key('dashatar_score_score'),
                                        style: PuzzleTextStyle.headline5.copyWith(
                                          color: theme.defaultColor,
                                        ),
                                        duration:
                                            PuzzleThemeAnimationDuration.textStyle,
                                        child: Text("dashatarSuccessScore"),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    SlideTransition(
                                      position: _scoreOffset,
                                      child: AnimatedDefaultTextStyle(
                                        key: const Key(
                                            'dashatar_score_number_of_moves'),
                                        style: numberOfMovesTextStyle.copyWith(
                                          color: PuzzleColors.white,
                                        ),
                                        duration:
                                            PuzzleThemeAnimationDuration.textStyle,
                                        child: Text(
                                          "50",
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
                position: _scoreOffset,
                child: FadeTransition(
                  opacity: _controller.drive(CurveTween(curve: Curves.easeOut)),
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.backgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(_keys.length, (index) {
                        return StarBackgroundPoint(
                          key: _keys[index],
                          index: index,
                          isActive: _pointProgress >= index + 1,
                        );
                      }),
                    ),
                  ),
                ),
              ),
              SlideTransition(
                position: _scoreOffset,
                child: FadeTransition(
                  opacity: _controller.drive(CurveTween(curve: Curves.easeOut)),
                  child: PointLevel(
                    levelKey: _levelStarPoint,
                    point: _pointProgress,
                  ),
                ),
              ),
              const Spacer(),
              Row(
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
              const SizedBox(height: 80),
            ],
          ),
          ...List.generate(_keys.length, (index) {
            return StarPoint(
              isActive: _pointProgress >= index + 1,
              index: index,
              levelKeyOffset: _levelStarPointOffset,
              offset: _keysOffset[index],
            );
          }),
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

class _PointLevelState extends State<PointLevel> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _containerLevelScale;

  bool _isComplete = false;

  int _currentPoint = 2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..repeatEx(times: widget.point);
    _controller.addStatusListener(_animationStatusListener);
    _containerLevelScale =
        Tween<double>(begin: 0.99, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    ));
    Future.delayed(Duration(milliseconds: 3800 + widget.point * 100))
        .then((value) {
      _controller.forward();
    });
  }

  void _animationStatusListener(AnimationStatus listener) async {
    if (listener == AnimationStatus.forward) {
      setState(() {
        _isComplete = true;
        _currentPoint += 1;
      });
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        _isComplete = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    return ScaleTransition(
      scale: _containerLevelScale,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: _isComplete
              ? PuzzleColors.bluePrimary.withOpacity(0.1)
              : theme.backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Text("Next level"),
                Spacer(),
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
  late final AnimationController _controller;
  late final Animation<double> _starScale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _starScale = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    ));
    if (widget.isActive) {
      Future.delayed(
        Duration(milliseconds: widget.index * 300),
        _controller.forward,
      ).then((value) {
        Future.delayed(
          const Duration(milliseconds: 200),
          _controller.reverse,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: ScaleTransition(
        scale: _starScale,
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
  late Animation<double> _starPointScale;

  bool _needOffset = true;

  @override
  void initState() {
    super.initState();
    _pointController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _starPointScale = CurvedAnimation(
      parent: _pointController,
      curve: Curves.elasticOut,
    );
  }

  final StreamController<Offset> _controller = StreamController<Offset>();

  Stream<Offset> get _levelOffset => _controller.stream;

  @override
  void didUpdateWidget(covariant StarPoint oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.offset != Offset.zero) {
      _needOffset = false;
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
          Future.delayed(const Duration(seconds: 2)).then((value) {
            _controller.add(widget.levelKeyOffset ?? Offset.zero);
          }).then((value) {
            _pointController.forward();
            Future.delayed(const Duration(milliseconds: 300), () {
              _controller.add(Offset.zero);
            });
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Offset>(
      builder: (context, snap) {
        if (snap.hasData && snap.data != Offset.zero) {
          return AnimatedPositioned(
            top: (snap.data == widget.offset)
                ? snap.data!.dy - 5
                : snap.data!.dy - 21,
            left: (snap.data == widget.offset)
                ? snap.data!.dx - 5
                : snap.data!.dx - 21,
            duration: const Duration(milliseconds: 200),
            child: Visibility(
              visible: widget.isActive,
              child: ScaleTransition(
                key: widget.key,
                scale: _starPointScale,
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: Image.asset(
                    'assets/images/point/star_outline.png',
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
