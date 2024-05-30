import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:tp_synthse_flutter/global.dart';

class ChatbotPage extends StatefulWidget {
  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final _model = GenerativeModel(
    apiKey: geminiApi,
    model: 'gemini-pro',
  );
  final _controller = TextEditingController();
  final _messages = <String>[];

 void _sendMessage() async {
  if (_controller.text.isNotEmpty) {
    final userMessage = _controller.text;
    _controller.clear();

    // Unfocus the text field to dismiss the keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _messages.add(userMessage); // Add user's message
      _messages.add('Loading...'); // Placeholder for chatbot's response
    });

    final content = [Content.text(userMessage)];
    final response = await _model.generateContent(content);

    if (response != null && response.text != null) {
      setState(() {
        _messages[_messages.indexOf('Loading...')] = response.text!; // Update placeholder with actual response
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot Google Generative AI'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment:
                      (index % 2 == 0) ? Alignment.topRight : Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: (index % 2 == 0)
                            ? Colors.blueAccent
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text(
                        message,
                        style: GoogleFonts.poppins(
                          color: (index % 2 == 0) ? Colors.white : Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                );
              },
               
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Entrez votre message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: Colors.blueAccent,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
