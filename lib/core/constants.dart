import 'package:flutter/foundation.dart';

class Constants {
  // Use localhost for Web, and 10.0.2.2 for Android Emulator
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000/api';
    }
    return 'http://10.0.2.2:5000/api'; // Android Emulator
  }
}
