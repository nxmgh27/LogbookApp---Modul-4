import 'package:flutter/material.dart';
import '../models/log_model.dart';
import '../log_controller.dart';

class LogItemWidget extends StatelessWidget {
  final LogModel log;
  final int index;
  final LogController controller;
  final VoidCallback onEdit;

  final VoidCallback onDelete;

  const LogItemWidget({
    super.key,
    required this.log,
    required this.index,
    required this.controller,
    required this.onEdit,
    required this.onDelete, 
  });

  Color _getCardColor(String category) {
    switch (category) {
      case "Pribadi":
        return const Color(0xFFECE69D);
      case "Urgent":
        return const Color(0xFF59789F);
      case "Pekerjaan":
      default:
        return const Color(0xFF7A9445);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = _getCardColor(log.category);

    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF243C2C).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                log.category,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF243C2C),
                ),
              ),
            ),

            const SizedBox(height: 6),

            // Judul
            Text(
              log.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF243C2C),
              ),
            ),

            const SizedBox(height: 4),

            // Deskripsi
            Text(
              log.description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF243C2C),
              ),
            ),

            const SizedBox(height: 8),

            // Waktu
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Color(0xFFA9B6C4)),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}