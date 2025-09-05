// import 'dart:convert';

// import 'package:flutter/services.dart';

// class Configuration {
//   static Future<Map<String, dynamic>> getConfig() {
//     return rootBundle
//         .loadString('assets/config/config.json')
//         .then((value) => jsonDecode(value) as Map<String, dynamic>);
//   }
// }
// /// Sends an HTTP POST request with the given headers and body to the given URL.
import 'dart:convert';
import 'package:flutter/services.dart';

class Configuration {
  static Map<String, dynamic>? _config;

  // โหลด config จาก JSON
  static Future<Map<String, dynamic>> getConfig() async {
    if (_config != null) return _config!;

    final String jsonString = await rootBundle.loadString(
      'assets/config/config.json',
    );
    _config = jsonDecode(jsonString) as Map<String, dynamic>;
    return _config!;
  }

  // ดึง API endpoint
  static Future<String> getApiEndpoint() async {
    final config = await getConfig();
    return config['apiEndpoint'] as String;
  }

  // ดึง headers
  static Future<Map<String, String>> getHeaders() async {
    final config = await getConfig();
    final Map<String, dynamic> headersMap =
        config['defaultHeaders'] as Map<String, dynamic>;
    return headersMap.map((key, value) => MapEntry(key, value.toString()));
  }
}
