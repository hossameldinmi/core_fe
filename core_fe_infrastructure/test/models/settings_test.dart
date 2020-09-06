import 'package:core_fe_flutter/enums.dart';
import 'package:core_fe_infrastructure/src/models/settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Serialization & Deserialization', () {
    var json = {'language': 'en_US'};
    var settings = Settings(language: Language.en_US);
    expect(settings.toMap(), json);
    expect(settings, Settings.fromMap(json));
  });
}
