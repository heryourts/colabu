import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:colabu/providers/estudiante_perfil_provider.dart';
import 'package:colabu/models/estudiante_perfil.dart';
import 'package:colabu/utils/permisos.dart';

class PerfilAlumnoScreen extends StatelessWidget {
  const PerfilAlumnoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final perfil = Provider.of<EstudiantePerfilProvider>(context).perfil;

    if (perfil == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil del Alumno')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _FotoPerfil(perfil: perfil),
            const SizedBox(height: 20),
            _DatoPerfil(
              titulo: 'Nombre',
              valor: '${perfil.nombre} ${perfil.apellido}',
            ),
            _DatoPerfil(titulo: 'Correo', valor: perfil.email),
            _DatoPerfil(titulo: 'Universidad', valor: perfil.universidadNombre),
            _DatoPerfil(titulo: 'Carrera', valor: perfil.carreraNombre),
          ],
        ),
      ),
    );
  }
}

class _DatoPerfil extends StatelessWidget {
  final String titulo;
  final String valor;

  const _DatoPerfil({required this.titulo, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$titulo: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(valor)),
        ],
      ),
    );
  }
}

class _FotoPerfil extends StatelessWidget {
  final EstudiantePerfil perfil;

  const _FotoPerfil({required this.perfil});

  @override
  Widget build(BuildContext context) {
    final iniciales = '${perfil.nombre[0]}${perfil.apellido[0]}'.toUpperCase();

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.teal,
          backgroundImage:
              (perfil.fotoUrl != null && perfil.fotoUrl!.isNotEmpty)
              ? NetworkImage(perfil.fotoUrl!)
              : null,
          child: (perfil.fotoUrl == null || perfil.fotoUrl!.isEmpty)
              ? Text(
                  iniciales,
                  style: const TextStyle(fontSize: 32, color: Colors.white),
                )
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.teal),
          onPressed: () => _mostrarOpcionesFoto(context),
        ),
      ],
    );
  }

  void _mostrarOpcionesFoto(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Elegir de galería'),
              onTap: () {
                Navigator.pop(context);
                _seleccionarImagen(context, ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Tomar una foto'),
              onTap: () {
                Navigator.pop(context);
                _seleccionarImagen(context, ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _seleccionarImagen(
    BuildContext context,
    ImageSource source,
  ) async {
    await verificarPermisos(source);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final file = File(pickedFile.path);
      final storageRef = FirebaseStorage.instance.ref().child(
        'fotos_perfil/$uid.jpg',
      );

      await storageRef.putFile(file);
      final url = await storageRef.getDownloadURL();

      // Actualiza en Firestore
      await FirebaseFirestore.instance
          .collection('estudiantes')
          .doc(uid)
          .update({'fotoUrl': url});

      // Recarga el perfil
      await Provider.of<EstudiantePerfilProvider>(
        context,
        listen: false,
      ).cargarPerfil(uid);
    }
  }
}
