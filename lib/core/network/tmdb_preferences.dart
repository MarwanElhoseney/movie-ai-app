class TmdbPreferences {
  TmdbPreferences._();

  static final TmdbPreferences instance = TmdbPreferences._();

  String languageCode = 'en-US';
  String countryCode = 'US';

  void update({String? language, String? country}) {
    if (language != null) {
      languageCode = language;
    }

    if (country != null) {
      countryCode = country;
    }
  }
}
