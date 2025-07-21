import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import 'check_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool cargando = false;

  void _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => cargando = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.iniciarSesion(email, password);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CheckVerificationScreen()),
      );
    } catch (e) {
      setState(() => cargando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
                    val!.length < 6 ? 'Contraseña inválida' : null,
                onSaved: (val) => password = val!,
              ),
              const SizedBox(height: 24),
              cargando
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _iniciarSesion,
                      child: const Text('Ingresar'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
