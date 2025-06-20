import 'package:flutter/material.dart';

import '../widgets/message_item.dart';

class ReceivedMessagesScreen extends StatefulWidget {
  const ReceivedMessagesScreen({Key? key}) : super(key: key);

  @override
  State<ReceivedMessagesScreen> createState() => _ReceivedMessagesScreenState();
}

class _ReceivedMessagesScreenState extends State<ReceivedMessagesScreen> {
  // Mock data - remplacez avec vos vraies données
  final List<Map<String, dynamic>> _receivedMessages = [
    // Ajoutez vos messages reçus ici
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1f2e),
      appBar: AppBar(
        title: const Text('Messages reçus'),
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
                  Icon(Icons.inbox, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Messages reçus',
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
                child: _receivedMessages.isEmpty
                    ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox,
                        size: 64,
                        color: Colors.white24,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Aucun message reçu',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Les messages reçus apparaîtront ici.',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  itemCount: _receivedMessages.length,
                  itemBuilder: (context, index) {
                    final message = _receivedMessages[index];
                    return MessageItem(
                      phoneNumber: message['phoneNumber'],
                      message: message['message'],
                      timestamp: message['timestamp'],
                      isReceived: true,
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