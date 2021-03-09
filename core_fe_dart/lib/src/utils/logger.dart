import 'package:meta/meta.dart';

class Logger {
  final String _className;
  static LoggerProvider _logger;
  static void initLogger(LoggerProvider loggerProvider) {
    _logger = loggerProvider;
  }

  Logger(this._className);

  void debug(
    dynamic message, {
    String methodName,
    dynamic args,
    dynamic output,
    dynamic error,
    StackTrace stackTrace,
    bool showStackTrace = false,
  }) {
    if (showStackTrace) stackTrace ??= StackTrace.current;
    _logger?.debug(
      logObject: LogObject(
          className: _className,
          args: args,
          output: output,
          message: message,
          methodName: methodName),
      error: error,
      stackTrace: stackTrace,
    );
  }

  void info(
    dynamic message, {
    String methodName,
    dynamic args,
    dynamic output,
    dynamic error,
    StackTrace stackTrace,
    bool showStackTrace = false,
  }) {
    if (showStackTrace) stackTrace ??= StackTrace.current;

    _logger?.debug(
      logObject: LogObject(
          className: _className,
          args: args,
          output: output,
          message: message,
          methodName: methodName),
      error: error,
      stackTrace: stackTrace,
    );
  }

  void error(
    dynamic message, {
    String methodName,
    dynamic args,
    dynamic output,
    dynamic error,
    StackTrace stackTrace,
    bool showStackTrace = false,
  }) {
    if (showStackTrace) stackTrace ??= StackTrace.current;

    _logger?.error(
      logObject: LogObject(
          className: _className,
          args: args,
          output: output,
          message: message,
          methodName: methodName),
      error: error,
      stackTrace: stackTrace,
    );
  }

  void success(
    dynamic message, {
    String className,
    String methodName,
    dynamic args,
    dynamic output,
    dynamic error,
    StackTrace stackTrace,
    bool showStackTrace = false,
  }) {
    if (showStackTrace) stackTrace ??= StackTrace.current;

    _logger?.success(
      logObject: LogObject(
          className: _className,
          args: args,
          output: output,
          message: message,
          methodName: methodName),
      error: error,
      stackTrace: stackTrace,
    );
  }

  void warning(
    dynamic message, {
    String className,
    String methodName,
    dynamic args,
    dynamic output,
    dynamic error,
    StackTrace stackTrace,
    bool showStackTrace = false,
  }) {
    if (showStackTrace) stackTrace ??= StackTrace.current;

    _logger?.warning(
      logObject: LogObject(
          className: _className,
          args: args,
          output: output,
          message: message,
          methodName: methodName),
      error: error,
      stackTrace: stackTrace,
    );
  }

  void verbose(
    dynamic message, {
    String methodName,
    dynamic args,
    dynamic output,
    dynamic error,
    StackTrace stackTrace,
    bool showStackTrace = false,
  }) {
    if (showStackTrace) stackTrace ??= StackTrace.current;
    _logger?.verbose(
      logObject: LogObject(
          className: _className,
          args: args,
          output: output,
          message: message,
          methodName: methodName),
      error: error,
      stackTrace: stackTrace,
    );
  }
}

abstract class LoggerProvider {
  void debug({
    @required LogObject logObject,
    dynamic error,
    StackTrace stackTrace,
    bool showStackTrace = false,
  });
  void info({
    @required LogObject logObject,
    dynamic error,
    StackTrace stackTrace,
    bool showStackTrace = false,
  });
  void error({
    @required LogObject logObject,
    dynamic error,
    StackTrace stackTrace,
    bool showStackTrace = false,
  });

  void success({
    @required LogObject logObject,
    dynamic error,
    StackTrace stackTrace,
    bool showStackTrace = false,
  });

  void warning({
    @required LogObject logObject,
    dynamic error,
    StackTrace stackTrace,
    bool showStackTrace = false,
  });
  void verbose({
    @required LogObject logObject,
    dynamic error,
    StackTrace stackTrace,
    bool showStackTrace = false,
  });
}

class LogObject {
  final String className;
  final String methodName;
  final dynamic message;
  final dynamic args;
  final dynamic output;

  LogObject({
    this.className,
    this.methodName,
    this.args,
    this.output,
    this.message,
  });
}
