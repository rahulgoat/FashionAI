import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:nexthack/screens/camerascreen.dart';

class DescriptionScreen extends StatefulWidget {
  final String imagePath;

  const DescriptionScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  _DescriptionScreenState createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  String? description;

  @override
  void initState() {
    super.initState();
    sendImageToGeminiAPI();
  }

  Future<void> sendImageToGeminiAPI() async {
    // Access your API key as an environment variable or directly as a string
    final apiKey =
        'AIzaSyCKhUYONJJe5WJJSL7xQgvb22L38NALqX0'; // Replace with your actual API key if necessary

    if (apiKey.isEmpty) {
      setState(() {
        description = 'API key is missing';
      });
      return;
    }

    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    final imageBytes = await File(widget.imagePath).readAsBytes();
    final imagePart = DataPart('image/jpeg', imageBytes);

    final response = await model.generateContent([
      Content.multi([
        TextPart(
            "Describe the person's age, gender, size of his top and bottom that the person's wearing. "),
        imagePart
      ])
    ]);

    setState(() {
      description = response.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Description'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.keyboard_arrow_left),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CameraScreen()));
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: Center(
        child: description == null
            ? CircularProgressIndicator()
            : Text(description!),
      ),
    );
  }
}
