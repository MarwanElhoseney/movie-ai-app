class TmdbSettings {
  static const Map<String, String> languageCodes = {
    'English (UK)': 'en-GB',
    'English': 'en-US',
    'Bahasa Indonesia': 'id-ID',
    'Chinese': 'zh-CN',
    'Croatian': 'hr-HR',
    'Czech': 'cs-CZ',
    'Danish': 'da-DK',
    'Filipino': 'tl-PH',
    'Finnish': 'fi-FI',
  };

  static const Map<String, String> countryCodes = {
    'Egypt': 'EG',
    'United Kingdom': 'GB',
    'United States': 'US',
    'Canada': 'CA',
    'Germany': 'DE',
    'France': 'FR',
    'Saudi Arabia': 'SA',
    'United Arab Emirates': 'AE',
  };

  static String getLanguageCode(String language) {
    return languageCodes[language] ?? 'en-US';
  }

  static String getCountryCode(String country) {
    return countryCodes[country] ?? 'US';
  }
}
