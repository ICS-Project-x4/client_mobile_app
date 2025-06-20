// main_screen.dart - Page principale avec statistiques
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  // Mock data - remplacez avec vos vraies données d'API
  final Map<String, dynamic> _stats = const {
    'sentToday': 0,
    'receivedToday': 0,
    'pending': 0,
    'deliveryRate': 0.0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1f2e),
      appBar: AppBar(
        title: const Text('SMS Center - Dashboard'),
        backgroundColor: const Color(0xFF1a1f2e),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: (
              
            ) {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tableau de bord',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Statistics Cards
            _buildStatsSection(),
            const SizedBox(height: 32),

            // Quick Actions
            _buildQuickActionsSection(context),
            const SizedBox(height: 32),

            // Recent Activity
            _buildRecentActivitySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Statistiques d\'aujourd\'hui',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Envoyés',
                _stats['sentToday'].toString(),
                Icons.send,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Reçus',
                _stats['receivedToday'].toString(),
                Icons.inbox,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'En attente',
                _stats['pending'].toString(),
                Icons.schedule,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Taux de livraison',
                '${_stats['deliveryRate'].toStringAsFixed(1)}%',
                Icons.check_circle,
                Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2a3142),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Actions rapides',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                'Envoyer SMS',
                Icons.send,
                Colors.blue,
                    () {
                  Navigator.pushNamed(context, '/send');
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildQuickActionCard(
                'Messages reçus',
                Icons.inbox,
                Colors.green,
                    () {
                  Navigator.pushNamed(context, '/received');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2a3142),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Activité récente',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF2a3142),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Column(
              children: [
                Icon(
                  Icons.history,
                  size: 48,
                  color: Colors.white24,
                ),
                SizedBox(height: 16),
                Text(
                  'Aucune activité récente',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'L\'activité apparaîtra ici une fois que vous commencerez à envoyer des messages.',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// send_message_screen.dart - Écran d'envoi de messages


// received_messages_screen.dart - Écran des messages reçus


// sent_history_screen.dart - Écran de l'historique des messages envoyés

// message_item.dart - Widget pour afficher un message

// main_navigation.dart - Navigation principale avec BottomNavigationBar


// app.dart - Configuration principale de l'application
