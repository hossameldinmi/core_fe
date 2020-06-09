import 'package:logger/logger.dart';

class LoggerHelper {
  final _logger = Logger(printer: PrettyPrinter(methodCount: 0));
  final _erroLogger = Logger(printer: PrettyPrinter(methodCount: 10));
  void logInformation(dynamic message) {
    _logger.d(message);
  }

  void logError(dynamic message) {
    _erroLogger.e(message);
  }

  void logSuccess(dynamic information) {
    _logger.i(information);
  }

   void logWarning(dynamic information) {
    _logger.w(information);
  }
}

final loggerHelper = LoggerHelper();
