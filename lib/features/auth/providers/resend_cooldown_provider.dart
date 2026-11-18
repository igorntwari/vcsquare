// Seconds until the verification email can be resent (0 = ready).
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_sizes.dart';

final resendCooldownProvider =
    NotifierProvider.autoDispose<ResendCooldown, int>(ResendCooldown.new);

class ResendCooldown extends Notifier<int> {
  Timer? _timer;

  @override
  int build() {
    ref.onDispose(() => _timer?.cancel());
    return 0;
  }

  void start() {
    _timer?.cancel();
    state = AppSizes.resendCooldownSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state <= 1) {
        timer.cancel();
        state = 0;
      } else {
        state = state - 1;
      }
    });
  }
}
