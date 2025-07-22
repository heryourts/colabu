import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/tutor.dart';

class TutoresProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Tutor> _tutores = [];
  Map<String, String> _mapaApoyos = {}; // apoyo_001 → "Redacción"

  List<Tutor> get tutores => _tutores;
  Map<String, String> get mapaApoyos => _mapaApoyos;

  Future<void> cargarTutores() async {
    try {
      // 1. Cargar apoyos (una sola vez)
      final apoyosSnapshot = await _firestore.collection('apoyos').get();
      _mapaApoyos = {
        for (var doc in apoyosSnapshot.docs)
          doc.id: doc['nombre'] ?? 'Sin nombre',
      };

      // 2. Cargar tutores
      final snapshot = await _firestore.collection('tutores').get();
      _tutores = snapshot.docs
          .map((doc) => Tutor.fromMap(doc.data(), doc.id))
          .toList();

      notifyListeners();
    } catch (e) {
      print('Error al cargar tutores: $e');
    }
  }
}
