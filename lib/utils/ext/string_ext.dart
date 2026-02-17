extension FormatDuration on Duration {
  String strDigits(int n) => n.toString().padLeft(2, '0');

  String toCountDownTimer() {
    return '${strDigits(inMinutes.remainder(60))}:${strDigits(inSeconds.remainder(60))}';
  }
}
