import 'package:core_fe_flutter/src/enums/language.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  void matchEnum(Language lang, String locale) {
    expect(lang.locale, locale);
    expect(lang, Language.fromLocale(locale));
  }

  test('toLocale & fromLocale', () {
    matchEnum(Language.en_US, 'en_US');
    matchEnum(Language.ar_EG, 'ar_EG');
    expect(() => Language.fromLocale('ar_AR'), throwsArgumentError);
  });

  test('equality', () {
    expect(Language.ar_EG, Language.ar_EG);
    expect(Language.ar_EG, isNot(equals(Language.en_US)));
  });
}
