import 'package:core_fe_dart/utils.dart';
import 'package:core_fe_flutter/src/utils/pretty_printer_logger_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Logger.initLogger(PrinterLoggerImpl());
  final loggingObject = Logging();
  test('logger', () {
    loggingObject.all();
    expect(0, 0);
  });
}

class Logging {
  final logger = Logger('logger_test');
  void all() {
    // debug();
    // error();
    // info();
    success();
    // warning();
    // verbose();
  }

  void debug() {
    logger.debug(
      'debug',
      methodName: 'debug',
      args: {
        'arg1': 'arg1',
        'arg2': {'ar': 'ar'},
      },
      output: {
        'output1': 'output',
      },
    );
  }

  void error() {
    logger.error(
      'error',
      methodName: 'error',
      args: {
        'arg1': 'arg1',
        'arg2': {'ar': 'ar'},
      },
      output: {
        'output1': 'output',
      },
    );
  }

  void info() {
    logger.info(
      'info',
      methodName: 'info',
      args: {
        'arg1': 'arg1',
        'arg2': {'ar': 'ar'},
      },
      output: {
        'output1': 'output',
      },
    );
  }

  void success() {
    logger.success(
      'success',
      methodName: 'success',
      args: {
        'arg1': 'arg1',
        'arg2': {'ar': 'ar'},
      },
      output: {
        'output1': 'output',
      },
    );
  }

  void warning() {
    logger.warning(
      'warning',
      methodName: 'warning',
      args: {
        'arg1': 'arg1',
        'arg2': {'ar': 'ar'},
      },
      output: {
        'output1': 'output',
      },
    );
  }

  void verbose() {
    logger.verbose(
      'verbose',
      methodName: 'verbose',
      args: {
        'arg1': 'arg1',
        'arg2': {'ar': 'ar'},
      },
      output: {
        'output1': 'output',
      },
    );
  }
}
