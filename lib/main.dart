// lib/main.dart
import 'package:flutter/material.dart';
import 'package:yzugfejs/screens/Auth.dart';

void main() {
  runApp(const SMSGatewayApp());
}

class SMSGatewayApp extends StatelessWidget {
  const SMSGatewayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMS Gateway Pro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const AuthScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}