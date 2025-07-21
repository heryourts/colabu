import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'welcome_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final usuario = authProvider.usuarioActual;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.cerrarSesion();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: usuario == null
            ? const Text('Cargando usuario...')
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¡Hola, ${usuario.nombre}!',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Rol: ${usuario.tipo}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Text('Email: ${usuario.email}'),
                ],
              ),
      ),
    );
  }
}
