import 'package:core_fe_flutter/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Settings extends Equatable {
  final Language language;
  const Settings({
    required this.language,
  });

  Map<String, dynamic> toMap() {
    return {
      'language': language.locale,
    };
  }

  factory Settings.fromMap(Map<String, dynamic>? map) {
    ArgumentError.checkNotNull(map, 'map');
    return Settings(
      language: Language.fromLocale(map!['language']),
    );
  }

  @override
  List<Object> get props => [language];
}
