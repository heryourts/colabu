import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/usuario.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Usuario? usuarioActual;

  Future<void> registrarAlumnoConDatos({
    required String nombre,
    required String apellido,
    required String email,
    required String password,
    required String universidadId,
    required String universidadNombre,
    required String carreraId,
    required String carreraNombre,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await cred.user!.sendEmailVerification();

      final uid = cred.user!.uid;

      await _db.collection('estudiantes').doc(uid).set({
        'uid': uid,
        'nombre': nombre,
        'apellido': apellido,
        'email': email,
        'universidadId': universidadId,
        'universidadNombre': universidadNombre,
        'carreraId': carreraId,
        'carreraNombre': carreraNombre,
        'verificado': false,
      });

      usuarioActual = Usuario(
        uid: uid,
        email: email,
        nombre: '$nombre $apellido',
        tipo: 'alumno',
      );

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> iniciarSesion(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = _auth.currentUser;
    await user?.reload();

    final uid = cred.user!.uid;

    // Buscar en colección usuarios
    final docUsuarios = await _db.collection('usuarios').doc(uid).get();

    if (docUsuarios.exists) {
      usuarioActual = Usuario.fromMap(docUsuarios.data()!);
      return usuarioActual!.tipo;
    }

    // Buscar en estudiantes
    final docEstudiantes = await _db.collection('estudiantes').doc(uid).get();
    if (docEstudiantes.exists) {
      final data = docEstudiantes.data()!;
      usuarioActual = Usuario(
        uid: uid,
        email: data['email'],
        nombre: '${data['nombre']} ${data['apellido']}',
        tipo: 'alumno',
      );
      notifyListeners();
      return 'alumno';
    }

    // Buscar en tutores
    final docTutores = await _db.collection('tutores').doc(uid).get();
    if (docTutores.exists) {
      final data = docTutores.data()!;
      usuarioActual = Usuario(
        uid: uid,
        email: data['email'],
        nombre: '${data['nombre']} ${data['apellido']}',
        tipo: 'tutor',
      );
      notifyListeners();
      return 'tutor';
    }

    throw Exception('Usuario no encontrado en ninguna colección');
  }

  Future<void> cerrarSesion() async {
    await _auth.signOut();
    usuarioActual = null;
    notifyListeners();
  }
}
