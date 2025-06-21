import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart'; // Importez le service API

class SendMessageScreen extends StatefulWidget {
  const SendMessageScreen({Key? key}) : super(key: key);

  @override
  State<SendMessageScreen> createState() => _SendMessageScreenState();
}

class _SendMessageScreenState extends State<SendMessageScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int _characterCount = 0;
  final int _maxCharacters = 160;
  bool _isLoading = false;
  bool _isSending = false;
  
  List<SIM> _sims = [];
  SIM? _selectedSim;
  bool _isLoadingSims = true;

  // Créer une instance du service SMS
  final SMSService _smsService = SMSService();

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_updateCharacterCount);
    _loadUserSims();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _updateCharacterCount() {
    setState(() {
      _characterCount = _messageController.text.length;
    });
  }

Future<void> _loadUserSims() async {
  setState(() {
    _isLoadingSims = true;
  });

  try {
    final sims = await _smsService.getUserSims();
    
    setState(() {
      _sims = sims;
      _isLoadingSims = false;
      
      // Sélectionner automatiquement la première SIM active
      if (_sims.isNotEmpty) {
        // Try to find an active SIM first
        final activeSims = _sims.where((sim) => sim.isActive).toList();
        if (activeSims.isNotEmpty) {
          _selectedSim = activeSims.first;
        } else {
          // If no active SIM, select the first one anyway
          _selectedSim = _sims.first;
        }
      } else {
        // No SIMs available
        _selectedSim = null;
      }
    });
  } catch (e) {
    setState(() {
      _isLoadingSims = false;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du chargement des SIMs: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
  Future<void> _sendMessage() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedSim == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner une SIM'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      final sms = await _smsService.sendSMS(
        simId: _selectedSim!.id,
        recipientNumber: _phoneController.text.trim(),
        content: _messageController.text.trim(),
      );

      // Succès
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Message envoyé avec succès à ${_phoneController.text}'),
            backgroundColor: Colors.green,
          ),
        );

        // Vider le formulaire
        _phoneController.clear();
        _messageController.clear();
        setState(() {
          _characterCount = 0;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'envoi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1f2e),
      appBar: AppBar(
        title: const Text('Envoyer un message'),
        backgroundColor: const Color(0xFF1a1f2e),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoadingSims ? null : _loadUserSims,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF2a3142),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.send, color: Colors.blue, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Nouveau message',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // SIM Selection
                const Text(
                  'Sélectionner une SIM',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 8),
                _isLoadingSims
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1a1f2e),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Chargement des SIMs...',
                              style: TextStyle(color: Colors.white54),
                            ),
                          ],
                        ),
                      )
                    : DropdownButtonFormField<SIM>(
                        value: _selectedSim,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF1a1f2e),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.sim_card, color: Colors.white54),
                        ),
                        dropdownColor: const Color(0xFF2a3142),
                        style: const TextStyle(color: Colors.white),
                        items: _sims.map((SIM sim) {
                          return DropdownMenuItem<SIM>(
                            value: sim,
                            child: Row(
                              children: [
                                Icon(
                                  sim.isActive ? Icons.check_circle : Icons.cancel,
                                  color: sim.isActive ? Colors.green : Colors.red,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${sim.phoneNumber} (${sim.messagesUsed}/${sim.messagesLimit})',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (SIM? newValue) {
                          setState(() {
                            _selectedSim = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Veuillez sélectionner une SIM';
                          }
                          if (!value.isActive) {
                            return 'Cette SIM n\'est pas active';
                          }
                          if (value.messagesUsed >= value.messagesLimit) {
                            return 'Limite de messages atteinte pour cette SIM';
                          }
                          return null;
                        },
                      ),
                const SizedBox(height: 24),

                // Phone Number Field
                const Text(
                  'Numéro de téléphone',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: '1234567890',
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: const Color(0xFF1a1f2e),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.phone, color: Colors.white54),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un numéro de téléphone';
                    }
                    if (value.length < 10) {
                      return 'Veuillez entrer un numéro valide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                const Text(
                  'Entrez uniquement les chiffres (ex: 1234567890)',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 24),

                // Message Field
                const Text(
                  'Message',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _messageController,
                  maxLines: 4,
                  maxLength: _maxCharacters,
                  decoration: InputDecoration(
                    hintText: 'Tapez votre message ici...',
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: const Color(0xFF1a1f2e),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    counterText: '',
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un message';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Maximum $_maxCharacters caractères',
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    Text(
                      '$_characterCount/$_maxCharacters',
                      style: TextStyle(
                        color: _characterCount > _maxCharacters
                            ? Colors.red
                            : Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Send Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_characterCount <= _maxCharacters && !_isSending)
                        ? _sendMessage
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isSending
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Envoi en cours...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.send, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Envoyer le message',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}