import 'package:flutter/foundation.dart';

extension StringUtilsExtension on String {
  /// formate string:
  /// - replaces [{key}] with [value]
  /// - [key value map]
  /// ```
  /// 'between {min} and {max}'.formatString({'min': 5, 'max': 10}),
  /// ```
  /// Expected ['between 5 and 10']
  String formatString(Map<String, dynamic> args) {
    return _formatText(this, args);
  }
}

String _formatText(String text, Map<String, dynamic> args) {
  args ??= {};
  args?.forEach((key, value) {
    text = text.replaceAll('{$key}', value != null ? value.toString() : '');
    debugPrint(text);
  });
  return text;
}
