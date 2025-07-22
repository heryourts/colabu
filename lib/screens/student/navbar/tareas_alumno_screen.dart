import 'package:flutter/material.dart';

class TareasAlumnoScreen extends StatelessWidget {
  const TareasAlumnoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tareas')),
      body: const Center(
        child: Text('Aquí irán tus tareas', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
