// Flip-now, save-later helper for likes, saves, follows and joins.
import 'package:flutter/foundation.dart';

// Adds [id] to [ids] if missing (or removes it) straight away through
// [update], then calls [save] with the new state. If saving throws, the
// change is undone and [onError] runs.
//
// [update] should wrap setState and skip it once the widget is unmounted.
Future<void> optimisticToggle({
  required Set<String> ids,
  required String id,
  required void Function(VoidCallback change) update,
  required Future<void> Function(bool selected) save,
  VoidCallback? onError,
}) async {
  final selected = !ids.contains(id);
  void apply(bool value) => value ? ids.add(id) : ids.remove(id);

  update(() => apply(selected));
  try {
    await save(selected);
  } catch (error) {
    debugPrint('[optimisticToggle] $id: $error');
    update(() => apply(!selected));
    onError?.call();
  }
}
