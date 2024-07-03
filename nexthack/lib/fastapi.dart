// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';
// import 'package:nexthack/outfit.dart';

// class Fastapi {
//   static Future<List<Outfit>> game1(
//       String responseText, String gender, String occasion) async {
//     try {
//       final apiResponse = await http.post(
//         Uri.parse(
//             'https://fastapi-vercel-phi-nine.vercel.app/get-gemini-response/'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'question':
//               '$responseText, the gender is $gender, occasion is $occasion'
//         }),
//       );
//       print('FastAPI Response Status: ${apiResponse.statusCode}');

//       if (apiResponse.statusCode == 200) {
//         // Decode the API response body as a string
//         // String responseBody = apiResponse.body;

//         // // Remove the single quotes from the string
//         // responseBody = responseBody.replaceAll("'", "");

//         // Parse the cleaned string into a JSON object
//         List<dynamic> jsonResponse = json.decode(apiResponse.body);
//         print(jsonResponse[0].runtimeType);
//         Map<String, dynamic> decodedJson = jsonDecode(jsonResponse[0]);
//         print(decodedJson['response']);
//         print(decodedJson['response'][0]);
//         // print(decodedJson['response'][0]['Outfit_name']);
//         String jsondata = jsonEncode(decodedJson['response'][0]);
//         final List<Outfit> outfits = outfitFromJson(jsondata);
//         return outfits;

//         // // var outfit1 = jsonResponse[0]["response"];
//         // // print(jsonResponse[0].runtimeType);
//         // print("response is $jsonResponse");
//         // // Convert the JSON object into a list of Outfit objs
//         // // List<Outfit> outfits =
//         // //     jsonResponse.map((dynamic item) => Outfit.fromJson(item)).toList();

//         // //return outfits;

//         // List<dynamic> responses = jsonResponse[0]['response'];

//         // for (var entry in decodedJson.entries) {
//         //   print('Key: ${entry.key}, Value: ${entry.value}');
//         // }
//         // // Print each response
//         // for (var response in responses) {
//         //   response.forEach((key, value) {
//         //     print('$key: $value');
//         //   });
//         //   print('---');
//         // }

//         // List<dynamic> decodedJson = json.decode(apiResponse.body);
//         // List<Outfit> outfits =
//         //     decodedJson.map((item) => Outfit.fromJson(item)).toList();

//         // for (var outfit in outfits) {
//         //   print('Outfit Name: ${outfit.name}');
//         //   print('Description: ${outfit.description}');
//       } else {
//         return <Outfit>[];
//       }
//     } catch (e) {
//       print('Error: $e');
//       return <Outfit>[];
//     }
//   }
// }

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Fastapi {
  static Future<List<Map<String, dynamic>>> game1(
      String responseText, String gender, String occasion) async {
    final apiResponse = await http.post(
      Uri.parse(
          'https://fastapi-vercel-phi-nine.vercel.app/get-gemini-response/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'question':
            '$responseText, the gender is $gender, occasion is $occasion and the culture of dress must be western'
      }),
    );

    print('FastAPI Response Status: ${apiResponse.statusCode}');

    if (apiResponse.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(apiResponse.body);
      String innerJsonString = jsonResponse[0];
      Map<String, dynamic> decodedJson = jsonDecode(innerJsonString);
      List<Map<String, dynamic>> outfits =
          List<Map<String, dynamic>>.from(decodedJson['response']);

      print(outfits);
      return outfits;
    } else {
      return [];
    }
  }
}
