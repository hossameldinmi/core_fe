import 'dart:io';

import 'package:core_fe_flutter/enums.dart';
import 'package:core_fe_infrastructure/models.dart';
import 'package:core_fe_infrastructure/src/exceptions/network_exceptions.dart';
import 'package:core_fe_infrastructure/src/models/base_response.dart';
import 'package:core_fe_infrastructure/src/models/settings.dart';
import 'package:core_fe_infrastructure/src/utils/i_http_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:core_fe_infrastructure/src/models/http_response.dart'
    as http_response;
import 'package:matcher/matcher.dart';

import '../mocks/managers_mocks.dart';
import '../shared.dart';

void main() {
  var mockSessionManager = MockISessionManager();
  var mockSettingsManager = MockISettingsManager();
  var settings = Settings(language: Language.ar_EG);
  var httpHelper = HttpHelper(mockSessionManager, mockSettingsManager);
  group('getDefaultHeaders', () {
    test('default headers when session is anonymous', () async {
      when(mockSettingsManager.getSettings())
          .thenAnswer((realInvocation) => Future.value(settings));
      when(mockSessionManager.isAnonymousSession())
          .thenAnswer((realInvocation) => Future.value(true));

      var headers = await httpHelper.getDefaultHeaders();

      var expectedHeaders = {
        HttpHeaders.acceptHeader: ContentType.json.value,
        HttpHeaders.acceptLanguageHeader: '${settings.language.languageCode}',
      };

      expect(headers, equals(expectedHeaders));
    });

    test('default headers when session is active', () async {
      var session = UserSession(
          userId: 'userId1',
          expiryDate: DateTime.now(),
          token: 'token1',
          username: 'user name');
      when(mockSettingsManager.getSettings())
          .thenAnswer((realInvocation) => Future.value(settings));
      when(mockSessionManager.isAnonymousSession())
          .thenAnswer((realInvocation) => Future.value(false));
      when(mockSessionManager.getCurrentSession())
          .thenAnswer((realInvocation) => Future.value(session));

      var headers = await httpHelper.getDefaultHeaders();

      var expectedHeaders = {
        HttpHeaders.acceptHeader: ContentType.json.value,
        HttpHeaders.acceptLanguageHeader: '${settings.language.languageCode}',
        HttpHeaders.authorizationHeader: 'Bearer ${session.token}',
      };

      expect(headers, equals(expectedHeaders));
    });
  });

  group('resolveResponse', () {
    test('resolve when status is 200(OK)', () {
      var httpResponse = http_response.HttpResponse<int>(
        data: 2,
        statusCode: HttpStatus.ok,
        statusMessage: ok,
      );

      var expectedResponse = BaseResponse<int>(
        2,
        HttpStatus.ok,
        ok,
      );
      var response = httpHelper.resolveResponse(httpResponse);

      expect(response, expectedResponse);
    });

    test('client exception when status is 404(Not Found)', () {
      var httpResponse = http_response.HttpResponse<int>(
        data: null,
        statusCode: HttpStatus.notFound,
        statusMessage: notFound,
      );

      expect(
        () => httpHelper.resolveResponse(httpResponse),
        throwsA(
          const TypeMatcher<ClientException>()
              .having(
                  (e) => e.errorCode, 'error-code', equals(HttpStatus.notFound))
              .having(
                (e) => e.errorMessage,
                'error-message',
                equals(notFound),
              ),
        ),
      );
    });

    test('Server exception when status is 500(Internal Server Error)', () {
      var httpResponse = http_response.HttpResponse<int>(
        data: null,
        statusCode: HttpStatus.internalServerError,
        statusMessage: internalServerError,
      );

      expect(
        () => httpHelper.resolveResponse(httpResponse),
        throwsA(
          const TypeMatcher<ServerException>()
              .having(
                (e) => e.errorCode,
                'error-code',
                equals(HttpStatus.internalServerError),
              )
              .having((e) => e.errorMessage, 'error-message',
                  equals(internalServerError)),
        ),
      );
    });

    test('Authorization exception when status is 401(unauthorized)', () {
      const unauthorized = 'Unauthorized';
      var httpResponse = http_response.HttpResponse<int>(
        data: null,
        statusCode: HttpStatus.unauthorized,
        statusMessage: unauthorized,
      );

      expect(
        () => httpHelper.resolveResponse(httpResponse),
        throwsA(
          const TypeMatcher<AuthorizationException>()
              .having(
                (e) => e.errorCode,
                'error-code',
                equals(HttpStatus.unauthorized),
              )
              .having(
                  (e) => e.errorMessage, 'error-message', equals(unauthorized)),
        ),
      );
    });
  });
}
