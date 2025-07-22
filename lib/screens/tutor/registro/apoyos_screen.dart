import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colabu/screens/tutor/registro/etiquetas.dart';
import 'package:flutter/material.dart';

class SeleccionarApoyosScreen extends StatefulWidget {
  final Map<String, dynamic> datosBasicos; // datos de pantalla 1

  const SeleccionarApoyosScreen({super.key, required this.datosBasicos});

  @override
  State<SeleccionarApoyosScreen> createState() =>
      _SeleccionarApoyosScreenState();
}

class _SeleccionarApoyosScreenState extends State<SeleccionarApoyosScreen> {
  List<Map<String, dynamic>> apoyos = [];
  Set<String> apoyosSeleccionados = {};

  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarApoyos();
  }

  Future<void> _cargarApoyos() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('apoyos')
        .get();

    final datos = snapshot.docs.map((doc) {
      return {'id': doc.id, 'nombre': doc['nombre'] ?? ''};
    }).toList();

    setState(() {
      apoyos = datos;
      cargando = false;
    });
  }

  void _continuarRegistro() {
    final datosCompletos = {
      ...widget.datosBasicos,
      'apoyos': apoyosSeleccionados.toList(),
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EtiquetasScreen(datosPrevios: datosCompletos),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona los Apoyos')),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Selecciona los apoyos que deseas brindar:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ...apoyos.map((apoyo) {
                  final id = apoyo['id'];
                  final nombre = apoyo['nombre'];

                  return CheckboxListTile(
                    title: Text(nombre),
                    value: apoyosSeleccionados.contains(id),
                    onChanged: (bool? seleccionado) {
                      setState(() {
                        if (seleccionado == true) {
                          apoyosSeleccionados.add(id);
                        } else {
                          apoyosSeleccionados.remove(id);
                        }
                      });
                    },
                  );
                }).toList(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: apoyosSeleccionados.isEmpty
                      ? null
                      : _continuarRegistro,
                  child: const Text('Continuar'),
                ),
              ],
            ),
    );
  }
}
