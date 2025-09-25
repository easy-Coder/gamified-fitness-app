import 'dart:ui';

import 'package:gaimon/gaimon.dart';

void playHapticFeedback(VoidCallback onCall) async {
  final canPlay = await Gaimon.canSupportsHaptic;

  if (canPlay) {
    onCall();
  }
}
