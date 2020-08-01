import 'package:logger/logger.dart';
import 'package:core_fe_dart/utils.dart';

class PrettyPrinterLogger implements ILogger {
  final _logger = Logger(printer: PrettyPrinter(methodCount: 0));
  final _erroLogger = Logger(printer: PrettyPrinter(methodCount: 10));
  @override
  void logInformation(dynamic message) {
    _logger.d(message);
  }

  @override
  void logError(dynamic message) {
    _erroLogger.e(message);
  }

  @override
  void logSuccess(dynamic information) {
    _logger.i(information);
  }

  @override
  void logWarning(dynamic information) {
    _logger.w(information);
  }
}
