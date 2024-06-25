import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nexthack/screens/chatscreen.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:nexthack/screens/camerascreen.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  List<Message> messages = [];
  bool isMicSelected = true;
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  int selectedIndex = 0;

  void initState() {
    super.initState();
    messages.add(Message(
        content: 'Welcome! Press the microphone button to start.',
        isUser: false));

    _initSpeech();
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

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      messages.add(Message(content: _lastWords, isUser: true));
      getGeminiResponse(_lastWords);
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('NextHack'),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ToggleIconButton(
                  icon: Icons.mic_outlined,
                  isSelected: selectedIndex == 0,
                  onPressed: () {
                    toggleicon(0);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => VoiceScreen()));
                  }),
              SizedBox(width: 10),
              ToggleIconButton(
                  icon: Icons.keyboard_outlined,
                  isSelected: selectedIndex == 1,
                  onPressed: () {
                    toggleicon(1);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => chatscreen()));
                  }),
              SizedBox(width: 10),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Speak Up',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
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
                            color:
                                message.isUser ? Colors.white : Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            // If not yet listening for speech start, otherwise stop
            _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
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
