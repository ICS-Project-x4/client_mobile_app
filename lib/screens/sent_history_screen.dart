import 'package:flutter/material.dart';

import '../widgets/message_item.dart';

class SentHistoryScreen extends StatefulWidget {
  const SentHistoryScreen({Key? key}) : super(key: key);

  @override
  State<SentHistoryScreen> createState() => _SentHistoryScreenState();
}

class _SentHistoryScreenState extends State<SentHistoryScreen> {
  // Mock data - remplacez avec vos vraies données
  final List<Map<String, dynamic>> _sentMessages = [
    // Ajoutez vos messages envoyés ici
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1f2e),
      appBar: AppBar(
        title: const Text('Historique des envois'),
        backgroundColor: const Color(0xFF1a1f2e),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF2a3142),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.history, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Historique des envois',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Expanded(
                child: _sentMessages.isEmpty
                    ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.send,
                        size: 64,
                        color: Colors.white24,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Aucun message envoyé',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'L\'historique des messages envoyés apparaîtra ici.',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  itemCount: _sentMessages.length,
                  itemBuilder: (context, index) {
                    final message = _sentMessages[index];
                    return MessageItem(
                      phoneNumber: message['phoneNumber'],
                      message: message['message'],
                      timestamp: message['timestamp'],
                      status: message['status'],
                      isReceived: false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
