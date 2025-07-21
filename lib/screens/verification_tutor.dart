import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VerificacionTutor extends StatefulWidget {
  const VerificacionTutor({super.key});

  @override
  State<VerificacionTutor> createState() => _VerificacionTutorState();
}

class _VerificacionTutorState extends State<VerificacionTutor> {
  bool verificado = false;
  bool cargando = false;

  Future<void> _checkVerification() async {
    setState(() => cargando = true);

    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();

    if (user != null && user.emailVerified) {
      // 🔁 ACTUALIZAR FIRESTORE para tutor
      await FirebaseFirestore.instance
          .collection('tutores')
          .doc(user.uid)
          .update({'verificado': true});

      setState(() => verificado = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Correo verificado! Registro completado.'),
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
                        Navigator.pushReplacementNamed(context, '/home');
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
