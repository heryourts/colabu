import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerificacionScreen extends StatefulWidget {
  const VerificacionScreen({super.key});

  @override
  State<VerificacionScreen> createState() => _VerificacionScreenState();
}

class _VerificacionScreenState extends State<VerificacionScreen> {
  bool verificado = false;
  bool cargando = false;

  Future<void> _checkVerification() async {
    setState(() => cargando = true);

    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();

    if (user != null && user.emailVerified) {
      setState(() => verificado = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Correo verificado! Registrado con éxito.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aún no has verificado tu correo.'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => cargando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verifica tu correo')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: verificado
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '¡Tu correo fue verificado con éxito!',
                      style: TextStyle(fontSize: 18, color: Colors.green),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Navegar al WelcomeScreen (reemplaza con tu ruta)
                        Navigator.pushReplacementNamed(context, '/welcome');
                      },
                      child: const Text('Ir al inicio'),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Te enviamos un correo de verificación. Revisa tu bandeja de entrada o spam.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    cargando
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _checkVerification,
                            child: const Text('Ya me verifiqué'),
                          ),
                  ],
                ),
        ),
      ),
    );
  }
}
