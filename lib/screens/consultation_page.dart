import 'package:flutter/material.dart';
import 'package:stunting_android/services/api_service.dart';

class ConsultationPage extends StatefulWidget {
  const ConsultationPage({Key? key}) : super(key: key);

  @override
  _ConsultationPageState createState() => _ConsultationPageState();
}

class _ConsultationPageState extends State<ConsultationPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _fetchChat();
  }

  Future<void> _fetchChat() async {
    try {
      final chatData = await _apiService.getChat();
      setState(() {
        _messages = List<Map<String, dynamic>>.from(chatData['data'] ?? []);
      });
      _scrollToBottom();
    } catch (e) {
      print('Error fetching chat: $e');
    }
  }

  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    try {
      final newMessage = {
        'pesan': messageText,
        'role': 'user',
        'created_at': DateTime.now().toIso8601String(),
      };
      setState(() {
        _messages.add(newMessage);
        _messageController.clear();
      });
      _scrollToBottom();
      await _apiService.createChat(messageText);
      _fetchChat();
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konsultasi'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final messageText = message['pesan'] ?? 'Pesan kosong';
                final isUser = message['role'] == 'user';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.greenAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      messageText,
                      style: TextStyle(
                        color: isUser ? Colors.black : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
