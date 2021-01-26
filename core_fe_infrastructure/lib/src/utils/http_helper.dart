import 'dart:io';
import 'package:core_fe_infrastructure/src/exceptions/network_exceptions.dart';
import 'package:core_fe_infrastructure/src/interfaces/http_network.dart';
import 'package:core_fe_infrastructure/src/interfaces/session_manager.dart';
import 'package:core_fe_infrastructure/src/interfaces/settings_manager.dart';
import 'package:core_fe_infrastructure/src/models/base_response.dart';
import 'package:core_fe_infrastructure/src/models/http_response.dart';

class HttpHelperImpl implements HttpHelper {
  final SessionManager _sessionManager;
  final SettingsManager _settingsManager;
  HttpHelperImpl(this._sessionManager, this._settingsManager);

  @override
  Future<Map<String, dynamic>> getDefaultHeaders() async {
    var headers = <String, dynamic>{};
    headers[HttpHeaders.acceptHeader] = ContentType.json.value;

    // add language header
    var settings = await _settingsManager.getSettings();
    headers[HttpHeaders.acceptLanguageHeader] =
        '${settings.language.languageCode}';

    // add credentials header
    if (!await _sessionManager.isAnonymousSession()) {
      var isAnonymousSession = await _sessionManager.isAnonymousSession();
      if (!isAnonymousSession) {
        var currentSession = await _sessionManager.getCurrentSession();
        headers[HttpHeaders.authorizationHeader] =
            'Bearer ${currentSession.token}';
      }
    }
    return headers;
  }

  @override
  BaseResponse<TResponse> resolveResponse<TResponse>(
      HttpResponse<TResponse> response) {
    var responseData = response.data;
    TResponse data;
    if (validateStatus(response.statusCode)) {
      data = responseData;
    } else {
      handleException(response);
    }
    var result = BaseResponse<TResponse>(
        data, response.statusCode, response.statusMessage);
    return result;
  }

  @override
  bool validateStatus(int statusCode) {
    return statusCode < HttpStatus.badRequest;
  }

  @override
  void handleException(HttpResponse response) {
    if (response.statusCode == HttpStatus.unauthorized) {
      throw AuthorizationException(
          errorCode: response.statusCode, errorMessage: response.statusMessage);
    } else if (response.statusCode >= HttpStatus.badRequest &&
        response.statusCode < HttpStatus.internalServerError) {
      throw ClientException(
          errorCode: response.statusCode, errorMessage: response.statusMessage);
    } else if (response.statusCode >= HttpStatus.internalServerError) {
      throw ServerException(
          errorCode: response.statusCode,
          errorMessage: response.statusMessage,
          errorDetails: response.statusMessage);
    }
  }
}
