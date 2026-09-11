import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../constants/api_constants.dart';
import 'tmdb_preferences.dart';

class ApiClient {
  late final Dio dio;

  final TmdbPreferences preferences;

  ApiClient({
    TmdbPreferences? preferences,
  }) : preferences = preferences ?? TmdbPreferences.instance {
    final token = dotenv.env['TMDB_ACCESS_TOKEN'];

    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'accept': 'application/json',
        },
      ),
    );
  }

  Future<Response<dynamic>> get(String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    final params = {
      'language': preferences.languageCode,
      'region': preferences.countryCode,
      ...?queryParameters,
    };

    return dio.get(
      path,
      queryParameters: params,
    );
  }
}