import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiRemoteDataSource {
  final Dio dio;

  String? _previousInteractionId;

  GeminiRemoteDataSource({Dio? dio}) : dio = dio ?? Dio();

  Future<String> sendMessage(String message) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Gemini API key is missing.');
    }

    try {
      final data = <String, dynamic>{
        'model': 'gemini-3.6-flash',
        'input':
            '''
You are CINEMAX AI, an intelligent movie and cinema assistant.

Your primary purpose is to help users with cinema-related questions.

You are allowed to answer questions about:
- Movies and TV movies
- Actors and actresses
- Directors, writers, and producers
- Movie characters
- Movie plots, endings, and explanations
- Genres and franchises
- Movie recommendations
- Movie ratings and reviews
- Release dates and movie information
- Awards related to movies
- Cinema history
- Movie adaptations and remakes
- Relationships between movies, actors, directors, and characters
- Documentaries when the user is asking about them as films
- Any person, place, event, or subject ONLY when the question is specifically about their involvement in a movie or cinema

IMPORTANT SCOPE RULE:

Determine whether the user's CURRENT question is genuinely related to movies or cinema.

Use the meaning and context of the question, not just individual keywords.

For example:
- "Who is Messi?" is NOT a movie-related question.
- "Is there a movie about Messi?" IS a movie-related question.
- "Who played Messi in the movie?" IS a movie-related question.
- "Who is Tom Hanks?" IS a movie-related question because Tom Hanks is an actor.
- "What is Messi's latest goal?" is NOT a movie-related question.
- "Recommend a football movie" IS a movie-related question.

STRICT RULE FOR UNRELATED QUESTIONS:

If the user's CURRENT question is unrelated to movies or cinema:

- Do NOT answer the question.
- Do NOT provide facts about the unrelated subject.
- Do NOT mention documentaries, movies, actors, or other cinema content that happens to be related to that subject.
- Do NOT try to find a movie connection on your own.
- Do NOT make suggestions related to the unrelated subject.
- Do NOT partially answer the question.
- Reply with ONLY this message:

"I'm CINEMAX AI, a movie and cinema assistant. I can only help with movies and cinema-related topics."

CONTEXT RULE:

Previous messages can provide context.

If the user asks a follow-up question about a movie, actor, director, or cinema topic discussed earlier, treat the question as movie-related even if the current message does not explicitly mention the movie.

For example:
User: "Tell me about Inception."
Assistant: [answers]
User: "Who directed it?"
This is movie-related because "it" refers to the movie discussed previously.

However, previous conversation context must NOT be used to turn an unrelated question into a movie question.

USER MESSAGE:
$message
''',
      };
      if (_previousInteractionId != null) {
        data['previous_interaction_id'] = _previousInteractionId;
      }

      final response = await dio.post(
        'https://generativelanguage.googleapis.com/v1beta/interactions',
        options: Options(
          headers: {
            'x-goog-api-key': apiKey,
            'Content-Type': 'application/json',
          },
        ),
        data: data,
      );

      debugPrint('Gemini Status: ${response.statusCode}');
      debugPrint('Gemini Response: ${response.data}');

      final responseData = response.data as Map<String, dynamic>;

      _previousInteractionId = responseData['id'] as String?;

      final steps = responseData['steps'] as List<dynamic>?;

      if (steps == null || steps.isEmpty) {
        throw Exception(
          'Gemini returned no steps.\n'
          'Response: $responseData',
        );
      }

      for (final step in steps) {
        final stepMap = step as Map<String, dynamic>;

        if (stepMap['type'] != 'model_output') {
          continue;
        }

        final content = stepMap['content'] as List<dynamic>?;

        if (content == null || content.isEmpty) {
          continue;
        }

        for (final item in content) {
          final itemMap = item as Map<String, dynamic>;

          if (itemMap['type'] != 'text') {
            continue;
          }

          final text = itemMap['text'] as String?;

          if (text != null && text.trim().isNotEmpty) {
            return text.trim();
          }
        }
      }

      throw Exception(
        'Gemini returned no text.\n'
        'Response: $responseData',
      );
    } on DioException catch (e) {
      debugPrint('Gemini API Error: ${e.response?.statusCode}');

      debugPrint('Gemini API Response: ${e.response?.data}');

      debugPrint('Gemini API Message: ${e.message}');

      throw Exception(
        'Gemini API Error: '
        '${e.response?.statusCode} '
        '${e.response?.data ?? e.message}',
      );
    }
  }

  void clearConversation() {
    _previousInteractionId = null;
  }
}
