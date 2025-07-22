import 'package:colabu/providers/estudiante_perfil_provider.dart';
import 'package:colabu/providers/tutores_provider.dart';
import 'package:colabu/screens/student/navbar/home_alumno_screen.dart';
import 'package:colabu/screens/student/register/verification_screen.dart';
import 'package:colabu/screens/tutor/home_tutor_screen.dart';
import 'package:colabu/screens/tutor/registro/verification_tutor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDFxb4nmkQbVBL3151Kbi2zxK124uO5ufw",
        authDomain: "colabuteam.firebaseapp.com",
        projectId: "colabuteam",
        storageBucket: "colabuteam.firebasestorage.app",
        messagingSenderId: "1877789785",
        appId: "1:1877789785:web:3fb46fa73b386dfe66f548",
      ),
    );
  } else {
    await Firebase.initializeApp(); // Para Android/iOS
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TutoresProvider()),
        ChangeNotifierProvider(create: (_) => EstudiantePerfilProvider()),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/welcome',
        routes: {
          '/welcome': (context) => const WelcomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/homeAlumno': (context) => const HomeScreenAlumno(),
          '/homeTutor': (context) => const HomeTutorScreen(),
          '/verificacionAlumno': (context) =>
              const VerificacionScreen(), // para alumno
          '/verificacionTutor': (context) =>
              const VerificacionTutorScreen(), // para tutor
        },
      ),
    );
  }
}
