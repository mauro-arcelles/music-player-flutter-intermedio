import 'package:flutter/material.dart';

class AudioPlayerModel extends ChangeNotifier {
  bool _playing = false;
  Duration _songDuration = const Duration(milliseconds: 0);
  Duration _current = const Duration(milliseconds: 0);
  late AnimationController _controller;

  String get songTotalDuration => printDuration(_songDuration);
  String get currentSecond => printDuration(_current);

  double get porcentaje => _songDuration.inSeconds > 0 ? _current.inMilliseconds / _songDuration.inSeconds : 0;

  AnimationController get controller => _controller;
  bool get playing => _playing;
  Duration get songDuration => _songDuration;
  Duration get current => _current;

  set controller(AnimationController controller) {
    _controller = controller;
  }

  set playing(bool playing) {
    _playing = playing;
    notifyListeners();
  }

  set songDuration(Duration songDuration) {
    _songDuration = songDuration;
    notifyListeners();
  }

  set current(Duration current) {
    _current = current;
    notifyListeners();
  }

  String printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
