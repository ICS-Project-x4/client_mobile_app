import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../screens/Auth.dart';
import '../screens/received_messages_screen.dart';
import '../screens/send_message_screen.dart';
import '../screens/sent_history_screen.dart';
import '../navigation/main_navigation.dart';

class SMSGatewayApp extends StatelessWidget {
  const SMSGatewayApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMS Gateway Pro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Use FutureBuilder to check token and decide initial screen
      home: FutureBuilder(
        future: const FlutterSecureStorage().read(key: 'token'),
        builder: (context, snapshot) {
          // Show loading indicator while checking token
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // If token exists, go to main screen
          if (snapshot.hasData && snapshot.data != null) {
            return const MainNavigation();
          }

          // Otherwise show auth screen
          return const AuthScreen();
        },
      ),
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/main': (context) => const MainNavigation(),
        '/send': (context) => const SendMessageScreen(),
        '/received': (context) => const ReceivedMessagesScreen(),
        '/history': (context) => const SentHistoryScreen(),
      },
    );
  }
}