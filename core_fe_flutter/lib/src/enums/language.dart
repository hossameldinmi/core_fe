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

  /// English-US language
  static const Language en_US = Language(
    name: 'English-US',
    countryCode: 'US',
    languageCode: 'en',
  );

  /// Arabic-Egypt language
  static const Language ar_EG = Language(
      name: 'عربي - مصر',
      countryCode: 'EG',
      languageCode: 'ar',
      flowDirection: FlowDirection.rtl);

  static Map<String, Language> get _hardCodedLangs =>
      {en_US.locale: en_US, ar_EG.locale: ar_EG};

  static final Map<String, Language> _languages = _hardCodedLangs;

  @visibleForTesting
  static void resetLangs() {
    _languages.clear();
    _languages.addAll(_hardCodedLangs);
  }

  static List<Language> get languages =>
      _languages.entries.map((e) => e.value).toList();

  /// add Language to the language list,
  /// incase of inserting existing languag's key,
  /// you can update it, but this [Language] `Will-NOT` affect the original language object in Language enum,
  /// you will `Only` find it if you use `
  /// Language.fromCode `
  static void addLanguage(Language language, [bool updateIfExists = false]) {
    if (_languages.containsKey(language.locale) && !updateIfExists) {
      throw AssertionError(
          'locale ${language.locale} already exists, you can set [updateIfExists]=true');
    }

    _languages[language.locale] = language;
  }

  factory Language.fromLocale(String locale) {
    var lang =
        languages.firstWhere((l) => l.locale == locale, orElse: () => null);
    if (lang.isNullEmptyOrWhitespace()) {
      throw AssertionError(
          'locale $locale not exists, you can add it by using [Language.addLanguage]');
    }
    return lang;
  }

  @override
  List<Object> get props => [locale];
}

enum FlowDirection { rtl, ltr }
