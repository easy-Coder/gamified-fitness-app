import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/web.dart';

final loggerProvider = Provider((ref) {
  return Logger();
});

