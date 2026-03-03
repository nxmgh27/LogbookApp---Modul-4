import 'package:mongo_dart/mongo_dart.dart';

class LogModel {
  // Menggunakan ObjectId? agar kompatibel dengan identitas unik global MongoDB [cite: 287, 288]
  final ObjectId? id; 
  final String title;
  final String description;
  final DateTime date;
  final String category;

  LogModel({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
  });

  // CONVERT
  Map<String, dynamic> toMap() {
    return {
      '_id': id ?? ObjectId(), 
      'title': title,
      'description': description,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  factory LogModel.fromMap(Map<String, dynamic> map) {
    return LogModel(
      id: map['_id'] as ObjectId?, 
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
    );
  }
}