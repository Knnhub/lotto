import 'dart:convert';

import 'package:flutter/services.dart';

class Configuration {
  static Future<Map<String, dynamic>> getConfig() {
    return rootBundle
        .loadString('assets/config/config.json')
        .then((value) => jsonDecode(value) as Map<String, dynamic>);
  }
}
/// Sends an HTTP POST request with the given headers and body to the given URL.