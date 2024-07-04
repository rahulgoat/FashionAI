import 'package:http/http.dart' as http;
import 'dart:convert';

class Serper {
  Future<List<Map<String, dynamic>>> serpercall(String gender, String budget,
      Map<String, dynamic> outfit, String things) async {
    const serperApiKey = 'Use your api key';
    String wear = '';
    switch (things) {
      case "top":
        wear = outfit["top"];
        break;
      case "bottom":
        wear = outfit["bottom"];
        break;
      case "shoes":
        wear = outfit["shoes"];
        break;
      case "accessories":
        wear = outfit["accessories"];
        break;

      default:
        wear = outfit['top'];
        break;
    }

    try {
      List<Map<String, dynamic>> products = [];
      print(wear);
      if (wear.isNotEmpty) {
        var request = http.Request(
            'POST', Uri.parse('https://google.serper.dev/shopping'));
        request.body = json.encode({
          "q":
              'For $gender, provide $wear within the budget of $budget/4 in usd'
        });
        request.headers.addAll(
            {'X-API-KEY': serperApiKey, 'Content-Type': 'application/json'});

        http.StreamedResponse serperResponse = await request.send();
        final responseString = await serperResponse.stream.bytesToString();
        print(responseString);

        final responseJson = json.decode(responseString);
        products = List<Map<String, dynamic>>.from(responseJson['shopping']);
      }
      return products;
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}
