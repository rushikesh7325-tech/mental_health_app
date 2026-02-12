import 'package:flutter/material.dart';

class UniversityController {
  // Singleton pattern to maintain data across multiple UI screens
  static final UniversityController _instance = UniversityController._internal();
  factory UniversityController() => _instance;
  UniversityController._internal();

  // Stores university-related data (e.g., {"name": "Harvard", "gpa": 3.8})
  final Map<String, dynamic> _universityData = {};

  /// Save a specific field (e.g., 'gpa', 3.9)
  void saveField(String key, dynamic value) {
    _universityData[key] = value;
    debugPrint("University Update -> $key: $value");
    debugPrint("Current University Payload: $_universityData");
  }

  /// Wipe data after successful submission
  void clearData() => _universityData.clear();

  /// Getter for the full data map
  Map<String, dynamic> get allData => _universityData;

  /// Helper to check if a specific field is filled
  dynamic getFieldValue(String key) => _universityData[key];
}