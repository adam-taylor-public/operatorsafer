import 'dart:convert';
import 'package:http/http.dart' as http;

class GeoapifyService {
  static const String _apiKey = 'YOUR_GEOAPIFY_API_KEY';
  static const String _baseUrl = 'https://api.geoapify.com/v1/geocode/reverse';

  static Future<String?> getAddressFromCoords(double lat, double lon) async {
    final url = Uri.parse(
      '$_baseUrl?lat=$lat&lon=$lon&apiKey=$_apiKey',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['features'] != null && data['features'].isNotEmpty) {
          return data['features'][0]['properties']['formatted'];
        } else {
          return 'No address found';
        }
      } else {
        print('Geoapify error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error calling Geoapify: $e');
      return null;
    }
  }
}
