import 'package:flutter/material.dart';

class AssessmentController {
  // Singleton pattern to access the same data across all 16 screens
  static final AssessmentController _instance = AssessmentController._internal();
  factory AssessmentController() => _instance;
  AssessmentController._internal();

  // Dictionary to hold question_id -> user_response
  final Map<int, dynamic> _responses = {};

 void saveResponse(int questionId, dynamic response) {
  _responses[questionId] = response;
  // This line shows you exactly what just arrived
  debugPrint("Question ID: $questionId | Received Data: $response");
  debugPrint("Current Full Payload: $_responses");
}

  void clearData() => _responses.clear();

  Map<int, dynamic> get allResponses => _responses;

  // Potential Backend Logic
  Future<bool> submitToBackend() async {
    // Logic to call your http.post will go here later
    return true; 
  }
}