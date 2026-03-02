import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/log_model.dart';

class LogController {
  final ValueNotifier<List<LogModel>> logsNotifier =
      ValueNotifier<List<LogModel>>([]);

  final ValueNotifier<List<LogModel>> filteredLogs =
      ValueNotifier<List<LogModel>>([]);

  static const String storageKey = 'log_data';

  LogController() {
    loadLogs();
  }

  List<String> get categories => [
        "Pekerjaan",
        "Pribadi",
        "Urgent",
      ];

  Future<void> loadLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(storageKey);

    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      logsNotifier.value =
          decoded.map((item) => LogModel.fromJson(item)).toList();
    }

    filteredLogs.value = logsNotifier.value;
  }

  Future<void> saveLogs() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonList =
        logsNotifier.value.map((log) => log.toJson()).toList();

    await prefs.setString(storageKey, jsonEncode(jsonList));
  }

  // Search
  void searchLog(String query) {
    if (query.isEmpty) {
      filteredLogs.value = logsNotifier.value;
    } else {
      filteredLogs.value = logsNotifier.value
          .where((log) =>
              log.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  // CRUD
  void addLog(String title, String description, String category) {
    final updated = List<LogModel>.from(logsNotifier.value);

    updated.add(
      LogModel(
        title: title,
        description: description,
        category: category,
        timestamp: DateTime.now(),
      ),
    );

    logsNotifier.value = updated;
    filteredLogs.value = updated;
    saveLogs();
  }

  void updateLog(
      int index, String title, String description, String category) {
    final updated = List<LogModel>.from(logsNotifier.value);

    updated[index] = LogModel(
      title: title,
      description: description,
      category: category,
      timestamp: DateTime.now(),
    );

    logsNotifier.value = updated;
    filteredLogs.value = updated;
    saveLogs();
  }

  void removeLog(int index) {
    final updated = List<LogModel>.from(logsNotifier.value);
    updated.removeAt(index);

    logsNotifier.value = updated;
    filteredLogs.value = updated;
    saveLogs();
  }

  String getgreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 6 && hour < 12) return "Selamat Pagi";
    if (hour < 15) return "Selamat Siang";
    if (hour < 18) return "Selamat Sore";
    return "Selamat Malam";
  }
}