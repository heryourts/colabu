import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/estudiante_perfil.dart';

class EstudiantePerfilProvider with ChangeNotifier {
  EstudiantePerfil? _perfil;

  EstudiantePerfil? get perfil => _perfil;

  // Carga todo el perfil desde Firestore
  Future<void> cargarPerfil(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('estudiantes')
        .doc(uid)
        .get();
    if (doc.exists) {
      _perfil = EstudiantePerfil.fromMap(doc.data()!);
      notifyListeners();
    }
  }

  // Actualiza solo la URL de la foto en el perfil local y notifica cambios
  void actualizarFotoPerfil(String nuevaUrl) {
    if (_perfil != null) {
      _perfil = _perfil!.copyWith(fotoUrl: nuevaUrl);
      notifyListeners();
    }
  }
}
