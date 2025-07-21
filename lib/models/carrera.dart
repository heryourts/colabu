class Carrera {
  final String id;
  final String nombre;

  Carrera({required this.id, required this.nombre});

  factory Carrera.fromDoc(String id, Map<String, dynamic> data) {
    return Carrera(id: id, nombre: data['nombre']);
  }
}
