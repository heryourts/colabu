class Universidad {
  final String id;
  final String nombre;

  Universidad({required this.id, required this.nombre});

  factory Universidad.fromDoc(String id, Map<String, dynamic> data) {
    return Universidad(id: id, nombre: data['nombre']);
  }
}
