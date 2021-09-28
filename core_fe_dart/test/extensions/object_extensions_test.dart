import 'package:flutter_test/flutter_test.dart';
import 'package:core_fe_dart/extensions.dart';

void main() {
  group('item fold', () {
    var str1 = '1.01';
    var double1 = 1.01;

    var str2 = '2.02';
    var double2 = 2.02;
    double toDouble(dynamic value) {
      return double.parse(value as String);
    }

    Future<void> expectCasting(dynamic input, dynamic expected) async {
      expect((input as Object?).castAllInSync<double>(toDouble), expected);
      expect(
          await input.castAllIn<double>(
              (value) => Future.delayed(const Duration(milliseconds: 1)).then((v) => toDouble(value))),
          expected);
    }

    group('castAllInSync', () {
      test('expected null when value is null', () {
        expectCasting(null, null);
      });

      test('expected double Value when value is String', () {
        expectCasting(str1, double1);
        expectCasting(str2, double2);
      });

      test('expected List<double> when value is List<String>', () {
        expectCasting([str1, str2], [double1, double2]);
      });

      test('expected Map<String,double> when value is Map<String,String>', () {
        expectCasting({'str1': str1, 'str2': str2}, {'str1': double1, 'str2': double2});
      });

      test('expected Map<String,dynamic> when value is Map<String,dynamic>(List<String> & String)', () {
        expectCasting({
          'str1': [str1, str2],
          'str2': str1
        }, {
          'str1': [double1, double2],
          'str2': double1
        });
      });

      test('expected List<Map<String,dynamic>> when value is List<Map<String,dynamic>>(List<String> & String)', () {
        expectCasting([
          {
            'str1': [str1, str2],
            'str2': str1
          },
          {
            'str1': [str1, str2],
            'str2': str1
          }
        ], [
          {
            'str1': [double1, double2],
            'str2': double1
          },
          {
            'str1': [double1, double2],
            'str2': double1
          }
        ]);
      });
    });
  });
}
