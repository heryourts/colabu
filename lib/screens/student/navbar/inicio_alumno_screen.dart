import 'package:colabu/models/tutor.dart';
import 'package:colabu/providers/tutores_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InicioAlumnoScreen extends StatefulWidget {
  const InicioAlumnoScreen({super.key});

  @override
  State<InicioAlumnoScreen> createState() => _InicioAlumnoScreenState();
}

class _InicioAlumnoScreenState extends State<InicioAlumnoScreen> {
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    await Provider.of<TutoresProvider>(context, listen: false).cargarTutores();
    setState(() {
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tutoresProvider = Provider.of<TutoresProvider>(context);
    final tutores = tutoresProvider.tutores;
    final mapaApoyos = tutoresProvider.mapaApoyos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tutores'),
        backgroundColor: Colors.green[700],
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: tutores.length,
              itemBuilder: (context, index) {
                final tutor = tutores[index];
                final iniciales =
                    tutor.nombre.isNotEmpty && tutor.apellido.isNotEmpty
                    ? '${tutor.nombre[0].toUpperCase()}${tutor.apellido[0].toUpperCase()}'
                    : '--';

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.green[300],
                              child: Text(
                                iniciales,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${tutor.nombre} ${tutor.apellido}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(tutor.carrera),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Tipos de Apoyo:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          children: tutor.apoyosIds.map((id) {
                            final nombre = mapaApoyos[id] ?? id;
                            return Chip(
                              label: Text(nombre),
                              backgroundColor: Colors.green[50],
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Especialidades:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          children: tutor.etiquetas.map((e) {
                            return Chip(
                              label: Text(e),
                              backgroundColor: Colors.blue[50],
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),

                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              print(
                                'Contactar a ${tutor.nombre} ${tutor.apellido}',
                              );
                            },
                            icon: const Icon(Icons.message),
                            label: const Text('Contactar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
