part of 'timer_bloc.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object?> get props => [];
}

class TimerStarted extends TimerEvent{}

class TimerTicked extends TimerEvent{
  final int secondsElapsed;

  const TimerTicked(this.secondsElapsed);
  @override
  List<Object?> get props => [secondsElapsed];
}

class TimerStopped extends TimerEvent{}

class TimerReset extends TimerEvent{}