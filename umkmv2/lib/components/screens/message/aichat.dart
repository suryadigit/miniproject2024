// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers, unused_element, depend_on_referenced_packages, avoid_printimport 'dart:convert';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:cached_network_image/cached_network_image.dart';

class ChatAI extends StatefulWidget {
  const ChatAI({super.key});
  @override
  State<ChatAI> createState() => _ChatAIState();
}

class _ChatAIState extends State<ChatAI> {
  final List<Map<String, dynamic>> _conversations = [];
  final ScrollController _scrollController = ScrollController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  late TextEditingController _textController;
  bool _isLoading = false;
  late String? apiKey = dotenv.env['API_KEY'];
  late String? apiUrl = dotenv.env['API_URL'];

  Future<void> requestMicrophonePermission() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
    } else if (status.isDenied) {
    } else if (status.isPermanentlyDenied) {}
  }

  @override
  void initState() {
    super.initState();
    loadApiKey();
    _textController = TextEditingController();
    requestMicrophonePermission();
    _speech.initialize().then((value) {
      if (!_speech.isAvailable) {}
    });
  }

  Future<void> loadApiKey() async {
    await dotenv.load();
    setState(() {
      apiKey = dotenv.env['API_KEY']!;
      apiUrl = dotenv.env['API_URL']!;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _conversations.length,
              itemBuilder: (context, index) {
                final message = _conversations[index];
                return Align(
                  alignment: message['role'] == 'user'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: message['role'] == 'ai'
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                'https://www.una.study/wp-content/uploads/2022/01/3094520-1024x846.png',
                              ),
                              radius: 16,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 8.0),
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: message['role'] == 'user'
                                      ? Colors.green[400]
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Text(
                                  message['content'],
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            )
                          ],
                        )
                      : Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: message['role'] == 'user'
                                ? Colors.green[400]
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            message['content'],
                            style: const TextStyle(color: Colors.black),
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
                  child: TextFormField(
                    controller: _textController,
                    maxLines: null,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Tanyakan sesuatu...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.green,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 12),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (_speech.isListening) {
                      _speech.stop();
                    } else {
                      startListening();
                    }
                  },
                  icon: Icon(_speech.isListening ? Icons.mic_off : Icons.mic),
                ),
                IconButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_textController.text.isNotEmpty) {
                            _submitForm();
                          }
                        },
                  icon: _isLoading
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void startListening() {
    if (_speech.isAvailable) {
      try {
        _speech.listen(
          onResult: (result) {
            setState(() {
              _textController.text = result.recognizedWords;
            });
          },
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Gagal dengar suara, ada yang error kayaknya: $error'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('Device kamu tidak support nih.'),
            ],
          ),
        ),
      );
    }
  }

  void _submitForm() async {
    if (_isLoading || _textController.text.isEmpty) return;
    setState(() {
      _isLoading = true;
    });

     
    final response = await http.post(
      Uri.parse(apiUrl!),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
        'Charset': 'utf-8',
        'Authorization': 'Bearer $apiKey'
      },
      body: jsonEncode(
        <String, dynamic>{
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "user",
              "content":
                  "ini merupakan pertanyaan user tolong jawab dengan mudah di mengerti ${_textController.text} gunakan data berikut sebagai data kamu nanti"
            }
          ],
          'max_tokens': 300,
        },
      ),
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final aiResponse = responseData['choices'][0]['message']['content'];
      setState(() {
        _conversations.add({'role': 'user', 'content': _textController.text});
        _conversations.add({'role': 'ai', 'content': aiResponse});
      });
      _textController.clear();
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to get response from server.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
    setState(() {
      _isLoading = false;
    });
  }
}
