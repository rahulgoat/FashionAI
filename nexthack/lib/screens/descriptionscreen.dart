import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class DescriptionScreen extends StatefulWidget {
  final String imagePath;
  final String gender;

  const DescriptionScreen(
      {Key? key, required this.imagePath, required this.gender})
      : super(key: key);

  @override
  _DescriptionScreenState createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  List<Outfit> outfits = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    sendImageToGeminiAPI();
  }

  Future<void> sendImageToGeminiAPI() async {
    const apiKey =
        'AIzaSyCKhUYONJJe5WJJSL7xQgvb22L38NALqX0'; // Replace with your actual API key
    const serperApiKey =
        '2bda1354efbfdaee475b00017a4c91deb875d3ec'; // Replace with your actual API key

    if (apiKey.isEmpty || serperApiKey.isEmpty) {
      setState(() {
        isLoading = false;
        print('API keys are missing');
      });
      return;
    }

    try {
      final model = GenerativeModel(model: 'gemini-pro-vision', apiKey: apiKey);
      final imageBytes = await File(widget.imagePath).readAsBytes();
      final imagePart = DataPart('image/jpeg', imageBytes);

      final response = await model.generateContent([
        Content.multi([
          TextPart(
              "answer the three things: the product shown in the image like it is for male or female cloth, predict cloth size, whether is it suite for the person skin tone."),
          imagePart
        ])
      ]);

      print('Gemini API Response: ${response.text}');

      final apiResponse = await http.post(
        Uri.parse(
            'https://fastapi-vercel-phi-nine.vercel.app/get-gemini-response/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'question': response.text}),
      );

      print('FastAPI Response Status: ${apiResponse.statusCode}');
      print('FastAPI Response Body: ${apiResponse.body}');

      if (apiResponse.statusCode == 200) {
        final responseData = json.decode(apiResponse.body);
        String answer = responseData['response'].toString();

        var request = http.Request(
            'POST', Uri.parse('https://google.serper.dev/shopping'));
        request.body = json.encode({"q": '$answer'});
        request.headers.addAll(
            {'X-API-KEY': serperApiKey, 'Content-Type': 'application/json'});

        http.StreamedResponse serperResponse = await request.send();
        final responseString = await serperResponse.stream.bytesToString();

        print('Serper API Response: $responseString');

        setState(() {
          outfits = parseOutfits(responseString);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          print(
              'FastAPI request failed with status: ${apiResponse.statusCode}');
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        print('Error: $e');
      });
    }
  }

  List<Outfit> parseOutfits(String responseString) {
    try {
      Map<String, dynamic> data = json.decode(responseString);
      if (data.containsKey('recommendations') &&
          data['recommendations'] != null) {
        List<dynamic> recommendations = data['recommendations'];
        return recommendations.map((item) {
          return Outfit(
            name: item['Outfit 1'],
          );
        }).toList();
      } else {
        print('No recommendations found in the response');
        return [];
      }
    } catch (e) {
      print('Error parsing outfits: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Outfit Recommendations'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : outfits.isEmpty
                ? Text('No recommendations available')
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: outfits.map((outfit) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              outfit.name,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
      ),
    );
  }
}

class Outfit {
  final String name;

  Outfit({required this.name});
}
