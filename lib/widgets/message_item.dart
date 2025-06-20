// lib/widgets/message_item.dart
import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  final String phoneNumber;
  final String message;
  final String timestamp;
  final String? status;
  final bool isReceived;

  const MessageItem({
    Key? key,
    required this.phoneNumber,
    required this.message,
    required this.timestamp,
    this.status,
    required this.isReceived,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1a1f2e),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isReceived ? Icons.call_received : Icons.call_made,
                      color: isReceived ? Colors.green : Colors.blue,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      phoneNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                if (!isReceived && status != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status!).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status!,
                      style: TextStyle(
                        color: _getStatusColor(status!),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              timestamp,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
      case 'livré':
        return Colors.green;
      case 'pending':
      case 'en attente':
        return Colors.orange;
      case 'failed':
      case 'échoué':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}