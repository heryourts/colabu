import 'package:flutter/material.dart';

class InicioAlumnoScreen extends StatelessWidget {
  const InicioAlumnoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: const Center(
        child: Text('Bienvenido, Alumno', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
