import 'dart:async';

/// Utility class for creating cancelable future tasks.
class Cron {
  Duration? _duration;
  Timer? _timer;
  void Function()? _onComplete;
  final _stopWatch = Stopwatch();

  /// Returns `true` if cron is running, and `false` if it's not.
  bool get isRunning => _stopWatch.isRunning;

  /// Cancels current timer and starts a new one.
  void start({
    required void Function() onComplete,
    required Duration duration,
    Duration? startFrom,
  }) {
    _duration = duration;
    _onComplete = onComplete;

    _timer?.cancel();

    final ticksToEnd = duration - (startFrom ?? Duration.zero);
    _timer = Timer(ticksToEnd, onComplete);
    _stopWatch.start();
  }

  /// Cancels current timer and keeps last tick value.
  void pause() {
    if (_timer == null || _duration == null) return;

    _timer!.cancel();
    _stopWatch.stop();

    _duration = _duration! - _stopWatch.elapsed;
    _stopWatch.reset();
  }

  /// Resumes current timer from last position.
  void resume() {
    if (_timer == null || _duration == null) return;

    _timer = Timer(_duration!, _onComplete!);
    _stopWatch.start();
  }

  /// Cancels current timer and resets tick value.
  void stop() {
    _timer?.cancel();
    _stopWatch.stop();
    _stopWatch.reset();

    _duration = null;
    _onComplete = null;
  }
}
