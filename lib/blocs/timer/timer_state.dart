part of 'timer_bloc.dart';

class TimerState extends Equatable {
  const TimerState({
    this.isRunning = false,
    this.secondsElapsed = 0,
    this.timerStatus = TimerStatus.notStarted
  });

  final bool isRunning;
  final TimerStatus timerStatus;
  final int secondsElapsed;

  @override
  List<Object> get props => [isRunning, secondsElapsed, timerStatus];

  TimerState copyWith({bool? isRunning, int? secondsElapsed, TimerStatus? timerStatus}) {
    return TimerState(
        isRunning: isRunning ?? this.isRunning,
        timerStatus: timerStatus ?? this.timerStatus,
        secondsElapsed: secondsElapsed ?? this.secondsElapsed);
  }
}
