// import 'dart:async';
// import 'dart:convert';
// import 'package:core_fe_infrastructure/src/interfaces/noSql_storage.dart';
// import 'package:core_fe_infrastructure/src/models/storage_model.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:core_fe_dart/extensions.dart';

// class SecureStorageProviderImpl extends NoSqlStorageProvider {
//   final storage = FlutterSecureStorage();
//   @override
//   Future<void> add<T>(StorageModel<T> object, {bool shared = false}) async {
//     return storage.write(
//       key: object.key,
//       value: json.encode(object.toJson()),
//     );
//   }

//   @override
//   Future<void> delete(String key, {shared = false}) async {
//     return storage.delete(
//       key: key,
//     );
//   }

//   @override
//   Future<void> deleteAll({List<String> tags, shared = false}) async {
//     return findAllKeys(tags: tags)
//         .then(
//           (keys) => keys.map((key) => storage.delete(key: key)),
//         )
//         .then((value) => Future.wait(value));
//   }

//   @override
//   Future<List<String>> findAllKeys({List<String> tags}) async {
//     return storage
//         .readAll()
//         .then(
//           (record) => StorageModel<dynamic>.fromJson(record),
//         )
//         .asStream()
//         .where((object) =>
//             (!(tags.isNullEmptyOrWhitespace()) &&
//                 object.tags.intersection(tags).isNotEmpty) ||
//             tags.isNullEmptyOrWhitespace())
//         .map((object) => object.key)
//         .toList();
//     // ((value) => tags.intersection(value.tags).isNotEmpty).;
//   }

//   @override
//   Future<StorageModel<T>> get<T>(
//     String key, {
//     bool shared = false,
//   }) {
//     return storage.read(key: key).then(
//           (record) => StorageModel<T>.fromJson(json.decode(record)),
//         );
//   }

//   @override
//   Future<void> update<T>(StorageModel<T> object, {bool shared = false}) async {
//     return storage.write(
//       key: object.key,
//       value: json.encode(object.toJson()),
//     );
//   }
// }
