import 'package:mongo_dart/mongo_dart.dart';

class LogModel {
  final ObjectId? id;
  final String title;
  final String description;
  final DateTime date;
  final String category;
  final String createdAt;
  final String owner;

  LogModel({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    required this.createdAt,
    required this.owner,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id ?? ObjectId(),
      'title': title,
      'description': description,
      'category': category,
      'date': date.toIso8601String(),
      'createdAt': createdAt,
      'owner': owner,
    };
  }

  factory LogModel.fromMap(Map<String, dynamic> map) {
    return LogModel(
      id: map['_id'] as ObjectId?,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: map['date'] != null ? DateTime.now() : DateTime.now(),
      category: map['category'] ?? 'Pribadi',
      createdAt: map['createdAt'] != null
          ? map['createdAt'].toString()
          : DateTime.now().toIso8601String(),
      owner: map['owner'] ?? 'unknown',
    );
  }
}
