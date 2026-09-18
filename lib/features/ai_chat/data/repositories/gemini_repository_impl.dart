import '../../domain/repositories/gemini_repository.dart';
import '../datasources/gemini_remote_data_source.dart';

class GeminiRepositoryImpl implements GeminiRepository {
  final GeminiRemoteDataSource dataSource;

  GeminiRepositoryImpl({GeminiRemoteDataSource? dataSource})
    : dataSource = dataSource ?? GeminiRemoteDataSource();

  @override
  Future<String> sendMessage(String message) {
    return dataSource.sendMessage(message);
  }
}
