import 'package:core_fe_flutter/src/enums/language.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  void matchEnum(Language lang, String locale) {
    expect(lang.locale, locale);
    expect(lang, Language.fromLocale(locale));
  }

  test('toLocale & fromLocale', () {
    matchEnum(Language.enUS, 'en_US');
    matchEnum(Language.arEG, 'ar_EG');
    expect(() => Language.fromLocale('ar_AR'), throwsArgumentError);
  });

  test('equality', () {
    expect(Language.arEG, Language.arEG);
    expect(Language.arEG, isNot(Language.enUS));
  });
}
