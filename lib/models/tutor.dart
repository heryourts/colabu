class Tutor {
  final String uid;
  final String nombre;
  final String apellido;
  final String carrera;
  final String email;
  final String universidad;
  final bool verificado;
  final List<String> apoyosIds;
  final List<String> etiquetas;

  Tutor({
    required this.uid,
    required this.nombre,
    required this.apellido,
    required this.carrera,
    required this.email,
    required this.universidad,
    required this.verificado,
    required this.apoyosIds,
    required this.etiquetas,
  });

  factory Tutor.fromMap(Map<String, dynamic> data, String docId) {
    return Tutor(
      uid: docId,
      nombre: data['nombre'] ?? '',
      apellido: data['apellido'] ?? '',
      carrera: data['carrera'] ?? '',
      email: data['email'] ?? '',
      universidad: data['universidad'] ?? '',
      verificado: data['verificado'] ?? false,
      apoyosIds: List<String>.from(data['apoyos'] ?? []),
      etiquetas: List<String>.from(data['etiquetas'] ?? []),
    );
  }
}
