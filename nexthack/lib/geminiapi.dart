import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexthack/fastapi.dart';

//import 'package:nexthack/outfit.dart';

class GeminiApi {
  final String gender, occasion;
  final XFile xfilePick;

  GeminiApi(
      {required this.occasion, required this.gender, required this.xfilePick});

  Future<List<Map<String, dynamic>>> sendImageToGeminiAPI() async {
    Future<List<Map<String, dynamic>>>? _futureOutfits;

    const apiKey =
        'AIzaSyCKhUYONJJe5WJJSL7xQgvb22L38NALqX0'; // Replace with your actual API key

    try {
      final model = GenerativeModel(model: 'gemini-pro-vision', apiKey: apiKey);
      final imageBytes = await File(xfilePick.path).readAsBytes();
      final imagePart = DataPart('image/jpeg', imageBytes);

      final response = await model.generateContent([
        Content.multi([
          TextPart(
              "answer the these things: the product shown in the image, predict the cloth size, whether is it suit for the person's skin tone also predict the person's age"),
          imagePart
        ])
      ]);

      final responseText = response.text ?? 'No response text';
      print(responseText);

      _futureOutfits = Fastapi.game1(responseText, gender, occasion);
      return _futureOutfits;
    } catch (e) {
      print('Error in gemini: $e');
      return [];
    }
  }
}
