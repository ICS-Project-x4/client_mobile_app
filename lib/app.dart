import 'package:flutter/material.dart';
import '../screens/received_messages_screen.dart';
import '../screens/send_message_screen.dart';
import '../screens/sent_history_screen.dart';

import '../navigation/main_navigation.dart';

class SMSGatewayApp extends StatelessWidget {
  const SMSGatewayApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMS Center',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainNavigation(),
      routes: {
        '/main': (context) => const MainNavigation(),
        '/send': (context) => const SendMessageScreen(),
        '/received': (context) => const ReceivedMessagesScreen(),
        '/history': (context) => const SentHistoryScreen(),
      },
    );
  }
}