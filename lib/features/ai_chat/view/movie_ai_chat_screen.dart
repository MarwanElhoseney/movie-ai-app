import 'package:flutter/material.dart';

import '../data/repositories/gemini_repository_impl.dart';
import '../domain/usecases/send_movie_message.dart';

class MovieAIChatScreen extends StatefulWidget {
  const MovieAIChatScreen({super.key});

  @override
  State<MovieAIChatScreen> createState() => _MovieAIChatScreenState();
}

class _MovieAIChatScreenState extends State<MovieAIChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  late final SendMovieMessage _sendMovieMessage;

  final List<_ChatMessage> _messages = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    final repository = GeminiRepositoryImpl();

    _sendMovieMessage = SendMovieMessage(repository);

    _messages.add(
      const _ChatMessage(
        text:
            'Hi! I\'m CINEMAX AI 🤖\n\n'
            'Ask me anything about movies, actors, genres, '
            'or movie recommendations.',
        isUser: false,
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();

    if (message.isEmpty || _isLoading) {
      return;
    }

    _messageController.clear();

    setState(() {
      _messages.add(_ChatMessage(text: message, isUser: true));

      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final response = await _sendMovieMessage(message);

      if (!mounted) return;

      setState(() {
        _messages.add(_ChatMessage(text: response, isUser: false));

        _isLoading = false;
      });

      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _messages.add(
          const _ChatMessage(
            text: 'Sorry, something went wrong. Please try again.',
            isUser: false,
          ),
        );

        _isLoading = false;
      });

      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1D2B),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'CINEMAX AI',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];

                return _ChatBubble(message: message);
              },
            ),
          ),

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(left: 20, bottom: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF00D5E6),
                  ),
                ),
              ),
            ),

          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF292736),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  decoration: const InputDecoration(
                    hintText: 'Ask about movies...',
                    hintStyle: TextStyle(color: Colors.white38, fontSize: 12),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: IconButton(
                  onPressed: _isLoading ? null : _sendMessage,
                  icon: const Icon(
                    Icons.send_rounded,
                    color: Color(0xFF00D5E6),
                    size: 21,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;

  const _ChatMessage({required this.text, required this.isUser});
}

class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
        decoration: BoxDecoration(
          color: message.isUser
              ? const Color(0xFF00D5E6)
              : const Color(0xFF292736),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.black : Colors.white,
            fontSize: 11,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
