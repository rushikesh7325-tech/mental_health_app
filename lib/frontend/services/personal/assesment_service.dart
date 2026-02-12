import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'assesment.controller.dart';
import '../auth_service.dart'; // Your AuthService containing getUserId()

class AssessmentService {
  final AuthService _authService = AuthService();
  final _storage = const FlutterSecureStorage();
  
  // Use 10.0.2.2 for Android Emulator, localhost for iOS
  static const String _baseUrl = 'http://localhost:5000/api/user';

  /// Main method to submit the stored responses
 Future<bool> submitAssessment() async {
  final url = Uri.parse('$_baseUrl/assesment');
  final String? userId = await _authService.getUserId();
  
  if (userId == null) return false;

  // FETCH DATA
  final Map<int, dynamic> rawResponses = AssessmentController().allResponses;

  // FIX: Convert Map<int, dynamic> to Map<String, dynamic>
  // JSON encoding requires String keys
  final Map<String, dynamic> stringKeyedResponses = rawResponses.map(
    (key, value) => MapEntry(key.toString(), value),
  );

  try {
    final headers = await _getAuthHeaders();

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        "userId": userId,
        "responses": stringKeyedResponses, // Use the fixed map here
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      debugPrint("✅ Assessment synced successfully");
      AssessmentController().clearData();
      return true;
    } else {
      debugPrint("❌ Server Error: ${response.body}");
      return false;
    }
  } catch (e) {
    debugPrint("⚠️ Connectivity Error: $e");
    return false;
  }
}

  /// Helper to fetch the token and format the Bearer header
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _storage.read(key: 'jwt_token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}