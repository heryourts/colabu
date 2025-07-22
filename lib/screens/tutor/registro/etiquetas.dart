import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EtiquetasScreen extends StatefulWidget {
  final Map<String, dynamic> datosPrevios;

  const EtiquetasScreen({super.key, required this.datosPrevios});

  @override
  State<EtiquetasScreen> createState() => _EtiquetasScreenState();
}

class _EtiquetasScreenState extends State<EtiquetasScreen> {
  final TextEditingController _etiquetaController = TextEditingController();
  final List<String> etiquetas = [];
  bool cargando = false;

  void _addLabel() {
    final texto = _etiquetaController.text.trim().toUpperCase();
    if (texto.isEmpty) return;

    if (etiquetas.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solo puedes agregar hasta 5 etiquetas')),
      );
      return;
    }

    if (!etiquetas.contains(texto)) {
      setState(() {
        etiquetas.add(texto);
        _etiquetaController.clear();
      });
    }
  }

  void _eliminarEtiqueta(String etiqueta) {
    setState(() {
      etiquetas.remove(etiqueta);
    });
  }

  Future<void> _continuar() async {
    print('Datos previos recibidos: ${widget.datosPrevios}');
    if (cargando) return;

    setState(() => cargando = true);

    try {
      final email = widget.datosPrevios['email'] as String;
      final password = widget.datosPrevios['password'] as String;

      // 1. Crear usuario en Firebase Auth
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = cred.user!.uid;

      // 2. Guardar perfil completo en Firestore (colección 'tutores', doc = uid)
      final datosFinales = {
        ...widget.datosPrevios,
        'etiquetas': etiquetas,
        'createdAt': DateTime.now(),
        'verificado': false,
      };

      // Elimina la contraseña para no guardar en Firestore
      datosFinales.remove('password');

      await FirebaseFirestore.instance
          .collection('tutores')
          .doc(uid)
          .set(datosFinales);

      // 3. Enviar correo de verificación
      await cred.user!.sendEmailVerification();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Registro exitoso. Revisa tu correo para verificar la cuenta.',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // 4. Navegar a pantalla de verificación
      Navigator.pushReplacementNamed(context, '/verificacionTutor');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
    } finally {
      setState(() => cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Áreas de especialidad')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Escribe tus áreas de especialidad o temas que dominas:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _etiquetaController,
                    decoration: const InputDecoration(
                      hintText: 'Ej: Estadísticas',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addLabel,
                  child: const Text('Añadir'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: etiquetas.map((etiqueta) {
                return Chip(
                  label: Text(etiqueta),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () => _eliminarEtiqueta(etiqueta),
                );
              }).toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: cargando
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: etiquetas.isNotEmpty ? _continuar : null,
                      child: const Text('Finalizar Registro'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
