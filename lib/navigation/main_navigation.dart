import 'package:flutter/material.dart';

import '../screens/main_screen.dart';
import '../screens/received_messages_screen.dart';
import '../screens/send_message_screen.dart';
import '../screens/sent_history_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const MainScreen(),
    const SendMessageScreen(),
    const ReceivedMessagesScreen(),
    const SentHistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF2a3142),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.send),
            label: 'Envoyer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: 'Reçus',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historique',
          ),
        ],
      ),
    );
  }
}