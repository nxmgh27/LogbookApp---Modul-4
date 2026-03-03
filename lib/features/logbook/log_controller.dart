import 'dart:convert'; // Wajib ditambahkan untuk jsonEncode & jsonDecode
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:logbook_app_086/features/logbook/models/log_model.dart';
import 'package:logbook_app_086/services/mongo_service.dart';
import 'package:logbook_app_086/helpers/log_helper.dart';

class LogController {
  final ValueNotifier<List<LogModel>> logsNotifier =
      ValueNotifier<List<LogModel>>([]);

  static const String _storageKey = 'user_logs_data';

  List<LogModel> get logs => logsNotifier.value;

  LogController() {
    loadFromDisk();
  }

  // Tambah data baru ke Cloud
  Future<void> addLog(String title, String desc, String category) async {
    final newLog = LogModel(
      id: ObjectId(),
      title: title,
      description: desc,
      category: category,
      date: DateTime.now(),
    );

    try {
      // Kirim ke MongoDB Atlas
      await MongoService().insertLog(newLog);

      // Update UI
      final currentLogs = List<LogModel>.from(logsNotifier.value);
      currentLogs.add(newLog);
      logsNotifier.value = currentLogs;

      await LogHelper.writeLog(
        "SUCCESS: Tambah data dengan ID lokal",
        source: "log_controller.dart",
      );
    } catch (e) {
      await LogHelper.writeLog("ERROR: Gagal sinkronisasi Add - $e", level: 1);
    }
  }

  // Memperbarui data di Cloud
  Future<void> updateLog(
    int index,
    String newTitle,
    String newDesc,
    String category,
  ) async {
    final currentLogs = List<LogModel>.from(logsNotifier.value);
    final oldLog = currentLogs[index];

    final updatedLog = LogModel(
      id: oldLog.id,
      title: newTitle,
      description: newDesc,
      category: category,
      date: DateTime.now(),
    );

    try {
      await MongoService().updateLog(updatedLog);

      currentLogs[index] = updatedLog;
      logsNotifier.value = currentLogs;

      await LogHelper.writeLog(
        "SUCCESS: Sinkronisasi Update '${oldLog.title}' Berhasil",
        source: "log_controller.dart",
        level: 2,
      );
    } catch (e) {
      await LogHelper.writeLog(
        "ERROR: Gagal sinkronisasi Update - $e",
        source: "log_controller.dart",
        level: 1,
      );
    }
  }

  Future<void> removeLog(int index) async {
    final currentLogs = List<LogModel>.from(logsNotifier.value);
    final targetLog = currentLogs[index];

    try {
      if (targetLog.id == null) {
        throw Exception(
          "ID Log tidak ditemukan, tidak bisa menghapus di Cloud.",
        );
      }

      await MongoService().deleteLog(targetLog.id!);

      currentLogs.removeAt(index);
      logsNotifier.value = currentLogs;

      await LogHelper.writeLog(
        "SUCCESS: Sinkronisasi Hapus '${targetLog.title}' Berhasil",
        source: "log_controller.dart",
        level: 2,
      );
    } catch (e) {
      await LogHelper.writeLog(
        "ERROR: Gagal sinkronisasi Hapus - $e",
        source: "log_controller.dart",
        level: 1,
      );
    }
  }

  Future<void> saveToDisk() async {
    final prefs = await SharedPreferences.getInstance();

    final String encodedData = jsonEncode(
      logsNotifier.value.map((log) => log.toMap()).toList(),
    );
    await prefs.setString(_storageKey, encodedData);
  }

  Future<void> loadFromDisk() async {
    final cloudData = await MongoService().getLogs();
    logsNotifier.value = cloudData;
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) {
      return "Selamat Pagi";
    } else if (hour >= 12 && hour < 15) {
      return "Selamat Siang";
    } else if (hour >= 15 && hour < 18) {
      return "Selamat Sore";
    } else {
      return "Selamat Malam";
    }
  }
}
