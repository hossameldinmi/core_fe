import 'package:core_fe_dart/enums.dart';
import 'package:meta/meta.dart';
import 'package:core_fe_dart/extensions.dart';

@immutable
class Language extends Enum {
  const Language(
      {@required this.name,
      @required this.languageCode,
      @required this.countryCode,
      String locale,
      this.flowDirection = FlowDirection.ltr})
      : _locale = locale,
        super();

  /// Flow direction for the specified language.
  /// ```
  /// FlowDirection.rtl,FlowDirection.ltr
  /// ```
  final FlowDirection flowDirection;

  /// Langauge code eg. `ar`,`en`
  final String languageCode;

  /// Country code eg. `EG`,`US`
  final String countryCode;

  /// name that can be used for display eg. `عربي - مصر`,`English-US`
  final String name;
  final String _locale;
  String get locale => _locale.isNullEmptyOrWhitespace()
      ? '$languageCode' '_' '$countryCode'
      : _locale;

  /// `English-US` language
  static const Language en_US = Language(
    name: 'English-US',
    languageCode: 'en',
    countryCode: 'US',
  );

  /// `Arabic-Egypt` language
  static const Language ar_EG = Language(
      name: 'عربي - مصر',
      languageCode: 'ar',
      countryCode: 'EG',
      flowDirection: FlowDirection.rtl);

  static List<Language> get languages => [en_US, ar_EG];

  factory Language.fromLocale(String locale) {
    var lang =
        languages.firstWhere((l) => l.locale == locale, orElse: () => null);
    if (lang.isNullEmptyOrWhitespace()) {
      throw AssertionError('locale $locale not exists');
    }
    return lang;
  }

  @override
  List<Object> get props => [locale];
}

enum FlowDirection { rtl, ltr }
