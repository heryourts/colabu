import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerificacionTutorScreen extends StatefulWidget {
  const VerificacionTutorScreen({super.key});

  @override
  State<VerificacionTutorScreen> createState() =>
      _VerificacionTutorScreenState();
}

class _VerificacionTutorScreenState extends State<VerificacionTutorScreen> {
  bool cargando = false;

  Future<void> _verificarEstado() async {
    setState(() => cargando = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.reload(); // 🔄 recarga datos desde Firebase

      if (user != null && user.emailVerified) {
        // ✅ Si está verificado, redirigir
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Correo verificado. ¡Bienvenido!'),
            backgroundColor: Colors.green,
          ),
        );

        // 👉 Ir al Home del tutor (ajusta la ruta según tu app)
        Navigator.pushReplacementNamed(context, '/homeTutor');
      } else {
        // ❌ Aún no verificado
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tu correo aún no ha sido verificado.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al verificar: $e')));
    } finally {
      setState(() => cargando = false);
    }
  }

  Future<void> _reenviarCorreo() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Correo de verificación reenviado.'),
          backgroundColor: Colors.blue,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al reenviar correo: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verifica tu correo')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Te hemos enviado un correo de verificación. Por favor, revisa tu bandeja de entrada y haz clic en el enlace.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            cargando
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: _verificarEstado,
                    icon: const Icon(Icons.verified),
                    label: const Text('Ya estoy verificado'),
                  ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _reenviarCorreo,
              child: const Text('Reenviar correo de verificación'),
            ),
          ],
        ),
      ),
    );
  }
}
