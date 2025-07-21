import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart'; // reemplaza con tu pantalla principal

class CheckVerificationScreen extends StatefulWidget {
  const CheckVerificationScreen({super.key});

  @override
  State<CheckVerificationScreen> createState() =>
      _CheckVerificationScreenState();
}

class _CheckVerificationScreenState extends State<CheckVerificationScreen> {
  bool verificado = false;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    verificarEstado();
  }

  Future<void> verificarEstado() async {
    User? user = FirebaseAuth.instance.currentUser;

    await user?.reload(); // actualiza el estado del usuario
    user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {
      setState(() {
        verificado = true;
        cargando = false;
      });

      // Redirige a la pantalla principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      setState(() {
        verificado = false;
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verificación de correo")),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Aún no has verificado tu correo.\nRevisa tu bandeja de entrada o spam.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Ya verifiqué, continuar'),
                      onPressed: verificarEstado,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
