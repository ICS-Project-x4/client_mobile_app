import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_updateCharacterCount);
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

  void _sendMessage() {
    if (_formKey.currentState!.validate()) {
      // Implémentez votre logique d'envoi SMS ici
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Message envoyé à ${_phoneController.text}'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1f2e),
      appBar: AppBar(
        title: const Text('Envoyer un message'),
        backgroundColor: const Color(0xFF1a1f2e),
        elevation: 0,
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
                    onPressed: _characterCount <= _maxCharacters ? _sendMessage : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Row(
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