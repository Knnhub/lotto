import 'package:flutter_application_1/config/config.dart';

Future<String> getApiEndpoint() async {
  final config = await Configuration.getConfig();
  return config['apiEndpoint'] as String;
}

String API_ENDPOINT = "http://192.168.82.175:3000";
