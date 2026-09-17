import '../repositories/gemini_repository.dart';

class SendMovieMessage {
  final GeminiRepository repository;

  SendMovieMessage(this.repository);

  Future<String> call(String message) {
    return repository.sendMessage(message);
  }
}
