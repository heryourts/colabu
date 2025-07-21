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

  Future<void> registrarTutor(
    String nombre,
    String email,
    String password,
  ) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final usuario = Usuario(
      uid: cred.user!.uid,
      email: email,
      nombre: nombre,
      tipo: 'tutor',
    );
    await _db.collection('usuarios').doc(usuario.uid).set(usuario.toMap());
    usuarioActual = usuario;
    notifyListeners();
  }

  Future<void> iniciarSesion(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Refrescar el estado del usuario actual para obtener la info más reciente
    final user = _auth.currentUser;
    await user?.reload();

    final uid = cred.user!.uid;

    // El resto del código para cargar datos de Firestore...

    final docUsuarios = await _db.collection('usuarios').doc(uid).get();

    if (docUsuarios.exists) {
      usuarioActual = Usuario.fromMap(docUsuarios.data()!);
    } else {
      final docEstudiantes = await _db.collection('estudiantes').doc(uid).get();

      if (!docEstudiantes.exists) {
        throw Exception('Usuario no encontrado en ninguna colección');
      }

      final data = docEstudiantes.data()!;
      usuarioActual = Usuario(
        uid: uid,
        email: data['email'],
        nombre: '${data['nombre']} ${data['apellido']}',
        tipo: 'alumno',
      );
    }

    notifyListeners();
  }

  Future<void> cerrarSesion() async {
    await _auth.signOut();
    usuarioActual = null;
    notifyListeners();
  }
}
