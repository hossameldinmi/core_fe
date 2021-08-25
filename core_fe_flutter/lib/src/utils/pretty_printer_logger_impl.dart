import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:core_fe_dart/utils.dart' hide Logger;
import 'package:core_fe_dart/extensions.dart';

class PrinterLoggerImpl implements LoggerProvider {
  final _logger = Logger(printer: CustomPrinter(methodCount: 0));
  final _longMethodLogger = Logger(printer: CustomPrinter(methodCount: 10));

  @override
  void debug({
    required LogObject logObject,
    dynamic error,
    StackTrace? stackTrace,
    bool showStackTrace = false,
  }) =>
      _getLogger(showStackTrace).d(
        logObject,
        error,
        stackTrace,
      );

  @override
  void info({
    required LogObject logObject,
    dynamic error,
    StackTrace? stackTrace,
    bool showStackTrace = false,
  }) =>
      _getLogger(showStackTrace).i(
        logObject,
        error,
        stackTrace,
      );

  @override
  void error({
    required LogObject logObject,
    dynamic error,
    StackTrace? stackTrace,
    bool showStackTrace = false,
  }) =>
      _getLogger(showStackTrace).e(
        logObject,
        error,
        stackTrace,
      );

  @override
  void success({
    required LogObject logObject,
    dynamic error,
    StackTrace? stackTrace,
    bool showStackTrace = false,
  }) =>
      _getLogger(showStackTrace).i(
        logObject,
        error,
        stackTrace,
      );

  @override
  void warning({
    required LogObject logObject,
    dynamic error,
    StackTrace? stackTrace,
    bool showStackTrace = false,
  }) =>
      _getLogger(showStackTrace).w(
        logObject,
        error,
        stackTrace,
      );

  @override
  void verbose({
    required LogObject logObject,
    dynamic error,
    StackTrace? stackTrace,
    bool showStackTrace = false,
  }) =>
      _getLogger(showStackTrace).v(
        logObject,
        error,
        stackTrace,
      );

  Logger _getLogger(bool showStackTrace) {
    return showStackTrace ? _longMethodLogger : _logger;
  }

  @override
  void event({String? eventName, Map<String, String>? args}) {}

  @override
  List<Map<String, dynamic>> getLogs() {
    throw UnimplementedError();
  }
}

/// Default implementation of [LogPrinter].
///
/// Outut looks like this:
/// ```
/// ┌──────────────────────────
/// │ Error info
/// ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
/// │ Method stack history
/// ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
/// │ Log message
/// └──────────────────────────
/// ```
class CustomPrinter extends LogPrinter {
  static const topLeftCorner = '┌';
  static const bottomLeftCorner = '└';
  static const middleCorner = '├';
  static const verticalLine = '│';
  static const doubleDivider = '─';
  static const singleDivider = '┄';

  static final levelColors = {
    Level.verbose: AnsiColor.fg(AnsiColor.grey(0.5)),
    Level.debug: AnsiColor.none(),
    Level.info: AnsiColor.fg(12),
    Level.warning: AnsiColor.fg(208),
    Level.error: AnsiColor.fg(196),
    Level.wtf: AnsiColor.fg(199),
  };

  static final levelEmojis = {
    Level.verbose: '',
    Level.debug: '🐛 ',
    Level.info: '💡 ',
    Level.warning: '⚠️ ',
    Level.error: '⛔ ',
    Level.wtf: '👾 ',
  };

  /// Matches a stacktrace line as generated on Android/iOS devices.
  /// For example:
  /// #1      Logger.log (package:logger/src/logger.dart:115:29)
  static final _deviceStackTraceRegex = RegExp(r'#[0-9]+[\s]+(.+) \(([^\s]+)\)');

  /// Matches a stacktrace line as generated by Flutter web.
  /// For example:
  /// packages/logger/src/printers/pretty_printer.dart 91:37
  static final _webStackTraceRegex = RegExp(r'^((packages|dart-sdk)\/[^\s]+\/)');

  /// Matches a stacktrace line as generated by browser Dart.
  /// For example:
  /// dart:sdk_internal
  /// package:logger/src/logger.dart
  static final _browserStackTraceRegex = RegExp(r'^(?:package:)?(dart:[^\s]+|[^\s]+)');

  static DateTime? _startTime;

  final int methodCount;
  final int errorMethodCount;
  final int lineLength;
  final bool colors;
  final bool printEmojis;
  final bool printTime;

  String _topBorder = '';
  String _middleBorder = '';
  String _bottomBorder = '';

  CustomPrinter({
    this.methodCount = 2,
    this.errorMethodCount = 8,
    this.lineLength = 120,
    this.colors = true,
    this.printEmojis = true,
    this.printTime = false,
  }) {
    _startTime ??= DateTime.now();

    var doubleDividerLine = StringBuffer();
    var singleDividerLine = StringBuffer();
    for (var i = 0; i < lineLength - 1; i++) {
      doubleDividerLine.write(doubleDivider);
      singleDividerLine.write(singleDivider);
    }

    _topBorder = '$topLeftCorner$doubleDividerLine';
    _middleBorder = '$middleCorner$singleDividerLine';
    _bottomBorder = '$bottomLeftCorner$doubleDividerLine';
  }

  @override
  List<String> log(LogEvent event) {
    var logObj = event.message as LogObject;

    String? stackTraceStr;
    if (event.stackTrace == null) {
      if (methodCount > 0) {
        stackTraceStr = formatStackTrace(StackTrace.current, methodCount);
      }
    } else if (errorMethodCount > 0) {
      stackTraceStr = formatStackTrace(event.stackTrace, errorMethodCount);
    }

    var errorStr = event.error?.toString();

    String? timeStr;
    if (printTime) {
      timeStr = getTime();
    }

    return _formatAndPrint(
      event.level,
      logObj,
      timeStr,
      errorStr,
      stackTraceStr,
    );
  }

