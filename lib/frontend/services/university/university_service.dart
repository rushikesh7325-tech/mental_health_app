import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'UniversityAssessment.Controller.dart'; // Ensure correct path
import '../auth_service.dart'; 

class UniversityService {
  final AuthService _authService = AuthService();
  final _storage = const FlutterSecureStorage();
  
  // Update with your actual server URL
  static const String _baseUrl = 'http://localhost:5000/api/university';

  /// Final method to submit all university-related responses
  Future<bool> submitUniversityDetails() async {
    final url = Uri.parse('$_baseUrl/unisubmit');
    final String? userId = await _authService.getUserId();
    
    if (userId == null) return false;

    // Retrieve the complete data map from your controller
    final Map<String, dynamic> universityData = UniversityController().allData;

    try {
      final headers = await _getAuthHeaders();

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          "userId": userId,
          "universityDetails": universityData,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        debugPrint("✅ University data synced successfully");
        UniversityController().clearData();
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

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _storage.read(key: 'jwt_token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}