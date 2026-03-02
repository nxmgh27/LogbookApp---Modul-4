class LogModel {
  final String title;
  final String description;
  final DateTime timestamp;
  final String category;

  LogModel({
    required this.title,
    required this.description,
    required this.timestamp,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'category': category,
    };
  }

  factory LogModel.fromJson(Map<String, dynamic> json) {
    return LogModel(
      title: json['title'],
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
      category: json['category'],
    );
  }
}
