// Whether the campus terms are accepted. Starts unticked.
import 'package:flutter_riverpod/flutter_riverpod.dart';

final termsAcceptedProvider = NotifierProvider<TermsAccepted, bool>(
  TermsAccepted.new,
);

class TermsAccepted extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
}
