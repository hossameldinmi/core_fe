import 'package:core_fe_infrastructure/src/models/response_options.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_fe_infrastructure/models.dart';

void main() {
  group('MergeWith', () {
    test('expected ResponseOptions when passed options<int> is null', () async {
      const responseOptions = ResponseOptions<int>();
      var epectedResponseOptions = responseOptions.mergeWith();

      expect(responseOptions, epectedResponseOptions);
    });
    // test('expect default ResponseOptions when passing Empty initalized Object',
    //     () async {
    //   final options = ResponseOptions<int>();
    //   var updatedOptions =
    //       await networkManager.updateResponseOptions<int>(options);
    //   var expectedOptions = ResponseOptions(
    //     responseType: ResponseType.json,
    //     fromJson: JsonUtil.getType<int>().fromJson,
    //     receiveTimeout: 60000,
    //     validateStatus: mockHttpHelper.validateStatus,
    //   );
    //   expect(updatedOptions, expectedOptions);
    // });
    // test('expect new ResponseOptions with new receiveTimeout', () async {
    //   final options = ResponseOptions<int>(receiveTimeout: 2000);
    //   var updatedOptions =
    //       await networkManager.updateResponseOptions<int>(options);
    //   var expectedOptions = ResponseOptions(
    //     responseType: ResponseType.json,
    //     fromJson: JsonUtil.getType<int>().fromJson,
    //     receiveTimeout: 2000,
    //     validateStatus: mockHttpHelper.validateStatus,
    //   );
    //   expect(updatedOptions, expectedOptions);
    // });

    // test('expect new ResponseOptions with new responseType', () async {
    //   final options = ResponseOptions<int>(
    //     receiveTimeout: 2000,
    //     responseType: ResponseType.plain,
    //   );
    //   var updatedOptions =
    //       await networkManager.updateResponseOptions<int>(options);
    //   var expectedOptions = ResponseOptions(
    //     responseType: ResponseType.plain,
    //     fromJson: JsonUtil.getType<int>().fromJson,
    //     receiveTimeout: 2000,
    //     validateStatus: mockHttpHelper.validateStatus,
    //   );
    //   expect(updatedOptions, expectedOptions);
    // });
  });
}
