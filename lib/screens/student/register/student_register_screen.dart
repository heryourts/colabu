import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colabu/screens/student/register/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/auth_provider.dart';
import '../../../../models/universidad.dart';
import '../../../../models/carrera.dart';

class StudentRegisterScreen extends StatefulWidget {
  const StudentRegisterScreen({super.key});

  @override
  State<StudentRegisterScreen> createState() => _StudentRegisterScreenState();
}

class _StudentRegisterScreenState extends State<StudentRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String nombre = '';
  String apellido = '';
  String email = '';
  String password = '';
  String repetirPassword = '';
  Universidad? universidadSeleccionada;
  Carrera? carreraSeleccionada;
  bool cargando = false;

  List<Universidad> universidades = [];
  List<Carrera> carreras = [];

  @override
  void initState() {
    super.initState();
    cargarDropdowns();
  }

  Future<void> cargarDropdowns() async {
    final uniSnap = await FirebaseFirestore.instance
        .collection('universidades')
        .get();
    final carSnap = await FirebaseFirestore.instance
        .collection('carreras')
        .get();

    setState(() {
      universidades = uniSnap.docs
          .map((doc) => Universidad.fromDoc(doc.id, doc.data()))
          .toList();
      carreras = carSnap.docs
          .map((doc) => Carrera.fromDoc(doc.id, doc.data()))
          .toList();
    });
  }

  void registrarAlumno() async {
    if (!_formKey.currentState!.validate()) return;
    if (universidadSeleccionada == null || carreraSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona universidad y carrera')),
      );
      return;
    }

    if (password != repetirPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    _formKey.currentState!.save();
    setState(() => cargando = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.registrarAlumnoConDatos(
        nombre: nombre,
        apellido: apellido,
        email: email,
        password: password,
        universidadId: universidadSeleccionada!.id,
        universidadNombre: universidadSeleccionada!.nombre,
        carreraId: carreraSeleccionada!.id,
        carreraNombre: carreraSeleccionada!.nombre,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const VerificacionScreen()),
      );
    } catch (e) {
      setState(() => cargando = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro Alumno')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: universidades.isEmpty || carreras.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      onSaved: (val) => nombre = val!,
                      validator: (val) =>
                          val!.isEmpty ? 'Campo requerido' : null,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Apellido'),
                      onSaved: (val) => apellido = val!,
                      validator: (val) =>
                          val!.isEmpty ? 'Campo requerido' : null,
                    ),
                    DropdownButtonFormField<Universidad>(
                      decoration: const InputDecoration(
                        labelText: 'Universidad',
                      ),
                      value: universidadSeleccionada,
                      items: universidades
                          .map(
                            (u) => DropdownMenuItem(
                              value: u,
                              child: Text(u.nombre),
                            ),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => universidadSeleccionada = val),
                      validator: (val) =>
                          val == null ? 'Selecciona una universidad' : null,
                    ),
                    DropdownButtonFormField<Carrera>(
                      decoration: const InputDecoration(labelText: 'Carrera'),
                      value: carreraSeleccionada,
                      items: carreras
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(c.nombre),
                            ),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => carreraSeleccionada = val),
                      validator: (val) =>
                          val == null ? 'Selecciona una carrera' : null,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Correo institucional',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (val) => email = val!,
                      validator: (val) =>
                          val!.isEmpty ? 'Campo requerido' : null,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                      ),
                      obscureText: true,
                      onChanged: (val) => password = val,
                      validator: (val) =>
                          val!.length < 6 ? 'Mínimo 6 caracteres' : null,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Confirmar contraseña',
                      ),
                      obscureText: true,
                      onChanged: (val) => repetirPassword = val,
                      validator: (val) =>
                          val!.isEmpty ? 'Repite tu contraseña' : null,
                    ),
                    const SizedBox(height: 24),
                    cargando
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: registrarAlumno,
                            child: const Text('Confirmar registro'),
                          ),
                  ],
                ),
              ),
      ),
    );
  }
}
