import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'posh_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../navigation/index.dart';

class POSHController extends GetxController {
  // --- SERVICE & AUTH ---
  final POSHService _poshService = Get.put(POSHService());

  // Replace this with your actual Token retrieval logic (e.g., from GetStorage or AuthController)
  // Inside POSHController class
  final AuthService _authService = AuthService();
  Future<String> getJwtToken() async {
    return await _getJwtToken(); // calls your existing private _getJwtToken
  }

  // Change from async getter to a private method
  Future<String> _getJwtToken() async {
    final storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt_token');
    return token ?? "";
  }

  // --- 1. CONSENT & ACKNOWLEDGMENT STATE ---
  final isAcknowledgeAccepted = false.obs;
  final consentTimestamp = Rxn<DateTime>();
  final digitalSignature = RxnString();

  // --- 2. TRAINING MODULE PROGRESSION ---
  final completedModules = <String, bool>{
    'verbal': false,
    'physical': false,
    'digital': false,
    'workplace': false,
    'evidence': false,
  }.obs;

  final moduleTimeSpent = <String, int>{}.obs;
  final _moduleStopwatch = Stopwatch();

  // --- 3. COMPLAINT FORM STATE ---
  final isAnonymous = true.obs;
  final selectedCategory = RxnString();
  final isSubmitting = false.obs;
  final lastReportReference = RxnString();

  /// Calculates the visual progress (0.0 to 1.0) for the Training Progress Bar.
  /// This looks at how many modules in the map are marked 'true'.
  // --- 4. REACTIVE GETTERS ---

  /// Calculates the visual progress (0.0 to 1.0) for the Training Progress Bar.
  /// This looks at how many modules in the map are marked 'true'.
  double get progressPercentage {
    if (completedModules.isEmpty) return 0.0;
    int completeCount = completedModules.values.where((v) => v == true).length;
    return completeCount / completedModules.length;
  }

  bool get canProceed => isAcknowledgeAccepted.value;
  bool get isFlowComplete => completedModules.values.every((v) => v == true);

  /// Handles the initial policy sign-off and syncs to backend.
  // Inside POSHController class...

  /// Bridges the gap between the UI Consent Screen and the Backend.
  /// Triggered by the "Proceed" or "Sign" button.
  /// FIX 1: Added setInitialConsent for the Checkbox/Switch toggle in UI
  void setInitialConsent(bool value) {
    isAcknowledgeAccepted.value = value;
    if (value) {
      consentTimestamp.value = DateTime.now();
      digitalSignature.value =
          "SIG-${consentTimestamp.value!.millisecondsSinceEpoch}";
    } else {
      consentTimestamp.value = null;
      digitalSignature.value = null;
    }
  }

