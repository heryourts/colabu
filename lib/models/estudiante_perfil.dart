class EstudiantePerfil {
  final String uid;
  final String nombre;
  final String apellido;
  final String email;
  final String universidadId;
  final String universidadNombre;
  final String carreraId;
  final String carreraNombre;
  final bool verificado;

  EstudiantePerfil({
    required this.uid,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.universidadId,
    required this.universidadNombre,
    required this.carreraId,
    required this.carreraNombre,
    required this.verificado,
  });

  factory EstudiantePerfil.fromMap(Map<String, dynamic> data) {
    return EstudiantePerfil(
      uid: data['uid'],
      nombre: data['nombre'],
      apellido: data['apellido'],
      email: data['email'],
      universidadId: data['universidadId'],
      universidadNombre: data['universidadNombre'],
      carreraId: data['carreraId'],
      carreraNombre: data['carreraNombre'],
      verificado: data['verificado'] ?? false,
    );
  }
}
