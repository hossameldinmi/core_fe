import 'package:core_fe_infrastructure/src/providers/json_model_provider.dart';
import 'package:meta/meta.dart';
import 'package:core_fe_flutter/src/extenstions/date_time_extensions.dart';
import 'package:core_fe_dart/src/extensions/iterable_extensions.dart';
import 'package:core_fe_dart/src/extensions/validation_extensions.dart';
import 'dart:collection';

@immutable
class StorageModel<T> {
  StorageModel(
      {@required this.key,
      @required this.data,
      @required this.createdDate,
      @required this.updatedDate,
      this.expiryDate,
      this.tags})
      : assert(!key.isNullEmptyOrWhitespace()),
        assert(createdDate != null),
        assert(updatedDate != null);
  final T data;
  final String key;
  final DateTime createdDate;
  final DateTime updatedDate;
  final DateTime expiryDate;
  final List<String> tags;

  @override
  String toString() =>
      'StorageModel<$T>\n$kKey:$key\ndata:$data\ncreatedDate:$createdDate\nupdatedDate:$updatedDate\nexpiryDate:$expiryDate\n$kTags:$tags\n-----';

  factory StorageModel.fromJson(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }
    return StorageModel<T>(
        key: map[kKey],
        data: jsonUtil<T>().fromJson(
          (map[_kData]),
        ),
        createdDate: (map[_kCreatedDate] as String)?.parseToDateTime(),
        updatedDate: (map[_kUpdatedDate] as String)?.parseToDateTime(),
        expiryDate: (map[_kExpiryDate] as String)?.parseToDateTime(),
        tags: (map[kTags] as List)?.map((model) => model as String)?.toList());
  }

  Map<String, dynamic> toJson() => {
        kKey: key,
        _kData: jsonUtil<T>().toJson(data),
        _kCreatedDate: createdDate.format(),
        _kUpdatedDate: updatedDate.format(),
        _kExpiryDate: expiryDate != null ? expiryDate.format() : null,
        kTags: tags,
      };

  bool isExpired() => DateTime.now().isAfter(expiryDate);

  @override
  bool operator ==(Object other) {
    var result = (other is StorageModel<T> &&
        key == other.key &&
        data == other.data &&
        createdDate == other.createdDate &&
        updatedDate == other.updatedDate &&
        expiryDate == other.expiryDate &&
        tags.equals(other.tags, isOrderEquality: false));
    return result;
  }

  static const kTags = 'tags';
  static const kKey = 'Key';
  static const _kData = 'data';
  static const _kCreatedDate = 'created_date';
  static const _kUpdatedDate = 'updated_date';
  static const _kExpiryDate = 'expiry_date';
}
