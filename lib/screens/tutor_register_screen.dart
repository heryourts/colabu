import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colabu/screens/apoyos_screen.dart';
import 'package:flutter/material.dart';

class RegistroTutorScreen1 extends StatefulWidget {
  const RegistroTutorScreen1({super.key});

  @override
  State<RegistroTutorScreen1> createState() => _RegistroTutorScreen1State();
}

class _RegistroTutorScreen1State extends State<RegistroTutorScreen1> {
  final _formKey = GlobalKey<FormState>();
  String nombre = '';
  String apellido = '';
  String email = '';
  String password = '';
  String confirmarPassword = '';
  String? universidad;
  String? carrera;

  List<String> universidades = [];
  List<String> carreras = [];

  bool cargando = false;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final snapshotUniv = await FirebaseFirestore.instance
        .collection('universidades')
        .get();
    final snapshotCarr = await FirebaseFirestore.instance
        .collection('carreras')
        .get();

    setState(() {
      universidades = snapshotUniv.docs
          .map((doc) => doc['nombre'] as String)
          .toList();
      carreras = snapshotCarr.docs
          .map((doc) => doc['nombre'] as String)
          .toList();
    });
  }

  void _continuar() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (password != confirmarPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Las contraseñas no coinciden'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final datosBasicos = {
        'nombre': nombre,
        'apellido': apellido,
        'universidad': universidad,
        'carrera': carrera,
        'email': email,
        'password': password,
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SeleccionarApoyosScreen(datosBasicos: datosBasicos),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro Tutor - Paso 1')),
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
                      onSaved: (val) => nombre = val!.trim(),
                      validator: (val) =>
                          val!.isEmpty ? 'Ingrese su nombre' : null,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Apellido'),
                      onSaved: (val) => apellido = val!.trim(),
                      validator: (val) =>
                          val!.isEmpty ? 'Ingrese su apellido' : null,
                    ),
                    DropdownButtonFormField<String>(
                      value: universidad,
                      items: universidades
                          .map(
                            (u) => DropdownMenuItem(value: u, child: Text(u)),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => universidad = val),
                      validator: (val) =>
                          val == null ? 'Seleccione una universidad' : null,
                      decoration: const InputDecoration(
                        labelText: 'Universidad',
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: carrera,
                      items: carreras
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => carrera = val),
                      validator: (val) =>
                          val == null ? 'Seleccione una carrera' : null,
                      decoration: const InputDecoration(labelText: 'Carrera'),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Correo institucional',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (val) => email = val!.trim(),
                      validator: (val) =>
                          val!.isEmpty ? 'Ingrese un correo válido' : null,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                      ),
                      obscureText: true,
                      onSaved: (val) => password = val!,
                      validator: (val) => val!.length < 6
                          ? 'La contraseña debe tener al menos 6 caracteres'
                          : null,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Confirmar contraseña',
                      ),
                      obscureText: true,
                      onSaved: (val) => confirmarPassword = val!,
                      validator: (val) =>
                          val!.isEmpty ? 'Confirme su contraseña' : null,
                    ),
                    const SizedBox(height: 24),
                    // En tu pantalla 1 (RegistroTutorPaso1Screen)
                    ElevatedButton(
                      onPressed: _continuar,
                      child: const Text('Siguiente'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
