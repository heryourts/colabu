import 'package:flutter/material.dart';

class HomeTutorScreen extends StatelessWidget {
  const HomeTutorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Bienvenido al Home del Tutor',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