  String? formatStackTrace(StackTrace? stackTrace, int methodCount) {
    var lines = stackTrace.toString().split('\n');
    var formatted = <String>[];
    var count = 0;
    for (var line in lines) {
      if (_discardDeviceStacktraceLine(line) ||
          _discardWebStacktraceLine(line) ||
          _discardBrowserStacktraceLine(line) ||
          _discardLoggerUtilLine(line)) {
        continue;
      }
      formatted.add('#$count   ${line.replaceFirst(RegExp(r'#\d+\s+'), '')}');
      if (++count == methodCount) {
        break;
      }
    }

    if (formatted.isEmpty) {
      return null;
    } else {
      return formatted.join('\n');
    }
  }

  bool _discardDeviceStacktraceLine(String line) {
    var match = _deviceStackTraceRegex.matchAsPrefix(line);
    if (match == null) {
      return false;
    }
    return match.group(2)!.startsWith('package:logger');
  }

  bool _discardWebStacktraceLine(String line) {
    var match = _webStackTraceRegex.matchAsPrefix(line);
    if (match == null) {
      return false;
    }
    return match.group(1)!.startsWith('packages/logger') || match.group(1)!.startsWith('dart-sdk/lib');
  }

  bool _discardBrowserStacktraceLine(String line) {
    var match = _browserStackTraceRegex.matchAsPrefix(line);
    if (match == null) {
      return false;
    }
    return match.group(1)!.startsWith('package:logger') || match.group(1)!.startsWith('dart:');
  }

  bool _discardLoggerUtilLine(String line) {
    var match = _deviceStackTraceRegex.matchAsPrefix(line);
    if (match == null) {
      return false;
    }
    return (match.group(1)!.startsWith('PrinterLoggerImpl') ||
        match.group(1)!.startsWith('Logger.') ||
        match.group(1)!.startsWith('CustomPrinter.'));
  }

  String getTime() {
    String _threeDigits(int n) {
      if (n >= 100) return '$n';
      if (n >= 10) return '0$n';
      return '00$n';
    }

    String _twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    var now = DateTime.now();
    var h = _twoDigits(now.hour);
    var min = _twoDigits(now.minute);
    var sec = _twoDigits(now.second);
    var ms = _threeDigits(now.millisecond);
    var timeSinceStart = now.difference(_startTime!).toString();
    return '$h:$min:$sec.$ms (+$timeSinceStart)';
  }

  String stringify(dynamic message) {
    if (message is Map || message is Iterable) {
      var encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(message);
    } else {
      return message.toString();
    }
  }

  AnsiColor? _getLevelColor(Level level) {
    if (colors) {
      return levelColors[level];
    } else {
      return AnsiColor.none();
    }
  }

  AnsiColor _getErrorColor(Level level) {
    if (colors) {
      if (level == Level.wtf) {
        return levelColors[Level.wtf]!.toBg();
      } else {
        return levelColors[Level.error]!.toBg();
      }
    } else {
      return AnsiColor.none();
    }
  }

  String? _getEmoji(Level level) {
    if (printEmojis) {
      return levelEmojis[level];
    } else {
      return '';
    }
  }

  List<String> _formatAndPrint(
    Level level,
    LogObject message,
    String? time,
    String? error,
    String? stacktrace,
  ) {
    // This code is non trivial and a type annotation here helps understanding.
    // ignore: omit_local_variable_types
    List<String> buffer = [];
    var color = _getLevelColor(level)!;
    buffer.add(color(_topBorder));
    var emoji = _getEmoji(level);
    if (!message.className.isNullEmptyOrWhitespace() || !message.methodName.isNullEmptyOrWhitespace()) {
      if (!message.className.isNullEmptyOrWhitespace()) {
        buffer.add(color('$verticalLine $emoji class : ${message.className}'));
      }
      if (!message.methodName.isNullEmptyOrWhitespace()) {
        buffer.add(color('$verticalLine $emoji method: ${message.methodName}'));
      }
      buffer.add(color(_middleBorder));
    }

    if (!(message.args as Object?).isNullEmptyOrWhitespace()) {
      buffer.add(color('$verticalLine $emoji args:'));
      for (var line in stringify(message.args).split('\n')) {
        buffer.add(color('$verticalLine $emoji$line'));
      }
      buffer.add(color(_middleBorder));
    }

    if (!(message.output as Object?).isNullEmptyOrWhitespace()) {
      buffer.add(color('$verticalLine $emoji output'));
      for (var line in stringify(message.output).split('\n')) {
        buffer.add(color('$verticalLine $emoji$line'));
      }
      buffer.add(color(_middleBorder));
    }

    if (error != null) {
      var errorColor = _getErrorColor(level);
      for (var line in error.split('\n')) {
        buffer.add(
          color('$verticalLine ') + errorColor.resetForeground + errorColor(line) + errorColor.resetBackground,
        );
      }
      buffer.add(color(_middleBorder));
    }

    if (stacktrace != null) {
      for (var line in stacktrace.split('\n')) {
        buffer.add('$color$verticalLine $line');
      }
      buffer.add(color(_middleBorder));
    }

    if (time != null) {
      buffer..add(color('$verticalLine $time'))..add(color(_middleBorder));
    }

    for (var line in stringify(message.message).split('\n')) {
      buffer.add(color('$verticalLine $emoji$line'));
    }
    buffer.add(color(_bottomBorder));

    return buffer;
  }
}
