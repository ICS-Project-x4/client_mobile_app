import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SentHistoryScreen extends StatefulWidget {
  const SentHistoryScreen({Key? key}) : super(key: key);

  @override
  State<SentHistoryScreen> createState() => _SentHistoryScreenState();
}

class _SentHistoryScreenState extends State<SentHistoryScreen> {
  final SMSService _smsService = SMSService();
  List<SMS> _sentMessages = [];
  bool _isLoading = true;
  String? _error;
  int _currentPage = 0;
  static const int _pageSize = 50;
  final ScrollController _scrollController = ScrollController();
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _loadSentMessages();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == 
        _scrollController.position.maxScrollExtent) {
      if (!_isLoading && _hasMoreData) {
        _loadMoreMessages();
      }
    }
  }

  Future<void> _loadSentMessages() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final messages = await _smsService.getSMSHistory(
        skip: 0,
        limit: _pageSize,
      );

      // Filter only outbound messages (sent messages)
      final sentMessages = messages.where(
        (message) => message.direction == 'outbound'
      ).toList();

      setState(() {
        _sentMessages = sentMessages;
        _isLoading = false;
        _currentPage = 0;
        _hasMoreData = sentMessages.length == _pageSize;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreMessages() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final nextPage = _currentPage + 1;
      final messages = await _smsService.getSMSHistory(
        skip: nextPage * _pageSize,
        limit: _pageSize,
      );

      // Filter only outbound messages
      final sentMessages = messages.where(
        (message) => message.direction == 'outbound'
      ).toList();

      setState(() {
        _sentMessages.addAll(sentMessages);
        _currentPage = nextPage;
        _isLoading = false;
        _hasMoreData = sentMessages.length == _pageSize;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du chargement: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'sent':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Icons.check_circle;
      case 'sent':
        return Icons.send;
      case 'pending':
        return Icons.schedule;
      case 'failed':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Aujourd\'hui ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == yesterday) {
      return 'Hier ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }

  Widget _buildMessageItem(SMS message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(message.status).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with recipient and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'À: ${message.recipientNumber}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(message.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getStatusColor(message.status).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getStatusIcon(message.status),
                      size: 16,
                      color: _getStatusColor(message.status),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      message.status.toUpperCase(),
                      style: TextStyle(
                        color: _getStatusColor(message.status),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Message content
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF374151),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message.content,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Footer with timestamp and additional info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(message.createdAt),
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.smartphone,
                    size: 12,
                    color: Colors.white54,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'SIM ${message.simId}',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Error message if failed
          if (message.errorMessage != null && message.errorMessage!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Colors.red.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 16,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      message.errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsHeader() {
    final totalMessages = _sentMessages.length;
    final deliveredCount = _sentMessages.where((msg) => msg.status == 'delivered').length;
    final pendingCount = _sentMessages.where((msg) => msg.status == 'pending').length;
    final failedCount = _sentMessages.where((msg) => msg.status == 'failed').length;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2a3142),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Statistiques',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Total', totalMessages.toString(), Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('Livrés', deliveredCount.toString(), Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard('En attente', pendingCount.toString(), Colors.orange),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('Échués', failedCount.toString(), Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1f2e),
      appBar: AppBar(
        title: const Text('Historique des envois'),
        backgroundColor: const Color(0xFF1a1f2e),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSentMessages,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadSentMessages,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (!_isLoading && _sentMessages.isNotEmpty)
                _buildStatsHeader(),
              
              Expanded(
                child: _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Erreur de chargement',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _error!,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadSentMessages,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: const Text('Réessayer'),
                            ),
                          ],
                        ),
                      )
                    : _isLoading && _sentMessages.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          )
                        : _sentMessages.isEmpty
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
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                itemCount: _sentMessages.length + (_hasMoreData ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == _sentMessages.length) {
                                    return const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    );
                                  }
                                  return _buildMessageItem(_sentMessages[index]);
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