

String formatTime(Duration? restTime) {
  if (restTime == null) return "00:00";

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  final hours = restTime.inHours;
  final minutes = restTime.inMinutes.remainder(60);
  final seconds = restTime.inSeconds.remainder(60);

  final buffer = StringBuffer();

  if (hours > 0) {
    buffer.write(twoDigits(hours));
    if (hours > 1) {
      buffer.write('hrs ');
    } else {
      buffer.write('hr ');
    }
  }

  if (minutes > 0) {
    buffer.write(twoDigits(minutes));
    if (minutes > 1) {
      buffer.write('mins ');
    } else {
      buffer.write('min ');
    }
  }

  if (seconds > 0) {
    buffer.write(twoDigits(seconds));
    if (seconds > 1) {
      buffer.write('secs');
    } else {
      buffer.write('sec');
    }
  }

  return buffer.toString();
}
