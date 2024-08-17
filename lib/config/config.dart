import 'dart:convert';

import 'package:flutter/services.dart';

class Configuration {
  static Future<Map<String, dynamic>> getConfig() {
    // load file text or json to flutter
    return rootBundle.loadString('assets/config/config.json').then((value) {
      // jsonDecode => Convert String to Object
      return jsonDecode(value) as Map<String, dynamic>;
    });
  }
}
