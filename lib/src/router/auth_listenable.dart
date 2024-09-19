import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthListenable extends ChangeNotifier {
  late final StreamSubscription _subscription;
  AuthListenable(Stream<AuthState> stream) {
    _subscription = stream.listen((state) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
