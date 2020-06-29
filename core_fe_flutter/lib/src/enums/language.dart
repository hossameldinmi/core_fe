import 'package:core_fe_dart/core_fe_dart.dart';

class Language extends Enum<String, Language> {
  const Language(String code, this.name, [this.isRtl = false]) : super(code);
  final bool isRtl;
  final String name;

  static const Language en_US = Language('en_US', 'English-US');
  static const Language ar_EG = Language('ar_EG', 'عربي-مصر', true);
}
