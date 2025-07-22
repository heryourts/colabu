import 'package:flutter/material.dart';

class MensajesAlumnoScreen extends StatelessWidget {
  const MensajesAlumnoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mensajes')),
      body: const Center(
        child: Text(
          'Aquí estarán tus mensajes',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
