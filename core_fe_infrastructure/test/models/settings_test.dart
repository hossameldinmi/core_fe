import 'package:core_fe_flutter/enums.dart';
import 'package:core_fe_infrastructure/src/models/settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Serialization & Deserialization', () {
    var json = {'language': 'en_US'};
    const settings = Settings(language: Language.enUS);
    expect(settings.toMap(), json);
    expect(settings, Settings.fromMap(json));
  });
}
