import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nexthack/screens/camerascreen.dart';
import 'package:nexthack/screens/imagepickscreen.dart';
import 'package:nexthack/screens/signin.dart';
import 'package:nexthack/screens/voicescreen.dart';

class chatscreen extends StatefulWidget {
  const chatscreen({super.key});

  @override
  State<chatscreen> createState() => _chatscreenState();
}

class _chatscreenState extends State<chatscreen> {
  List<Message> messages = [];
  bool isMicSelected = false;
  TextEditingController _controller = TextEditingController();
  int selectedIndex = 1;
  @override
  void initState() {
    super.initState();
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

  void toggleicon(int index) {
    setState(() {
      selectedIndex = selectedIndex == index ? -1 : index;
      if (selectedIndex == 1) {
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
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.keyboard_arrow_left),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInScreen()));
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        automaticallyImplyLeading: false,
        title: Text('NextHack'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
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
                      color: message.isUser
                          ? Colors.deepPurple[400]
                          : Colors.grey[300],
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
        padding: const EdgeInsets.all(0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.grey[200], // Background color of the container
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ToggleIconButton(
                  icon: Icons.mic_outlined,
                  isSelected: selectedIndex == 0,
                  onPressed: () {
                    toggleicon(0);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => VoiceScreen()));
                  }),
              ToggleIconButton(
                  icon: Icons.keyboard_outlined,
                  isSelected: selectedIndex == 1,
                  onPressed: () {
                    toggleicon(1);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => chatscreen()));
                  }),
              ToggleIconButton(
                  icon: Icons.camera_alt_outlined,
                  isSelected: selectedIndex == 2,
                  onPressed: () {
                    toggleicon(2);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CameraScreen()));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class ToggleIconButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;

  ToggleIconButton({
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      color: isSelected ? Colors.deepPurple : Colors.grey,
      onPressed: onPressed,
      iconSize: 36,
    );
  }
}

class Message {
  final String content;
  final bool isUser;

  Message({required this.content, required this.isUser});
}
