import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class chatscreen extends StatefulWidget {
  const chatscreen({super.key});

  @override
  State<chatscreen> createState() => _chatscreenState();
}

class _chatscreenState extends State<chatscreen> {
  List<Message> messages = [];
  bool isMicSelected = true;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    messages.add(Message(
        content: 'Welcome! Press the microphone button to start.',
        isUser: false));
  }

  Future<void> getGeminiResponse(String question) async {
    final url = Uri.parse(
        'https://fastapi-vercel-phi-nine.vercel.app/get-gemini-response/');
    final data = {'question': question};

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        String answer = responseData['response']
            .toString(); // Extracting the response content
        setState(() {
          messages.add(Message(content: answer, isUser: false));
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
        setState(() {
          messages.add(Message(
              content: 'Request failed with status: ${response.statusCode}',
              isUser: false));
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        messages.add(Message(content: 'Error: $e', isUser: false));
      });
    }
  }

  void toggleButton(bool isMic) {
    setState(() {
      isMicSelected = isMic;
      if (!isMicSelected) {
        // Clear previous messages when switching to keyboard input
        messages.clear();
        messages.add(Message(
            content: 'Type your question and press send.', isUser: false));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LABAI"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(8, 25, 8, 25),
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                Message message = messages[index];
                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    margin:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color:
                          message.isUser ? Colors.deepPurple : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      message.content,
                      style: TextStyle(
                          color: message.isUser ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          if (!isMicSelected)
            Container(
              color: Colors.grey[200],
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type your question here',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      String question = _controller.text;
                      if (question.isNotEmpty) {
                        setState(() {
                          messages
                              .add(Message(content: question, isUser: true));
                        });
                        getGeminiResponse(question);
                        _controller.clear();
                      }
                    },
                    icon: Icon(Icons.send),
                    color: Colors.deepPurple,
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsetsDirectional.all(0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.grey[200], // Background color of the container
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: () => toggleButton(true),
                icon: Icon(Icons.mic),
                color: isMicSelected ? Colors.deepPurple : Colors.grey,
                iconSize: 36.0,
              ),
              SizedBox(
                  width: 10), // Adjust this value to reduce/increase the space
              IconButton(
                onPressed: () => toggleButton(false),
                icon: Icon(Icons.keyboard),
                color: isMicSelected ? Colors.grey : Colors.deepPurple,
                iconSize: 36.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Message {
  final String content;
  final bool isUser;

  Message({required this.content, required this.isUser});
}