  /// FIX 2: saveInitialConsent handles the "Proceed" button and Backend Sync
  Future<void> saveInitialConsent() async {
    if (!isAcknowledgeAccepted.value) {
      Get.snackbar(
        "Action Required",
        "Please read and accept the policy to proceed.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isSubmitting.value = true;

      // Safety check for signature
      digitalSignature.value ??= "SIG-${DateTime.now().millisecondsSinceEpoch}";

      bool success = await _poshService.submitConsent(
        digitalSignature: digitalSignature.value!,
        timestamp: DateTime.now().toIso8601String(),
        token: await _getJwtToken(),
      );

      if (success) {
        debugPrint("CONSENT SUCCESS: Data saved to PostgreSQL.");
        // Change '/posh-training-modules' to your actual route name
        Get.toNamed('/posh-training-modules');
      } else {
        throw Exception("Server rejected consent data");
      }
      // posh.controller.dart line 111 - IMPROVE THIS:
    } catch (e) {
      debugPrint("CONSENT ERROR: $e");
      if (Get.context != null) {
        // Add this check to prevent the null crash
        Get.snackbar(
          "Error",
          "Could not sync consent. Check backend connection.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isSubmitting.value = false;
    }
  }

  void startModuleTimer() {
    _moduleStopwatch.reset();
    _moduleStopwatch.start();
  }

  /// Finalizes module completion and syncs metrics to the backend.
  void markModuleAsComplete(String key) async {
    if (completedModules.containsKey(key)) {
      _moduleStopwatch.stop();
      completedModules[key] = true;
      int duration = _moduleStopwatch.elapsed.inSeconds;
      moduleTimeSpent[key] = duration;

      // SYNC TO BACKEND
      await _poshService.syncModuleProgress(
        moduleKey: key,
        timeSpent: duration,
        isComplete: true,
        token: await _getJwtToken(),
      );
    }
  }

  /// Submits the official report payload to the backend via the service.
  Future<bool> submitOfficialReport({
    required String description,
    required String date,
    required String time,
    required String location,
    String? userName,
  }) async {
    if (isSubmitting.value) return false;
    isSubmitting.value = true;

    try {
      final String refId = _generateReferenceId();
      final Map<String, dynamic> reportPayload = {
        "meta": {
          "ref_id": refId,
          "is_anonymous": isAnonymous.value,
          "submission_date": DateTime.now().toIso8601String(),
          "compliance_sig": digitalSignature.value,
        },
        "details": {
          "category": selectedCategory.value,
          "description": description,
          "incident_occurrence": "$date $time",
          "location": location,
        },
        "profile": {
          "reported_by": isAnonymous.value
              ? "ANON_PROTECTED"
              : (userName ?? "NAME_NOT_PROVIDED"),
          "training_verified": isFlowComplete,
        },
      };

      // REAL NETWORK CALL
      final backendRefId = await _poshService.uploadIncidentReport(
        payload: reportPayload,
        token: await _getJwtToken(),
      );

      if (backendRefId != null) {
        lastReportReference.value = backendRefId;
        debugPrint("✅ Controller Updated lastReportReference: $backendRefId");
        await loadReports();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  String _generateReferenceId() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    Random rnd = Random();
    return "POSH-${List.generate(6, (i) => chars[rnd.nextInt(chars.length)]).join()}";
  }

  // Inside POSHController
  final userReports = <dynamic>[].obs;
  final isLoadingReports = false.obs;

  // posh.controller.dart
  Future<void> loadReports() async {
    isLoadingReports.value = true;
    String token = await _getJwtToken();

    // Update your service to have fetchUserReports
    final List<dynamic> reports = await _poshService.fetchUserReports(token);

    if (reports.isNotEmpty) {
      userReports.assignAll(reports);
      // Update the reference for the most recent one
      lastReportReference.value = reports[0]['ref_id'];
    }
    isLoadingReports.value = false;
  }
  //   final isLoadingStatus = false.obs;
  //   Future<void> checkExistingProgress() async {
  //     isLoadingStatus.value = true;
  //     String token = await _getJwtToken();

  //     final status = await _poshService.getLiveStatus(token);
  //     if (status != null) {
  //       // 1. Update Training State
  //       if (status['training'] != null) {
  //         completedModules['verbal'] = status['training']['verbal_complete'] ?? false;
  //         completedModules['physical'] = status['training']['physical_complete'] ?? false;
  //         completedModules['digital'] = status['training']['digital_complete'] ?? false;
  //         completedModules['workplace'] = status['training']['workplace_complete'] ?? false;
  //         completedModules['evidence'] = status['training']['evidence_complete'] ?? false;
  //         digitalSignature.value = status['training']['digital_signature'];
  //       }

  //       // 2. Update Report State
  //       if (status['latestReport'] != null) {
  //         lastReportReference.value = status['latestReport']['ref_id'];
  //       }
  //     }
  //     isLoadingStatus.value = false;
  //   }
  // posh.controller.dart

  Future<Map<String, dynamic>?> fetchLiveStatus() async {
    final token = await _getJwtToken();
    debugPrint("🚀 [CONTROLLER DEBUG] Fetching live status...");

    final status = await _poshService.getLiveStatus(token);

    if (status != null && status['report'] != null) {
      // 🚨 FIX: Your log shows the key is 'ref_id' inside the 'report' object
      final String serverId = status['report']['ref_id'].toString();
      lastReportReference.value = serverId;
      debugPrint("✅ [CONTROLLER] Synced Reference ID: $serverId");
    }

    return status;
  }
}
