import 'package:core_fe_flutter/enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('equality', () {
    expect(DateTimeFormat.isoFormat, DateTimeFormat.isoFormat);
    expect(DateTimeFormat.shortDateFormat, DateTimeFormat.shortDateFormat);
    expect(DateTimeFormat.isoFormat, isNot(DateTimeFormat.shortDateFormat));
  });
}
