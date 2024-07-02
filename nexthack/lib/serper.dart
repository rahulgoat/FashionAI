import 'package:http/http.dart' as http;
import 'dart:convert';

class Serper {
  Future<List<Map<String, dynamic>>> serpercall(
      String gender, String budget, Map<String, dynamic> outfit) async {
    String top = outfit['top'];
    String bottom = outfit['bottom'];
    String shoes = outfit['shoes'];
    String accessories = outfit['accessories'];
    const serperApiKey = '2bda1354efbfdaee475b00017a4c91deb875d3ec';
    try {
      var request =
          http.Request('POST', Uri.parse('https://google.serper.dev/shopping'));
      request.body = json.encode({
        "q":
            'For $gender, the top is $top, the bottom is $bottom, the shoes is $shoes and the accessories is $accessories, the total budget is $budget'
      });
      request.headers.addAll(
          {'X-API-KEY': serperApiKey, 'Content-Type': 'application/json'});

      http.StreamedResponse serperResponse = await request.send();
      final responseString = await serperResponse.stream.bytesToString();
      print(responseString);

      final responseJson = json.decode(responseString);
      List<Map<String, dynamic>> products =
          List<Map<String, dynamic>>.from(responseJson['shopping']);
      return products;
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}
