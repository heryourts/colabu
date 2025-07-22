import 'package:colabu/providers/estudiante_perfil_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'inicio_alumno_screen.dart';
import 'tareas_alumno_screen.dart';
import 'mensajes_alumno_screen.dart';
import 'perfil_alumno_screen.dart';

class HomeScreenAlumno extends StatefulWidget {
  const HomeScreenAlumno({super.key});

  @override
  State<HomeScreenAlumno> createState() => _HomeScreenAlumnoState();
}

class _HomeScreenAlumnoState extends State<HomeScreenAlumno> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    InicioAlumnoScreen(),
    TareasAlumnoScreen(),
    MensajesAlumnoScreen(),
    PerfilAlumnoScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  void _cargarPerfil() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      // Carga el perfil del estudiante desde Firestore
      Provider.of<EstudiantePerfilProvider>(
        context,
        listen: false,
      ).cargarPerfil(uid);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Tareas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Mensajes'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
