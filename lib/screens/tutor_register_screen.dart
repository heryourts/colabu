import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'home_screen.dart';

class TutorRegisterScreen extends StatefulWidget {
  const TutorRegisterScreen({super.key});

  @override
  State<TutorRegisterScreen> createState() => _TutorRegisterScreenState();
}

class _TutorRegisterScreenState extends State<TutorRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String nombre = '';
  String email = '';
  String password = '';
  bool cargando = false;

  void _registrarTutor() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => cargando = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.registrarTutor(nombre, email, password);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
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
      appBar: AppBar(title: const Text('Registro Tutor')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (val) => val!.isEmpty ? 'Ingrese su nombre' : null,
                onSaved: (val) => nombre = val!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Correo'),
                keyboardType: TextInputType.emailAddress,
                validator: (val) => val!.isEmpty ? 'Ingrese su correo' : null,
                onSaved: (val) => email = val!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (val) =>
                    val!.length < 6 ? 'Mínimo 6 caracteres' : null,
                onSaved: (val) => password = val!,
              ),
              const SizedBox(height: 24),
              cargando
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _registrarTutor,
                      child: const Text('Registrarse'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
