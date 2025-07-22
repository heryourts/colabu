import 'package:colabu/providers/estudiante_perfil_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PerfilAlumnoScreen extends StatelessWidget {
  const PerfilAlumnoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final perfil = Provider.of<EstudiantePerfilProvider>(context).perfil;

    if (perfil == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre: ${perfil.nombre} ${perfil.apellido}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 12),
            Text(
              'Universidad: ${perfil.universidadNombre}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 12),
            Text(
              'Carrera: ${perfil.carreraNombre}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 12),
            Text('Correo: ${perfil.email}', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
