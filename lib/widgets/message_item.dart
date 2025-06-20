import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  final String phoneNumber;
  final String message;
  final DateTime timestamp;
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1f2e),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                phoneNumber,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _formatTimestamp(timestamp),
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(color: Colors.white70),
          ),
          if (!isReceived && status != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(status!),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                status!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'envoyé':
      case 'sent':
        return Colors.green;
      case 'en attente':
      case 'pending':
        return Colors.orange;
      case 'échec':
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
