import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:first_task_app/frontend/navigation/index.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class POSHService extends GetConnect {
  @override
  void onInit() {
    baseUrl = "http://localhost:5000/api/user";
    httpClient.timeout = const Duration(seconds: 20);

    // --- ADD THIS LOGGING MODIFIER ---
    httpClient.addRequestModifier<dynamic>((request) {
      debugPrint("📡 [NETWORK DEBUG] ${request.method} ${request.url}");
      debugPrint("📡 [NETWORK DEBUG] Headers: ${request.headers}");

      // This logs the actual body being sent
      // Note: request.bodyBytes is usually where the encoded data sits
      return request;
    });

    super.onInit();
  }

  Future<List<dynamic>> fetchUserReports(String token) async {
    final response = await get(
      '/posh/my-reports',
      headers: {'Authorization': 'Bearer $token'},
    );
    return response.status.isOk ? response.body : [];
  }

 // posh_service.dart
Future<Map<String, dynamic>?> getLiveStatus(String token) async {
  final response = await get('/posh/status', headers: {'Authorization': 'Bearer $token'});
  debugPrint("📡 [SERVICE DEBUG] Status Code: ${response.statusCode}");
  debugPrint("📡 [SERVICE DEBUG] Raw Body: ${response.body}");
  return response.status.isOk ? response.body : null;
}
  /// 1. Sync Training Progress
  /// Updates time spent and completion for specific modules
  Future<bool> syncModuleProgress({
    required String moduleKey,
    required int timeSpent,
    required bool isComplete,
    required String token,
  }) async {
    try {
      final response = await post(
        '/posh/progress',
        {
          "moduleKey": moduleKey,
          "timeSpent": timeSpent,
          "isComplete": isComplete,
        },
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.status.isOk) {
        debugPrint("✅ Progress Synced: $moduleKey");
        return true;
      } else {
        debugPrint("❌ Progress Sync Failed: ${response.bodyString}");
        return false;
      }
    } catch (e) {
      debugPrint("⚠️ Service Error (Progress): $e");
      return false;
    }
  }

  /// 2. Finalize Digital Consent
  /// Saves the legal signature string to the compliance table
  /// Finalize Digital Consent
  /// 2. Finalize Digital Consent
  Future<bool> submitConsent({
    required String digitalSignature,
    required String timestamp,
    required String token,
  }) async {
    final Map<String, dynamic> body = {
      "digitalSignature": digitalSignature,
      "timestamp": timestamp,
    };

    debugPrint("🔍 [PRE-SEND CHECK] Body: ${jsonEncode(body)}");

    try {
      // GetConnect's post method handles the JSON encoding automatically
      // as long as the body is a Map.
      final response = await post(
        '/posh/consent',
        body,
        headers: {
          'Authorization': 'Bearer $token',
          // Note: Content-Type is already handled in onInit's modifier
        },
      );

      debugPrint("📡 [RESPONSE DEBUG] Status: ${response.statusCode}");
      debugPrint("📡 [RESPONSE DEBUG] Body: ${response.bodyString}");

      if (response.status.isOk) {
        debugPrint("✅ Consent Finalized successfully");
        return true;
      } else {
        debugPrint("❌ Consent Failed: ${response.bodyString}");
        return false;
      }
    } catch (e) {
      debugPrint("❌ [SERVICE ERROR]: $e");
      return false;
    }
  }

  /// 3. Submit Incident Report
  /// Sends the full report. Returns the reference ID if successful.
  Future<String?> uploadIncidentReport({
    required Map<String, dynamic> payload,
    required String token,
  }) async {
    try {
      final response = await post(
        '/posh/report',
        payload,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.status.isOk) {
        final refId = response.body['referenceId'];
        debugPrint("✅ Report Submitted! Ref ID: $refId");
        return refId;
      } else {
        // This will capture the "Complete training first" error from the backend
        final errorMsg = response.body?['error'] ?? "Unknown Error";
        debugPrint("❌ Report Submission Failed: $errorMsg");
        return null;
      }
    } catch (e) {
      debugPrint("⚠️ Service Error (Report): $e");
      return null;
    }
  }
}
