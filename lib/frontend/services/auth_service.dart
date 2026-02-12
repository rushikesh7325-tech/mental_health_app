import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  // Use 10.0.2.2 for Android Emulator, localhost for iOS Simulator/Web
  static const String baseUrl = 'http://localhost:5000/api/user';
  final _storage = const FlutterSecureStorage();

  // --- PRIVATE HELPERS ---

  /// Internal helper to construct authenticated headers for protected routes
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await _storage.read(key: 'jwt_token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  void _handleError(http.Response response) {
    // Attempt to parse the error message from the backend JSON response
    Map<String, dynamic> data;
    try {
      data = jsonDecode(response.body);
    } catch (e) {
      data = {'error': 'Critical server error occurred.'};
    }

    final String message = data['error'] ?? 'An unknown error occurred';

    if (response.statusCode == 401) {
      logout(); // Automatic logout on unauthorized/expired token
      throw Exception('Session expired: $message');
    }
    throw Exception(message);
  }

  // --- PUBLIC METHODS ---

  /// Extracts the User ID from the JWT payload without a network request.
  /// Ensure your backend includes 'id' or 'userId' in the token payload.
  Future<String?> getUserId() async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      if (token != null && !JwtDecoder.isExpired(token)) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

        // This key must match what you define in your Node.js jwt.sign() payload
        return decodedToken['id']?.toString() ??
            decodedToken['userId']?.toString();
      }
    } catch (e) {
      debugPrint("Error decoding token: $e");
    }
    return null;
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'jwt_token');
    return token != null && !JwtDecoder.isExpired(token);
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required String userType,
    Map<String, dynamic>? extraData,
  }) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'full_name': fullName,
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
        'user_type': userType,
        ...?extraData,
      }),
    );

    if (response.statusCode != 201) _handleError(response);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Save the token locally for future authenticated requests
      await _storage.write(key: 'jwt_token', value: data['token']);
      return data;
    } else {
      _handleError(response);
      return {};
    }
  }

  Future<void> updatePrimaryGoals(List<String> goals) async {
    final url = Uri.parse('$baseUrl/goals');
    final response = await http.put(
      url,
      headers: await getAuthHeaders(),
      body: jsonEncode({'goals': goals}),
    );

    if (response.statusCode != 200) _handleError(response);
  }

  /// Extracts the User Type from the JWT payload.
  Future<String?> getUserType() async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      if (token == null) {
        debugPrint(
          "🚨 NAVIGATION ERROR: No token found. User is likely a guest.",
        );
        return null;
      }

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      debugPrint("🔑 JWT PAYLOAD: $decodedToken"); // LOOK AT THIS IN CONSOLE

      // Check multiple possible keys just in case
      final type =
          decodedToken['user_type'] ??
          decodedToken['role'] ??
          decodedToken['type'];

      return type?.toString();
    } catch (e) {
      debugPrint("🚨 JWT DECODE FAILED: $e");
      return null;
    }
  }
}
